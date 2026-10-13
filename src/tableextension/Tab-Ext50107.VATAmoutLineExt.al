tableextension 50107 VATAmoutLineExt extends "VAT Amount Line"
{
    fields
    {
    }
    procedure CalcLineAmount1(): Decimal begin
        exit("Line Amount" - "Invoice Discount Amount")end;
}
