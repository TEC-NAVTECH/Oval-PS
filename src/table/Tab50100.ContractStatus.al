table 50100 "Contract Status"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Contract Status";

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
