tableextension 50106 SalesInvLineExt extends "Sales Invoice Line"
{
    fields
    {
        field(50100; "Description 3"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
}
