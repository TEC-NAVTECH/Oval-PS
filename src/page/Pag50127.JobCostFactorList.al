page 50127 "Job Cost Factor List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Job Cost Factor";


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                }
                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field("Job Cost Factor"; Rec."Job Cost Factor")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {
        }
    }
}
