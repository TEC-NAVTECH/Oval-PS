table 50101 "Contract Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Contract Type";

    fields
    {
        field(1; "Type"; Code[4])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type';
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Type")
        {
            Clustered = true;
        }
    }
}
