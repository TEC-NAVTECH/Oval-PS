tableextension 50101 JobExtension extends Job
{
    fields
    {
        field(50100; "Project Code Prefix"; Code[4])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Code Prefix';

            trigger OnValidate()
            var
                PICmgtCU: Codeunit "PIC Project Managment";
            begin
                if "Project Code Suffix" <> '' then "No." := "Project Code Prefix" + '-' + "Project Code Suffix";
                JobRec.Reset();
                if JobRec.Get("No.") then Error('Same Job No. already exist.');



            end;
        }
        field(50101; "Project Code Suffix"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Code Suffix';

            trigger OnValidate()

            begin
                //TestField("Project Code Prefix");
                "No." := "Project Code Prefix" + '-' + "Project Code Suffix";
                JobRec.Reset();
                if JobRec.Get("No.") then Error('Same Job No. already exist.');

            end;
        }

        field(50102; "Project Name EN"; Text[80])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Name EN';
        }
        field(50103; "Project Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Projct Type';
            TableRelation = "Project Type";
        }
        field(50104; "Project Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Status';
            TableRelation = "Project Status";
        }
        field(50105; "PIC"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'PIC';
            TableRelation = Resource;
        }
        field(50106; "Project Client Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Client Name';
            Editable = false;
        }
        field(50107; "Project Client No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project Client No.';
            TableRelation = Customer;
            trigger OnValidate()
            var
                Customer: record Customer;
            begin
                Customer.Reset();
                Customer.SetRange("No.", "Project Client No.");
                if Customer.FindFirst() then
                    "Project Client Name" := Customer.Name;
            end;
        }
        // field(50108; "Project Code Prefix"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'PIC';
        //     TableRelation = Resource;
        // }
    }


    var
        JobRec: Record Job;
}
