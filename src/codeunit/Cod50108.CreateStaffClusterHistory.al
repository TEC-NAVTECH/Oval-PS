codeunit 50108 CreateStaffClusterHistory
{
    var
        CreatedCount: Integer;

    procedure CreateFromSalaryHistory(SalaryHistory: Record "Resource Cost New"; ShowMessage: Boolean)
    var
        StaffClusterHistory: Record "Staff Cluster History";
        Resource: Record Resource;
        EffectiveDate: Date;
        EndDate: Date;
        NewEntryNo: Integer;
        ConfirmMsg: Label 'Do you want to create Staff Cluster History for Staff %1?';
        SuccessMsg: Label 'Staff Cluster History entry %1 has been created.';
        MissingStaffErr: Label 'Staff %1 does not exist.';
        MissingDateErr: Label 'Effective Date must not be blank.';

        MonthNo: Integer;
        YearNo: Integer;

    begin
        // if not Confirm(ConfirmMsg, false, SalaryHistory.Code)
        // then
        //     exit;
        if not Resource.Get(SalaryHistory.Code) then
            Error(MissingStaffErr, SalaryHistory.Code);

        MonthNo := SalaryHistory.Month;
        YearNo := SalaryHistory.Year;
        if (MonthNo = 0) or (YearNo = 0) then
            exit;
        // First day of the selected month.
        EffectiveDate := DMY2Date(1, MonthNo, YearNo);

        // Last day of the selected month.
        EndDate := CalcDate('<CM>', EffectiveDate);

        // Generate the next Entry No.
        StaffClusterHistory.LockTable();

        if StaffClusterHistory.FindLast() then
            NewEntryNo := StaffClusterHistory."Entry No." + 1
        else
            NewEntryNo := 1;

        StaffClusterHistory.Init();
        StaffClusterHistory."Entry No." := NewEntryNo;
        // Map fields from the current Salary History record.
        StaffClusterHistory.Validate(Staff, SalaryHistory.Code);
        //StaffClusterHistory.Staff := SalaryHistory.Code;
        StaffClusterHistory.Staff_Cluster := SalaryHistory."Staff Cluster";
        StaffClusterHistory.Effective_Date := EffectiveDate;
        StaffClusterHistory.End_Date := EndDate;
        // Insert the new record.
        StaffClusterHistory.Insert(true);
        CreatedCount += 1;
        // Message(SuccessMsg, NewEntryNo);
        if ShowMessage then
            Message('%1 Staff Cluster History record(s) created.', CreatedCount);
    end;

    procedure Showcountcreated(): Integer
    begin
        exit(CreatedCount);
    end;

    procedure DeleteStaffClusterHistory(var SalaryHistory: Record "Resource Cost New")
    var
        StaffClusterHistory: Record "Staff Cluster History";
        MonthNo: Integer;
        YearNo: Integer;
        EffectiveDate: date;
    begin
        StaffClusterHistory.Reset();
        if SalaryHistory.GetFilter(code) <> '' then
            StaffClusterHistory.Setfilter(Staff, SalaryHistory.GetFilter(code));
        if SalaryHistory.GetFilter("Staff Cluster") <> '' then
            StaffClusterHistory.Setfilter(Staff_Cluster, SalaryHistory.GetFilter("Staff Cluster"));
        if SalaryHistory.GetFilter("Month/Year") <> '' then begin

            MonthNo := SalaryHistory.Month;
            YearNo := SalaryHistory.Year;
            if (MonthNo = 0) or (YearNo = 0) then
                exit;
            // First day of the selected month.
            EffectiveDate := DMY2Date(1, MonthNo, YearNo);
            StaffClusterHistory.SetRange(Effective_Date, EffectiveDate);
        end;
        if StaffClusterHistory.FindFirst() then
            StaffClusterHistory.DeleteAll();

    end;
}
