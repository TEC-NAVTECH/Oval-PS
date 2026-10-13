table 50115 "Staff Cluster History"
{
    Caption = 'Staff Cluster History';
    DataClassification = CustomerContent;

    fields
    {
        // ── Primary Key ──────────────────────────────────────────
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }

        // ── Staff (lookup Resource table) ────────────────────────
        field(2; Staff; Code[20])
        {
            Caption = 'Staff';
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if Staff = '' then begin
                    "Staff_Name" := '';
                    "Resource_Group_No" := '';
                    Status := Status::" ";
                    exit;
                end;

                if Resource.Get(Staff) then begin
                    "Staff_Name" := Resource.Name;
                    "Resource_Group_No" := Resource."Resource Group No.";
                end;
            end;
        }
        field(3; Staff_Name; Text[250])
        {
            Caption = 'Staff Name';
            DataClassification = CustomerContent;
        }
        field(4; Staff_Cluster; Code[20])
        {
            Caption = 'Staff Cluster';
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }

        field(5; Effective_Date; Date)
        {
            Caption = 'Effective Date';
            DataClassification = CustomerContent;
        }
        field(6; End_Date; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (End_Date <> 0D) and (Effective_Date <> 0D) and (End_Date < Effective_Date) then
                    Error('End Date %1 cannot be earlier than Effective Date %2.', End_Date, Effective_Date);
            end;
        }

        field(7; Resource_Group_No; Code[20])
        {
            Caption = 'Resource Group No.';
            DataClassification = CustomerContent;
            TableRelation = "Resource Group"."No.";
        }

        field(8; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Active,Inactive,Planning,Resigned,Rotated';
            OptionMembers = " ",Active,Inactive,Planning,Resigned,Rotated;
        }
        field(9; Cluster_Description; Text[500])
        {
            Caption = 'Cluster Description';
            DataClassification = CustomerContent;
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

