pageextension 50111 CompInfoExt extends "Company Information"
{
    layout
    {
        addlast(Payments)
        {
            field("Bank Address"; Rec."Bank Address")
            {
                ApplicationArea = All;
            }
            field("Bank Address 2"; Rec."Bank Address 2")
            {
                ApplicationArea = All;
            }
        }
    }
}
