pageextension 50114 GLSetupExt extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            field("Year in Chinese Text"; Rec."Year in Chinese Text")
            {
                ApplicationArea = all;
            }
            field("Month in Chinese Text"; Rec."Month in Chinese Text")
            {
                ApplicationArea = all;
            }
            field("Date in Chinese Text"; Rec."Date in Chinese Text")
            {
                ApplicationArea = all;
            }
        }
    }
}
