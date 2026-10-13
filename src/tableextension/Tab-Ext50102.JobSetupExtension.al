tableextension 50102 JobSetupExtension extends "Jobs Setup"
{
    fields
    {
        field(50100; "Job Planning Line Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Planning Line Account No.';
            TableRelation = "G/L Account";
        }
    }
}
