table 50110 "PIC Project Balance"
{
    DataClassification = CustomerContent;
    Caption = 'PIC Project Balance';
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(2; "Total HR %"; Boolean)
        {
            Caption = 'Total HR %';
        }

        field(3; "Company Name"; Text[250])
        {
            Caption = 'Company Name';
        }

        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }

        field(5; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
        }

        field(6; "Nature"; Option)
        {
            Caption = 'Nature';

            OptionMembers = ACTUAL,PROJECTED;
            OptionCaption = 'ACTUAL,PROJECTED';
        }

        field(7; "ProjectPIC"; Text[250])
        {
            Caption = 'ProjectPIC';
        }

        field(8; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }

        field(9; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
            TableRelation = Job;
        }

        field(10; "Project Name"; Text[250])
        {
            Caption = 'Project Name';
        }

        field(11; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 0 : 2;
        }

        field(12; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
            DecimalPlaces = 0 : 2;
        }

        field(13; "Category"; Option)
        {
            Caption = 'Category';

            OptionMembers = Billing,Resource;
            OptionCaption = 'Billing,Resource';
        }

        field(14; "Job Cost Factor"; Decimal)
        {
            Caption = 'Job Cost Factor';
            DecimalPlaces = 0 : 5;
        }
        field(15; "Profit Sharing Ratio"; Decimal)
        {
            Caption = 'Profit Sharing Ratio';

        }
        field(16; "Project_PIC"; Text[250])
        {
            Caption = 'Project_PIC';
        }
        field(17; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }


    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
