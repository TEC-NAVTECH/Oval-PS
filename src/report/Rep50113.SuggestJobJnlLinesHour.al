report 50113 "Suggest Job Jnl. Lines-Hour"
{
    // version NAVW113.00
    Caption = 'Suggest Job Jnl. Lines-Hour';
    ProcessingOnly = true;
    UsageCategory = None; //Upgrade OP Code

    dataset
    {
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(StartingDate_; StartingDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(EndingDate_; EndingDate)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(ResourceNoFilter_; ResourceNoFilter)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource No. Filter';
                        TableRelation = Resource;
                        ToolTip = 'Specifies the resource number that the batch job will suggest job lines for.';
                    }
                    field(JobNoFilter_; JobNoFilter)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job No. Filter';
                        TableRelation = Job;
                        ToolTip = 'Specifies a filter for the job numbers that will be included in the report.';
                    }
                    field(JobTaskNoFilter_; JobTaskNoFilter)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Task No. Filter';
                        ToolTip = 'Specifies a filter for the job task numbers that will be included in the report.';

                        trigger OnLookup(var Text: Text): Boolean var
                            JobTask: Record "Job Task";
                        begin
                            JobTask.FILTERGROUP(2);
                            if JobNoFilter <> '' then JobTask.SETFILTER("Job No.", JobNoFilter);
                            JobTask.FILTERGROUP(0);
                            if PAGE.RUNMODAL(PAGE::"Job Task List", JobTask) = ACTION::LookupOK then JobTask.TESTFIELD("Job Task Type", JobTask."Job Task Type"::Posting);
                            JobTaskNoFilter:=JobTask."Job Task No.";
                        end;
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnPostReport()
    var
        NoSeriesMgt: Codeunit "No. Series";
        TimeSheetMgt: Codeunit "Time Sheet Management";
        NextDocNo: Code[20];
        LineNo: Integer;
        QtyToPost: Decimal;
    begin
        DateFilter:=TimeSheetMgt.GetDateFilter(StartingDate, EndingDate);
        FillTimeSheetLineBuffer();
        if TempTimeSheetLine.FINDSET()then begin
            JobJnlLine.LOCKTABLE();
            JobJnlTemplate.GET(JobJnlLine."Journal Template Name");
            JobJnlBatch.GET(JobJnlLine."Journal Template Name", JobJnlLine."Journal Batch Name");
            if JobJnlBatch."No. Series" = '' then NextDocNo:=''
            else
                NextDocNo:=NoSeriesMgt.GetNextNo(JobJnlBatch."No. Series", TempTimeSheetLine."Time Sheet Starting Date", false);
            JobJnlLine.SETRANGE("Journal Template Name", JobJnlLine."Journal Template Name");
            JobJnlLine.SETRANGE("Journal Batch Name", JobJnlLine."Journal Batch Name");
            if JobJnlLine.FINDLAST()then;
            LineNo:=JobJnlLine."Line No.";
            repeat TimeSheetHeader.GET(TempTimeSheetLine."Time Sheet No.");
                TimeSheetDetail.SETRANGE("Time Sheet No.", TempTimeSheetLine."Time Sheet No.");
                TimeSheetDetail.SETRANGE("Time Sheet Line No.", TempTimeSheetLine."Line No.");
                if DateFilter <> '' then TimeSheetDetail.SETFILTER(Date, DateFilter);
                TimeSheetDetail.SETFILTER(Quantity, '<>0');
                TimeSheetDetail.SETRANGE(Posted, false);
                if TimeSheetDetail.FINDSET()then repeat QtyToPost:=TimeSheetDetail.GetMaxQtyToPost();
                        if QtyToPost <> 0 then begin
                            JobJnlLine.INIT();
                            LineNo:=LineNo + 10000;
                            JobJnlLine."Line No.":=LineNo;
                            JobJnlLine."Time Sheet No.":=TimeSheetDetail."Time Sheet No.";
                            JobJnlLine."Time Sheet Line No.":=TimeSheetDetail."Time Sheet Line No.";
                            JobJnlLine."Time Sheet Date":=TimeSheetDetail.Date;
                            JobJnlLine.VALIDATE("Job No.", TimeSheetDetail."Job No.");
                            JobJnlLine."Source Code":=JobJnlTemplate."Source Code";
                            if TimeSheetDetail."Job Task No." <> '' then JobJnlLine.VALIDATE("Job Task No.", TimeSheetDetail."Job Task No.");
                            JobJnlLine.VALIDATE(Type, JobJnlLine.Type::Resource);
                            JobJnlLine.VALIDATE("No.", TimeSheetHeader."Resource No.");
                            if TempTimeSheetLine."Work Type Code" <> '' then JobJnlLine.VALIDATE("Work Type Code", TempTimeSheetLine."Work Type Code");
                            JobJnlLine.VALIDATE("Posting Date", TimeSheetDetail.Date);
                            JobJnlLine."Document No.":=NextDocNo;
                            NextDocNo:=INCSTR(NextDocNo);
                            JobJnlLine."Posting No. Series":=JobJnlBatch."Posting No. Series";
                            JobJnlLine.Description:=TempTimeSheetLine.Description;
                            JobJnlLine.VALIDATE(Quantity, QtyToPost);
                            JobJnlLine.VALIDATE(Chargeable, TempTimeSheetLine.Chargeable);
                            JobJnlLine."Reason Code":=JobJnlBatch."Reason Code";
                            if TempTimeSheetLine."Work Percent" <> 0 then JobJnlLine."Total Hours Percent":=TempTimeSheetLine."Work Percent";
                            if TempTimeSheetLine."Percent Per Month" <> 0 then JobJnlLine."Total Hours Percent":=TempTimeSheetLine."Percent Per Month";
                            OnAfterTransferTimeSheetDetailToJobJnlLine(JobJnlLine, JobJnlTemplate, TempTimeSheetLine, TimeSheetDetail);
                            JobJnlLine.INSERT();
                            if TimeSheetHeader."Posted Exists" = false then begin
                                TimeSheetHeader."Posted Exists":=true;
                                TimeSheetHeader.Modify();
                            end;
                        end;
                    until TimeSheetDetail.NEXT() = 0;
            until TempTimeSheetLine.NEXT() = 0;
        end;
    end;
    var JobJnlLine: Record "Job Journal Line";
    JobJnlBatch: Record "Job Journal Batch";
    JobJnlTemplate: Record "Job Journal Template";
    TimeSheetHeader: Record "Time Sheet Header";
    TimeSheetLine: Record "Time Sheet Line";
    TempTimeSheetLine: Record "Time Sheet Line" temporary;
    TimeSheetDetail: Record "Time Sheet Detail";
    ResourceNoFilter: Code[1024];
    JobNoFilter: Code[1024];
    JobTaskNoFilter: Code[1024];
    StartingDate: Date;
    EndingDate: Date;
    DateFilter: Text[30];
    procedure SetJobJnlLine(NewJobJnlLine: Record "Job Journal Line")
    begin
        JobJnlLine:=NewJobJnlLine;
    end;
    procedure InitParameters(NewJobJnlLine: Record "Job Journal Line"; NewResourceNoFilter: Code[1024]; NewJobNoFilter: Code[1024]; NewJobTaskNoFilter: Code[1024]; NewStartingDate: Date; NewEndingDate: Date)
    begin
        JobJnlLine:=NewJobJnlLine;
        ResourceNoFilter:=NewResourceNoFilter;
        JobNoFilter:=NewJobNoFilter;
        JobTaskNoFilter:=NewJobTaskNoFilter;
        StartingDate:=NewStartingDate;
        EndingDate:=NewEndingDate;
    end;
    local procedure FillTimeSheetLineBuffer()
    var
        SkipLine: Boolean;
    begin
        if ResourceNoFilter <> '' then TimeSheetHeader.SETFILTER("Resource No.", ResourceNoFilter);
        if DateFilter <> '' then begin
            TimeSheetHeader.SETFILTER("Starting Date", DateFilter);
            TimeSheetHeader.SETFILTER("Starting Date", '..%1', TimeSheetHeader.GETRANGEMAX("Starting Date"));
            TimeSheetHeader.SETFILTER("Ending Date", DateFilter);
            TimeSheetHeader.SETFILTER("Ending Date", '%1..', TimeSheetHeader.GETRANGEMIN("Ending Date"));
        end;
        TimeSheetHeader.SetRange("Posted Exists", false);
        TimeSheetHeader.SetRange("Time Sheet Type", TimeSheetHeader."Time Sheet Type"::Hour);
        if TimeSheetHeader.FINDSET()then repeat TimeSheetLine.SETRANGE("Time Sheet No.", TimeSheetHeader."No.");
                TimeSheetLine.SETRANGE(Type, TimeSheetLine.Type::Job);
                TimeSheetLine.SETRANGE(Status, TimeSheetLine.Status::Approved);
                if JobNoFilter <> '' then TimeSheetLine.SETFILTER("Job No.", JobNoFilter);
                if JobTaskNoFilter <> '' then TimeSheetLine.SETFILTER("Job Task No.", JobTaskNoFilter);
                TimeSheetLine.SETRANGE(Posted, false);
                TimeSheetLine.SetRange("Timesheet Nature");
                if TimeSheetLine.FINDSET()then repeat TempTimeSheetLine:=TimeSheetLine;
                        OnBeforeInsertTempTimeSheetLine(JobJnlLine, TimeSheetHeader, TempTimeSheetLine, SkipLine);
                        if not SkipLine then TempTimeSheetLine.INSERT();
                    until TimeSheetLine.NEXT() = 0;
            until TimeSheetHeader.NEXT() = 0;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertTempTimeSheetLine(JobJournalLine: Record "Job Journal Line"; TimeSheetHeader: Record "Time Sheet Header"; var TempTimeSheetLine: Record "Time Sheet Line" temporary; var SkipLine: Boolean)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterTransferTimeSheetDetailToJobJnlLine(var JobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; var TempTimeSheetLine: Record "Time Sheet Line" temporary; TimeSheetDetail: Record "Time Sheet Detail")
    begin
    end;
}
