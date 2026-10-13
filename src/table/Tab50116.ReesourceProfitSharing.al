table 50116 "Reesource Profit Sharing"
{
    Caption = 'Reesource Profit Sharing';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PIC; Code[20])
        {
            Caption = 'PIC';
            TableRelation = Job."No.";//VJ05082026 Added
        }

        field(2; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource."No.";
            trigger OnValidate()
            var
                ResourceRec: Record Resource;
            begin
                if ResourceRec.Get("Resource No.") then
                    "Resource Name" := ResourceRec.Name
                else
                    "Resource Name" := '';
            end;
        }

        field(3; "Resource Name"; Text[250])
        {
            Caption = 'Resource Name';
        }

        field(4; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }

        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
        }

        field(6; "Profit Sharing Ratio"; Decimal)
        {
            Caption = 'Profit Sharing Ratio';
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(PK; PIC, "Resource No.")
        {
            Clustered = true;
        }
    }

}
