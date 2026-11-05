report 50116 "Create Actual HR %"
{
    Caption = 'Create Actual HR %';
    ProcessingOnly = true;
    dataset
    {

        dataitem(TimeSheetHeader; "Time Sheet Header")
        {
            RequestFilterFields = "No.", "Resource No.", "Starting Date", "Ending Date", "Time Sheet Type";
            trigger OnAfterGetRecord()
            begin
                CUCreateActualHRPercent.CreateActualHRRecords("Time Sheet No.", false);
                CreatedCount := CUCreateActualHRPercent.Showcountcreated();
            end;

            trigger OnPostDataItem()
            begin
                Message('%1 Actual HR%% record(s) created.', CreatedCount);
            end;
        }
    }
    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //             }
    //         }
    //     }
    //     actions
    //     {
    //         area(Processing)
    //         {
    //         }
    //     }
    // }
    var
        CUCreateActualHRPercent: Codeunit "Create Actual HR %";
        CreatedCount: Integer;
}
