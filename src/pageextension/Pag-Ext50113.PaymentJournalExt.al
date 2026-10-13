pageextension 50113 PaymentJournalExt extends "Payment Journal"
{
    layout
    {
        modify("Check Printed")
        {
            Visible = true;
            Editable = true;
        }
    }
    actions
    {
        addafter(PrintCheck)
        {
            action("Print SCB Check")
            {
                ApplicationArea = All;
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Line No.", Rec."Line No.");
                    Report.RunModal(50105, true, true, GenJnlLine);
                end;
            }
            action("Print Hang Seng Check")
            {
                ApplicationArea = All;
                Image = PrintCheck;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Line No.", Rec."Line No.");
                    Report.RunModal(50106, true, true, GenJnlLine);
                end;
            }
        }
    }
}
