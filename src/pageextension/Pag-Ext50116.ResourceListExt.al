pageextension 50116 ResourceListExt extends "Resource List"
{
    layout
    {

        addafter("Resource Group No.")
        {
            field("Name (Short)"; Rec."Name (Short)")
            {
                ApplicationArea = All;
            }
            field("Coupled to Dataverse1"; rec."Coupled to Dataverse")
            {
                ApplicationArea = all;
                Caption = 'Coupled to Dataverse';
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
