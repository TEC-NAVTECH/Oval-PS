table 50106 "Project Status"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Project Status";

    fields
    {
        field(1; Status; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }
        field(2; Description; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; Status)
        {
            Clustered = true;
        }
    }
}
