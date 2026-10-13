pageextension 50102 JobJournalExt extends "Job Journal"
{
    layout
    {
        addafter(Quantity)
        {
            field("Total Hours Percent"; Rec."Total Hours Percent")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action("Suggest Lines from Time Sheets for hour nature")
            {
                ApplicationArea = All;
                Caption = 'Suggest Lines from Time Sheets for hour nature';
                Image = SuggestLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SuggestJobJnlLines: Report "Suggest Job Jnl. Lines-Hour";
                begin
                    SuggestJobJnlLines.SetJobJnlLine(Rec);
                    SuggestJobJnlLines.RUNMODAL();
                end;
            }
            action("Suggest Lines from Time Sheets for percent nature")
            {
                ApplicationArea = All;
                Caption = 'Suggest Lines from Time Sheets for percent nature';
                Image = SuggestLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SuggestJobJnlLines: Report "Suggest Job Jnl. Lines New";
                begin
                    SuggestJobJnlLines.SetJobJnlLine(Rec);
                    SuggestJobJnlLines.RUNMODAL();
                end;
            }
            action("Renumber Job Journal")
            {
                ApplicationArea = All;
                Caption = 'Renumber Job Journal';
                Image = SuggestNumber;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    // NoSeriesMgt: Codeunit 396;
                    NoSeriesMgt: Codeunit "No. Series";
                    JobJnlLine: Record "Job Journal Line";
                    JobJnlBatch: Record "Job Journal Batch";
                begin
                    JobJnlLine.Reset();
                    JobJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    JobJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    if JobJnlLine.FindSet()then repeat JobJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                            JobJnlLine."Document No.":=NoSeriesMgt.GetNextNo(JobJnlBatch."No. Series", JobJnlLine."Posting Date", false);
                            JobJnlLine.Modify();
                        until JobJnlLine.Next() = 0;
                    CurrPage.Update();
                end;
            }
        }
        modify(SuggestLinesFromTimeSheets)
        {
            Caption = 'Suggest Lines from Time Sheets for hour nature';
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
            Visible = false;
        }
    }
}
