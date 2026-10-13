pageextension 50101 JobCardExtension extends "Job Card"
{
    layout
    {
        addbefore("No.")
        {
            field("Project Code Prefix"; Rec."Project Code Prefix")
            {
                ApplicationArea = All;
            }
            field("Project Code Suffix"; Rec."Project Code Suffix")
            {
                ApplicationArea = All;
            }
        }
        addafter("Project Manager")
        {
            field("Project Name EN"; Rec."Project Name EN")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Project Type"; Rec."Project Type")
            {
                ApplicationArea = All;
            }
            field("Project Status"; Rec."Project Status")
            {
                ApplicationArea = All;
            }
        }
        modify("No.")
        {
            Caption = 'Project Code';
            Editable = false;
        }
        modify("Bill-to Contact")
        {
            Visible = false;
        }
        modify("Bill-to Name")
        {
            Visible = false;
        }
        modify("Project Manager")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Editable = false;
        }
        modify("Invoice Currency Code")
        {
            Editable = false;
        }
        modify("Person Responsible")
        {
            Caption = 'PIC';
        }
        modify("Bill-to Contact No.")
        {
            Visible = false;
        }
        modify("Bill-to Address")
        {
            Visible = false;
        }
        modify("Bill-to Address 2")
        {
            Visible = false;
        }
        modify("Bill-to City")
        {
            Visible = false;
        }
        modify("Bill-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Bill-to Post Code")
        {
            Visible = false;
        }
        modify("External Document No.")
        {
            Visible = false;
        }
        modify(Description)
        {
            Caption = 'Project name';
        }
        modify("Sell-to Customer No.")
        {
            Caption = 'Project Client';
        }
        addbefore(Blocked)
        {
            field(PIC; Rec.PIC)
            {
                ApplicationArea = All;
            }
        }
        addafter(Blocked)
        {
            field("Project Client No."; Rec."Project Client No.")
            {
                ApplicationArea = All;
            }
            field("Project Client Name"; Rec."Project Client Name")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast("&Job")
        {
            action("Contract List")
            {
                ApplicationArea = All;
                Image = List;
                RunObject = page "Contract List";
                RunPageLink = "Project Code" = field("No.");
            }
        }
        addafter(Category_Report)
        {
            actionref(JobCostFactorList_Promoted; JobCostFactorList) { }
            actionref(PICList_Promoted; PICList) { }
        }
        addafter("F&unctions")
        {

            action(JobCostFactorList)
            {
                Caption = 'Job Cost Factor';
                ApplicationArea = All;
                Image = Job;
                RunObject = page "Job Cost Factor List";
                RunPageLink = "Project Code" = field("No.");
            }

            action(PICList)
            {
                Caption = 'PIC';
                ApplicationArea = All;
                Image = PersonInCharge;
                RunObject = page "PIC List";
                RunPageLink = "Project Code" = field("No.");
            }

            action(GeneratePICBalance) //VJ 01JUNE2026 Action button added
            {
                Caption = 'Generate PIC Balance';
                ApplicationArea = All;
                Image = Calculate;
                trigger OnAction()
                var
                    PICManagment: Codeunit "PIC Project Managment";
                begin

                    if Confirm('Do You Want Generate PIC Balance for Job %1?', false, Rec."No.") then begin
                        PICManagment.GeneratePICBalance(Rec);
                        Message('PIC Balance Generated');
                    end


                end;

            }
            action(GenerateTask)
            {
                //TEC VJ 23July2026 fixed issue to create task when new project created
                Caption = 'Generate Default Task';
                ApplicationArea = All;
                Image = Create;
                Visible = false;
                trigger OnAction()
                var
                    PICmgtCU: Codeunit "PIC Project Managment";
                begin
                    if not confirm('Do you want to generate default task?', false) then
                        exit;
                    if Rec."No." <> '' then
                        PICmgtCU.GenerateProjectTask(rec);//TEC VJ 25MAY2026

                end;
            }

        }
    }
}
