page 50107 "Contract List"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Contract Card Header";
    Editable = false;
    CardPageId = 50106;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract Code Full"; Rec."Contract Code Full")
                {
                    ApplicationArea = All;
                }
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = All;
                }
                field("Project Code Prefix"; Rec."Project Code Prefix")
                {
                    ApplicationArea = All;
                }
                field("Project Code Suffix"; Rec."Project Code Suffix")
                {
                    ApplicationArea = All;
                }
                field("Contract Code Suffix"; Rec."Contract Code Suffix")
                {
                    ApplicationArea = All;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = All;
                }
                field("Project Client"; Rec."Project Client")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Contract Name CN"; Rec."Contract Name CN")
                {
                    ApplicationArea = All;
                }
                field("Contract Name EN"; Rec."Contract Name EN")
                {
                    ApplicationArea = All;
                }
                field("Contract Client Code"; Rec."Contract Client Code")
                {
                    ApplicationArea = All;
                }
                field("Contract Client Name"; Rec."Contract Client Name")
                {
                    ApplicationArea = All;
                }
                field("Total Building Area"; Rec."Total Building Area")
                {
                    ApplicationArea = All;
                }
                field("Lead Person"; Rec."Lead Person")
                {
                    ApplicationArea = All;
                }
                field("Contract Signed Date"; Rec."Contract Signed Date")
                {
                    ApplicationArea = All;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {
        }
    }
}
