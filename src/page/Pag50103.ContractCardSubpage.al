page 50103 "Contract Card Subpage"
{
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Contract Card Line";
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = true;

    //Editable = false;
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
            }
        }
    }
}
