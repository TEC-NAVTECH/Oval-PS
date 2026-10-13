page 50102 "Project Stage"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Project Stage";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Stage; Rec.Stage)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
