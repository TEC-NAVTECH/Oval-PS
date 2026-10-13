pageextension 50149 JobListExt extends "Job List"
{
    layout
    {
        modify("Bill-to Customer No.")
        {
            Caption = 'Project Client';
        }
        modify("Search Description")
        {
            Visible = false;
        }
        addafter("Person Responsible")
        {
            field("Project Type"; Rec."Project Type")
            {
                ApplicationArea = all;
            }
            field("Project Status"; Rec."Project Status")
            {
                ApplicationArea = all;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = all;
            }
            field("Non-Project Task"; Rec."Non-Project Task")
            {
                ApplicationArea = all;
            }
            field("Last Date Modified"; Rec."Last Date Modified")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addlast("&Job")
        {
            action("Contract List")
            {
                ApplicationArea = All;
                Image = List;
                RunObject = page "Contract List";
                RunPageLink = "Project Code"=field("No.");
            }
        }
    }
}
