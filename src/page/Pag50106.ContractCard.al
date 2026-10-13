page 50106 "Contract Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Contract Card Header";
    Caption = 'Contract Card';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Project Code Prefix"; Rec."Project Code Prefix")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Project Code Suffix"; Rec."Project Code Suffix")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Project Code"; Rec."Project Code")
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
                field("Contract Type Description"; Rec."Contract Type Description")
                {
                    ApplicationArea = All;
                }
                field("Contract Code Full"; Rec."Contract Code Full")
                {
                    ApplicationArea = All;
                }
                field("Project Client"; Rec."Project Client")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Project Client Description"; Rec."Project Client Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Contract Name EN"; Rec."Contract Name EN")
                {
                    ApplicationArea = All;
                }
                field("Contract Name CN"; Rec."Contract Name CN")
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
                field("Contract Status Description"; Rec."Contract Status Description")
                {
                    ApplicationArea = All;
                }
            }
        //part(ContractCardLines; "Contract Card Subpage")
        //{
        //    ApplicationArea = Basic, Suite;
        //    SubPageLink = "Contract Code Full" = field ("Contract Code Full");
        // }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Li&nes")
            {
                ApplicationArea = All;
                Caption = 'Li&nes';
                Image = Line;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Contract Lines";
                RunPageLink = "Contract Code Full"=field("Contract Code Full");
                PromotedOnly = true; //
            }
        }
    // area(Promoted)
    // {
    //     group(Category_Process)
    //     {
    //         Caption = 'Li&nes';
    //         actionref(Lines_Promoted; "Li&nes")
    //         { }
    //     }
    // }
    }
}
