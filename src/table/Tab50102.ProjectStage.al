table 50102 "Project Stage"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Project Stage";

    fields
    {
        field(1; Stage; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Stage';
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; Stage)
        {
            Clustered = true;
        }
    }
}
