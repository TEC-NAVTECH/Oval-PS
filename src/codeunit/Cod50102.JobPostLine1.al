codeunit 50102 "Job Post-Line 1"
{
    // version NAVW111.00.00.19846
    Permissions = tabledata 169=rm,
        tabledata 1003=rimd;

    trigger OnRun()
    begin
    end;
    var TempSalesLineJob: Record "Sales Line" temporary;
    TempPurchaseLineJob: Record "Purchase Line" temporary;
    TempJobJournalLine: Record "Job Journal Line" temporary;
    JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
    JobTransferLine: Codeunit "Job Transfer Line";
    Text000: Label 'has been changed (initial a %1: %2= %3, %4= %5)';
    Text003: Label 'You cannot change the sales line because it is linked to\';
    Text004: Label ' %1: %2= %3, %4= %5.';
    Text005: Label 'You must post more usage or credit the sale of %1 %2 in %3 %4 before you can post purchase credit memo %5 %6 = %7.';
    procedure InsertPlLineFromLedgEntry(JobLedgEntry: Record "Job Ledger Entry")
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        if JobLedgEntry."Line Type" = JobLedgEntry."Line Type"::" " then exit;
        CLEARALL();
        JobPlanningLine."Job No.":=JobLedgEntry."Job No.";
        JobPlanningLine."Job Task No.":=JobLedgEntry."Job Task No.";
        JobPlanningLine.SETRANGE("Job No.", JobPlanningLine."Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", JobPlanningLine."Job Task No.");
        if JobPlanningLine.FINDLAST()then;
        JobPlanningLine."Line No.":=JobPlanningLine."Line No." + 10000;
        JobPlanningLine.INIT();
        JobPlanningLine.RESET();
        CLEAR(JobTransferLine);
        JobTransferLine.FromJobLedgEntryToPlanningLine(JobLedgEntry, JobPlanningLine);
        PostPlanningLine(JobPlanningLine);
    end;
    local procedure PostPlanningLine(JobPlanningLine: Record "Job Planning Line")
    var
        Job: Record Job;
    begin
        if JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::"Both Budget and Billable" then begin
            Job.GET(JobPlanningLine."Job No.");
            if not Job."Allow Schedule/Contract Lines" or (JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account")then begin
                JobPlanningLine.VALIDATE("Line Type", JobPlanningLine."Line Type"::Budget);
                JobPlanningLine.INSERT(true);
                InsertJobUsageLink(JobPlanningLine);
                JobPlanningLine.VALIDATE("Qty. to Transfer to Journal", 0);
                JobPlanningLine.MODIFY(true);
                JobPlanningLine."Job Contract Entry No.":=0;
                JobPlanningLine."Line No.":=JobPlanningLine."Line No." + 10000;
                JobPlanningLine.VALIDATE("Line Type", JobPlanningLine."Line Type"::Billable);
            end;
        end;
        if(JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account") and (JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::Billable)then ChangeGLNo(JobPlanningLine);
        JobPlanningLine.INSERT(true);
        JobPlanningLine.VALIDATE("Qty. to Transfer to Journal", 0);
        JobPlanningLine.MODIFY(true);
        if JobPlanningLine."Line Type" in[JobPlanningLine."Line Type"::Budget, JobPlanningLine."Line Type"::"Both Budget and Billable"]then InsertJobUsageLink(JobPlanningLine);
    end;
    local procedure InsertJobUsageLink(JobPlanningLine: Record "Job Planning Line")
    var
        JobUsageLink: Record "Job Usage Link";
        JobLedgerEntry: Record "Job Ledger Entry";
    begin
        if not JobPlanningLine."Usage Link" then exit;
        JobLedgerEntry.GET(JobPlanningLine."Job Ledger Entry No.");
        JobUsageLink.Create(JobPlanningLine, JobLedgerEntry);
    end;
    procedure PostInvoiceContractLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    var
        Job: Record Job;
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
        EntryType: Option Usage, Sale;
        JobLedgEntryNo: Integer;
    begin
        JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
        JobPlanningLine.SETRANGE("Job Contract Entry No.", SalesLine."Job Contract Entry No.");
        JobPlanningLine.FINDFIRST();
        Job.GET(JobPlanningLine."Job No.");
        if Job."Invoice Currency Code" = '' then //Job.TESTFIELD("Currency Code", SalesHeader."Currency Code");
 //Job.TESTFIELD("Currency Code", JobPlanningLine."Currency Code");
            //SalesHeader.TESTFIELD("Currency Code", JobPlanningLine."Currency Code");
            //SalesHeader.TESTFIELD("Currency Factor", JobPlanningLine."Currency Factor");
            Job."Invoice Currency Code":=Job."Invoice Currency Code" //
        else
            Job.TESTFIELD("Currency Code", '');
        //JobPlanningLine.TESTFIELD("Currency Code", '');
        //SalesHeader.TESTFIELD("Bill-to Customer No.", Job."Bill-to Customer No.");
        JobPlanningLine.CALCFIELDS("Qty. Transferred to Invoice");
        if JobPlanningLine.Type <> JobPlanningLine.Type::Text then JobPlanningLine.TESTFIELD("Qty. Transferred to Invoice");
        ValidateRelationship(SalesHeader, SalesLine, JobPlanningLine);
        case SalesHeader."Document Type" of SalesHeader."Document Type"::Invoice: if JobPlanningLineInvoice.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", JobPlanningLine."Line No.", JobPlanningLineInvoice."Document Type"::Invoice, SalesHeader."No.", SalesLine."Line No.")then begin
                JobPlanningLineInvoice.DELETE(true);
                JobPlanningLineInvoice."Document Type":=JobPlanningLineInvoice."Document Type"::"Posted Invoice";
                JobPlanningLineInvoice."Document No.":=SalesLine."Document No.";
                JobLedgEntryNo:=FindNextJobLedgEntryNo(JobPlanningLineInvoice);
                JobPlanningLineInvoice.INSERT(true);
                JobPlanningLineInvoice."Invoiced Date":=SalesHeader."Posting Date";
                JobPlanningLineInvoice."Invoiced Amount (LCY)":=CalcLineAmountLCY(JobPlanningLine, JobPlanningLineInvoice."Quantity Transferred");
                JobPlanningLineInvoice."Invoiced Cost Amount (LCY)":=JobPlanningLineInvoice."Quantity Transferred" * JobPlanningLine."Unit Cost (LCY)";
                JobPlanningLineInvoice."Job Ledger Entry No.":=JobLedgEntryNo;
                JobPlanningLineInvoice.MODIFY();
            end;
        SalesHeader."Document Type"::"Credit Memo": if JobPlanningLineInvoice.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.", JobPlanningLine."Line No.", JobPlanningLineInvoice."Document Type"::"Credit Memo", SalesHeader."No.", SalesLine."Line No.")then begin
                JobPlanningLineInvoice.DELETE(true);
                JobPlanningLineInvoice."Document Type":=JobPlanningLineInvoice."Document Type"::"Posted Credit Memo";
                JobPlanningLineInvoice."Document No.":=SalesLine."Document No.";
                JobLedgEntryNo:=FindNextJobLedgEntryNo(JobPlanningLineInvoice);
                JobPlanningLineInvoice.INSERT(true);
                JobPlanningLineInvoice."Invoiced Date":=SalesHeader."Posting Date";
                JobPlanningLineInvoice."Invoiced Amount (LCY)":=CalcLineAmountLCY(JobPlanningLine, JobPlanningLineInvoice."Quantity Transferred");
                JobPlanningLineInvoice."Invoiced Cost Amount (LCY)":=JobPlanningLineInvoice."Quantity Transferred" * JobPlanningLine."Unit Cost (LCY)";
                JobPlanningLineInvoice."Job Ledger Entry No.":=JobLedgEntryNo;
                JobPlanningLineInvoice.MODIFY();
            end;
        end;
        JobPlanningLine.UpdateQtyToInvoice();
        JobPlanningLine."Actual Invoice Date":=Today; //PS
        //JobPlanningLine."Invoice No." := SalesLine."Document No.";  //PS
        JobPlanningLine.MODIFY();
        if JobPlanningLine.Type <> JobPlanningLine.Type::Text then PostJobOnSalesLine(JobPlanningLine, SalesHeader, SalesLine, "Job Journal Line Entry Type"::Sale);
    //PostJobOnSalesLine(JobPlanningLine, SalesHeader, SalesLine, EntryType::Sale);
    end;
    local procedure ValidateRelationship(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; JobPlanningLine: Record "Job Planning Line")
    var
        JobTask: Record "Job Task";
        Txt: Text[500];
    begin
        JobTask.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
        Txt:=STRSUBSTNO(Text000, JobTask.TABLECAPTION, JobTask.FIELDCAPTION("Job No."), JobTask."Job No.", JobTask.FIELDCAPTION("Job Task No."), JobTask."Job Task No.");
        if JobPlanningLine.Type = JobPlanningLine.Type::Text then if SalesLine.Type <> SalesLine.Type::" " then SalesLine.FIELDERROR(Type, Txt);
        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then if SalesLine.Type <> SalesLine.Type::Resource then SalesLine.FIELDERROR(Type, Txt);
        if JobPlanningLine.Type = JobPlanningLine.Type::Item then if SalesLine.Type <> SalesLine.Type::Item then SalesLine.FIELDERROR(Type, Txt);
        if JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account" then if SalesLine.Type <> SalesLine.Type::"G/L Account" then SalesLine.FIELDERROR(Type, Txt);
        if SalesLine."No." <> JobPlanningLine."No." then SalesLine.FIELDERROR("No.", Txt);
        if SalesLine."Location Code" <> JobPlanningLine."Location Code" then SalesLine.FIELDERROR("Location Code", Txt);
        if SalesLine."Work Type Code" <> JobPlanningLine."Work Type Code" then SalesLine.FIELDERROR("Work Type Code", Txt);
        if SalesLine."Unit of Measure Code" <> JobPlanningLine."Unit of Measure Code" then SalesLine.FIELDERROR("Unit of Measure Code", Txt);
        if SalesLine."Variant Code" <> JobPlanningLine."Variant Code" then SalesLine.FIELDERROR("Variant Code", Txt);
        if SalesLine."Gen. Prod. Posting Group" <> JobPlanningLine."Gen. Prod. Posting Group" then SalesLine.FIELDERROR("Gen. Prod. Posting Group", Txt);
        if SalesLine."Line Discount %" <> JobPlanningLine."Line Discount %" then SalesLine.FIELDERROR("Line Discount %", Txt);
        if JobPlanningLine."Unit Cost (LCY)" <> SalesLine."Unit Cost (LCY)" then SalesLine.FIELDERROR("Unit Cost (LCY)", Txt);
        if SalesLine.Type = SalesLine.Type::" " then if SalesLine."Line Amount" <> 0 then SalesLine.FIELDERROR("Line Amount", Txt);
        if SalesHeader."Prices Including VAT" then if JobPlanningLine."VAT %" <> SalesLine."VAT %" then SalesLine.FIELDERROR("VAT %", Txt);
    end;
    procedure PostJobOnSalesLine(JobPlanningLine: Record "Job Planning Line"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; EntryType: Enum "Job Journal Line Entry Type")
    var
        JobJnlLine: Record "Job Journal Line";
    begin
        JobTransferLine.FromPlanningSalesLineToJnlLine(JobPlanningLine, SalesHeader, SalesLine, JobJnlLine, EntryType);
        if SalesLine.Type = SalesLine.Type::"G/L Account" then begin
            TempSalesLineJob:=SalesLine;
            TempSalesLineJob.Insert();
            InsertTempJobJournalLine(JobJnlLine, TempSalesLineJob."Line No.");
        end
        else
            JobJnlPostLine.RunWithCheck(JobJnlLine);
    end;
    local procedure CalcLineAmountLCY(JobPlanningLine: Record "Job Planning Line"; Qty: Decimal): Decimal var
        TotalPrice: Decimal;
    begin
        TotalPrice:=ROUND(Qty * JobPlanningLine."Unit Price (LCY)", 0.01);
        exit(TotalPrice - ROUND(TotalPrice * JobPlanningLine."Line Discount %" / 100, 0.01));
    end;
    procedure PostGenJnlLine(GenJnlLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry")
    var
        JobJnlLine: Record "Job Journal Line";
        Job: Record Job;
        JT: Record "Job Task";
        SourceCodeSetup: Record "Source Code Setup";
        _cuJobTransferLine: Codeunit "Job Transfer Line"; //
    begin
        if GenJnlLine."System-Created Entry" then exit;
        if GenJnlLine."Job No." = '' then exit;
        SourceCodeSetup.GET();
        if GenJnlLine."Source Code" = SourceCodeSetup."Job G/L WIP" then exit;
        GenJnlLine.TESTFIELD("Job Task No.");
        GenJnlLine.TESTFIELD("Job Quantity");
        Job.LOCKTABLE();
        JT.LOCKTABLE();
        Job.GET(GenJnlLine."Job No.");
        //GenJnlLine.TESTFIELD("Job Currency Code", Job."Currency Code");
        JT.GET(GenJnlLine."Job No.", GenJnlLine."Job Task No.");
        JT.TESTFIELD("Job Task Type", JT."Job Task Type"::Posting);
        _cuJobTransferLine.FromGenJnlLineToJnlLine(GenJnlLine, JobJnlLine);
        JobJnlPostLine.SetGLEntryNo(GLEntry."Entry No.");
        JobJnlPostLine.RunWithCheck(JobJnlLine);
        JobJnlPostLine.SetGLEntryNo(0);
    end;
    procedure PostJobOnPurchaseLine(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; PurchLine: Record "Purchase Line"; Sourcecode: Code[10])
    var
        JobJnlLine: Record "Job Journal Line";
        Job: Record Job;
        JobTask: Record "Job Task";
    begin
        //OnBeforePostJobOnPurchaseLine(PurchHeader, PurchInvHeader, PurchCrMemoHdr, PurchLine, JobJnlLine);
        if(PurchLine.Type <> PurchLine.Type::Item) and (PurchLine.Type <> PurchLine.Type::"G/L Account")then exit;
        CLEAR(JobJnlLine);
        PurchLine.TESTFIELD("Job No.");
        PurchLine.TESTFIELD("Job Task No.");
        Job.LOCKTABLE();
        JobTask.LOCKTABLE();
        Job.GET(PurchLine."Job No.");
        //PurchLine.TESTFIELD("Job Currency Code", Job."Currency Code");
        JobTask.GET(PurchLine."Job No.", PurchLine."Job Task No.");
        JobTransferLine.FromPurchaseLineToJnlLine(PurchHeader, PurchInvHeader, PurchCrMemoHdr, PurchLine, Sourcecode, JobJnlLine);
        JobJnlLine."Job Posting Only":=true;
        if PurchLine.Type = PurchLine.Type::"G/L Account" then begin
            TempPurchaseLineJob:=PurchLine;
            TempPurchaseLineJob.INSERT();
            InsertTempJobJournalLine(JobJnlLine, TempPurchaseLineJob."Line No.");
        end
        else
            JobJnlPostLine.RunWithCheck(JobJnlLine);
    end;
    procedure TestSalesLine(var SalesLine: Record "Sales Line")
    var
        JT: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        Txt: Text[250];
    begin
        if SalesLine."Job Contract Entry No." = 0 then exit;
        JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
        JobPlanningLine.SETRANGE("Job Contract Entry No.", SalesLine."Job Contract Entry No.");
        if JobPlanningLine.FINDFIRST()then begin
            JT.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
            Txt:=Text003 + STRSUBSTNO(Text004, JT.TABLECAPTION, JT.FIELDCAPTION("Job No."), JT."Job No.", JT.FIELDCAPTION("Job Task No."), JT."Job Task No.");
            ERROR(Txt);
        end;
    end;
    local procedure ChangeGLNo(var JobPlanningLine: Record "Job Planning Line")
    var
        GLAcc: Record "G/L Account";
        Job: Record Job;
        JT: Record "Job Task";
        JobPostingGr: Record "Job Posting Group";
        Cust: Record Customer;
    begin
        JT.GET(JobPlanningLine."Job No.", JobPlanningLine."Job Task No.");
        Job.GET(JobPlanningLine."Job No.");
        //Cust.GET(Job."Bill-to Customer No.");
        Cust.Get(JobPlanningLine."Customer No.");
        if JT."Job Posting Group" <> '' then JobPostingGr.GET(JT."Job Posting Group")
        else
        begin
            Job.TESTFIELD("Job Posting Group");
            JobPostingGr.GET(Job."Job Posting Group");
        end;
        if JobPostingGr."G/L Expense Acc. (Contract)" = '' then exit;
        GLAcc.GET(JobPostingGr."G/L Expense Acc. (Contract)");
        GLAcc.CheckGLAcc();
        JobPlanningLine."No.":=GLAcc."No.";
        JobPlanningLine."Gen. Bus. Posting Group":=Cust."Gen. Bus. Posting Group";
        JobPlanningLine."Gen. Prod. Posting Group":=GLAcc."Gen. Prod. Posting Group";
    end;
    procedure CheckItemQuantityPurchCredit(var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line")
    var
        Item: Record Item;
        Job: Record Job;
    begin
        Job.GET(PurchaseLine."Job No.");
        if Job.GetQuantityAvailable(PurchaseLine."No.", PurchaseLine."Location Code", PurchaseLine."Variant Code", 0, 2) < -PurchaseLine."Return Qty. to Ship (Base)" then ERROR(Text005, Item.TABLECAPTION, PurchaseLine."No.", Job.TABLECAPTION, PurchaseLine."Job No.", PurchaseHeader."No.", PurchaseLine.FIELDCAPTION("Line No."), PurchaseLine."Line No.");
    end;
    procedure PostPurchaseGLAccounts(TempInvoicePostBuffer: Record "OP Invoice Post. Buffer" temporary; GLEntryNo: Integer) //
    begin
        //WITH TempPurchaseLineJob DO BEGIN
        TempPurchaseLineJob.RESET();
        TempPurchaseLineJob.SETRANGE("Job No.", TempInvoicePostBuffer."Job No.");
        TempPurchaseLineJob.SETRANGE("No.", TempInvoicePostBuffer."G/L Account");
        TempPurchaseLineJob.SETRANGE("Gen. Bus. Posting Group", TempInvoicePostBuffer."Gen. Bus. Posting Group");
        TempPurchaseLineJob.SETRANGE("Gen. Prod. Posting Group", TempInvoicePostBuffer."Gen. Prod. Posting Group");
        TempPurchaseLineJob.SETRANGE("VAT Bus. Posting Group", TempInvoicePostBuffer."VAT Bus. Posting Group");
        TempPurchaseLineJob.SETRANGE("VAT Prod. Posting Group", TempInvoicePostBuffer."VAT Prod. Posting Group");
        if TempPurchaseLineJob.FINDSET()then begin
            repeat TempJobJournalLine.RESET();
                TempJobJournalLine.SETRANGE("Line No.", TempPurchaseLineJob."Line No.");
                TempJobJournalLine.FINDFIRST();
                JobJnlPostLine.SetGLEntryNo(GLEntryNo);
                JobJnlPostLine.RunWithCheck(TempJobJournalLine);
            until TempPurchaseLineJob.NEXT() = 0;
            TempPurchaseLineJob.DELETEALL();
        end;
    //END;
    end;
    procedure PostSalesGLAccounts(TempInvoicePostBuffer: Record "OP Invoice Post. Buffer" temporary; GLEntryNo: Integer) //
    begin
        //WITH TempSalesLineJob DO BEGIN
        TempSalesLineJob.RESET();
        TempSalesLineJob.SETRANGE("Job No.", TempInvoicePostBuffer."Job No.");
        TempSalesLineJob.SETRANGE("No.", TempInvoicePostBuffer."G/L Account");
        TempSalesLineJob.SETRANGE("Gen. Bus. Posting Group", TempInvoicePostBuffer."Gen. Bus. Posting Group");
        TempSalesLineJob.SETRANGE("Gen. Prod. Posting Group", TempInvoicePostBuffer."Gen. Prod. Posting Group");
        TempSalesLineJob.SETRANGE("VAT Bus. Posting Group", TempInvoicePostBuffer."VAT Bus. Posting Group");
        TempSalesLineJob.SETRANGE("VAT Prod. Posting Group", TempInvoicePostBuffer."VAT Prod. Posting Group");
        if TempSalesLineJob.FINDSET()then begin
            repeat TempJobJournalLine.RESET();
                TempJobJournalLine.SETRANGE("Line No.", TempSalesLineJob."Line No.");
                TempJobJournalLine.FINDFIRST();
                JobJnlPostLine.SetGLEntryNo(GLEntryNo);
                JobJnlPostLine.RunWithCheck(TempJobJournalLine);
            until TempSalesLineJob.NEXT() = 0;
            TempSalesLineJob.DELETEALL();
        end;
    //END;
    end;
    local procedure InsertTempJobJournalLine(JobJournalLine: Record "Job Journal Line"; LineNo: Integer)
    begin
        TempJobJournalLine:=JobJournalLine;
        TempJobJournalLine."Line No.":=LineNo;
        TempJobJournalLine.INSERT();
    end;
    local procedure FindNextJobLedgEntryNo(JobPlanningLineInvoice: Record "Job Planning Line Invoice"): Integer var
        RelatedJobPlanningLineInvoice: Record "Job Planning Line Invoice";
        JobLedgEntry: Record "Job Ledger Entry";
    begin
        RelatedJobPlanningLineInvoice.SETRANGE("Document Type", JobPlanningLineInvoice."Document Type");
        RelatedJobPlanningLineInvoice.SETRANGE("Document No.", JobPlanningLineInvoice."Document No.");
        if RelatedJobPlanningLineInvoice.FINDLAST()then exit(RelatedJobPlanningLineInvoice."Job Ledger Entry No." + 1);
        if JobLedgEntry.FINDLAST()then exit(JobLedgEntry."Entry No." + 1);
        exit(1);
    end;
//[IntegrationEvent(false, TRUE)]
//local procedure OnBeforePostJobOnPurchaseLine(var PurchHeader: Record "Purchase Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchLine: Record "Purchase Line"; var JobJnlLine: Record "Job Journal Line")
//begin
//end;
}
