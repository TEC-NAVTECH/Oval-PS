pageextension 50104 JobSetupPageExtension extends "Jobs Setup"
{
    layout
    {
        addlast(General)
        {
            field("Job Planning Line Account No."; Rec."Job Planning Line Account No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
