tableextension 50112 CustLedgerEntryExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(50100; "AuxiliaryIndex1"; Code[20])
        {
            // CaptionClass = '1,1,1';
            Caption = 'AuxiliaryIndex1';
            //ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
    }
}
