tableextension 50110 CompanyInfoExt extends "Company Information"
{
    fields
    {
        field(50100; "Bank Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "Bank Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        a: Record 167;
}
