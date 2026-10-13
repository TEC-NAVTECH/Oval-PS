table 50112 "Job Cost Factor"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Job Cost Factor List";

    fields
    {

        field(1; "Project Code"; Code[20])
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
        field(2; "Month"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Month';
        }
        field(3; "Year"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Year';
        }
        field(4; "Project Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Name';
            Editable = false;
        }
        field(5; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Effective Date';
        }
        field(6; "Job Cost Factor"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Cost Factor';
            //  Editable = false;
        }

    }
    keys
    {
        key(PK; "Project Code")
        {
            Clustered = true;
        }
    }
}
