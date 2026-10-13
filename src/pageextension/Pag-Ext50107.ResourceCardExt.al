pageextension 50107 ResourceCardExt extends "Resource Card"
{
    layout
    {
        addlast(General)
        {
            field("Overseas Staff"; Rec."Overseas Staff")
            {
                ApplicationArea = All;
            }
        }
        addafter("Staff Type")
        {
            field("Name (Short)"; Rec."Name (Short)")
            {
                ApplicationArea = All;
            }
            field("Staff Name"; Rec."Staff Name")//VJ15072026 Added
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Staff Name field.', Comment = '%';
            }
        }
    }
    var

}
