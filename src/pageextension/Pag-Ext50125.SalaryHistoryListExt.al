pageextension 50125 SalaryHistoryListExt extends "Salary History"
{
    actions
    {
        addlast(Processing)
        {
            action(CreateStaffClusterHistory1)
            {
                ApplicationArea = All;
                Caption = 'Create Staff Cluster History for Current Record';
                ToolTip = 'Create a Staff Cluster History record for the current Salary History record.';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction()
                var
                    CreateStaffClusterHistoryMgt: Codeunit CreateStaffClusterHistory;
                begin
                    if not Confirm('Do you want to create Staff Cluster History records for Salary History %1?', true, Rec.Code) then
                        exit;
                    CreateStaffClusterHistoryMgt.CreateFromSalaryHistory(Rec, true);
                end;
            }
            action(CreateStaffClusterHistory)
            {
                ApplicationArea = all;
                Caption = 'Create Staff Cluster History Record';
                Image = CreateDocument;
                ToolTip = 'Create a Staff Cluster History record for the current Salary History record.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // RunObject = Report "Create Actual HR %";
                // RunPageOnRec = true;
                trigger OnAction()
                var
                    ReportCreateStaffClustreHist: Report "Create Staff Cluster History";
                    RecUserSEtup: Record "User Setup";
                begin
                    RecUserSEtup.Get(UserId);
                    if not RecUserSEtup."Setup Admin" then
                        Error('you do not have permission to run this button');
                    // if not Confirm('Do you want to create Actual HR%% records for Time Sheet %1?', true, Rec."Time Sheet No.") then
                    //     exit;
                    ReportCreateStaffClustreHist.Run();
                end;
            }
        }

    }
}
