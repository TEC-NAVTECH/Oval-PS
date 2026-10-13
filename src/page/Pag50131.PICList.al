page 50131 "PIC List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = PIC;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    ToolTip = 'Specifies the value of the Project Code field.', Comment = '%';
                }

                field("Project Name"; Rec."Project Name")
                {
                    ToolTip = 'Specifies the value of the Project Name field.', Comment = '%';
                }
                field(PIC; Rec.PIC)
                {
                    ToolTip = 'Specifies the value of the PIC field.', Comment = '%';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
                field("Profit Sharing Ratio"; Rec."Profit Sharing Ratio")
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
