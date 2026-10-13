table 50104 "Contract Card Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Project Code"; Code[7])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Code';
            //Editable = false;
            TableRelation = Job;
        }
        field(2; "Project Code Prefix"; Code[4])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Code Prefix';

            trigger OnValidate()
            begin
                if "Project Code Suffix" <> '' then "Project Code":="Project Code Prefix" + '-' + "Project Code Suffix"
                else
                    "Project Code":="Project Code Prefix";
            end;
        }
        field(3; "Project Code Suffix"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Code Suffix';

            trigger OnValidate()
            begin
                TestField("Project Code Prefix");
                "Project Code":="Project Code Prefix" + '-' + "Project Code Suffix";
            end;
        }
        field(4; "Contract Code Suffix"; Code[12])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Code Suffix';

            trigger OnValidate()
            begin
                TestField("Project Code");
                if "Contract Type" <> '' then begin
                    if "Contract Code Full" = '' then "Contract Code Full":="Project Code" + '-' + "Contract Code Suffix" + '-' + "Contract Type";
                end
                else
                    "Contract Code Full":="Project Code" + '-' + "Contract Code Suffix";
                //ContractCardHdr.Reset();
                if ContractCardHdr.Get("Contract Code Full")then if ContractCardHdr."Contract Code Full" <> '' then Error('Same Contract Code already exist.');
            end;
        }
        field(5; "Contract Code Full"; Code[25])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Code Full';
            Editable = false;
            NotBlank = true;
        }
        field(6; "Contract Type"; Code[4])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Type';
            TableRelation = "Contract Type";

            trigger OnValidate()
            begin
                TestField("Project Code");
                TestField("Contract Code Suffix");
                //if "Contract Code Full" = '' then
                "Contract Code Full":="Project Code" + '-' + "Contract Code Suffix" + '-' + "Contract Type";
                ContractCardHdr.Reset();
                if ContractCardHdr.Get("Contract Code Full")then if ContractCardHdr."Contract Code Full" <> '' then Error('Same Contract Code already exist.');
                ContractType.Reset();
                ContractType.Get("Contract Type");
                "Contract Type Description":=ContractType.Description;
            end;
        }
        field(7; "Project Client"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Client';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                CustRec.Reset();
                CustRec.Get("Project Client");
                "Project Client Description":=CustRec.Name;
            end;
        }
        field(8; City; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'City';
            TableRelation = "Country/Region";
        }
        field(9; "Contract Name EN"; Text[80])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Name EN';
        }
        field(10; "Contract Name CN"; Text[80])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Name CN';
        }
        field(11; "Contract Client Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Client Code';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                CustRec.reset();
                CustRec.get("Contract Client Code");
                "Contract Client Name":=CustRec.Name;
            end;
        }
        field(12; "Contract Client Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Contract Client Name';
        }
        field(13; "Total Building Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Building Area';
        }
        field(14; "Lead Person"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Lead Person';
            TableRelation = Resource;
        }
        field(15; "Contract Signed Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Signed Date';
        }
        field(16; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract End Date';
        }
        field(17; "Contract Status"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Status';
            TableRelation = "Contract Status";

            trigger OnValidate()
            begin
                ContractStatus.Reset();
                ContractStatus.Get("Contract Status");
                "Contract Status Description":=ContractStatus.Description;
            end;
        }
        field(18; "Contract Type Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Type Description';
            Editable = false;
        }
        field(19; "Contract Status Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Status Description';
            Editable = false;
        }
        field(20; "Project Client Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Client Description';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Contract Code Full")
        {
            Clustered = true;
        }
    }
    var CustRec: Record Customer;
    ContractType: Record "Contract Type";
    ContractStatus: Record "Contract Status";
    ContactRec: Record Contact;
    ContractCardHdr: Record "Contract Card Header";
}
