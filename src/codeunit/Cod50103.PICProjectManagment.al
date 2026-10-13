codeunit 50103 "PIC Project Managment"
{
    trigger OnRun()
    begin

    end;

    procedure GenerateProjectTask(JobRec: Record Job)
    begin
        CreateTask(JobRec, 1100, 'Stage Billing Actual');
        CreateTask(JobRec, 1200, 'Stage Billing Projected');
        CreateTask(JobRec, 2100, 'HR Staff Cost Actual Multiplied');
        CreateTask(JobRec, 2200, 'HR Staff Cost Actual 1.0x');
        CreateTask(JobRec, 2500, 'HR Staff Cost Projected Multiplied');
        CreateTask(JobRec, 2600, 'HR Staff Cost Projected 1.0x');
        CreateTask(JobRec, 3000, 'Expenses');
        CreateTask(JobRec, 4000, 'Freelancer');
        CreateTask(JobRec, 5000, 'Other Project Expenses');
        //Message('Project Tasks Generated Successfully');
    end;

    local procedure CreateTask(JobRec: Record Job; TaskNo: Integer; DescTxt: Text[100])
    var
        JobTask: Record "Job Task";
    begin
        if not JobTask.Get(JobRec."No.", Format(TaskNo)) then begin
            JobTask.Init();
            JobTask."Job No." := JobRec."No.";
            JobTask."Job Task No." := Format(TaskNo);
            JobTask.Description := DescTxt;
            JobTask.Insert(true);
        end;
    end;


    //GeneratePICBalance from JobPlanningLine
    //VJ 01JUNE2026<<
    procedure GeneratePICBalance(l_JobRec: Record Job)

    var

        JobPlanningLine: Record "Job Planning Line";

        PICProjectBalance: Record "PIC Project Balance";
        ProjectLedEnt: record "Job Ledger Entry";

    begin

        PICProjectBalance.Reset();

        PICProjectBalance.SetRange("Project Code", l_JobRec."No.");

        PICProjectBalance.DeleteAll();


        JobPlanningLine.Reset();

        JobPlanningLine.SetRange("Job No.", l_JobRec."No.");
        JobPlanningLine.SetFilter("Job Task No.", '1100|1200|2100|2200|2500|2600|3000|4000|5000');

        if JobPlanningLine.FindSet() then
            repeat

                ProcessPlanningLine(JobPlanningLine);

            until JobPlanningLine.Next() = 0;

        ProjectLedEnt.Reset();
        ProjectLedEnt.SetRange("Job No.", l_JobRec."No.");
        ProjectLedEnt.SetFilter("Job Task No.", '1100|1200|2100|2200|2500|2600|3000|4000|5000');
        ProjectLedEnt.SetRange("Entry Type", ProjectLedEnt."Entry Type"::Usage);
        if ProjectLedEnt.FindSet() then
            repeat
                ProcessLedgerLine(ProjectLedEnt);
            until ProjectLedEnt.Next() = 0;
    end;

    local procedure ProcessLedgerLine(ProjectLedgerEntry: Record "Job Ledger Entry")

    var

        PIC: Record PIC;

    begin
        PIC.Reset();

        PIC.SetRange("Project Code", ProjectLedgerEntry."Job No.");

        if PIC.FindSet() then
            repeat

                if PIC.Count > 1 then
                    InsertPICBalanceFromLedger(ProjectLedgerEntry, PIC);

            until PIC.Next() = 0;
        InsertPICBalanceSumFromLedger(ProjectLedgerEntry, PIC);
    end;

    //Process Each PlanningLine
    local procedure ProcessPlanningLine(JobPlanningLine: Record "Job Planning Line")

    var

        PIC: Record PIC;

    begin

        if SkipLine(JobPlanningLine) then
            exit;

        PIC.Reset();

        PIC.SetRange("Project Code", JobPlanningLine."Job No.");

        if PIC.FindSet() then
            repeat

                if PIC.Count > 1 then
                    InsertPICBalance(JobPlanningLine, PIC);

            until PIC.Next() = 0;
        InsertPICBalanceSum(JobPlanningLine, PIC);
    end;
    //Skip Task 1200
    //Task 1200 with ActualBillMth contains value will not show in PIC Project Balance
    local procedure SkipLine(JobPlanningLine: Record "Job Planning Line"): Boolean

    begin

        if (JobPlanningLine."Job Task No." = '1200') and (JobPlanningLine.ActualBillMth <> 0D) then
            exit(true);

        exit(false);

    end;
    //Insert Balance Record
    local procedure InsertPICBalance(JobPlanningLine: Record "Job Planning Line"; PICRec: Record PIC)

    var

        Balance: Record "PIC Project Balance";
        Job: Record Job;
        JobCostFactor: record "Job Cost Factor";  //TEC.VJ.16SEP2026
        CompanyInfo: Record "Company Information";
        IsNewRec: Boolean;
    begin
        CompanyInfo.Get();
        Job.Get(JobPlanningLine."Job No.");

        // if not Evaluate(TaskNoInt, JobPlanningLine."Job Task No.") then
        //     Error('Job Task No. %1 is not numeric.', JobPlanningLine."Job Task No.");

        Balance.Reset();
        Balance.SetRange("Project Code", JobPlanningLine."Job No.");
        Balance.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        Balance.SetRange("Line No.", JobPlanningLine."Line No.");
        Balance.SetRange(ProjectPIC, PICRec."Resource No.");
        Balance.SetRange("Total HR %", false);
        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then
            Balance.SetRange("Resource No.", JobPlanningLine."No.");

        IsNewRec := not Balance.FindFirst();
        if IsNewRec then begin
            Balance.Init();
            Balance."Project Code" := JobPlanningLine."Job No.";
            Balance."Job Task No." := JobPlanningLine."Job Task No.";
            Balance."Line No." := JobPlanningLine."Line No.";
        end;

        Balance."Total HR %" := false;
        Balance."Company Name" := CompanyInfo.Name;
        Balance.Date := GetBalanceDate(JobPlanningLine);

        if JobPlanningLine."Job Task No." in ['2100'] then
            Balance.Nature := Balance.Nature::ACTUAL
        else
            if JobPlanningLine."Job Task No." in ['1200', '2200'] then
                Balance.Nature := Balance.Nature::PROJECTED
            else
                Balance.Nature := GetNature(JobPlanningLine);

        //Balance.ProjectPIC := JobPlanningLine."Job No.";
        Balance.ProjectPIC := PICRec."Resource No.";
        Balance.Project_PIC := JobPlanningLine."Job No.";

        Clear(Balance."Resource No.");
        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then
            Balance."Resource No." := JobPlanningLine."No.";

        Balance."Project Name" := Job.Description;
        Balance.Category := GetCategory(JobPlanningLine);

        Clear(Balance."Job Cost Factor");
        if JobCostFactor.Get(JobPlanningLine."Job No.") and (JobPlanningLine."Job Task No." = '2200') then
            Balance."Job Cost Factor" := JobCostFactor."Job Cost Factor";

        Balance."Profit Sharing Ratio" := PICRec."Profit Sharing Ratio";

        PopulateAmountsFromJobLine(Balance, JobPlanningLine, PICRec, false);

        if Balance.Date <> 0D then begin
            if IsNewRec then
                Balance.Insert(true)
            else
                Balance.Modify(true);
        end;
        // CompanyInfo.Get();

        // Job.Get(JobPlanningLine."Job No.");

        // Balance.Init();

        // Balance."Total HR %" := false;

        // Balance."Company Name" := CompanyInfo.Name;

        // Balance.Date := GetBalanceDate(JobPlanningLine);

        // IF NOT Evaluate(Balance."Job Task No.", JobPlanningLine."Job Task No.") then
        //     Error('Job Task No. %1 is not numeric.', JobPlanningLine."Job Task No.");
        // //VJ08092026
        // // if JobPlanningLine."Job Task No." in ['2100', '2200'] then
        // //     Balance.Nature := Balance.Nature::ACTUAL
        // // else
        // //     Balance.Nature := GetNature(JobPlanningLine);

        // //TEC.VJ.16SEP2026
        // if JobPlanningLine."Job Task No." in ['2100'] then
        //     Balance.Nature := Balance.Nature::ACTUAL
        // else
        //     if JobPlanningLine."Job Task No." in ['1200', '2200'] then
        //         Balance.Nature := Balance.Nature::PROJECTED
        //     else
        //         Balance.Nature := GetNature(JobPlanningLine);
        // //TEC.VJ.16SEP2026

        // Balance.ProjectPIC := JobPlanningLine."Job No.";

        // // Balance."Resource No." := PICRec."Resource No.";//VJ26082026 Commented
        // if JobPlanningLine.Type = JobPlanningLine.Type::Resource then//VJ26082026 Added
        //     Balance."Resource No." := JobPlanningLine."No.";//VJ26082026 Added

        // Balance."Project Code" := JobPlanningLine."Job No.";

        // Balance."Project Name" := Job.Description;

        // Balance.Category := GetCategory(JobPlanningLine);
        // //TEC.VJ.16SEP2026 Start
        // if JobCostFactor.Get(JobPlanningLine."Job No.") and (JobPlanningLine."Job Task No." = '2200') then
        //     Balance."Job Cost Factor" := JobCostFactor."Job Cost Factor";
        // Balance."Profit Sharing Ratio" := PICRec."Profit Sharing Ratio";
        // Balance."Line No." := JobPlanningLine."Line No.";
        // //TEC.VJ.16SEP2026 End

        // Balance.Project_PIC := JobPlanningLine."Job No.";//VJ26082026 Added

        // PopulateAmountsFromJobLine(Balance, JobPlanningLine, PICRec, false);
        // if Balance.Date <> 0D then
        //     Balance.Insert(true);

    end;

    local procedure InsertPICBalanceFromLedger(JobLedgerEntry: Record "Job Ledger Entry"; PICRec: Record PIC)

    var

        Balance: Record "PIC Project Balance";

        Job: Record Job;

        CompanyInfo: Record "Company Information";

    begin

        CompanyInfo.Get();
        Job.Get(JobLedgerEntry."Job No.");
        Balance.Init();
        Balance."Total HR %" := false;
        Balance."Company Name" := CompanyInfo.Name;
        Balance.Date := JobLedgerEntry."Posting Date";
        IF NOT Evaluate(Balance."Job Task No.", JobLedgerEntry."Job Task No.") then
            Error('Job Task No. %1 is not numeric.', JobLedgerEntry."Job Task No.");
        if (JobLedgerEntry."Job Task No." = '1200') or (JobLedgerEntry."Job Task No." = '2200') then
            Balance.Nature := Balance.Nature::PROJECTED
        else
            Balance.Nature := Balance.Nature::ACTUAL;

        Balance.ProjectPIC := JobLedgerEntry."Job No.";
        Balance.Project_PIC := JobLedgerEntry."Job No.";//VJ26082026 Added

        Balance."Resource No." := PICRec."Resource No.";

        Balance."Project Code" := JobLedgerEntry."Job No.";

        Balance."Project Name" := job.Description;
        Balance.Amount := JobLedgerEntry."Line Amount";
        // Balance."Total Cost" := JobLedgerEntry."Total Cost (LCY)";
        PopulateAmountsFromJobLeedger(Balance, JobLedgerEntry, PICRec, false);

        Balance.Category := Balance.Category::Billing;

        // Balance."Job Cost Factor" := PICRec."Profit Sharing Ratio";
        Balance."Profit Sharing Ratio" := PICRec."Profit Sharing Ratio"; //TEC.VJ.16SEP2026


        if Balance.Date <> 0D then
            Balance.Insert(true);

    end;

    local procedure InsertPICBalanceSumFromLedger(JobLedgerEntry: Record "Job Ledger Entry"; PICRec: Record PIC)

    var

        Balance: Record "PIC Project Balance";

        Job: Record Job;

        CompanyInfo: Record "Company Information";

    begin

        CompanyInfo.Get();

        Job.Get(JobLedgerEntry."Job No.");

        Balance.Init();

        Balance."Total HR %" := true;

        Balance."Company Name" := CompanyInfo.Name;
        Balance.Date := JobLedgerEntry."Posting Date";



        IF NOT Evaluate(Balance."Job Task No.", JobLedgerEntry."Job Task No.") then
            Error('Job Task No. %1 is not numeric.', JobLedgerEntry."Job Task No.");

        Balance.Nature := Balance.Nature::ACTUAL;


        Balance.ProjectPIC := JobLedgerEntry."Job No.";
        Balance.Project_PIC := JobLedgerEntry."Job No.";//VJ26082026 Added
        // Balance."Resource No." := PICRec."Resource No.";

        Balance."Project Code" := JobLedgerEntry."Job No.";

        Balance."Project Name" := Job.Description;
        Balance.Amount := JobLedgerEntry."Line Amount";
        // Balance."Total Cost" := JobLedgerEntry."Total Cost (LCY)";
        PopulateAmountsFromJobLeedger(Balance, JobLedgerEntry, PICRec, true);

        Balance.Category := Balance.Category::Billing;


        //Balance."Job Cost Factor" := PICRec."Profit Sharing Ratio";
        if Balance.Date <> 0D then
            Balance.Insert(true);

    end;

    local procedure InsertPICBalanceSum(JobPlanningLine: Record "Job Planning Line"; PICRec: Record PIC)

    var

        Balance: Record "PIC Project Balance";

        Job: Record Job;
        JobCostFactor: record "Job Cost Factor";  //TEC.VJ.````````````````````````````````````
        CompanyInfo: Record "Company Information";
        IsNewRec: Boolean;

    begin
        CompanyInfo.Get();
        Job.Get(JobPlanningLine."Job No.");

        // if not Evaluate(TaskNoInt, JobPlanningLine."Job Task No.") then
        //       Error('Job Task No. %1 is not numeric.', JobPlanningLine."Job Task No.");

        Balance.Reset();
        Balance.SetRange("Project Code", JobPlanningLine."Job No.");
        Balance.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        Balance.SetRange("Line No.", JobPlanningLine."Line No.");
        Balance.SetRange("Total HR %", true);

        IsNewRec := not Balance.FindFirst();
        if IsNewRec then begin
            Balance.Init();
            Balance."Project Code" := JobPlanningLine."Job No.";
            Balance."Job Task No." := JobPlanningLine."Job Task No.";
            Balance."Line No." := JobPlanningLine."Line No.";
        end else
            exit;

        Balance."Total HR %" := true;
        Balance."Company Name" := CompanyInfo.Name;
        Balance.Date := GetBalanceDate(JobPlanningLine);

        if JobPlanningLine."Job Task No." in ['2100'] then
            Balance.Nature := Balance.Nature::ACTUAL
        else
            if JobPlanningLine."Job Task No." in ['1200', '2200'] then
                Balance.Nature := Balance.Nature::PROJECTED
            else
                Balance.Nature := GetNature(JobPlanningLine);

        Balance.ProjectPIC := JobPlanningLine."Job No.";
        Balance.Project_PIC := JobPlanningLine."Job No.";

        Clear(Balance."Resource No.");
        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then
            Balance."Resource No." := JobPlanningLine."No.";

        Balance."Project Name" := Job.Description;
        Balance.Category := GetCategory(JobPlanningLine);

        Clear(Balance."Job Cost Factor");
        if JobCostFactor.Get(JobPlanningLine."Job No.") and (JobPlanningLine."Job Task No." = '2200') then
            Balance."Job Cost Factor" := JobCostFactor."Job Cost Factor";

        Balance."Profit Sharing Ratio" := 100;
        // Balance."Profit Sharing Ratio" := PICRec."Profit Sharing Ratio";

        PopulateAmountsFromJobLine(Balance, JobPlanningLine, PICRec, true);

        if Balance.Date <> 0D then begin
            if IsNewRec then
                Balance.Insert(true)
            else
                Balance.Modify(true);
        end;
        // CompanyInfo.Get();

        // Job.Get(JobPlanningLine."Job No.");

        // Balance.Init();

        // Balance."Total HR %" := true;

        // Balance."Company Name" := CompanyInfo.Name;

        // Balance.Date := GetBalanceDate(JobPlanningLine);

        // IF NOT Evaluate(Balance."Job Task No.", JobPlanningLine."Job Task No.") then
        //     Error('Job Task No. %1 is not numeric.', JobPlanningLine."Job Task No.");
        // //VJ08092026
        // // if JobPlanningLine."Job Task No." in ['2100', '2200'] then
        // //     Balance.Nature := Balance.Nature::ACTUAL
        // // else
        // //     Balance.Nature := GetNature(JobPlanningLine);
        // //VJ08092026

        // //TEC.VJ.16SEP2026
        // if JobPlanningLine."Job Task No." in ['2100'] then
        //     Balance.Nature := Balance.Nature::ACTUAL
        // else
        //     if JobPlanningLine."Job Task No." in ['1200', '2200'] then
        //         Balance.Nature := Balance.Nature::PROJECTED
        //     else
        //         Balance.Nature := GetNature(JobPlanningLine);
        // //TEC.VJ.16SEP2026

        // Balance.ProjectPIC := JobPlanningLine."Job No.";

        // // Balance."Resource No." := PICRec."Resource No.";
        // if JobPlanningLine.Type = JobPlanningLine.Type::Resource then//VJ26082026 Added
        //     Balance."Resource No." := JobPlanningLine."No.";//VJ26082026 Added
        // Balance.Project_PIC := JobPlanningLine."Job No.";//VJ26082026 Added
        // Balance."Project Code" := JobPlanningLine."Job No.";

        // Balance."Project Name" := Job.Description;

        // Balance.Category := GetCategory(JobPlanningLine);

        // //Balance."Job Cost Factor" := PICRec."Profit Sharing Ratio";

        // //TEC.VJ.16SEP2026 Start
        // if JobCostFactor.Get(JobPlanningLine."Job No.") and (JobPlanningLine."Job Task No." = '2200') then
        //     Balance."Job Cost Factor" := JobCostFactor."Job Cost Factor";
        // Balance."Profit Sharing Ratio" := PICRec."Profit Sharing Ratio";
        // Balance."Line No." := JobPlanningLine."Line No.";
        // //TEC.VJ.16SEP2026 End
        // // Balance."Profit Sharing Ratio" := PICRec."Profit Sharing Ratio"; //TEC.VJ.16SEP2026

        // PopulateAmountsFromJobLine(Balance, JobPlanningLine, PICRec, true);
        // if Balance.Date <> 0D then
        //     Balance.Insert(true);

    end;
    //Date Logic
    local procedure GetBalanceDate(

        JobPlanningLine: Record "Job Planning Line"): Date

    begin

        case JobPlanningLine."Job Task No." of

            '1200':

                exit(JobPlanningLine."Projected Bill Date");

            '1100':

                exit(JobPlanningLine.ActualBillMth);

            else
                exit(JobPlanningLine."Planned Delivery Date");

        end;

    end;
    //Nature Logic
    local procedure GetNature(JobPlanningLine: Record "Job Planning Line") Result: Option ACTUAL,PROJECTED

    begin

        if JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::Budget then
            exit(Result::PROJECTED);

        exit(Result::ACTUAL);

    end;
    //Category Logic
    local procedure GetCategory(JobPlanningLine: Record "Job Planning Line") Result: Option Billing,Resource

    begin

        case JobPlanningLine."Job Task No." of

            '2100',

            '2200',

            '2500',

            '2600':

                exit(Result::Resource);

        end;

        exit(Result::Billing);

    end;
    //Amount Calculation
    local procedure PopulateAmountsFromJobLine(var Balance: Record "PIC Project Balance"; JobPlanningLine: Record "Job Planning Line"; PICRec: Record PIC; lSum: Boolean)

    var

        Ratio: Decimal;

    begin

        Ratio := PICRec."Profit Sharing Ratio" / 100;
        if lSum then
            Ratio := 1;
        if JobPlanningLine."Job Task No." in ['1100', '1200'] then begin

            if JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::Budget then
                Balance.Amount := JobPlanningLine."Line Amount (LCY)" * Ratio //TEC.VJ.16SEP2026
                                                                              //   Balance."Total Cost" := JobPlanningLine."Line Amount (LCY)" * Ratio Commented By //TEC.VJ.16SEP2026

            else
                Balance.Amount := JobPlanningLine."Line Amount (LCY)" * Ratio; //TEC.VJ.16SEP2026
                                                                               // Balance."Total Cost" := JobPlanningLine."Line Amount (LCY)" * Ratio; Commented By //TEC.VJ.16SEP2026
        end;
        if JobPlanningLine."Job Task No." in ['2100', '2200', '2500', '2600', '3000', '4000', '5000'] then begin
            if JobPlanningLine."Line Type" = JobPlanningLine."Line Type"::Budget then
                //Balance.Amount := JobPlanningLine."Total Cost (LCY)" * Ratio
                Balance."Total Cost" := JobPlanningLine."Total Cost (LCY)" * Ratio

            else
                Balance."Total Cost" := JobPlanningLine."Total Cost (LCY)" * Ratio;

        end;


    end;

    local procedure PopulateAmountsFromJobLeedger(var Balance: Record "PIC Project Balance"; JobLedgerEntry: Record "Job Ledger Entry"; PICRec: Record PIC; lSum: Boolean)

    var

        Ratio: Decimal;

    begin

        Ratio := PICRec."Profit Sharing Ratio" / 100;
        if lSum then
            Ratio := 1;
        if JobLedgerEntry."Job Task No." in ['1100', '1200'] then begin

            if JobLedgerEntry."Line Type" = JobLedgerEntry."Line Type"::Budget then
                Balance.Amount := JobLedgerEntry."Line Amount (LCY)" * Ratio
            //Balance."Total Cost" := JobLedgerEntry."Line Amount (LCY)" * Ratio

            else
                //Balance."Total Cost" := JobLedgerEntry."Line Amount (LCY)" * Ratio;
                  Balance.Amount := JobLedgerEntry."Line Amount (LCY)" * Ratio
        end;
        if JobLedgerEntry."Job Task No." in ['2100', '2200', '2500', '2600', '3000', '4000', '5000'] then begin

            if JobLedgerEntry."Line Type" = JobLedgerEntry."Line Type"::Budget then
                //Balance.Amount := JobPlanningLine."Total Cost (LCY)" * Ratio
                Balance."Total Cost" := JobLedgerEntry."Total Cost (LCY)" * Ratio

            else
                Balance."Total Cost" := JobLedgerEntry."Total Cost (LCY)" * Ratio;
        end;

    end;


    local procedure IsTotalHR(ProjectCode: Code[20]; ResourceNo: Code[20]): Boolean
    var
        PICRec: Record PIC;
    begin

        PICRec.Reset();
        PICRec.SetRange("Project Code", ProjectCode);
        if PICRec.Count <> 1 then
            exit(false);
        PICRec.FindFirst();
        exit((PICRec."Resource No." = ResourceNo) and (PICRec."Profit Sharing Ratio" = 100));

    end;



    procedure CalculateProjectCost(l_Jobrec: Record Job)
    var
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        Resource: Record Resource;
        ActualHRPct: Decimal;
        ProjectedHRPct: Decimal;
        UnitCost: Decimal;
        Quantity: Decimal;
        TotalCost: Decimal;
        TaskNo: Code[20];
        ActualHRList: record "Actual HR%";
        ProjectedHRList: record "Projected HR %";
        SalaryHistory: Record "Resource Cost New";
        l_Month: Integer;
        l_Year: Integer;
        JobPlanningLine1: Record "Job Planning Line";
        JobCostFactor: Record "Job Cost Factor";
        SalrayDate: Date;
    begin

        JobTask.Reset();
        JobTask.SetRange("Job No.", l_Jobrec."No.");
        jobTask.Setfilter("Job Task No.", '%1|%2|%3|%4', '2100', '2200', '2500', '2600');
        if JobTask.FindSet() then
            repeat
                JobPlanningLine1.Reset();
                JobPlanningLine1.SetRange("Job No.", JobTask."Job No.");
                JobPlanningLine1.SetRange("Job Task No.", JobTask."Job Task No.");
                if JobPlanningLine1.findset() then
                    JobPlanningLine1.DeleteAll();

                UnitCost := 0;
                Quantity := 0;
                TotalCost := 0;
                l_Month := Date2DMY(Today, 2);
                l_Year := Date2DMY(Today, 3);
                if (JobTask."Job Task No." = '2100') or (JobTask."Job Task No." = '2200') then begin

                    ActualHRList.Reset();
                    ActualHRList.SetRange("Project Code", JobTask."Job No.");
                    //ActualHRList.SetFilter(Month, '<=%1', l_Month);
                    ActualHRList.SetFilter(Year, '<=%1', l_Year);
                    //ActualHRList.SetFilter("Resource No", '%1', 'BJ10006');
                    if ActualHRList.Findset() then begin
                        repeat

                            UnitCost := 0;
                            Quantity := 0;
                            TotalCost := 0;
                            SalaryHistory.Reset();
                            salaryHistory.setrange(Type, salaryHistory.Type::Resource);
                            salaryHistory.SetRange(Code, ActualHRList."Resource No");
                            salaryHistory.SetRange(Month, ActualHRList.Month);
                            salaryHistory.SetRange(Year, ActualHRList.Year);
                            if salaryHistory.FindFirst() then begin
                                SalrayDate := DMY2Date(1, salaryHistory.Month, salaryHistory.Year);
                                JobCostFactor.Reset();
                                JobCostFactor.SetRange("Project Code", l_Jobrec."No.");
                                //JobCostFactor.SetFilter("Effective Date", '<=%1', SalrayDate);  VJ05102026 Not Needed for task 2100&2200
                                if JobCostFactor.FindLast() then;
                                UnitCost := SalaryHistory."Monthly Salary" / 200;
                                //VJ05102026 Commented as per leung Cara calculation logic
                                // if JobTask."Job Task No." = '2100' then
                                //     Quantity := (round(ActualHRList."Project HR%" / 100, 0.01) * 200)
                                // else
                                Quantity := round((((ActualHRList."Project HR%" / 100) * 200) * JobCostFactor."Job Cost Factor"), 0.01);

                                TotalCost := UnitCost * Quantity;
                            end;

                            if (TotalCost <> 0) and (JobTask."Job Task No." = '2100') then begin
                                TotalCost := 0;//VJ05102026 Added
                                TotalCost := UnitCost * (Quantity);//VJ05102026 Added
                                InsertJobPlanningLine(
                                    l_Jobrec."No.",
                                    JobTask."Job Task No.",
                                   ActualHRList."Resource No",
                                    UnitCost,
                                    Quantity,
                                    '', DMY2Date(1, ActualHRList.Month, ActualHRList.Year));
                            end;
                            if (TotalCost <> 0) and (JobTask."Job Task No." = '2200') then begin
                                TotalCost := 0;
                                TotalCost := UnitCost * (Quantity);
                                InsertJobPlanningLine(
                                    l_Jobrec."No.",
                                    JobTask."Job Task No.",
                                    ActualHRList."Resource No",
                                    UnitCost,
                                    Quantity,
                                    '', DMY2Date(1, ActualHRList.Month, ActualHRList.Year));
                            end;
                        until ActualHRList.Next() = 0;
                    end;



                end else if (JobTask."Job Task No." = '2500') or (JobTask."Job Task No." = '2600') then begin
                    l_Month := Date2DMY(Today, 2);
                    l_Year := Date2DMY(Today, 3);
                    ProjectedHRList.Reset();
                    // ProjectedHRList.SetRange("Staff No", ActualHRList."Staff No"rojectedHRList.SetRange("Project Code", JobTask."Job No.");
                    //ProjectedHRList.Setfilter(Month, '>=%1', l_Month);
                    ProjectedHRList.Setfilter(Year, '>=%1', l_Year);
                    if ProjectedHRList.Findset() then begin
                        repeat
                            UnitCost := 0;
                            Quantity := 0;
                            TotalCost := 0;
                            SalaryHistory.Reset();
                            salaryHistory.setrange(Type, salaryHistory.Type::Resource);
                            salaryHistory.SetRange(Code, ProjectedHRList."Resource No");
                            salaryHistory.SetRange(Month, ProjectedHRList.Month);
                            salaryHistory.SetRange(Year, ProjectedHRList.Year);
                            if salaryHistory.findfirst() then begin
                                UnitCost := SalaryHistory."Monthly Salary" / 200;
                                Quantity := ProjectedHRList."Projected_HRPercent";
                            end;
                            TotalCost := UnitCost * Quantity;
                            if (TotalCost <> 0) and (JobTask."Job Task No." = '2500') then begin
                                InsertJobPlanningLine(
                                    l_Jobrec."No.",
                                    JobTask."Job Task No.",
                                    ProjectedHRList."Resource No",
                                    UnitCost,
                                    Quantity,
                                    '', DMY2Date(1, ProjectedHRList.Month, ProjectedHRList.Year));
                            end;
                            if (TotalCost <> 0) and (JobTask."Job Task No." = '2600') then begin
                                TotalCost := 0;
                                TotalCost := UnitCost * (Quantity * 200);
                                InsertJobPlanningLine(
                                    l_Jobrec."No.",
                                    JobTask."Job Task No.",
                                    ProjectedHRList."Resource No",
                                    UnitCost,
                                    Quantity * 200,
                                    '', DMY2Date(1, ProjectedHRList.Month, ProjectedHRList.Year));
                            end;
                        until ProjectedHRList.Next() = 0;

                    end;
                end;
            until JobTask.Next() = 0;
        if GuiAllowed then
            Message('Project Cost calculation completed for Job %1.', l_Jobrec."No.");
    end;

    local procedure InsertJobPlanningLine(
        JobNo: Code[20];
        JobTaskNo: Code[20];
        ResourceNo: Code[20];
        UnitCost: Decimal;
        Quantity: Decimal;
        Nature: Text[20];
        Planneddeliverydate: date)
    var
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLine1: Record "Job Planning Line";
        LineNo: Integer;
        Job: Record Job;
        JobTask: Record "Job Task";
    begin
        // JobPlanningLine1.Reset();
        // JobPlanningLine1.SetRange("Job No.", JobNo);
        // JobPlanningLine1.SetRange("Job Task No.", JobTaskNo);
        // if JobPlanningLine1.findset() then begin
        //     JobPlanningLine1.DeleteAll();
        // end;

        Job.Get(JobNo);
        // Find the next available Line No.
        JobPlanningLine.Reset();
        JobPlanningLine.SetRange("Job No.", JobNo);
        JobPlanningLine.SetRange("Job Task No.", JobTaskNo);
        if JobPlanningLine.FindLast() then
            LineNo := JobPlanningLine."Line No." + 10000
        else
            LineNo := 10000;
        JobPlanningLine.Reset();
        CLEAR(JobPlanningLine);
        JobPlanningLine.Init();


        JobPlanningLine."Job No." := JobNo;
        JobPlanningLine."Job Task No." := JobTaskNo;
        JobPlanningLine."Line No." := LineNo;


        JobPlanningLine.Validate("Line Type", JobPlanningLine."Line Type"::Budget);

        JobPlanningLine.Validate(Type, JobPlanningLine.Type::Resource);


        JobPlanningLine.Validate("No.", ResourceNo);
        if Job."Project Client No." <> '' then
            JobPlanningLine.Validate("Customer No.", Job."Project Client No.");

        if Planneddeliverydate <> 0D then
            JobPlanningLine.Validate("Planned Delivery Date", Planneddeliverydate);
        if UnitCost <> 0 then
            JobPlanningLine.Validate("Unit Cost", UnitCost);
        JobPlanningLine.Validate(Quantity, Quantity);
        JobPlanningLine.Description := StrSubstNo('Resource Cost (%1)', Nature);
        JobPlanningLine.Insert(true);
    end;
    //VJ 01JUNE2026>>


    //VJ NEW>> Action button support: sync PIC Project Balance for a single Job Planning Line
    procedure GeneratePICBalanceForLine(JobPlanningLine: Record "Job Planning Line")
    var
        PIC: Record PIC;
    begin
        if SkipLine(JobPlanningLine) then
            exit;

        PIC.Reset();
        PIC.SetRange("Project Code", JobPlanningLine."Job No.");
        if PIC.FindSet() then
            repeat
                if PIC.Count > 1 then
                    UpsertPICBalance(JobPlanningLine, PIC);
            until PIC.Next() = 0;

        UpsertPICBalanceSum(JobPlanningLine, PIC);
    end;

    local procedure UpsertPICBalance(JobPlanningLine: Record "Job Planning Line"; PICRec: Record PIC)
    var
        Balance: Record "PIC Project Balance";
        Job: Record Job;
        JobCostFactor: Record "Job Cost Factor";
        CompanyInfo: Record "Company Information";

        IsNewRec: Boolean;
    begin
        CompanyInfo.Get();
        Job.Get(JobPlanningLine."Job No.");


        Balance.Reset();
        Balance.SetRange("Project Code", JobPlanningLine."Job No.");
        Balance.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        Balance.SetRange("Line No.", JobPlanningLine."Line No.");
        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then
            Balance.SetRange("Resource No.", JobPlanningLine."No.");
        Balance.SetRange(ProjectPIC, PICRec."Resource No.");

        IsNewRec := not Balance.FindFirst();
        if IsNewRec then begin
            Balance.Init();
            Balance."Project Code" := JobPlanningLine."Job No.";
            Balance."Job Task No." := JobPlanningLine."Job Task No.";
            Balance."Line No." := JobPlanningLine."Line No.";
        end;

        Balance."Total HR %" := false;
        Balance."Company Name" := CompanyInfo.Name;
        Balance.Date := GetBalanceDate(JobPlanningLine);

        if JobPlanningLine."Job Task No." in ['2100'] then
            Balance.Nature := Balance.Nature::ACTUAL
        else
            if JobPlanningLine."Job Task No." in ['1200', '2200'] then
                Balance.Nature := Balance.Nature::PROJECTED
            else
                Balance.Nature := GetNature(JobPlanningLine);

        // Balance.ProjectPIC := JobPlanningLine."Job No.";
        Balance.ProjectPIC := PICRec."Resource No.";

        Balance.Project_PIC := JobPlanningLine."Job No.";

        Clear(Balance."Resource No.");
        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then
            Balance."Resource No." := JobPlanningLine."No.";

        Balance."Project Name" := Job.Description;
        Balance.Category := GetCategory(JobPlanningLine);

        Clear(Balance."Job Cost Factor");
        if JobCostFactor.Get(JobPlanningLine."Job No.") and (JobPlanningLine."Job Task No." = '2200') then
            Balance."Job Cost Factor" := JobCostFactor."Job Cost Factor";

        Balance."Profit Sharing Ratio" := PICRec."Profit Sharing Ratio";

        PopulateAmountsFromJobLine(Balance, JobPlanningLine, PICRec, false);

        if Balance.Date <> 0D then begin
            if IsNewRec then
                Balance.Insert(true)
            else
                Balance.Modify(true);
        end;
    end;

    local procedure UpsertPICBalanceSum(JobPlanningLine: Record "Job Planning Line"; PICRec: Record PIC)
    var
        Balance: Record "PIC Project Balance";
        Job: Record Job;
        JobCostFactor: Record "Job Cost Factor";
        CompanyInfo: Record "Company Information";

        IsNewRec: Boolean;
    begin
        CompanyInfo.Get();
        Job.Get(JobPlanningLine."Job No.");

        // if not Evaluate(TaskNoInt, JobPlanningLine."Job Task No.") then
        //     Error('Job Task No. %1 is not numeric.', JobPlanningLine."Job Task No.");

        Balance.Reset();
        Balance.SetRange("Project Code", JobPlanningLine."Job No.");
        Balance.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        Balance.SetRange("Line No.", JobPlanningLine."Line No.");
        Balance.SetRange("Total HR %", true);
        IsNewRec := not Balance.FindFirst();
        if IsNewRec then begin
            Balance.Init();
            Balance."Project Code" := JobPlanningLine."Job No.";
            Balance."Job Task No." := JobPlanningLine."Job Task No.";
            Balance."Line No." := JobPlanningLine."Line No.";
        end else
            exit;

        Balance."Total HR %" := true;
        Balance."Company Name" := CompanyInfo.Name;
        Balance.Date := GetBalanceDate(JobPlanningLine);

        if JobPlanningLine."Job Task No." in ['2100'] then
            Balance.Nature := Balance.Nature::ACTUAL
        else
            if JobPlanningLine."Job Task No." in ['1200', '2200'] then
                Balance.Nature := Balance.Nature::PROJECTED
            else
                Balance.Nature := GetNature(JobPlanningLine);

        Balance.ProjectPIC := JobPlanningLine."Job No.";
        Balance.Project_PIC := JobPlanningLine."Job No.";

        Clear(Balance."Resource No.");
        if JobPlanningLine.Type = JobPlanningLine.Type::Resource then
            Balance."Resource No." := JobPlanningLine."No.";

        Balance."Project Name" := Job.Description;
        Balance.Category := GetCategory(JobPlanningLine);

        Clear(Balance."Job Cost Factor");
        if JobCostFactor.Get(JobPlanningLine."Job No.") and (JobPlanningLine."Job Task No." = '2200') then
            Balance."Job Cost Factor" := JobCostFactor."Job Cost Factor";

        Balance."Profit Sharing Ratio" := 100;
        //  Balance."Profit Sharing Ratio" := PICRec."Profit Sharing Ratio";

        PopulateAmountsFromJobLine(Balance, JobPlanningLine, PICRec, true);

        if Balance.Date <> 0D then begin
            if IsNewRec then
                Balance.Insert(true)
            else
                Balance.Modify(true);
        end;
    end;
    //VJ NEW
}





