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
                Visible = false; //VJ 26oct2026
                trigger OnAction()
                var
                    CUCreateActualHR: Codeunit "Create Actual HR %";
                begin
                    if not Confirm('Do you want to create Actual HR%% records for Time Sheet %1?', true, Rec."Time Sheet No.") then
                        exit;
                    CUCreateActualHR.CreateActualHRRecords(Rec."Time Sheet No.", true);
                end;
            }
        }
    }

}
