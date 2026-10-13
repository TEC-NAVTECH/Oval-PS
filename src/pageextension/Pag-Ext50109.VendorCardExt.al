pageextension 50109 VendorCardExt extends "Vendor Card"
{
    actions
    {
        modify("Vendor - Balance to Date")
        {
            Visible = false;
        }
        addafter("Vendor - Labels")
        {
            action("Vendor - Balance to Date New")
            {
                ApplicationArea = All;
                Caption = 'Vendor - Balance to Date New';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    Vendor: Record vendor;
                begin
                    Vendor.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"Vendor - Balance to Date1", true, true, Vendor);
                end;
            }
        }
    }
}
