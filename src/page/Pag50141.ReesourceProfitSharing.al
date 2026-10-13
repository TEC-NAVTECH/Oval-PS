page 50141 "Reesource Profit Sharing"
{
    ApplicationArea = All;
    Caption = 'Reesource Profit Sharing';
    PageType = List;
    SourceTable = "Reesource Profit Sharing";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(PIC; Rec.PIC)
                {
                    ToolTip = 'Specifies the value of the PIC field.', Comment = '%';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.', Comment = '%';
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    ToolTip = 'Specifies the value of the Resource Name field.', Comment = '%';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }

                field("Profit Sharing Ratio"; Rec."Profit Sharing Ratio")
                {
                    ToolTip = 'Specifies the value of the Profit Sharing Ratio field.', Comment = '%';
                }
            }
        }
    }
}
