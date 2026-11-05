table 50111 "Actual HR%"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Actual HR% List";

    fields
    {
        field(1; "Resource No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource No';
            TableRelation = Resource;
            // trigger OnValidate()
            // var
            //     Resource: record Resource;
            // begin
            //     Resource.Reset();
            //     Resource.SetRange("No.", "Resource No");
            //     if Resource.FindFirst() then;
            //     Rec."Staff Name" := Resource."Name (Short)";
            // end;
            //VJ Field converted to flow field 15Oct2026
        }
        field(2; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Code';
            TableRelation = Job;
            trigger OnValidate()
            var
                Job: record Job;
            begin
                Job.Reset();
                Job.SetRange("No.", "Project Code");
                if Job.FindFirst() then
                    "Project Name" := Job."Description";
            end;
        }
        field(3; "Month/Year"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Month/Year';
        }
        field(4; "Staff Name"; Text[100])
        {
            // DataClassification = ToBeClassified;
            // Caption = 'Staff Name';
            caption = 'Staff Name (Full)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Resource.Name where("No." = field("Resource No")));
        }
        field(5; "Project Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Name';
            Editable = false;
        }
        field(6; "Project HR%"; Decimal)
        {
            DataClassification = ToBeClassified;
            //Caption = 'Project HR%';
            Caption = 'Actual HR%';
            decimalPlaces = 2 : 2;
        }
        field(7; "Month"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Month';
        }
        field(8; "Year"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Year';
        }
    }
    keys
    {
        key(PK; "Resource No", "Project Code", Month, Year)
        {
            Clustered = true;
        }
    }
}
