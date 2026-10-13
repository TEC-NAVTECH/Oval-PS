tableextension 50105 JobJournalLineExt extends "Job Journal Line"
{
    fields
    {
        field(50100; "Total Hours Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Hours Percent';
            Editable = false;
        }
    }
}
