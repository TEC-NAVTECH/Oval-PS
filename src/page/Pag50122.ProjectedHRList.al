page 50122 "Projected HR% List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Projected HR %";


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Resource No"; Rec."Resource No")
                {
                    ToolTip = 'Specifies the value of the Resource No field.', Comment = '%';
                }

                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = All;
                }
                field("MonthYear"; Rec."MonthYear")
                {
                    ApplicationArea = All;
                    Caption = 'MonthYear';
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    ToolTip = 'Specifies the value of the Resource Name field.', Comment = '%';
                }

                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;
                }
                field("Projected_HRPercent"; Rec."Projected_HRPercent")
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
