pageextension 50118 CustomerLedgerEnteriesExt extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Sales (LCY)")
        {

            // field("Transaction No."; Rec."Transaction No.")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Transaction No. field.', Comment = '%';
            // }

        }
        addafter("Due Date")
        {
            field(AuxiliaryIndex1; Rec.AuxiliaryIndex1)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the AuxiliaryIndex1 field.', Comment = '%';
            }
        }
    }
}
