pageextension 50103 JobTaskLineSubformExt extends "Job Task Lines Subform"
{
    actions
    {
        addfirst("&Job")
        {
            action("Job Planning Lines")
            {
                ApplicationArea = All;
                Caption = 'Job Planning Lines';
                Image = JobLines;
                Scope = "Repeater";

                trigger OnAction()
                var
                    JobPlanningLine: Record "Job Planning Line";
                    JobPlanningLines: Page "Job Planning Lines New";
                    JobPlanningLines2000: Page "Job Planning Lines 2000";
                    JobPlanningLines3000: Page "Job Planning Lines 3000";
                    JobPlanningLinesAll: Page "Job Planning Lines for All";
                begin
                    Rec.TESTFIELD("Job No.");
                    JobPlanningLine.FILTERGROUP(2);
                    JobPlanningLine.SETRANGE("Job No.", Rec."Job No.");
                    JobPlanningLine.SETRANGE("Job Task No.", Rec."Job Task No.");
                    JobPlanningLine.FILTERGROUP(0);
                    case Rec."Job Task No." of // Convert if statement to Case
                        '1000':
                            begin
                                JobPlanningLines.SETTABLEVIEW(JobPlanningLine);
                                JobPlanningLines.EDITABLE := true;
                                JobPlanningLines.RUN();
                            end;
                        '2000':
                            begin
                                JobPlanningLines2000.SETTABLEVIEW(JobPlanningLine);
                                JobPlanningLines2000.EDITABLE := true;
                                JobPlanningLines2000.RUN();
                            end;
                        '3000':
                            begin
                                JobPlanningLines3000.SETTABLEVIEW(JobPlanningLine);
                                JobPlanningLines3000.EDITABLE := true;
                                JobPlanningLines3000.RUN();
                            end;
                        else begin
                            JobPlanningLinesall.SETTABLEVIEW(JobPlanningLine);
                            JobPlanningLinesall.EDITABLE := true;
                            JobPlanningLinesall.RUN();
                        end;
                    end;
                end;
            }
            action("Calculate Project Cost")  //VJ 01JUNE202 Action button added
            {
                ApplicationArea = All;
                Caption = 'Calculate Project Cost';
                ToolTip = 'Calculates resource cost based on HR% lists and adds project planning lines to Task 2200/2600 or 2100/2500.';
                Image = Calculate;
                trigger OnAction()
                var
                    CalcProjectCost: Codeunit "PIC Project Managment";
                    l_Jobrec: Record job;
                begin
                    l_Jobrec.Get(Rec."Job No.");
                    if Confirm('Calculate Project Cost for Job %1?', false, Rec."Job No.") then
                        CalcProjectCost.CalculateProjectCost(l_Jobrec);
                end;
            }
        }
        modify(JobPlanningLines)
        {
            Visible = false;
        }
        modify("Create &Sales Invoice")
        {
            Visible = false;
        }
        addfirst(Documents)
        {
            action("Create Sales invoice")
            {
                ApplicationArea = All;
                Image = JobSalesInvoice;
                Caption = 'Create Sales Invoice';

                trigger OnAction()
                var
                    Job: Record Job;
                    JobTask: Record "Job Task";
                    JobPlanLine: Record "Job Planning Line";
                    JobCreateInvoice: Codeunit "Job Create-Invoice1";
                begin
                    Rec.TESTFIELD("Job No.");
                    Job.GET(Rec."Job No.");
                    if Job.Blocked = Job.Blocked::All then Job.TestBlocked();
                    JobTask.SETRANGE("Job No.", Job."No.");
                    if Rec."Job Task No." <> '' then JobTask.SETRANGE("Job Task No.", Rec."Job Task No.");
                    JobPlanLine.Reset();
                    JobPlanLine.SetRange("Job No.", Rec."Job No.");
                    JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
                    //if JobPlanLine.FindSet() then
                    JobCreateInvoice.CreateSalesInvoice(JobPlanLine, false);
                    //REPORT.RUNMODAL(REPORT::"Job Create Sales Invoice", TRUE, FALSE, JobTask);
                end;
            }
        }
    }
}
