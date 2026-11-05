codeunit 50107 "Generate PIC Balance Batch"
{

    trigger OnRun()
    begin
        g_Project.Reset();
        g_Project.SetFilter("Project Type", '<>%1', 'NON-Project');//VJ 26Oct2026 added filter as per Cara
        if g_Project.FindSet() then
            repeat
                g_CodPicprojmgmt.GeneratePICBalance(g_Project);
            until g_Project.Next() = 0;
    end;

    var
        g_Project: Record Job;
        g_CodPicprojmgmt: Codeunit "PIC Project Managment";
}