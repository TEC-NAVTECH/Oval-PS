page 50121 "Actual HR% List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Actual HR%";


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Resource No"; Rec."Resource No")
                {
                    ApplicationArea = All;
                    Caption = 'Resource No';
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = All;
                }
                field("Month/Year"; Rec."Month/Year")
                {
                    ApplicationArea = All;
                    Caption = 'MonthYear';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ApplicationArea = All;
                    Caption = 'Resource_Name';
                }
                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;
                }
                field("Project HR%"; Rec."Project HR%")
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
