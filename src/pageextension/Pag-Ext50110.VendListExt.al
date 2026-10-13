pageextension 50110 VendListExt extends "Vendor List"
{
    actions
    {
        modify("Vendor - Balance to Date")
        {
            Visible = false;
        }
        addafter("Vendor - Trial Balance")
        {
            action("Vendor - Balance to Date New")
            {
                ApplicationArea = All;
                Caption = 'Vendor - Balance to Date New';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                RunObject = report "Vendor - Balance to Date1";
            }
        }
    }
}
