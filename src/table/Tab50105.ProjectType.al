table 50105 "Project Type"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Project Type";

    fields
    {
        field(1; "Type"; Code[20])
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
