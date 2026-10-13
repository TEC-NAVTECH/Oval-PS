page 50113 "Sales Invoice Lines"
{
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Sales Invoice Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Description 3"; Rec."Description 3")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        Desc: Text[100];
                    begin
                        desc:=Rec."Description 3";
                        Rec."Description 3":=Rec.Description;
                        Rec.Description:=desc;
                        Rec.Modify();
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
