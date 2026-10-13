tableextension 50104 ResourceExtension extends Resource
{
    fields
    {
        field(50100; "Overseas Staff"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Overseas Staff';
        }
        field(50105; "Staff Name"; Text[100])//VJ15072026 Added
        {
            Caption = 'Staff Name';

        }

        /*
        field(50110; "Name (Short)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name (Short)';
        }
        */
    }
}
