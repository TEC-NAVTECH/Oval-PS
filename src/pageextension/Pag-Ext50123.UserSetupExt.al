pageextension 50123 "User Setup Ext" extends "user setup"
{
    layout
    {
        addlast(Control1)
        {

            field("Setup Admin"; Rec."Setup Admin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the permission to create actual HR% list field.', Comment = '%';
            }
        }

    }
}
