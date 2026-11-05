pageextension 50124 "Time Sheet List Ext" extends "Time Sheet List"
{
    actions
    {
        addafter(EditTimeSheet1)
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
                // RunObject = Report "Create Actual HR %";
                // RunPageOnRec = true;
                trigger OnAction()
                var
                    ReportCreateActualHRPer: Report "Create Actual HR %";
                    RecUserSEtup: Record "User Setup";
                begin
                    RecUserSEtup.Get(UserId);
                    if not RecUserSEtup."Setup Admin" then
                        Error('you do not have permission to run this button');
                    // if not Confirm('Do you want to create Actual HR%% records for Time Sheet %1?', true, Rec."Time Sheet No.") then
                    //     exit;
                    ReportCreateActualHRPer.Run();
                end;
            }

        }
    }
}
