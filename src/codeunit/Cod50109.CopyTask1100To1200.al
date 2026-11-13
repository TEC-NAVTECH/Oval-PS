codeunit 50109 "Copy Task 1100 To 1200"
{
    TableNo = "Job Planning Line";

    trigger OnRun()
    begin
        CopyTask1100To1200(Rec);
    end;

    local procedure CopyTask1100To1200(var PageRec: Record "Job Planning Line")
    var
        Source: Record "Job Planning Line";
        Target: Record "Job Planning Line";
        JobTask: Record "Job Task";
        Created: Integer;
        Updated: Integer;
        Skipped: Integer;
    begin
        // Respect the filters on the page (e.g. Job No.), then restrict to Task 1100
        Source.CopyFilters(PageRec);
        Source.SetRange("Job Task No.", '1100');

        if Source.FindSet() then
            repeat
                if not JobTask.Get(Source."Job No.", '1200') then
                    Skipped += 1
                else
                    if Target.Get(Source."Job No.", '1200', Source."Line No.") then begin
                        CopyFields(Source, Target);
                        Target.Modify(true);
                        Updated += 1;
                    end else begin
                        Clear(Target);
                        Target.Init();
                        Target."Job No." := Source."Job No.";
                        Target."Job Task No." := '1200';
                        Target."Line No." := Source."Line No.";
                        CopyFields(Source, Target);
                        Target.Insert(true);
                        Created += 1;
                    end;
            until Source.Next() = 0;

        Message('Task 1200 lines created: %1\Updated: %2\Skipped (Task 1200 missing on the job): %3',
            Created, Updated, Skipped);
    end;

    local procedure CopyFields(Source: Record "Job Planning Line"; var Target: Record "Job Planning Line")
    var
        Keep: Record "Job Planning Line";
    begin
        // Remember posting/invoicing state of the target so it is not overwritten
        Keep := Target;

        // Copies all non-key fields, including your custom fields
        Target.TransferFields(Source, false);

        Target."Qty. Posted" := Keep."Qty. Posted";
        Target."Qty. Transferred to Invoice" := Keep."Qty. Transferred to Invoice";
        Target."Qty. Invoiced" := Keep."Qty. Invoiced";
        Target."Invoiced Amount (LCY)" := Keep."Invoiced Amount (LCY)";
        Target."Invoiced Cost Amount (LCY)" := Keep."Invoiced Cost Amount (LCY)";
        Target."Ledger Entry No." := Keep."Ledger Entry No.";
        Target."Ledger Entry Type" := Keep."Ledger Entry Type";
        Target."Job Contract Entry No." := Keep."Job Contract Entry No.";
        target."Line Amount (LCY)" := keep."Line Amount (LCY)";//VJ 13Nov2026 added to keep line amount
        target."Total Cost (LCY)" := keep."Total Cost (LCY)";//VJ 13Nov2026 added to keep line amount
    end;
}