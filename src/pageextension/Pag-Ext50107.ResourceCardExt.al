pageextension 50107 ResourceCardExt extends "Resource Card"
{
    layout
    {
        modify(Name)
        {
            caption = 'Staff Name (Full)';
        }

        addlast(General)
        {
            field("Overseas Staff"; Rec."Overseas Staff")
            {
                ApplicationArea = All;
            }
        }
        addafter("Base Unit of Measure")
        {
            field("Name (Short)"; Rec."Name (Short)")
            {
                ApplicationArea = All;
                caption = 'Staff Name (Short)';
            }
            field("Staff Name"; Rec."Staff Name")//VJ15072026 Added
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Staff Name field.', Comment = '%';
            }
            //VJ05112026 commented  these field as per cara Oval issues start
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
            field("Staff Type"; Rec."Staff Type")
            {
                ApplicationArea = All;
            }
            //VJ05112026 commented  these field as per cara Oval issues end
        }
    }
    var

}
