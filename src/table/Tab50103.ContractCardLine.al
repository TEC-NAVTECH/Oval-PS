table 50103 "Contract Card Line"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Contract Lines";

    fields
    {
        field(1; "Stage Payment Code"; Code[80])
        {
            DataClassification = ToBeClassified;
            Caption = 'Stage Payment Code';
            Editable = false;
        }
        field(2; Phase; Code[4])
        {
            DataClassification = ToBeClassified;
            Caption = 'Phase';

            trigger OnValidate()
            begin
                "Stage Payment Code" := "Contract Code Full" + '/' + Phase + '-' + FORMAT("Serial No.") + '-' + Format("Stage Percent") + '-' + "Project Stage";
            end;
        }
        field(3; "Serial No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Serial No.';

            trigger OnValidate()
            begin
                "Stage Payment Code" := "Contract Code Full" + '/' + Phase + '-' + FORMAT("Serial No.") + '-' + Format("Stage Percent") + '-' + "Project Stage";
            end;
        }
        field(4; "Stage Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Stage Percent';

            trigger OnValidate()
            begin
                "Stage Payment Code" := "Contract Code Full" + '/' + Phase + '-' + FORMAT("Serial No.") + '-' + Format("Stage Percent") + '-' + "Project Stage";
            end;
        }
        field(5; "Project Stage"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Stage';
            TableRelation = "Project Stage";

            trigger OnValidate()
            begin
                ProjectStage.Reset();
                ProjectStage.get("Project Stage");
                "Stage Details Description" := ProjectStage.Description;
                "Stage Payment Code" := "Contract Code Full" + '/' + Phase + '-' + FORMAT("Serial No.") + '-' + Format("Stage Percent") + '-' + "Project Stage";
            end;
        }
        field(6; "Stage Details Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Stage Details Description';
        }
        field(7; Currency; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(8; "Stage Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Stage Amount';
        }
        field(9; "Contract Code Full"; Code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Code Full';
        }
        field(10; Selected; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Selected';
            Editable = false;
        }
        field(11; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }
        field(12; "ProjBillMth"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'ProjBillMth';
        }
        field(13; "FinEstBillMth"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'FinEstBillMth';
        }
        field(14; "ActualBillMth"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'ActualBillMth';
        }
        field(15; "ProjRecMth"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'ProjRecMth';
        }
    }
    keys
    {
        key(PK; "Contract Code Full", "Stage Payment Code", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        ProjectStage: Record "Project Stage";
}
