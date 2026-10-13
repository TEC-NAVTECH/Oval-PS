page 50140 "Staff Cluster History List"
{
    ApplicationArea = All;
    Caption = 'Staff Cluster History List';
    PageType = List;
    SourceTable = "Staff Cluster History";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field(Staff; Rec.Staff)
                {
                    ToolTip = 'Specifies the value of the Staff field.', Comment = '%';
                }
                field(Staff_Name; Rec.Staff_Name)
                {
                    ToolTip = 'Specifies the value of the Staff Name field.', Comment = '%';
                }
                field(Staff_Cluster; Rec.Staff_Cluster)
                {
                    ToolTip = 'Specifies the value of the Staff Cluster field.', Comment = '%';
                }
                field(Effective_Date; Rec.Effective_Date)
                {
                    ToolTip = 'Specifies the value of the Effective Date field.', Comment = '%';
                }
                field(End_Date; Rec.End_Date)
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field(Resource_Group_No; Rec.Resource_Group_No)
                {
                    ToolTip = 'Specifies the value of the Resource Group No. field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Cluster_Description; Rec.Cluster_Description)
                {
                    ToolTip = 'Specifies the value of the Cluster Description field.', Comment = '%';
                }
            }
        }
    }
}
