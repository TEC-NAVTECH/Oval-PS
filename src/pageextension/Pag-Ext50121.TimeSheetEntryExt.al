pageextension 50121 TimeSheetEntryExt extends "Time Sheet Monthly"
{
    actions
    {
        addafter(Reopen1)
        {
            action(CreateActualHRrecord)
            {
                ApplicationArea = all;
                Caption = 'Create Actual HR% record';
                Image = CreateDocument;
                ToolTip = 'Create Actual HR% records from Time Sheet Lines.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                begin
                    if not Confirm('Do you want to create Actual HR%% records for Time Sheet %1?', true, Rec."Time Sheet No.") then
                        exit;
                    CreateActualHRRecords(Rec."Time Sheet No.");
                end;
            }
        }
    }
    procedure CreateActualHRRecords(TimeSheetNo: Code[20])
    var
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        ActualHR: Record "Actual HR%";
        Resource: Record Resource;
        Job: Record Job;
        CreatedCount: Integer;
        ExistingCount: Integer;
        StartDate: Date;
        EndDate: Date;
    begin
        if TimeSheetNo = '' then
            Error('Please select a Time Sheet No. first.');
        TimeSheetHeader.Reset();
        TimeSheetHeader.SetRange("No.", TimeSheetNo);
        if not TimeSheetHeader.FindFirst() then
            Error('Time Sheet %1 does not exist.', TimeSheetNo);
        // Time Sheet period
        StartDate := TimeSheetHeader."Starting Date";
        EndDate := TimeSheetHeader."Ending Date";
        if StartDate = 0D then
            Error('Starting Date is blank for Time Sheet %1.', TimeSheetNo);
        if EndDate = 0D then
            Error('Ending Date is blank for Time Sheet %1.', TimeSheetNo);
        TimeSheetLine.Reset();
        TimeSheetLine.SetRange("Time Sheet No.", TimeSheetNo);
        if TimeSheetLine.IsEmpty() then
            Error('No Time Sheet Lines exist for Time Sheet %1.', TimeSheetNo);
        if TimeSheetLine.FindSet() then
            repeat
                // Ignore blank/non-project lines
                if TimeSheetLine."Job No." <> '' then begin
                    Resource.Reset();
                    if not Resource.Get(TimeSheetHeader."Resource No.") then
                        Error('Resource %1 does not exist.', TimeSheetHeader."Resource No.");
                    Job.Reset();
                    if not Job.Get(TimeSheetLine."Job No.") then
                        Error('Project %1 does not exist.', TimeSheetLine."Job No.");
                    // Prevent duplicate Actual HR% record
                    ActualHR.Reset();
                    ActualHR.SetRange("Resource No", TimeSheetHeader."Resource No.");
                    ActualHR.SetRange("Project Code", TimeSheetLine."Job No.");
                    ActualHR.SetRange(Month, Date2DMY(StartDate, 2));
                    ActualHR.SetRange(Year, Date2DMY(StartDate, 3));
                    if ActualHR.FindFirst() then begin
                        if not Confirm('Actual HR% already exist So Do you want to Create/Overwrite Actual HR% records for Time Sheet %1 and Project No. %2?', true, TimeSheetLine."Time Sheet No.", TimeSheetLine."Job No.") then
                            exit;
                        ActualHR.Delete();
                        ActualHR.Init();
                        ActualHR."Resource No" := TimeSheetHeader."Resource No.";
                        ActualHR."Project Code" := TimeSheetLine."Job No.";
                        ActualHR."Month/Year" := GetMonthYear(StartDate);
                        ActualHR."Staff Name" := Resource."Name (Short)";
                        ActualHR."Project Name" := Job.Description;
                        ActualHR."Project HR%" := TimeSheetLine."Percent Per Month";
                        ActualHR.Month := Date2DMY(StartDate, 2);
                        ActualHR.Year := Date2DMY(StartDate, 3);
                        ActualHR.Insert(true);
                        CreatedCount += 1;
                    end
                    else begin
                        ActualHR.Init();
                        ActualHR."Resource No" := TimeSheetHeader."Resource No.";
                        ActualHR."Project Code" := TimeSheetLine."Job No.";
                        ActualHR."Month/Year" := GetMonthYear(StartDate);
                        ActualHR."Staff Name" := Resource."Name (Short)";
                        ActualHR."Project Name" := Job.Description;
                        ActualHR."Project HR%" := TimeSheetLine."Percent Per Month";
                        ActualHR.Month := Date2DMY(StartDate, 2);
                        ActualHR.Year := Date2DMY(StartDate, 3);
                        ActualHR.Insert(true);
                        CreatedCount += 1;
                    end;

                    // if ActualHR.IsEmpty() then begin
                    //     ActualHR.Init();
                    //     ActualHR."Resource No" := TimeSheetHeader."Resource No.";
                    //     ActualHR."Project Code" := TimeSheetLine."Job No.";

                    //     ActualHR."Month/Year" := GetMonthYear(StartDate);
                    //     ActualHR."Staff Name" := Resource."Name (Short)";
                    //     ActualHR."Project Name" := Job.Description;
                    //     ActualHR."Project HR%" := TimeSheetLine."Percent Per Month";
                    //     ActualHR.Month := Date2DMY(StartDate, 2);
                    //     ActualHR.Year := Date2DMY(StartDate, 3);
                    //     ActualHR.Insert(true);
                    //     CreatedCount += 1;
                    // end else
                    //     ExistingCount += 1;

                end;
            until TimeSheetLine.Next() = 0;
        // Message('%1 Actual HR%% record(s) created.\%2 record(s) already existed.',
        //     CreatedCount,
        //     ExistingCount);
        Message('%1 Actual HR%% record(s) created.', CreatedCount);
    end;


    local procedure GetMonthYear(InputDate: Date): Text[30]
    begin
        // exit(StrSubstNo('%1 %2', Format(InputDate, 0, '<Month Text>'), Date2DMY(InputDate, 3)));
        //exit(StrSubstNo('%1/%2', PadStr(Format(Date2DMY(InputDate, 2)), 2, '0'), Format(Date2DMY(InputDate, 3))));
        exit(Format(InputDate, 0, '<Month,2>/<Year4>'));
    end;
}
