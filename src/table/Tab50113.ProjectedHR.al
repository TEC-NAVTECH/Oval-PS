table 50113 "Projected HR %"
{
    DataClassification = ToBeClassified;
    // LookupPageId = "Actual HR% List";

    fields
    {
        field(1; "Resource No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource No';
            TableRelation = Resource;
            trigger OnValidate()
            var
                Resource: record Resource;
            begin
                Resource.Reset();
                Resource.SetRange("No.", "Resource No");
                if Resource.FindFirst() then;
                Rec."Resource Name" := Resource."Name (Short)";
            end;
        }
        field(2; "Project Code"; Text[100])
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
        field(3; "MonthYear"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'MonthYear';
        }
        field(4; "Resource Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource Name';
            Editable = false;
        }
        field(5; "Project Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Name';
            Editable = false;
        }
        field(6; "Projected_HRPercent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Projected_HRPercent';
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
