report 50117 "Create Staff Cluster History"
{
    Caption = 'Create Staff Cluster History';
    ProcessingOnly = true;
    dataset
    {
        dataitem(ResourceCostNew; "Resource Cost New")
        {
            RequestFilterFields = Type, Code, "Month/Year", "Staff Cluster";

            trigger OnAfterGetRecord()
            begin
                CUCreateStaffClusterHistory.CreateFromSalaryHistory(ResourceCostNew, false);
                CreatedCount := CUCreateStaffClusterHistory.Showcountcreated();
            end;

            trigger OnPostDataItem()
            begin
                Message('%1 Staff Cluster History record(s) created.', CreatedCount);
            end;

            trigger OnPreDataItem()
            begin
                CUCreateStaffClusterHistory.deleteStaffClusterHistory(ResourceCostNew);//VJ 05Nov2026 added to delete the existing records before creating new records
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
        CUCreateStaffClusterHistory: Codeunit CreateStaffClusterHistory;
        CreatedCount: Integer;
}
