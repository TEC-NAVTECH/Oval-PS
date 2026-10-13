report 50101 "Consolidate Lines"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number)where(Number=const(1));

            trigger OnAfterGetRecord()
            begin
                Qty:=0;
                TotalHrsPrcnt:=0;
                RsourceNo:='';
                JobPlanLine.Reset();
                JobPlanLine.SetCurrentKey("Job No.", "Schedule Line", JobPlanLine.Type, JobPlanLine."No.", JobPlanLine."Planning Date");
                JobPlanLine.SetRange("Job No.", JobNo);
                JobPlanLine.SetRange("Job Task No.", JobTaskNo);
                JobPlanLine.SetRange(Type, JobPlanLine.Type::Resource);
                JobPlanLine.SetFilter("Line Type", '<>%1', JobPlanLine."Line Type"::Budget);
                //JobPlanLine.SetRange("No.", RsourceNo);
                //JobPlanLine.SetRange("Document No.", Rec."Document No.");
                JobPlanLine.SetRange("Planning Date", FromDate, ToDate);
                if JobPlanLine.FindSet()then repeat if(RsourceNo <> JobPlanLine."No.") and (RsourceNo <> '')then begin
                            JobPlanLine1.Reset();
                            JobPlanLine1.SetRange("Job No.", JobNo);
                            JobPlanLine1.SetRange("Job Task No.", JobTaskNo);
                            JobPlanLine1.SetFilter("Line Type", '<>%1', JobPlanLine1."Line Type"::Budget);
                            JobPlanLine1.SetRange("No.", RsourceNo);
                            //JobPlanLine.SetRange("Document No.", Rec."Document No.");
                            JobPlanLine1.SetRange("Planning Date", FromDate, ToDate);
                            if JobPlanLine1.FindSet()then repeat Qty+=JobPlanLine1.Quantity;
                                    if TotalHrsPrcnt = 0 then TotalHrsPrcnt:=JobPlanLine1."Total Hours Percent";
                                until JobPlanLine1.Next() = 0;
                            JobPlanLine1.Reset();
                            JobPlanLine1.SetRange("Job No.", JobNo);
                            JobPlanLine1.SetRange("Job Task No.", JobTaskNo);
                            JobPlanLine1.SetFilter("Line Type", '<>%1', JobPlanLine1."Line Type"::Budget);
                            JobPlanLine1.SetRange("No.", RsourceNo);
                            //JobPlanLine.SetRange("Document No.", Rec."Document No.");
                            JobPlanLine1.SetRange("Planning Date", FromDate, ToDate);
                            if JobPlanLine1.Findfirst()then begin
                                JobPlanLine1.Validate(Quantity, Qty);
                                JobPlanLine1.Validate("Planning Date", ToDate);
                                JobPlanLine1.Validate("Total Hours Percent", TotalHrsPrcnt);
                                JobPlanLine1.Modify();
                            end;
                            ctr:=0;
                            JobPlanLine1.Reset();
                            JobPlanLine1.SetRange("Job No.", JobNo);
                            JobPlanLine1.SetRange("Job Task No.", JobTaskNo);
                            JobPlanLine1.SetFilter("Line Type", '<>%1', JobPlanLine1."Line Type"::Budget);
                            JobPlanLine1.SetRange("No.", RsourceNo);
                            //JobPlanLine.SetRange("Document No.", Rec."Document No.");
                            JobPlanLine1.SetRange("Planning Date", FromDate, ToDate);
                            if JobPlanLine1.FindSet()then repeat if ctr <> 0 then JobPlanLine1.Delete();
                                    ctr+=1;
                                until JobPlanLine1.Next() = 0;
                        end;
                        RsourceNo:=JobPlanLine."No.";
                    until JobPlanLine.Next() = 0;
                qty:=0;
                JobPlanLine1.Reset();
                JobPlanLine1.SetRange("Job No.", JobNo);
                JobPlanLine1.SetRange("Job Task No.", JobTaskNo);
                JobPlanLine1.SetFilter("Line Type", '<>%1', JobPlanLine1."Line Type"::Budget);
                JobPlanLine1.SetRange("No.", RsourceNo);
                //JobPlanLine.SetRange("Document No.", Rec."Document No.");
                JobPlanLine1.SetRange("Planning Date", FromDate, ToDate);
                if JobPlanLine1.FindSet()then repeat Qty+=JobPlanLine1.Quantity;
                    until JobPlanLine1.Next() = 0;
                JobPlanLine1.Reset();
                JobPlanLine1.SetRange("Job No.", JobNo);
                JobPlanLine1.SetRange("Job Task No.", JobTaskNo);
                JobPlanLine1.SetFilter("Line Type", '<>%1', JobPlanLine1."Line Type"::Budget);
                JobPlanLine1.SetRange("No.", RsourceNo);
                //JobPlanLine.SetRange("Document No.", Rec."Document No.");
                JobPlanLine1.SetRange("Planning Date", FromDate, ToDate);
                if JobPlanLine1.Findfirst()then begin
                    JobPlanLine1.Validate(Quantity, Qty);
                    JobPlanLine1.Validate("Planning Date", ToDate);
                    JobPlanLine1.Modify();
                end;
                ctr:=0;
                JobPlanLine1.Reset();
                JobPlanLine1.SetRange("Job No.", JobNo);
                JobPlanLine1.SetRange("Job Task No.", JobTaskNo);
                JobPlanLine1.SetFilter("Line Type", '<>%1', JobPlanLine1."Line Type"::Budget);
                JobPlanLine1.SetRange("No.", RsourceNo);
                //JobPlanLine.SetRange("Document No.", Rec."Document No.");
                JobPlanLine1.SetRange("Planning Date", FromDate, ToDate);
                if JobPlanLine1.FindSet()then repeat if ctr <> 0 then JobPlanLine1.Delete();
                        ctr+=1;
                    until JobPlanLine1.Next() = 0;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(FromDate_; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';

                        trigger OnValidate()
                        begin
                            ToDate:=CalcDate('<CM>', FromDate);
                        end;
                    }
                    field(ToDate_; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                        Editable = false;
                    }
                    field(RsourceNo_; RsourceNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Resource No.';
                        TableRelation = Resource;
                        Visible = false;
                    }
                    field(JobNo_; JobNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Job No.';
                    }
                    field(JobTaskNo_; JobTaskNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Job Task No.';
                    }
                }
            }
        }
    }
    procedure SetValues(JobNo1: Code[20]; JobTaskNo1: Code[20])
    begin
        JobNo:=JobNo1;
        JobTaskNo:=JobTaskNo1;
    end;
    var RsourceNo: Code[20];
    FromDate: Date;
    ToDate: Date;
    JobNo: Code[20];
    JobTaskNo: Code[20];
    JobPlanLine: Record "Job Planning Line";
    Qty: Decimal;
    TotalHrsPrcnt: Decimal;
    Ctr: Integer;
    JobPlanLine1: Record "Job Planning Line";
}
