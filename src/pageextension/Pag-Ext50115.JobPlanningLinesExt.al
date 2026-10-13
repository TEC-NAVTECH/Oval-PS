pageextension 50115 JobPlanningLinesExt extends "Job Planning Lines"
{
    layout
    {


        addafter("Line Type")
        {
            field("Projected Bill Date"; Rec."Projected Bill Date")
            {
                ApplicationArea = All;
            }
            field("Actual Payment Date"; Rec."Actual Payment Date")
            {
                ApplicationArea = All;
            }
            field(FINESTBILLMTH; Rec.FINESTBILLMTH)
            {
                ApplicationArea = All;
            }
            field(ActualBillMth; Rec.ActualBillMth)
            {
                ApplicationArea = All;
            }
            field(ProjRecMth; Rec.ProjRecMth)
            {
                ApplicationArea = All;
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
            }
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Factor field.', Comment = '%';
                Editable = true;
            }
        }
        movebefore("Projected Bill Date"; "Planned Delivery Date")
    }

    actions
    {
        // Add changes to page actions here
        addafter("Linked Job Ledger E&ntries")
        {
            action(PICBalance)
            {
                ApplicationArea = all;
                Caption = 'PIC Balance';
                RunObject = page "PIC Project Balance List";
                RunPageLink = "Job Task No." = field("Job Task No.");
                trigger OnAction()
                begin

                end;
            }
            action(UpdatePICBalance)
            {
                ApplicationArea = All;
                Caption = 'Update PIC Balance';
                Image = Refresh;
                ToolTip = 'Recalculates the PIC Project Balance for the selected Job Planning Line(s), without touching balances for other lines on the job.';

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    PICProjectManagement: Codeunit "PIC Project Managment";
                    LineCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(JobPlanningLine);
                    LineCount := JobPlanningLine.Count();

                    if LineCount = 0 then
                        exit;

                    if not Confirm(StrSubstNo(ConfirmUpdateBalanceLbl, LineCount), false) then
                        exit;

                    if JobPlanningLine.FindSet() then
                        repeat
                            PICProjectManagement.GeneratePICBalanceForLine(JobPlanningLine);
                        until JobPlanningLine.Next() = 0;

                    Message(BalanceUpdatedLbl, LineCount);
                end;
            }
        }
    }
    var
        ConfirmUpdateBalanceLbl: Label 'This will recalculate the PIC Project Balance for %1 selected line(s). Do you want to continue?', Comment = '%1 = number of selected lines';
        BalanceUpdatedLbl: Label 'PIC Project Balance updated for %1 line(s).', Comment = '%1 = number of lines updated';

}