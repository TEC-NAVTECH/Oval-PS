page 50110 "Posted Invoice Details Factbox"
{
    PageType = CardPart;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Job Planning Line Invoice";
    Caption = 'Posted Invoice Details';

    layout
    {
        area(Content)
        {
            field("Actual Invoice Date"; Rec."Invoiced Date")
            {
                ApplicationArea = All;
                Caption = 'Actual Invoice Date';
            }
            field("Actual Payment Date"; ActualBillDate)
            {
                ApplicationArea = All;
                Caption = 'Actual Payment Date';
            }
            field("Document No."; Rec."Document No.")
            {
                ApplicationArea = All;
                Caption = 'Invoice No.';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        ActualBillDate:=0D;
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Document No.", Rec."Document No.");
        if CustLedgEntry.FindFirst()then begin
            DetailCustLedgEntry.Reset();
            DetailCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
            DetailCustLedgEntry.SetRange(Unapplied, false);
            DetailCustLedgEntry.SetFilter("Document Type", '%1|%2', DetailCustLedgEntry."Document Type"::Payment, DetailCustLedgEntry."Document Type"::Refund);
            if DetailCustLedgEntry.FindFirst()then ActualBillDate:=DetailCustLedgEntry."Posting Date";
        end;
    end;
    var ActualBillDate: Date;
    CustLedgEntry: Record "Cust. Ledger Entry";
    DetailCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
}
