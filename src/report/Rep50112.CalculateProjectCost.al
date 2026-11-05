report 50112 "Calculate Project Cost"
{
    Caption = 'Calculate Project Cost';
    ProcessingOnly = true;
    dataset
    {
        dataitem(Job; Job)
        {
            RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            begin
                g_CodPicprojmgmt.CalculateProjectCost(Job);
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed then
                    Message('Project Cost calculation completed');
            end;
        }
    }

    var
        g_CodPicprojmgmt: Codeunit "PIC Project Managment";
}
