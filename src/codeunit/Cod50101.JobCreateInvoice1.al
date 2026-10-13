codeunit 50101 "Job Create-Invoice1"
{
    // version NAVW113.05
    trigger OnRun()
    begin
    end;
    var Currency: Record Currency;
    SalesHeader: Record "Sales Header";
    SalesHeader2: Record "Sales Header";
    SalesLine: Record "Sales Line";
    TempJobPlanningLine: Record "Job Planning Line" temporary;
    Text000: Label 'The lines were successfully transferred to an invoice.';
    Text001: Label 'The lines were not transferred to an invoice.';
    Text002: Label 'There was no %1 with a %2 larger than 0. No lines were transferred.';
    Text003: Label '%1 may not be lower than %2 and may not exceed %3.';
    Text004: Label 'You must specify Invoice No. or New Invoice.';
    Text005: Label 'You must specify Credit Memo No. or New Invoice.';
    Text007: Label 'You must specify %1.';
    TransferExtendedText: Codeunit "Transfer Extended Text";
    JobInvCurrency: Boolean;
    UpdateExchangeRates: Boolean;
    Text008: Label 'The lines were successfully transferred to a credit memo.';
    Text009: Label 'The selected planning lines must have the same %1.';
    Text010: Label 'The currency dates on all planning lines will be updated based on the invoice posting date because there is a difference in currency exchange rates. Recalculations will be based on the Exch. Calculation setup for the Cost and Price values for the job. Do you want to continue?';
    Text011: Label 'The currency exchange rate on all planning lines will be updated based on the exchange rate on the sales invoice. Do you want to continue?';
    Text012: Label 'The %1 %2 does not exist anymore. A printed copy of the document was created before the document was deleted.', Comment = 'The Sales Invoice Header 103001 does not exist in the system anymore. A printed copy of the document was created before deletion.';
    NoOfSalesLinesCreated: Integer;
    //CustNo: Code[20];
    procedure CreateSalesInvoice(var JobPlanningLine: Record "Job Planning Line"; CrMemo: Boolean)
    var
        _recSalesHeader: Record "Sales Header";
        GetSalesInvoiceNo: Report "Job Transfer to Sales Invoice1";
        GetSalesCrMemoNo: Report "Job Transfer to Credit Memo";
        Done: Boolean;
        NewInvoice: Boolean;
        PostingDate: Date;
        InvoiceNo: Code[20];
        IsHandled: Boolean;
        JobPlanLineTemp: Record "Job Planning Line" temporary;
        CustNo: Code[20];
        DocumentDate: Date;
    begin
        if not CrMemo then begin
            GetSalesInvoiceNo.SetCustomer(JobPlanningLine."Job No.", JobPlanningLine."Customer No.");
            GetSalesInvoiceNo.RUNMODAL();
            IsHandled:=false;
            OnBeforeGetInvoiceNo(JobPlanningLine, Done, NewInvoice, PostingDate, InvoiceNo, IsHandled);
            if not IsHandled then GetSalesInvoiceNo.GetInvoiceNo(Done, NewInvoice, PostingDate, InvoiceNo);
        end
        else
        begin
            GetSalesCrMemoNo.SetCustomer(JobPlanningLine."Job No.");
            GetSalesCrMemoNo.RUNMODAL();
            IsHandled:=false;
            OnBeforeGetCrMemoNo(JobPlanningLine, Done, NewInvoice, PostingDate, InvoiceNo, IsHandled);
            //if not IsHandled then GetSalesCrMemoNo.GetCreditMemoNo(Done, NewInvoice, PostingDate, InvoiceNo);
            if not IsHandled then GetSalesCrMemoNo.GetCreditMemoNo(Done, NewInvoice, PostingDate, DocumentDate, InvoiceNo);
        end;
        if Done then begin
            if(PostingDate = 0D) and NewInvoice then ERROR(Text007, _recSalesHeader.FIELDCAPTION("Posting Date"));
            if(InvoiceNo = '') and not NewInvoice then begin
                if CrMemo then ERROR(Text005);
                ERROR(Text004);
            end;
            if JobPlanningLine.FindSet()then repeat if(CustNo = '') or (CustNo = JobPlanningLine."Customer No.")then begin
                        JobPlanLineTemp.Init();
                        JobPlanLineTemp.Copy(JobPlanningLine);
                        JobPlanLineTemp.Insert();
                        CustNo:=JobPlanningLine."Customer No.";
                    end
                    else
                    begin
                        CreateSalesInvoiceLines(JobPlanningLine."Job No.", JobPlanLineTemp, InvoiceNo, NewInvoice, PostingDate, CrMemo);
                        Clear(JobPlanLineTemp);
                        JobPlanLineTemp.DeleteAll();
                        JobPlanLineTemp.Init();
                        JobPlanLineTemp.Copy(JobPlanningLine);
                        JobPlanLineTemp.Insert();
                        CustNo:=JobPlanningLine."Customer No.";
                    end;
                until JobPlanningLine.Next() = 0;
            CreateSalesInvoiceLines(JobPlanningLine."Job No.", JobPlanLineTemp, InvoiceNo, NewInvoice, PostingDate, CrMemo);
            Clear(JobPlanLineTemp);
            JobPlanLineTemp.DeleteAll();
            MESSAGE(Text000);
        end;
    end;
    procedure CreateSalesInvoiceLines(JobNo: Code[20]; var JobPlanningLine: Record "Job Planning Line"; InvoiceNo: Code[20]; NewInvoice: Boolean; PostingDate: Date; CreditMemo: Boolean)
    var
        Cust: Record Customer;
        Job: Record Job;
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
        LineCounter: Integer;
        IsHandled: Boolean;
        JobPlanLine: Record "Job Planning Line";
    begin
        OnBeforeCreateSalesInvoiceLines(JobPlanningLine, InvoiceNo, NewInvoice, PostingDate, CreditMemo);
        CLEARALL();
        Job.GET(JobNo);
        if Job.Blocked = Job.Blocked::All then Job.TestBlocked();
        if Job."Currency Code" = '' then JobInvCurrency:=Job."Invoice Currency Code" <> '';
        Job.TESTFIELD("Bill-to Customer No.");
        IsHandled:=false;
        OnCreateSalesInvoiceLinesOnBeforeGetCustomer(JobPlanningLine, Cust, IsHandled);
        if not IsHandled then Cust.GET(Job."Bill-to Customer No.");
        if CreditMemo then SalesHeader2."Document Type":=SalesHeader2."Document Type"::"Credit Memo"
        else
            SalesHeader2."Document Type":=SalesHeader2."Document Type"::Invoice;
        if not NewInvoice then SalesHeader.GET(SalesHeader2."Document Type", InvoiceNo);
        if JobPlanningLine.FIND('-')then repeat if TransferLine(JobPlanningLine)then begin
                    LineCounter:=LineCounter + 1;
                    if JobPlanningLine."Job No." <> JobNo then ERROR(Text009, JobPlanningLine.FIELDCAPTION("Job No."));
                    if NewInvoice then TestExchangeRate(JobPlanningLine, PostingDate)
                    else
                        TestExchangeRate(JobPlanningLine, SalesHeader."Posting Date");
                end;
            until JobPlanningLine.NEXT() = 0;
        if LineCounter = 0 then ERROR(Text002, JobPlanningLine.TABLECAPTION, JobPlanningLine.FIELDCAPTION("Qty. to Transfer to Invoice"));
        if NewInvoice then CreateSalesHeader1(Job, PostingDate, JobPlanningLine."Customer No.", JobPlanningLine."Currency Code 2")
        else
            TestSalesHeader(SalesHeader, Job, JobPlanningLine."Currency Code 2");
        if JobPlanningLine.FIND('-')then repeat if TransferLine(JobPlanningLine)then begin
                    if JobPlanningLine.Type in[JobPlanningLine.Type::Resource, JobPlanningLine.Type::Item, JobPlanningLine.Type::"G/L Account"]then JobPlanningLine.TESTFIELD("No.");
                    OnCreateSalesInvoiceLinesOnBeforeCreateSalesLine(JobPlanningLine, SalesHeader, SalesHeader2, NewInvoice, NoOfSalesLinesCreated);
                    CreateSalesLine(JobPlanningLine);
                    JobPlanningLineInvoice.InitFromJobPlanningLine(JobPlanningLine);
                    if NewInvoice then JobPlanningLineInvoice.InitFromSales(SalesHeader, PostingDate, SalesLine."Line No.")
                    else
                        JobPlanningLineInvoice.InitFromSales(SalesHeader, SalesHeader."Posting Date", SalesLine."Line No.");
                    JobPlanningLineInvoice.INSERT();
                    JobPlanningLine.UpdateQtyToTransfer();
                    //Message('%1', PostingDate);
                    //JobPlanningLine."SCC issue date" := PostingDate;    //PS001
                    JobPlanLine.get(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", JobPlanningLine."Line No.");
                    if JobPlanLine."SCC issue date" = 0D then begin
                        JobPlanLine."SCC issue date":=PostingDate;
                        JobPlanLine.Modify();
                    end;
                    JobPlanningLine.MODIFY();
                end;
            until JobPlanningLine.NEXT() = 0;
        if NoOfSalesLinesCreated = 0 then ERROR(Text002, JobPlanningLine.TABLECAPTION, JobPlanningLine.FIELDCAPTION("Qty. to Transfer to Invoice"));
        COMMIT();
        if CreditMemo then MESSAGE(Text008);
        //ELSE
        //    MESSAGE(Text000);
        OnAfterCreateSalesInvoiceLines(SalesHeader, NewInvoice);
    end;
    procedure DeleteSalesInvoiceBuffer()
    begin
        CLEARALL();
        TempJobPlanningLine.DELETEALL();
    end;
    procedure CreateSalesInvoiceJobTask(var JobTask2: Record "Job Task"; PostingDate: Date; InvoicePerTask: Boolean; var NoOfInvoices: Integer; var OldJobNo: Code[20]; var OldJobTaskNo: Code[20]; LastJobTask: Boolean)
    var
        Cust: Record Customer;
        Job: Record Job;
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeCreateSalesInvoiceJobTask(JobTask2, PostingDate, InvoicePerTask, NoOfInvoices, OldJobNo, OldJobTaskNo, LastJobTask, IsHandled);
        if IsHandled then exit;
        CLEARALL();
        if not LastJobTask then begin
            JobTask:=JobTask2;
            if JobTask."Job No." = '' then exit;
            if JobTask."Job Task No." = '' then exit;
            JobTask.FindFirst(); //JobTask.FIND();
            if JobTask."Job Task Type" <> JobTask."Job Task Type"::Posting then exit;
            Job.GET(JobTask."Job No.");
        end;
        if LastJobTask then begin
            if not TempJobPlanningLine.FIND('-')then exit;
            Job.GET(TempJobPlanningLine."Job No.");
            JobTask.GET(TempJobPlanningLine."Job No.", TempJobPlanningLine."Job Task No.");
        end;
        OnCreateSalesInvoiceJobTaskTestJob(Job);
        Job.TESTFIELD("Bill-to Customer No.");
        if Job.Blocked = Job.Blocked::All then Job.TestBlocked();
        if Job."Currency Code" = '' then JobInvCurrency:=Job."Invoice Currency Code" <> '';
        Cust.GET(Job."Bill-to Customer No.");
        if CreateNewInvoice(JobTask, InvoicePerTask, OldJobNo, OldJobTaskNo, LastJobTask)then begin
            Job.GET(TempJobPlanningLine."Job No.");
            Cust.GET(Job."Bill-to Customer No.");
            NoOfInvoices:=NoOfInvoices + 1;
            SalesHeader2."Document Type":=SalesHeader2."Document Type"::Invoice;
            CreateSalesHeader(Job, PostingDate);
            if TempJobPlanningLine.FIND('-')then repeat Job.GET(TempJobPlanningLine."Job No.");
                    JobInvCurrency:=(Job."Currency Code" = '') and (Job."Invoice Currency Code" <> '');
                    JobPlanningLine:=TempJobPlanningLine;
                    JobPlanningLine.FIND();
                    if JobPlanningLine.Type in[JobPlanningLine.Type::Resource, JobPlanningLine.Type::Item, JobPlanningLine.Type::"G/L Account"]then JobPlanningLine.TESTFIELD("No.");
                    TestExchangeRate(JobPlanningLine, PostingDate);
                    OnCreateSalesInvoiceJobTaskOnBeforeCreateSalesLine(JobPlanningLine, SalesHeader, SalesHeader2, NoOfSalesLinesCreated);
                    CreateSalesLine(JobPlanningLine);
                    JobPlanningLineInvoice."Job No.":=JobPlanningLine."Job No.";
                    JobPlanningLineInvoice."Job Task No.":=JobPlanningLine."Job Task No.";
                    JobPlanningLineInvoice."Job Planning Line No.":=JobPlanningLine."Line No.";
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then JobPlanningLineInvoice."Document Type":=JobPlanningLineInvoice."Document Type"::Invoice;
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then JobPlanningLineInvoice."Document Type":=JobPlanningLineInvoice."Document Type"::"Credit Memo";
                    JobPlanningLineInvoice."Document No.":=SalesHeader."No.";
                    JobPlanningLineInvoice."Line No.":=SalesLine."Line No.";
                    JobPlanningLineInvoice."Quantity Transferred":=JobPlanningLine."Qty. to Transfer to Invoice";
                    JobPlanningLineInvoice."Transferred Date":=PostingDate;
                    JobPlanningLineInvoice.INSERT();
                    JobPlanningLine.UpdateQtyToTransfer();
                    JobPlanningLine.MODIFY();
                until TempJobPlanningLine.NEXT() = 0;
            TempJobPlanningLine.DELETEALL();
        end;
        OnCreateSalesInvoiceJobTaskOnAfterLinesCreated(SalesHeader, Job);
        if LastJobTask then begin
            if NoOfSalesLinesCreated = 0 then ERROR(Text002, JobPlanningLine.TABLECAPTION, JobPlanningLine.FIELDCAPTION("Qty. to Transfer to Invoice"));
            exit;
        end;
        JobPlanningLine.RESET();
        JobPlanningLine.SETCURRENTKEY("Job No.", "Job Task No.");
        JobPlanningLine.SETRANGE("Job No.", JobTask2."Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", JobTask2."Job Task No.");
        JobPlanningLine.SETFILTER("Planning Date", JobTask2.GETFILTER("Planning Date Filter"));
        if JobPlanningLine.FIND('-')then repeat if TransferLine(JobPlanningLine)then begin
                    TempJobPlanningLine:=JobPlanningLine;
                    TempJobPlanningLine.INSERT();
                end;
            until JobPlanningLine.NEXT() = 0;
    end;
    local procedure CreateNewInvoice(var JobTask: Record "Job Task"; InvoicePerTask: Boolean; var OldJobNo: Code[20]; var OldJobTaskNo: Code[20]; LastJobTask: Boolean): Boolean var
        NewInvoice: Boolean;
    begin
        if LastJobTask then NewInvoice:=true
        else
        begin
            if OldJobNo <> '' then begin
                if InvoicePerTask then if(OldJobNo <> JobTask."Job No.") or (OldJobTaskNo <> JobTask."Job Task No.")then NewInvoice:=true;
                if not InvoicePerTask then if OldJobNo <> JobTask."Job No." then NewInvoice:=true;
            end;
            OldJobNo:=JobTask."Job No.";
            OldJobTaskNo:=JobTask."Job Task No.";
        end;
        if not TempJobPlanningLine.FIND('-')then NewInvoice:=false;
        exit(NewInvoice);
    end;
    local procedure CreateSalesHeader(Job: Record Job; PostingDate: Date)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        IsHandled: Boolean;
    begin
        SalesSetup.GET();
        SalesHeader.INIT();
        SalesHeader."Document Type":=SalesHeader2."Document Type";
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then SalesSetup.TESTFIELD("Invoice Nos.");
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then SalesSetup.TESTFIELD("Credit Memo Nos.");
        SalesHeader."Posting Date":=PostingDate;
        OnBeforeInsertSalesHeader(SalesHeader, Job);
        SalesHeader.INSERT(true);
        Cust.GET(Job."Bill-to Customer No.");
        Cust.TESTFIELD("Bill-to Customer No.", '');
        SalesHeader.VALIDATE("Sell-to Customer No.", Job."Bill-to Customer No.");
        if Job."Currency Code" <> '' then SalesHeader.VALIDATE("Currency Code", Job."Currency Code")
        else
            SalesHeader.VALIDATE("Currency Code", Job."Invoice Currency Code");
        if PostingDate <> 0D then SalesHeader.VALIDATE("Posting Date", PostingDate);
        IsHandled:=false;
        OnCreateSalesHeaderOnBeforeUpdateSalesHeader(SalesHeader, Job, IsHandled);
        if not IsHandled then UpdateSalesHeader(SalesHeader, Job);
        OnBeforeModifySalesHeader(SalesHeader, Job);
        SalesHeader.MODIFY(true);
    end;
    local procedure CreateSalesHeader1(Job: Record Job; PostingDate: Date; CustNo: Code[20]; CurrCode: Code[10])
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        IsHandled: Boolean;
    begin
        SalesSetup.GET();
        SalesHeader.INIT();
        SalesHeader."Document Type":=SalesHeader2."Document Type";
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then SalesSetup.TESTFIELD("Invoice Nos.");
        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then SalesSetup.TESTFIELD("Credit Memo Nos.");
        SalesHeader."Posting Date":=PostingDate;
        OnBeforeInsertSalesHeader(SalesHeader, Job);
        SalesHeader.INSERT(true);
        Cust.GET(Job."Bill-to Customer No.");
        Cust.TESTFIELD("Bill-to Customer No.", '');
        SalesHeader.VALIDATE("Sell-to Customer No.", CustNo);
        //IF Job."Currency Code" <> '' THEN
        //    SalesHeader.VALIDATE("Currency Code", Job."Currency Code")
        //ELSE
        SalesHeader.VALIDATE("Currency Code", CurrCode);
        if PostingDate <> 0D then SalesHeader.VALIDATE("Posting Date", PostingDate);
        IsHandled:=false;
        OnCreateSalesHeaderOnBeforeUpdateSalesHeader(SalesHeader, Job, IsHandled);
        if not IsHandled then UpdateSalesHeader1(SalesHeader, Job, CustNo);
        OnBeforeModifySalesHeader(SalesHeader, Job);
        SalesHeader.MODIFY(true);
    end;
    local procedure CreateSalesLine(var JobPlanningLine: Record "Job Planning Line")
    var
        Job: Record Job;
        SourceCodeSetup: Record "Source Code Setup";
        DimMgt: Codeunit DimensionManagement;
        Factor: Integer;
        DimSetIDArr: array[10]of Integer;
    begin
        Factor:=1;
        if SalesHeader2."Document Type" = SalesHeader2."Document Type"::"Credit Memo" then Factor:=-1;
        TestTransferred(JobPlanningLine);
        JobPlanningLine.TESTFIELD("Planning Date");
        Job.GET(JobPlanningLine."Job No.");
        CLEAR(SalesLine);
        SalesLine."Document Type":=SalesHeader2."Document Type";
        SalesLine."Document No.":=SalesHeader."No.";
        if(not JobInvCurrency) and (JobPlanningLine.Type <> JobPlanningLine.Type::Text)then //SalesHeader.TESTFIELD("Currency Code", JobPlanningLine."Currency Code 2");
 //IF (Job."Currency Code" <> '') AND (JobPlanningLine."Currency Factor" <> SalesHeader."Currency Factor") THEN BEGIN
            //    IF CONFIRM(Text011) THEN BEGIN
            //        JobPlanningLine.VALIDATE("Currency Factor", SalesHeader."Currency Factor");
            //        JobPlanningLine.MODIFY;
            //   END ELSE
            //       ERROR(Text001);
            //END;
            SalesHeader.TESTFIELD("Currency Code", JobPlanningLine."Currency Code 2");
        if JobPlanningLine.Type = JobPlanningLine.Type::Text then SalesLine.VALIDATE(Type, SalesLine.Type::" ");
        if JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" then SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
        if JobPlanningLine.Type = JobPlanningLine.Type::Item then SalesLine.VALIDATE(Type, SalesLine.Type::Item);
        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then SalesLine.VALIDATE(Type, SalesLine.Type::Resource);
        SalesLine.VALIDATE("No.", JobPlanningLine."No.");
        SalesLine.VALIDATE("Gen. Prod. Posting Group", JobPlanningLine."Gen. Prod. Posting Group");
        SalesLine.VALIDATE("Location Code", JobPlanningLine."Location Code");
        SalesLine.VALIDATE("Work Type Code", JobPlanningLine."Work Type Code");
        SalesLine.VALIDATE("Variant Code", JobPlanningLine."Variant Code");
        if SalesLine.Type <> SalesLine.Type::" " then begin
            SalesLine.VALIDATE("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");
            SalesLine.VALIDATE(Quantity, Factor * JobPlanningLine."Qty. to Transfer to Invoice");
            if JobInvCurrency then begin
                Currency.GET(SalesLine."Currency Code");
                SalesLine.VALIDATE("Unit Price", ROUND(JobPlanningLine."Unit Price" * SalesHeader."Currency Factor", Currency."Unit-Amount Rounding Precision"));
            end
            else
                SalesLine.VALIDATE("Unit Price", JobPlanningLine."Unit Price");
            SalesLine.VALIDATE("Unit Cost (LCY)", JobPlanningLine."Unit Cost (LCY)");
            SalesLine.VALIDATE("Line Discount %", JobPlanningLine."Line Discount %");
            SalesLine."Inv. Discount Amount":=0;
            SalesLine."Inv. Disc. Amount to Invoice":=0;
            SalesLine.UpdateAmounts();
        end;
        if not SalesHeader."Prices Including VAT" then SalesLine.VALIDATE("Job Contract Entry No.", JobPlanningLine."Job Contract Entry No.");
        SalesLine."Job No.":=JobPlanningLine."Job No.";
        SalesLine."Job Task No.":=JobPlanningLine."Job Task No.";
        if SalesLine."Job Task No." <> '' then begin
            SourceCodeSetup.GET();
            DimSetIDArr[1]:=SalesLine."Dimension Set ID";
            DimSetIDArr[2]:=DimMgt.CreateDimSetFromJobTaskDim(SalesLine."Job No.", SalesLine."Job Task No.", SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code");
            DimSetIDArr[3]:=GetLedgEntryDimSetID(JobPlanningLine);
            DimSetIDArr[4]:=GetJobLedgEntryDimSetID(JobPlanningLine);
            DimMgt.CreateDimForSalesLineWithHigherPriorities(SalesLine, 0, DimSetIDArr[5], SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code", SourceCodeSetup.Sales, DATABASE::Job);
            SalesLine."Dimension Set ID":=DimMgt.GetCombinedDimensionSetID(DimSetIDArr, SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code");
        end;
        SalesLine.Description:=JobPlanningLine.Description;
        SalesLine."Description 2":=JobPlanningLine."Description 2";
        SalesLine."Line No.":=GetNextLineNo(SalesLine);
        OnBeforeInsertSalesLine(SalesLine, SalesHeader, Job, JobPlanningLine);
        SalesLine.INSERT(true);
        if SalesLine.Type <> SalesLine.Type::" " then begin
            NoOfSalesLinesCreated+=1;
            CalculateInvoiceDiscount(SalesLine, SalesHeader);
        end;
        if SalesHeader."Prices Including VAT" and (SalesLine.Type <> SalesLine.Type::" ")then begin
            Currency.Initialize(SalesLine."Currency Code");
            SalesLine."Unit Price":=ROUND(SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)), Currency."Unit-Amount Rounding Precision");
            if SalesLine.Quantity <> 0 then begin
                SalesLine."Line Discount Amount":=ROUND(SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100, Currency."Amount Rounding Precision");
                SalesLine.VALIDATE("Inv. Discount Amount", ROUND(SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)), Currency."Amount Rounding Precision"));
            end;
            SalesLine.VALIDATE("Job Contract Entry No.", JobPlanningLine."Job Contract Entry No.");
            OnBeforeModifySalesLine(SalesLine, SalesHeader, Job, JobPlanningLine);
            SalesLine.MODIFY();
            JobPlanningLine."VAT Unit Price":=SalesLine."Unit Price";
            JobPlanningLine."VAT Line Discount Amount":=SalesLine."Line Discount Amount";
            JobPlanningLine."VAT Line Amount":=SalesLine."Line Amount";
            JobPlanningLine."VAT %":=SalesLine."VAT %";
        end;
        if TransferExtendedText.SalesCheckIfAnyExtText(SalesLine, false)then TransferExtendedText.InsertSalesExtText(SalesLine);
        OnAfterCreateSalesLine(SalesLine, SalesHeader, Job, JobPlanningLine);
    end;
    local procedure CalculateInvoiceDiscount(var precSalesLine: Record "Sales Line"; precSalesHeader: Record "Sales Header") //
    var
        TotalSalesHeader: Record "Sales Header";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        PermissionManager: Codeunit "Permission Manager";
    begin
        TotalSalesHeader.GET(precSalesHeader."Document Type", precSalesHeader."No.");
        TotalSalesHeader.CALCFIELDS("Recalculate Invoice Disc.");
        if(not TotalSalesHeader."Recalculate Invoice Disc.") or (precSalesLine."Document No." = '') or (TotalSalesHeader."Customer Posting Group" = '')then exit;
        SalesReceivablesSetup.GET();
        if SalesReceivablesSetup."Calc. Inv. Discount" and (precSalesLine."Document No." <> '') and (TotalSalesHeader."Customer Posting Group" <> '') and TotalSalesHeader."Recalculate Invoice Disc." then CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount", precSalesLine);
    end;
    local procedure TransferLine(var JobPlanningLine: Record "Job Planning Line"): Boolean var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeTransferLine(JobPlanningLine, IsHandled);
        if IsHandled then exit;
        if not JobPlanningLine."Contract Line" then exit(false);
        if JobPlanningLine.Type = JobPlanningLine.Type::Text then exit(true);
        exit(JobPlanningLine."Qty. to Transfer to Invoice" <> 0);
    end;
    local procedure GetNextLineNo(precSalesLine: Record "Sales Line"): Integer var
        _recSalesLine: Record "Sales Line"; //
        NextLineNo: Integer;
    begin
        _recSalesLine.SETRANGE("Document Type", precSalesLine."Document Type"); //
        _recSalesLine.SETRANGE("Document No.", precSalesLine."Document No."); //
        NextLineNo:=10000;
        if _recSalesLine.FINDLAST()then NextLineNo:=_recSalesLine."Line No." + 10000; //
        exit(NextLineNo);
    end;
    local procedure TestTransferred(JobPlanningLine: Record "Job Planning Line")
    begin
        //WITH JobPlanningLine DO BEGIN
        JobPlanningLine.CALCFIELDS("Qty. Transferred to Invoice");
        if JobPlanningLine.Quantity > 0 then begin
            if(JobPlanningLine."Qty. to Transfer to Invoice" > 0) and (JobPlanningLine."Qty. to Transfer to Invoice" > (JobPlanningLine.Quantity - JobPlanningLine."Qty. Transferred to Invoice")) or (JobPlanningLine."Qty. to Transfer to Invoice" < 0)then ERROR(Text003, JobPlanningLine.FIELDCAPTION("Qty. to Transfer to Invoice"), 0, JobPlanningLine.Quantity - JobPlanningLine."Qty. Transferred to Invoice");
        end
        else if(JobPlanningLine."Qty. to Transfer to Invoice" > 0) or (JobPlanningLine."Qty. to Transfer to Invoice" < 0) and (JobPlanningLine."Qty. to Transfer to Invoice" < (JobPlanningLine.Quantity - JobPlanningLine."Qty. Transferred to Invoice"))then ERROR(Text003, JobPlanningLine.FIELDCAPTION("Qty. to Transfer to Invoice"), JobPlanningLine.Quantity - JobPlanningLine."Qty. Transferred to Invoice", 0);
    //END;
    end;
    procedure DeleteSalesLine(precSalesLine: Record "Sales Line") //
    var
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
        JobPlanningLine: Record "Job Planning Line";
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeDeleteSalesLine(precSalesLine, IsHandled);
        if IsHandled then exit;
        //WITH JobPlanningLineInvoice DO BEGIN
        case precSalesLine."Document Type" of precSalesLine."Document Type"::Invoice: JobPlanningLineInvoice.SETRANGE("Document Type", JobPlanningLineInvoice."Document Type"::Invoice);
        precSalesLine."Document Type"::"Credit Memo": JobPlanningLineInvoice.SETRANGE("Document Type", JobPlanningLineInvoice."Document Type"::"Credit Memo");
        end;
        JobPlanningLineInvoice.SETRANGE("Document No.", precSalesLine."Document No.");
        JobPlanningLineInvoice.SETRANGE("Line No.", precSalesLine."Line No.");
        if JobPlanningLineInvoice.FINDSET()then repeat JobPlanningLine.GET(JobPlanningLineInvoice."Job No.", JobPlanningLineInvoice."Job Task No.", JobPlanningLineInvoice."Job Planning Line No.");
                JobPlanningLineInvoice.DELETE();
                JobPlanningLine.Description:=JobPlanningLine.Description; //
                JobPlanningLine.UpdateQtyToTransfer();
                JobPlanningLine.MODIFY();
            until JobPlanningLineInvoice.NEXT() = 0;
    //END;
    end;
    procedure FindInvoices(var TempJobPlanningLineInvoice: Record "Job Planning Line Invoice" temporary; JobNo: Code[20]; JobTaskNo: Code[20]; JobPlanningLineNo: Integer; DetailLevel: Option All, "Per Job", "Per Job Task", "Per Job Planning Line")
    var
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
        RecordFound: Boolean;
    begin
        case DetailLevel of DetailLevel::All: begin
            if JobPlanningLineInvoice.FINDSET()then TempJobPlanningLineInvoice:=JobPlanningLineInvoice;
            exit;
        end;
        DetailLevel::"Per Job": JobPlanningLineInvoice.SETRANGE("Job No.", JobNo);
        DetailLevel::"Per Job Task": begin
            JobPlanningLineInvoice.SETRANGE("Job No.", JobNo);
            JobPlanningLineInvoice.SETRANGE("Job Task No.", JobTaskNo);
        end;
        DetailLevel::"Per Job Planning Line": begin
            JobPlanningLineInvoice.SETRANGE("Job No.", JobNo);
            JobPlanningLineInvoice.SETRANGE("Job Task No.", JobTaskNo);
            JobPlanningLineInvoice.SETRANGE("Job Planning Line No.", JobPlanningLineNo);
        end;
        end;
        TempJobPlanningLineInvoice.DELETEALL();
        if JobPlanningLineInvoice.FINDSET()then repeat RecordFound:=false;
                case DetailLevel of DetailLevel::"Per Job": if TempJobPlanningLineInvoice.GET(JobNo, '', 0, JobPlanningLineInvoice."Document Type", JobPlanningLineInvoice."Document No.", 0)then RecordFound:=true;
                DetailLevel::"Per Job Task": if TempJobPlanningLineInvoice.GET(JobNo, JobTaskNo, 0, JobPlanningLineInvoice."Document Type", JobPlanningLineInvoice."Document No.", 0)then RecordFound:=true;
                DetailLevel::"Per Job Planning Line": if TempJobPlanningLineInvoice.GET(JobNo, JobTaskNo, JobPlanningLineNo, JobPlanningLineInvoice."Document Type", JobPlanningLineInvoice."Document No.", 0)then RecordFound:=true;
                end;
                if RecordFound then begin
                    TempJobPlanningLineInvoice."Quantity Transferred"+=JobPlanningLineInvoice."Quantity Transferred";
                    TempJobPlanningLineInvoice."Invoiced Amount (LCY)"+=JobPlanningLineInvoice."Invoiced Amount (LCY)";
                    TempJobPlanningLineInvoice."Invoiced Cost Amount (LCY)"+=JobPlanningLineInvoice."Invoiced Cost Amount (LCY)";
                    TempJobPlanningLineInvoice.MODIFY();
                end
                else
                begin
                    case DetailLevel of DetailLevel::"Per Job": TempJobPlanningLineInvoice."Job No.":=JobNo;
                    DetailLevel::"Per Job Task": begin
                        TempJobPlanningLineInvoice."Job No.":=JobNo;
                        TempJobPlanningLineInvoice."Job Task No.":=JobTaskNo;
                    end;
                    DetailLevel::"Per Job Planning Line": begin
                        TempJobPlanningLineInvoice."Job No.":=JobNo;
                        TempJobPlanningLineInvoice."Job Task No.":=JobTaskNo;
                        TempJobPlanningLineInvoice."Job Planning Line No.":=JobPlanningLineNo;
                    end;
                    end;
                    TempJobPlanningLineInvoice."Document Type":=JobPlanningLineInvoice."Document Type";
                    TempJobPlanningLineInvoice."Document No.":=JobPlanningLineInvoice."Document No.";
                    TempJobPlanningLineInvoice."Quantity Transferred":=JobPlanningLineInvoice."Quantity Transferred";
                    TempJobPlanningLineInvoice."Invoiced Amount (LCY)":=JobPlanningLineInvoice."Invoiced Amount (LCY)";
                    TempJobPlanningLineInvoice."Invoiced Cost Amount (LCY)":=JobPlanningLineInvoice."Invoiced Cost Amount (LCY)";
                    TempJobPlanningLineInvoice."Invoiced Date":=JobPlanningLineInvoice."Invoiced Date";
                    TempJobPlanningLineInvoice."Transferred Date":=JobPlanningLineInvoice."Transferred Date";
                    TempJobPlanningLineInvoice.INSERT();
                end;
            until JobPlanningLineInvoice.NEXT() = 0;
    end;
    procedure GetJobPlanningLineInvoices(JobPlanningLine: Record "Job Planning Line")
    var
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
    begin
        CLEARALL();
        if JobPlanningLine."Line No." = 0 then exit;
        JobPlanningLine.TESTFIELD("Job No.");
        JobPlanningLine.TESTFIELD("Job Task No.");
        JobPlanningLineInvoice.SETRANGE("Job No.", JobPlanningLine."Job No.");
        JobPlanningLineInvoice.SETRANGE("Job Task No.", JobPlanningLine."Job Task No.");
        JobPlanningLineInvoice.SETRANGE("Job Planning Line No.", JobPlanningLine."Line No.");
        if JobPlanningLineInvoice.COUNT = 1 then begin
            JobPlanningLineInvoice.FINDFIRST();
            OpenSalesInvoice(JobPlanningLineInvoice);
        end
        else
            PAGE.RUNMODAL(PAGE::"Job Invoices", JobPlanningLineInvoice);
    end;
    procedure OpenSalesInvoice(JobPlanningLineInvoice: Record "Job Planning Line Invoice")
    var
        _recSalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeOpenSalesInvoice(JobPlanningLineInvoice, IsHandled);
        if IsHandled then exit;
        case JobPlanningLineInvoice."Document Type" of JobPlanningLineInvoice."Document Type"::Invoice: begin
            _recSalesHeader.GET(SalesHeader."Document Type"::Invoice, JobPlanningLineInvoice."Document No.");
            PAGE.RUNMODAL(PAGE::"Sales Invoice New", _recSalesHeader);
        end;
        JobPlanningLineInvoice."Document Type"::"Credit Memo": begin
            _recSalesHeader.GET(SalesHeader."Document Type"::"Credit Memo", JobPlanningLineInvoice."Document No.");
            PAGE.RUNMODAL(PAGE::"Sales Credit Memo", _recSalesHeader);
        end;
        JobPlanningLineInvoice."Document Type"::"Posted Invoice": begin
            if not SalesInvHeader.GET(JobPlanningLineInvoice."Document No.")then ERROR(Text012, SalesInvHeader.TABLECAPTION, JobPlanningLineInvoice."Document No.");
            PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvHeader);
        end;
        JobPlanningLineInvoice."Document Type"::"Posted Credit Memo": begin
            if not SalesCrMemoHeader.GET(JobPlanningLineInvoice."Document No.")then ERROR(Text012, SalesCrMemoHeader.TABLECAPTION, JobPlanningLineInvoice."Document No.");
            PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader);
        end;
        //OnAfterOpenSalesInvoice(JobPlanningLineInvoice);
        end;
    end;
    local procedure UpdateSalesHeader(var precSalesHeader: Record "Sales Header"; Job: Record Job) //
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeUpdateSalesHeader(precSalesHeader, Job, IsHandled);
        if IsHandled then exit;
        precSalesHeader."Bill-to Contact No.":=Job."Bill-to Contact No.";
        precSalesHeader."Bill-to Contact":=Job."Bill-to Contact";
        precSalesHeader."Bill-to Name":=Job."Bill-to Name";
        precSalesHeader."Bill-to Address":=Job."Bill-to Address";
        precSalesHeader."Bill-to Address 2":=Job."Bill-to Address 2";
        precSalesHeader."Bill-to City":=Job."Bill-to City";
        precSalesHeader."Bill-to Post Code":=Job."Bill-to Post Code";
        precSalesHeader."Sell-to Contact No.":=Job."Bill-to Contact No.";
        precSalesHeader."Sell-to Contact":=Job."Bill-to Contact";
        precSalesHeader."Sell-to Customer Name":=Job."Bill-to Name";
        precSalesHeader."Sell-to Address":=Job."Bill-to Address";
        precSalesHeader."Sell-to Address 2":=Job."Bill-to Address 2";
        precSalesHeader."Sell-to City":=Job."Bill-to City";
        precSalesHeader."Sell-to Post Code":=Job."Bill-to Post Code";
        precSalesHeader."Ship-to Contact":=Job."Bill-to Contact";
        precSalesHeader."Ship-to Name":=Job."Bill-to Name";
        precSalesHeader."Ship-to Address":=Job."Bill-to Address";
        precSalesHeader."Ship-to Address 2":=Job."Bill-to Address 2";
        precSalesHeader."Ship-to City":=Job."Bill-to City";
        precSalesHeader."Ship-to Post Code":=Job."Bill-to Post Code";
    end;
    local procedure UpdateSalesHeader1(var precSalesHeader: Record "Sales Header"; Job: Record Job; CustNo: Code[20])
    var
        IsHandled: Boolean;
        CustRec: Record Customer;
    begin
        IsHandled:=false;
        OnBeforeUpdateSalesHeader(precSalesHeader, Job, IsHandled);
        if IsHandled then exit;
        CustRec.Get(CustNo);
        precSalesHeader."Bill-to Contact No.":=CustRec."Primary Contact No.";
        precSalesHeader."Bill-to Contact":=CustRec.Contact;
        precSalesHeader."Bill-to Name":=CustRec.Name;
        precSalesHeader."Bill-to Address":=CustRec.Address;
        precSalesHeader."Bill-to Address 2":=CustRec."Address 2";
        precSalesHeader."Bill-to City":=CustRec.City;
        precSalesHeader."Bill-to Post Code":=CustRec."Post Code";
        precSalesHeader."Sell-to Contact No.":=CustRec."Primary Contact No.";
        precSalesHeader."Sell-to Contact":=CustRec.Contact;
        precSalesHeader."Sell-to Customer Name":=CustRec.Name;
        precSalesHeader."Sell-to Address":=CustRec.Address;
        precSalesHeader."Sell-to Address 2":=CustRec."Address 2";
        precSalesHeader."Sell-to City":=CustRec.City;
        precSalesHeader."Sell-to Post Code":=CustRec."Post Code";
        precSalesHeader."Ship-to Contact":=CustRec.Contact;
        precSalesHeader."Ship-to Name":=CustRec.Name;
        precSalesHeader."Ship-to Address":=CustRec.Address;
        precSalesHeader."Ship-to Address 2":=CustRec."Address 2";
        precSalesHeader."Ship-to City":=CustRec.City;
        precSalesHeader."Ship-to Post Code":=CustRec."Post Code";
    end;
    local procedure TestSalesHeader(var pSalesHeader: Record "Sales Header"; var Job: Record job; var CurrCode: Code[10])
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        CurrCode:=CurrCode; //
        OnBeforeTestSalesHeader(pSalesHeader, Job, IsHandled);
        if IsHandled then exit;
        pSalesHeader.TESTFIELD("Bill-to Customer No.", Job."Bill-to Customer No.");
        pSalesHeader.TESTFIELD("Sell-to Customer No.", Job."Bill-to Customer No.");
        //IF Job."Currency Code" <> '' THEN
        //  SalesHeader.TESTFIELD("Currency Code", Job."Currency Code")
        //ELSE
        //  SalesHeader.TESTFIELD("Currency Code", Job."Invoice Currency Code");
        pSalesHeader.TestField("Currency Code", CurrCode);
        OnAfterTestSalesHeader(pSalesHeader, Job);
    end;
    local procedure TestExchangeRate(var JobPlanningLine: Record "Job Planning Line"; PostingDate: Date)
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        if JobPlanningLine."Currency Code" <> '' then if(CurrencyExchangeRate.ExchangeRate(PostingDate, JobPlanningLine."Currency Code") <> JobPlanningLine."Currency Factor")then begin
                if not UpdateExchangeRates then UpdateExchangeRates:=CONFIRM(Text010, true);
                if UpdateExchangeRates then begin
                    JobPlanningLine."Currency Date":=PostingDate;
                    JobPlanningLine."Document Date":=PostingDate;
                    JobPlanningLine.VALIDATE("Currency Date");
                    JobPlanningLine."Last Date Modified":=TODAY;
                    JobPlanningLine."User ID":=Copystr(USERID, 1, MaxStrLen(JobPlanningLine."User ID")); //
                    JobPlanningLine.MODIFY(true);
                end
                else
                    ERROR('');
            end;
    end;
    local procedure GetLedgEntryDimSetID(JobPlanningLine: Record "Job Planning Line"): Integer var
        ResLedgEntry: Record "Res. Ledger Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        GLEntry: Record "G/L Entry";
    begin
        if JobPlanningLine."Ledger Entry No." = 0 then exit(0);
        case JobPlanningLine."Ledger Entry Type" of JobPlanningLine."Ledger Entry Type"::Resource: begin
            ResLedgEntry.GET(JobPlanningLine."Ledger Entry No.");
            exit(ResLedgEntry."Dimension Set ID");
        end;
        JobPlanningLine."Ledger Entry Type"::Item: begin
            ItemLedgEntry.GET(JobPlanningLine."Ledger Entry No.");
            exit(ItemLedgEntry."Dimension Set ID");
        end;
        JobPlanningLine."Ledger Entry Type"::"G/L Account": begin
            GLEntry.GET(JobPlanningLine."Ledger Entry No.");
            exit(GLEntry."Dimension Set ID");
        end;
        else
            exit(0);
        end;
    end;
    local procedure GetJobLedgEntryDimSetID(JobPlanningLine: Record "Job Planning Line"): Integer var
        JobLedgerEntry: Record "Job Ledger Entry";
    begin
        if JobPlanningLine."Job Ledger Entry No." = 0 then exit(0);
        if JobLedgerEntry.GET(JobPlanningLine."Job Ledger Entry No.")then exit(JobLedgerEntry."Dimension Set ID");
        exit(0);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesInvoiceLines(SalesHeader: Record "Sales Header"; NewInvoice: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; Job: Record Job; JobPlanningLine: Record "Job Planning Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesInvoiceLines(var JobPlanningLine: Record "Job Planning Line"; InvoiceNo: Code[20]; NewInvoice: Boolean; PostingDate: Date; CreditMemo: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesInvoiceJobTask(var JobTask2: Record "Job Task"; PostingDate: Date; InvoicePerTask: Boolean; var NoOfInvoices: Integer; var OldJobNo: Code[20]; var OldJobTaskNo: Code[20]; LastJobTask: Boolean; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteSalesLine(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetInvoiceNo(JobPlanningLine: Record "Job Planning Line"; Done: Boolean; NewInvoice: Boolean; PostingDate: Date; var InvoiceNo: Code[20]; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetCrMemoNo(JobPlanningLine: Record "Job Planning Line"; Done: Boolean; NewInvoice: Boolean; PostingDate: Date; var InvoiceNo: Code[20]; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSalesHeader(var SalesHeader: Record "Sales Header"; Job: Record Job)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifySalesHeader(var SalesHeader: Record "Sales Header"; Job: Record Job)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSalesLine(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; Job: Record Job; JobPlanningLine: Record "Job Planning Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeModifySalesLine(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; Job: Record Job; JobPlanningLine: Record "Job Planning Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenSalesInvoice(var JobPlanningLineInvoice: Record "Job Planning Line Invoice"; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestSalesHeader(var SalesHeader: Record "Sales Header"; Job: Record Job; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeTransferLine(var JobPlanningLine: Record "Job Planning Line"; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateSalesHeader(var SalesHeader: Record "Sales Header"; Job: Record Job; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterOpenSalesInvoice(var JobPlanningLineInvoice: Record "Job Planning Line Invoice")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterTestSalesHeader(var SalesHeader: Record "Sales Header"; Job: Record Job)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnCreateSalesHeaderOnBeforeUpdateSalesHeader(var SalesHeader: Record "Sales Header"; var Job: Record Job; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnCreateSalesInvoiceLinesOnBeforeCreateSalesLine(var JobPlanningLine: Record "Job Planning Line"; SalesHeader: Record "Sales Header"; SalesHeader2: Record "Sales Header"; NewInvoice: Boolean; var NoOfSalesLinesCreated: Integer)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnCreateSalesInvoiceLinesOnBeforeGetCustomer(JobPlanningLine: Record "Job Planning Line"; var Customer: Record Customer; var IsHandled: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnCreateSalesInvoiceJobTaskOnAfterLinesCreated(var SalesHeader: Record "Sales Header"; var Job: Record Job)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnCreateSalesInvoiceJobTaskOnBeforeCreateSalesLine(var JobPlanningLine: Record "Job Planning Line"; SalesHeader: Record "Sales Header"; SalesHeader2: Record "Sales Header"; var NoOfSalesLinesCreated: Integer)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnCreateSalesInvoiceJobTaskTestJob(var Job: Record Job)
    begin
    end;
}
