codeunit 50100 "Subscribe Events"
{
    [EventSubscriber(ObjectType::Table, Database::Job, 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertJobTaskLines(var Rec: Record Job)
    var
        JobTask: Record "Job Task";
        PICmgtCU: Codeunit "PIC Project Managment";
    begin
        if not JobTask.Get(Rec."No.", '1000') then begin
            JobTask.Init();
            JobTask.Validate("Job No.", Rec."No.");
            JobTask.Validate("Job Task No.", '1000');
            JobTask.Validate(Description, 'Stage Billing');
            JobTask.Insert(true);
        end;
        if not JobTask.Get(Rec."No.", '2000') then begin
            JobTask.Init();
            JobTask.Validate("Job No.", Rec."No.");
            JobTask.Validate("Job Task No.", '2000');
            JobTask.Validate(Description, 'Staff HR cost');
            JobTask.Insert(true);
            JobTask.Reset();
            JobTask.Get(Rec."No.", 2000);
            JobTask.Validate("WIP-Total", JobTask."WIP-Total"::Total);
            JobTask.Validate("WIP Method", 'SPOT');
            JobTask.Modify(true);
        end;
        //if not JobTask.Get(Rec."No.", '2001') then begin
        //  JobTask.Init();
        //JobTask.Validate("Job No.", Rec."No.");
        //JobTask.Validate("Job Task No.", '2001');
        //JobTask.Validate(Description, 'Overseas Staff HR cost');
        //JobTask.Insert(true);
        //JobTask.Reset();
        //JobTask.Get(Rec."No.", 2001);
        //JobTask.Validate("WIP-Total", JobTask."WIP-Total"::Excluded);
        //JobTask.Validate("WIP Method", 'SPOT');
        //JobTask.Modify(true);
        //end;
        if not JobTask.Get(Rec."No.", '3000') then begin
            JobTask.Init();
            JobTask.Validate("Job No.", Rec."No.");
            JobTask.Validate("Job Task No.", '3000');
            JobTask.Validate(Description, 'Expenses');
            JobTask.Insert(true);
        end;
        PICmgtCU.GenerateProjectTask(rec);//TEC VJ 23July2026
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Journal Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure UnitCostFromTimeSheet(var Rec: Record "Job Journal Line")
    var
        TimeSheetLine: Record "Time Sheet Line";
        ResourceCost: Record "Resource Cost New";
        UnitCost: Decimal;
        TotalQty: Decimal;
        Salary: Decimal;
        TimeSheetHdr: Record "Time Sheet Header";
        Resource: Record Resource;
    begin
        if Rec."Time Sheet No." <> '' then begin
            TotalQty := 0;
            TimeSheetHdr.Reset();
            TimeSheetHdr.Get(Rec."Time Sheet No.");
            if TimeSheetHdr."Time Sheet Type" = TimeSheetHdr."Time Sheet Type"::Hour then begin
                TimeSheetLine.Reset();
                TimeSheetLine.SetRange("Time Sheet No.", Rec."Time Sheet No.");
                //TimeSheetLine.SetRange("Line No.", Rec."Time Sheet Line No.");
                if TimeSheetLine.FindSet() then
                    repeat
                        if (TimeSheetLine."Timesheet Nature" = TimeSheetLine."Timesheet Nature"::Actual) then begin
                            TimeSheetLine.CalcFields("Total Quantity");
                            TotalQty += TimeSheetLine."Total Quantity";
                        end;
                        if (TimeSheetLine."Timesheet Nature" = TimeSheetLine."Timesheet Nature"::Projected) then //TimeSheetLine.CalcFields("Total Quantity");
                            TotalQty += TimeSheetLine."Estimated Work Hour";
                    until TimeSheetLine.next() = 0;
                ResourceCost.Reset();
                ResourceCost.SetRange(Type, ResourceCost.Type::Resource);
                ResourceCost.SetRange(Code, Rec."No.");
                ResourceCost.SetRange("Effective Date", CalcDate('<-CM>', Rec."Posting Date"), CalcDate('<CM>', Rec."Posting Date"));
                if TimeSheetLine."Timesheet Nature" = TimeSheetLine."Timesheet Nature"::Actual then ResourceCost.SetRange("History Status", ResourceCost."History Status"::Actual);
                if TimeSheetLine."Timesheet Nature" = TimeSheetLine."Timesheet Nature"::Projected then ResourceCost.SetRange("History Status", ResourceCost."History Status"::Projected);
                if ResourceCost.FindLast() then Salary := ResourceCost."Monthly Salary";
                UnitCost := 0;
                if TimeSheetHdr."Time Sheet Type" = TimeSheetHdr."Time Sheet Type"::Hour then UnitCost := Salary / TotalQty;
                if TimeSheetHdr."Time Sheet Type" = TimeSheetHdr."Time Sheet Type"::Percent then UnitCost := Salary / TotalQty;
                Rec.Validate("Unit Cost (LCY)", UnitCost);
                //Resource.Get(Rec."No.");
                //if Resource."Overseas Staff" then
                //    Rec.validate("Job Task No.", '2001');
            end;
            if (TimeSheetHdr."Time sheet Nature" = TimeSheetHdr."Time sheet Nature"::Projected) then
                Rec.Validate("Line Type", Rec."Line Type"::Budget)
            else
                Rec.Validate("Line Type", Rec."Line Type"::Billable);
            Rec.Modify();
        end;
    end;
    //[EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnBeforeDeleteEvent', '', True, True)]
    //local procedure UpdateContractLine(var Rec: Record "Job Planning Line")
    //var
    //    ContractLine: Record "Contract Card Line";
    //begin
    //    ContractLine.Reset();
    //    ContractLine.SetRange("Contract Code Full", Rec."Contract Code");
    //    ContractLine.SetRange("Stage Payment Code", Rec."Stage Payment Code");
    //    if ContractLine.FindSet() then
    //        repeat
    //            ContractLine.Selected := false;
    //            ContractLine.Modify(true);
    //        until ContractLine.Next() = 0;
    //end;
    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateExchRate(var Rec: Record "Job Planning Line")
    var
        ExchRate: Record "Currency Exchange Rate";
        JobJnlLine: Record "Job Journal Line";
        JobPlanLine123: Record "Job Planning Line";
        TotalHrsPrcnt: Decimal;
        JobSetup: Record "Jobs Setup";
    begin
        // TotalHrsPrcnt := 0;
        // JobJnlLine.Reset();
        // JobJnlLine.SetRange("Job No.", Rec."Job No.");
        // JobJnlLine.SetRange("Job Task No.", Rec."Job Task No.");
        // JobJnlLine.SetRange("No.", Rec."No.");
        // JobJnlLine.SetRange("Posting Date", Rec."Planning Date");
        // JobJnlLine.SetRange("Document No.", Rec."Document No.");
        // if Rec."Line Type" = Rec."Line Type"::Billable then JobJnlLine.SetRange("Line Type", JobJnlLine."Line Type"::Billable);
        // if Rec."Line Type" = Rec."Line Type"::Budget then JobJnlLine.SetRange("Line Type", JobJnlLine."Line Type"::Budget);
        // if JobJnlLine.FindFirst() then TotalHrsPrcnt := JobJnlLine."Total Hours Percent";
        // //rec.Modify();
        // if Rec."Line Type" = Rec."Line Type"::Budget then begin
        //     JobPlanLine123.Reset();
        //     JobPlanLine123.SetRange("Job No.", Rec."Job No.");
        //     JobPlanLine123.SetRange("Job Task No.", Rec."Job Task No.");
        //     JobPlanLine123.SetFilter("Line No.", '<>%1', Rec."Line No.");
        //     JobPlanLine123.SetRange("No.", Rec."No.");
        //     JobPlanLine123.SetRange("Planning Date", Rec."Planning Date");
        //     JobPlanLine123.SetRange("Line Type", JobPlanLine123."Line Type"::Budget);
        //     if JobPlanLine123.FindFirst() then begin
        //         rec."Total Hours Percent" := JobPlanLine123."Total Hours Percent" + TotalHrsPrcnt;
        //         // Rec."Unit Cost" += JobPlanLine123."Unit Cost";
        //         // Rec."Total Cost" += JobPlanLine123."Total Cost";
        //         // JobPlanLine123.Delete();
        //     end
        //     else
        //         Rec."Total Hours Percent" := TotalHrsPrcnt;
        // end
        // else
        //     Rec."Total Hours Percent" := TotalHrsPrcnt;
        // //Message('%1', TotalHrsPrcnt);
        // //Message('%1', Rec."Total Hours Percent");
        // if Rec."Currency Code 2" <> '' then begin
        //     ExchRate.Reset();
        //     ExchRate.SetCurrentKey("Currency Code", "Starting Date");
        //     ExchRate.SetRange("Currency Code", Rec."Currency Code 2");
        //     ExchRate.SetRange("Starting Date", 0D, WorkDate());
        //     if ExchRate.FindLast() then begin
        //         Rec."Exchange Rate" := ExchRate."Relational Exch. Rate Amount";
        //         Rec."Unit Price (LCY)" := Rec."Unit Price" * ExchRate."Relational Exch. Rate Amount";
        //         Rec."Line Amount (LCY)" := Rec."Unit Price" * ExchRate."Relational Exch. Rate Amount";
        //         Rec."Total Price (LCY)" := Rec."Unit Price" * ExchRate."Relational Exch. Rate Amount";
        //         rec."Unit Cost (LCY)" := rec."Unit Cost" * ExchRate."Relational Exch. Rate Amount";
        //         rec."Total Cost (LCY)" := rec."Total Cost" * ExchRate."Relational Exch. Rate Amount";
        //     end;
        // end;
        // if Rec.Type = Rec.Type::"G/L Account" then
        //     if Rec."No." = '' then begin
        //         jobSetup.Get();
        //         Rec.validate("No.", JobSetup."Job Planning Line Account No.");
        //     end;
        // //Error('abc');
        // rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnbeforeInsertEvent', '', true, true)]
    local procedure UpdateJobPlanLine(var Rec: Record "Job Planning Line")
    var
        JobPlanLine: Record "Job Planning Line";
    begin
        //Message('hi');
        JobPlanLine.Reset();
        JobPlanLine.SetRange("Job No.", Rec."Job No.");
        JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
        JobPlanLine.SetRange("No.", Rec."No.");
        JobPlanLine.SetRange("Planning Date", Rec."Planning Date");
        JobPlanLine.SetRange("Invoice No.", '');
        JobPlanLine.SetRange("Line Type", JobPlanLine."Line Type"::Budget);
        if JobPlanLine.FindFirst() then JobPlanLine.Delete();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterValidateEvent', 'Unit Price', true, true)]
    local procedure MyProcedure(var Rec: Record "Job Planning Line")
    var
        ExchRate: Record "Currency Exchange Rate";
    begin
        Rec."Net amount FCY" := Rec."Unit Price" * Rec.Quantity;
        if Rec."Currency Code 2" <> '' then begin
            ExchRate.Reset();
            ExchRate.SetCurrentKey("Currency Code", "Starting Date");
            ExchRate.SetRange("Currency Code", Rec."Currency Code 2");
            ExchRate.SetRange("Starting Date", 0D, WorkDate());
            if ExchRate.FindLast() then begin
                Rec."Exchange Rate" := ExchRate."Relational Exch. Rate Amount";
                Rec."Unit Price (LCY)" := Rec."Unit Price" * ExchRate."Relational Exch. Rate Amount";
                Rec."Line Amount (LCY)" := Rec."Line Amount" * ExchRate."Relational Exch. Rate Amount";
                Rec."Total Price (LCY)" := Rec."Total Price" * ExchRate."Relational Exch. Rate Amount";
                Rec."Net Amount LCY" := Rec."Net amount FCY" * ExchRate."Relational Exch. Rate Amount";
                //rec.Modify();
            end;
        end
        else begin
            Rec."Unit Price (LCY)" := Rec."Unit Price";
            Rec."Line Amount (LCY)" := Rec."Line Amount";
            Rec."Total Price (LCY)" := Rec."Total Price";
            Rec."Net Amount LCY" := Rec."Net amount FCY";
        end;
    end;
    //[EventSubscriber(ObjectType::Page, Page::"Job Journal", 'OnAfterActionEvent', 'P&ost', true, true)]
    //local procedure MergeJobPlanLine(var Rec: Record "Job Journal Line")
    //var
    //    JobPlanLine: Record "Job Planning Line";
    //    Qty: Decimal;
    //    Ctr: Integer;
    //begin
    //    Qty := 0;
    //    JobPlanLine.Reset();
    //    JobPlanLine.SetRange("Job No.", Rec."Job No.");
    //    JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
    //    JobPlanLine.SetFilter("Line Type", '<>%1', JobPlanLine."Line Type"::Budget);
    //    JobPlanLine.SetRange("No.", Rec."No.");
    //    JobPlanLine.SetRange("Document No.", Rec."Document No.");
    //    JobPlanLine.SetRange("Planning Date", CalcDate('-CM', Rec."Posting Date"), CalcDate('CM', Rec."Posting Date"));
    //    if JobPlanLine.FindSet() then
    //        repeat
    //            Qty += JobPlanLine.Quantity;
    ///        until JobPlanLine.Next() = 0;
     //   JobPlanLine.Reset();
    //   JobPlanLine.SetRange("Job No.", Rec."Job No.");
    //  JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
    //  JobPlanLine.SetFilter("Line Type", '<>%1', JobPlanLine."Line Type"::Budget);
    // JobPlanLine.SetRange("No.", Rec."No.");
    // JobPlanLine.SetRange("Document No.", Rec."Document No.");
    //JobPlanLine.SetRange("Planning Date", CalcDate('-CM', Rec."Posting Date"), CalcDate('CM', Rec."Posting Date"));
    //if JobPlanLine.Findfirst() then begin
    //    JobPlanLine.Validate(Quantity, Qty);
    //  JobPlanLine.Modify();
    //end;
    //ctr := 0;
    //JobPlanLine.Reset();
    //JobPlanLine.SetRange("Job No.", Rec."Job No.");
    //JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
    //JobPlanLine.SetFilter("Line Type", '<>%1', JobPlanLine."Line Type"::Budget);
    //JobPlanLine.SetRange("No.", Rec."No.");
    //JobPlanLine.SetRange("Document No.", Rec."Document No.");
    //JobPlanLine.SetRange("Planning Date", CalcDate('-CM', Rec."Posting Date"), CalcDate('CM', Rec."Posting Date"));
    //if JobPlanLine.FindSet() then
    //    repeat
    //      if ctr <> 0 then
    //        JobPlanLine.Delete();
    //  ctr += 1;
    //until JobPlanLine.Next() = 0;
    //end;
    [EventSubscriber(ObjectType::Table, Database::Job, 'OnAfterValidateEvent', 'Person Responsible', true, true)]
    local procedure UpdateDefDim(var Rec: Record Job)
    var
        DefDim: Record "Default Dimension";
        DimensionValue: Record "Dimension Value";
    begin
        if Rec."Person Responsible" <> '' then begin
            if not DimensionValue.GET('PIC', Rec."Person Responsible") then begin
                DimensionValue.INIT();
                DimensionValue."Dimension Code" := 'PIC';
                DimensionValue.Code := Rec."Person Responsible";
                DimensionValue.Name := Rec."Person Responsible";
                DimensionValue.INSERT(true);
            end;
            if DefDim.Get(167, Rec."No.", 'PIC') then DefDim.Delete();
            DefDim.Init();
            DefDim."Table ID" := 167;
            DefDim."No." := Rec."No.";
            DefDim."Dimension Code" := 'PIC';
            DefDim."Dimension Value Code" := Rec."Person Responsible";
            DefDim.Insert(true);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line Invoice", 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateInvoiceDateInJObPlanLine(var Rec: Record "Job Planning Line Invoice")
    var
        JobPlanLine: Record "Job Planning Line";
    begin
        if Rec."Document Type" = Rec."Document Type"::"Posted Invoice" then if JobPlanLine.Get(Rec."Job No.", Rec."Job Task No.", Rec."Job Planning Line No.") then;
        //JobPlanLine."Actual Invoice Date" := Today;
        //JobPlanLine."Invoice No." := Rec."Document No.";
        //JobPlanLine.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Cust. Ledg. Entry", 'OnAfterInsertEvent', '', true, true)]
    local procedure UpdateInvoiceNoInJobPlanLines(var Rec: Record "Detailed Cust. Ledg. Entry")
    var
        JobPlanLine: Record "Job Planning Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if (Rec."Entry Type" = Rec."Entry Type"::Application) and (Rec."Document Type" = Rec."Document Type"::Payment) then begin
            CustLedgEntry.Get(Rec."Cust. Ledger Entry No.");
            if CustLedgEntry."Document Type" = CustLedgEntry."Document Type"::Invoice then begin
                JobPlanLine.Reset();
                JobPlanLine.SetRange("Invoice No.", CustLedgEntry."Document No.");
                if JobPlanLine.FindSet() then
                    repeat
                        JobPlanLine."Actual Payment Date" := Rec."Posting Date";
                        JobPlanLine.Modify();
                    until JobPlanLine.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Ledger Entry", 'OnbeforeInsertEvent', '', true, true)]
    local procedure Onbeforeinsertjobledgerentry(var Rec: Record "Job Ledger Entry")
    var
        JobPlanLine: Record "Job Planning Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if rec.Description <> '' then
            rec."Job Description" := rec.Description;
        if rec."Global Dimension 1 Code" <> '' then
            rec.AuxiliaryIndex1 := rec."Global Dimension 1 Code";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnBeforeInsertEvent', '', true, true)]
    local procedure OnBeforeInsertCustLedgerEntry(var Rec: Record "Cust. Ledger Entry")
    begin
        if Rec."Global Dimension 1 Code" <> '' then
            Rec.AuxiliaryIndex1 := Rec."Global Dimension 1 Code";

    end;




}
