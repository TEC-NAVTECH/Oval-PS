page 50128 "PIC Project Balance List"
{
    PageType = List;
    SourceTable = "PIC Project Balance";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'PIC Project Balance List';
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Total HR %"; Rec."Total HR %")
                {
                    ApplicationArea = All;
                }

                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }

                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                }

                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                }

                field("Nature"; Rec."Nature")
                {
                    ApplicationArea = All;
                }
                field(ProjectPIC; Rec.ProjectPIC)
                {
                    ToolTip = 'Specifies the value of the ProjectPIC field.', Comment = '%';
                }
                field(Project_PIC; Rec.Project_PIC)
                {
                    ToolTip = 'Specifies the value of the Project_PIC field.', Comment = '%';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }



                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }

                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = All;
                }

                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                }

                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = All;
                }

                field("Category"; Rec."Category")
                {
                    ApplicationArea = All;
                }

                field("Job Cost Factor"; Rec."Job Cost Factor")
                {
                    ApplicationArea = All;
                }
                field("Profit Sharing Ratio"; Rec."Profit Sharing Ratio")
                {
                    ToolTip = 'Specifies the value of the Profit Sharing Ratio field.', Comment = '%';
                }

            }
        }
    }
}
