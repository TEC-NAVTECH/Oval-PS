tableextension 50103 SalesHdrExtension extends "Sales Header"
{
    fields
    {
        field(50100; "Job No."; Code[20])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Job No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Job No." where("Document No."=field("No.")));
        }
    }
}
