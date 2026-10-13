page 50108 "Contract Lines"
{
    PageType = List;
    //UsageCategory = Lists;
    //ApplicationArea = All;
    SourceTable = "Contract Card Line";
    //CardPageId = "Contract Card";
    //Editable = false;
    Caption = 'Contract Lines';
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;
    UsageCategory = None; //

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = All;
                }
                field(Phase; Rec.Phase)
                {
                    ApplicationArea = All;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Stage Percent"; Rec."Stage Percent")
                {
                    ApplicationArea = All;
                }
                field("Project Stage"; Rec."Project Stage")
                {
                    ApplicationArea = All;
                }
                field("Stage Details Description"; Rec."Stage Details Description")
                {
                    ApplicationArea = All;
                }
                field("Stage Payment Code"; Rec."Stage Payment Code")
                {
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                }
                field("Stage Amount"; Rec."Stage Amount")
                {
                    ApplicationArea = All;
                }
                field("Contract Code Full"; Rec."Contract Code Full")
                {
                    ApplicationArea = All;
                }
                field(ProjBillMth; Rec.ProjBillMth)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ProjBillMth field.', Comment = '%';
                }
                field(FinEstBillMth; Rec."FinEstBillMth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FinEstBillMth field.', Comment = '%';
                }
                field(ActualBillMth; Rec.ActualBillMth)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ActualBillMth field.', Comment = '%';
                }
                field(ProjRecMth; Rec.ProjRecMth)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ProjRecMth field.', Comment = '%';
                }

            }
        }


    }
    actions
    {
        area(Processing)
        {
            action(CreateProjectPlanningline)
            {
                Caption = 'Create Project Planning lines';
                Image = CreateLines;
                ApplicationArea = All;

                trigger OnAction()
                var
                begin
                    CreateProjectPlanningLines();
                end;

            }
        }
    }
    procedure CreateProjectPlanningLines()
    var
        ContractLine: Record "Contract Card Line";
        JobPlanningLine: Record "Job Planning Line";
        Contract: Record "Contract Card Header";
        ProjectSetup: Record "Jobs Setup";
        Job: Record Job;
        JobTask: Record "Job Task";
        TaskNo: Code[20];
        ProjectNo: Code[20];
        AccountNo: Code[20];
        CreatedCount: Integer;
    begin
        // ------------------------------------------------------------
        // Get Contract
        // ------------------------------------------------------------
        if Rec."Contract Code Full" = '' then
            Error('Contract No. must not be blank.');

        Contract.Get(Rec."Contract Code Full");

        // ------------------------------------------------------------
        // Get Project No. from Contract
        // CHANGE "Project Code" if your field has another name.
        // ------------------------------------------------------------
        ProjectNo := Contract."Project Code";

        if ProjectNo = '' then
            Error(
                'Project Code is blank in Contract %1.',
                Contract."Project Code");

        // ------------------------------------------------------------
        // Check Project
        // ------------------------------------------------------------
        if not Job.Get(ProjectNo) then
            Error(
                'Project %1 does not exist.',
                ProjectNo);

        // ------------------------------------------------------------
        // Get Job Planning Line G/L Account from Project Setup
        // CHANGE the table/field name if your setup is different.
        // ------------------------------------------------------------
        ProjectSetup.Get();

        AccountNo := ProjectSetup."Job Planning Line Account No.";

        if AccountNo = '' then
            Error(
                'Job Planning Lines Account No. is not configured in Project Setup.');

        // ------------------------------------------------------------
        // Validate that required project tasks exist
        // ------------------------------------------------------------
        ValidateProjectTask(JobTask, ProjectNo, '1100');
        ValidateProjectTask(JobTask, ProjectNo, '1200');

        // ------------------------------------------------------------
        // Create planning lines for each selected contract line
        // ------------------------------------------------------------
        ContractLine.Reset();
        ContractLine.SetRange("Contract Code Full", Rec."Contract Code Full");
        if ContractLine.FindSet() then
            repeat
                // Task 1100
                CreatePlanningLine(
                    JobPlanningLine,
                    ContractLine,
                    ProjectNo,
                    '1100',
                    AccountNo);

                CreatedCount += 1;

                // Task 1200
                CreatePlanningLine(
                    JobPlanningLine,
                    ContractLine,
                    ProjectNo,
                    '1200',
                    AccountNo);

                CreatedCount += 1;

            until ContractLine.Next() = 0;

        Message(
            '%1 Project Planning Lines have been created for Project %2.',
            CreatedCount,
            ProjectNo);
    end;

    local procedure CreatePlanningLine(
        var JobPlanningLine: Record "Job Planning Line";
        ContractLine: Record "Contract Card Line";
        ProjectNo: Code[20];
        TaskNo: Code[20];
        AccountNo: Code[20])
    var
        NextLineNo: Integer;
    begin
        NextLineNo := GetNextPlanningLineNo(
            JobPlanningLine,
            ProjectNo,
            TaskNo);

        Clear(JobPlanningLine);

        JobPlanningLine.Init();

        // ------------------------------------------------------------
        // Primary project information
        // ------------------------------------------------------------
        JobPlanningLine."Job No." := ProjectNo;
        JobPlanningLine."Job Task No." := TaskNo;
        JobPlanningLine."Line No." := NextLineNo;

        // ------------------------------------------------------------
        // Planning date
        // ------------------------------------------------------------
        JobPlanningLine."Planned Delivery Date" := Today;

        // ------------------------------------------------------------
        // Type = G/L Account
        // ------------------------------------------------------------
        JobPlanningLine.Type :=
            JobPlanningLine.Type::"G/L Account";

        // ------------------------------------------------------------
        // G/L Account No.
        // ------------------------------------------------------------
        JobPlanningLine.Validate("No.", AccountNo);

        // ------------------------------------------------------------
        // Line Type = Billable
        // ------------------------------------------------------------
        JobPlanningLine."Line Type" :=
            JobPlanningLine."Line Type"::Billable;

        // ------------------------------------------------------------
        // Description = Stage Details Description
        // CHANGE field name if necessary.
        // ------------------------------------------------------------
        JobPlanningLine.Description :=
            ContractLine."Stage Details Description";

        // ------------------------------------------------------------
        // Currency
        // CHANGE "Currency Code" if your Contract Line uses
        // another currency field.
        // ------------------------------------------------------------
        JobPlanningLine."Currency Code" :=
            ContractLine.Currency;

        // ------------------------------------------------------------
        // Quantity = 1
        // ------------------------------------------------------------
        JobPlanningLine.Validate(Quantity, 1);

        // ------------------------------------------------------------
        // Unit Price = Stage Amount
        // CHANGE field name if necessary.
        // ------------------------------------------------------------
        JobPlanningLine.Validate(
            "Unit Price",
            ContractLine."Stage Amount");

        // ------------------------------------------------------------
        // Mark as contract/billable planning line
        // ------------------------------------------------------------
        JobPlanningLine."Contract Line" := true;

        // ------------------------------------------------------------
        // Insert
        // ------------------------------------------------------------
        JobPlanningLine.Insert(true);
    end;

    local procedure GetNextPlanningLineNo(
        var JobPlanningLine: Record "Job Planning Line";
        ProjectNo: Code[20];
        TaskNo: Code[20]): Integer
    begin
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("Job No.", ProjectNo);
        JobPlanningLine.SetRange("Job Task No.", TaskNo);

        if JobPlanningLine.FindLast() then
            exit(JobPlanningLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure ValidateProjectTask(
        var JobTask: Record "Job Task";
        ProjectNo: Code[20];
        TaskNo: Code[20])
    begin
        JobTask.Reset();
        JobTask.SetRange("Job No.", ProjectNo);
        JobTask.SetRange("Job Task No.", TaskNo);

        if not JobTask.FindFirst() then
            Error(
                'Project %1 does not contain Project Task %2.',
                ProjectNo,
                TaskNo);
    end;
}
