table 50114 "PIC"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PIC List";

    fields
    {

        field(1; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Code';
            TableRelation = Job;

        }
        field(2; "Resource No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource No.';
            TableRelation = Resource;
            trigger OnValidate()
            var
                Resource: record Resource;
            begin
                Resource.Reset();
                Resource.SetRange("No.", "Resource No.");
                if Resource.FindFirst() then;
                Rec."Resource Name" := Resource.Name;
            end;
        }

        field(3; "Resource Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource Name';
            Editable = false;
        }
        field(4; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Effective Date';
        }
        field(5; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
        field(6; "Profit Sharing Ratio"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Profit Sharing Ratio';
        }
        field(7; "Project Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Name';
        }
        field(8; "PIC"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'PIC';
            TableRelation = Job;
        }

    }
    keys
    {
        key(PK; "Project Code", "Resource No.")
        {
            Clustered = true;
        }
    }
}
