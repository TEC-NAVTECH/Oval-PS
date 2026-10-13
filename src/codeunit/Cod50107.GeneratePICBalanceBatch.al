codeunit 50107 "Generate PIC Balance Batch"
{

    trigger OnRun()
    begin
        g_Project.Reset();
        if g_Project.FindSet() then
            repeat
                g_CodPicprojmgmt.GeneratePICBalance(g_Project);
            until g_Project.Next() = 0;
    end;

    var
        g_Project: Record Job;
        g_CodPicprojmgmt: Codeunit "PIC Project Managment";
}