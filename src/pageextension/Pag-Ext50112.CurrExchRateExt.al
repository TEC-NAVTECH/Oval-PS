pageextension 50112 CurrExchRateExt extends "Currency Exchange Rates"
{
    actions
    {
        addlast(Processing)
        {
            action("Update Rate in JPL")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = NewExchangeRate;

                trigger OnAction()
                var
                    JPL: Record "Job Planning Line";
                    CurrExchRate: Record "Currency Exchange Rate";
                begin
                    CurrExchRate.Reset();
                    CurrExchRate.SetCurrentKey("Currency Code", "Starting Date");
                    CurrExchRate.SetRange("Currency Code", Rec."Currency Code");
                    if CurrExchRate.FindLast()then begin
                        JPL.Reset();
                        JPL.SetRange("Currency Code 2", CurrExchRate."Currency Code");
                        JPL.SetRange("Actual Invoice Date", 0D);
                        if JPL.FindSet()then repeat JPL."Exchange Rate":=CurrExchRate."Relational Exch. Rate Amount";
                                jpl."Unit Price (LCY)":=jpl."Unit Price" * currExchRate."Relational Exch. Rate Amount";
                                jpl."Line Amount (LCY)":=jpl."Unit Price" * currExchRate."Relational Exch. Rate Amount";
                                jpl."Total Price (LCY)":=jpl."Unit Price" * currExchRate."Relational Exch. Rate Amount";
                                JPL."Unit Cost (LCY)":=JPL."Unit Cost" * CurrExchRate."Relational Exch. Rate Amount";
                                JPL."Total Cost (LCY)":=JPL."Total Cost" * CurrExchRate."Relational Exch. Rate Amount";
                                JPL."Net Amount LCY":=JPL."Net amount FCY" * CurrExchRate."Relational Exch. Rate Amount";
                                JPL.Modify();
                            until JPL.Next() = 0;
                    end;
                    Message('Done');
                end;
            }
        }
    }
}
