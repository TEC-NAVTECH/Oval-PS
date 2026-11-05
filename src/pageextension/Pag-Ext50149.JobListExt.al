pageextension 50149 JobListExt extends "Job List"
{
    layout
    {
        modify("Bill-to Customer No.")
        {
            Caption = 'Project Client';
        }
        modify("Search Description")
        {
            Visible = false;
        }
        addafter("Person Responsible")
        {
            field("Project Type"; Rec."Project Type")
            {
                ApplicationArea = all;
            }
            field("Project Status"; Rec."Project Status")
            {
                ApplicationArea = all;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = all;
            }
            field("Non-Project Task"; Rec."Non-Project Task")
            {
                ApplicationArea = all;
            }
            field("Last Date Modified"; Rec."Last Date Modified")
            {
                ApplicationArea = all;
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
        addafter("Create Job &Sales Invoice")
        {
            action(CalCulateProjectCostForAll) //VJ 15OCT2026 Action button added
            {
                ApplicationArea = All;
                Caption = 'Calculate Project Cost For All';
                ToolTip = 'Calculates resource cost based on HR% lists and adds project planning lines to Task 2200/2600 or 2100/2500.';
                Image = Calculate;
                RunObject = Report "Calculate Project Cost";
                RunPageOnRec = true;
                Promoted = true;
                PromotedCategory = Process;
                // trigger OnAction()
                // var
                //     CalcProjectCost: Codeunit "PIC Project Managment";
                //     l_Jobrec: Record job;
                // begin
                //     if Confirm('Do You Want to Calculate Project Cost for All Job?', false) then begin
                //         l_Jobrec.Reset();
                //         if l_Jobrec.FindSet() then
                //             repeat
                //                 CalcProjectCost.CalculateProjectCost(l_Jobrec);
                //             until l_Jobrec.Next() = 0;
                //     end;
                // end;

            }
            action(CreateActualHRrecord)
            {
                ApplicationArea = all;
                Caption = 'Create Actual HR% record';
                Image = CreateDocument;
                ToolTip = 'Create Actual HR% records from Time Sheet Lines.';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // RunObject = Report "Create Actual HR %";
                // RunPageOnRec = true;
                trigger OnAction()
                var
                    ReportCreateActualHRPer: Report "Create Actual HR %";
                    RecUserSEtup: Record "User Setup";
                begin
                    RecUserSEtup.Get(UserId);
                    if not RecUserSEtup."Setup Admin" then
                        Error('you do not have permission to run this button');
                    // if not Confirm('Do you want to create Actual HR%% records for Time Sheet %1?', true, Rec."Time Sheet No.") then
                    //     exit;
                    ReportCreateActualHRPer.Run();
                end;
            }

        }
    }
}
