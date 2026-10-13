tableextension 50100 JobPlanningLineExt extends "Job Planning Line"
{
    fields
    {
        //field(50110; "Tax expense LCY"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //trigger OnValidate()
        //begin
        //    "Net amount" := "Total Price (LCY)" - "Tax expense LCY" - "Subcon expense LCY";
        //end;
        // }
        //field(50111; "Subcon expense LCY"; Decimal)
        //{
        //   DataClassification = ToBeClassified;
        //trigger OnValidate()
        //begin
        //   "Net amount" := "Total Price (LCY)" - "Tax expense LCY" - "Subcon expense LCY";
        //end;
        // }
        //field(50112; "Net amount"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     Editable = false;
        // }
        //field(50113; "SCC issue date"; Date)
        // {
        //     DataClassification = ToBeClassified;
        //     Editable = false;
        // }
        field(50001; "Tax expense FCY"; Decimal)
        {
            trigger OnValidate()
            begin
                "Net amount FCY" := "Total Price" + "Tax expense FCY" + "Subcon expense FCY" + "Bank Charge FCY";
                if "Exchange Rate" <> 0 then
                    "Net Amount LCY" := "Net amount FCY" * "Exchange Rate"
                else
                    "Net Amount LCY" := "Net amount FCY";
            end;
        }
        field(50002; "Subcon expense FCY"; Decimal)
        {
            trigger OnValidate()
            begin
                "Net amount FCY" := "Total Price" + "Tax expense FCY" + "Subcon expense FCY" + "Bank Charge FCY";
                //"Net Amount LCY" := "Net amount FCY" * "Exchange Rate";
                if "Exchange Rate" <> 0 then
                    "Net Amount LCY" := "Net amount FCY" * "Exchange Rate"
                else
                    "Net Amount LCY" := "Net amount FCY";
            end;
        }
        field(50003; "Net amount FCY"; Decimal)
        {
            trigger OnValidate()
            begin
                "Net amount FCY" := "Total Price" + "Tax expense FCY" + "Subcon expense FCY" + "Bank Charge FCY";
                "Net Amount LCY" := "Net amount FCY" * "Exchange Rate";
            end;
        }
        field(50004; "SCC issue date"; Date)
        {
        }
        field(50005; "Net Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
        }
        field(50006; "Bank Charge FCY"; Decimal)
        {
            DataClassification = ToBeClassified;

            //Editable = false;
            trigger OnValidate()
            begin
                "Net amount FCY" := "Total Price" + "Tax expense FCY" + "Subcon expense FCY" + "Bank Charge FCY";
                //"Net Amount LCY" := "Net amount FCY" * "Exchange Rate";
                if "Exchange Rate" <> 0 then
                    "Net Amount LCY" := "Net amount FCY" * "Exchange Rate"
                else
                    "Net Amount LCY" := "Net amount FCY";
            end;
        }
        field(50100; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exchange Rate';
            //Editable = false;
        }
        field(50101; "Contract Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Code';
            //Editable = false;
            TableRelation = "Contract Card Header"."Contract Code Full";

            trigger OnValidate()
            var
                ContractHdr: Record "Contract Card Header";
            begin
                ContractHdr.Reset();
                ContractHdr.Get("Contract Code");
                validate("Customer No.", ContractHdr."Contract Client Code");
            end;
        }
        field(50102; "Projected Bill Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Projected Bill Date';
        }
        field(50103; "Projected Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Projected Payment Date';
        }
        field(50104; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Customer No.';
            //Editable = false;
            TableRelation = Customer;
        }
        field(50105; "Stage Payment Code"; Code[80])
        {
            DataClassification = ToBeClassified;
            Caption = 'Stage Payment Code';
            //Editable = false;
            //TableRelation = "Contract Card Line"."Stage Payment Code" where ("Contract Code Full" = field ("Contract Code"), Selected = const (false));
        }
        field(50106; "Currency Code 2"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code 2';
            TableRelation = Currency;

            trigger OnValidate()
            var
                ExchRate: Record "Currency Exchange Rate";
            begin
                if Rec."Currency Code 2" <> '' then begin
                    ExchRate.Reset();
                    ExchRate.SetCurrentKey("Currency Code", "Starting Date");
                    ExchRate.SetRange("Currency Code", Rec."Currency Code 2");
                    ExchRate.SetRange("Starting Date", 0D, WorkDate());
                    if ExchRate.FindLast() then begin
                        Rec."Exchange Rate" := ExchRate."Relational Exch. Rate Amount";
                        Rec."Unit Price (LCY)" := Rec."Unit Price" * ExchRate."Relational Exch. Rate Amount";
                        Rec."Line Amount (LCY)" := Rec."Line Amount" * ExchRate."Relational Exch. Rate Amount";
                        Rec."Total Price (LCY)" := Rec."Total Price" * ExchRate."Relational Exch. Rate Amount";
                        Rec."Unit Cost (LCY)" := rec."Unit Cost" * ExchRate."Relational Exch. Rate Amount";
                        rec."Total Cost (LCY)" := rec."Total Cost" * ExchRate."Relational Exch. Rate Amount";
                        //rec.Modify();
                    end;
                end;
            end;
        }
        field(50107; "Contract Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract line No.';
            Editable = false;
        }
        field(50108; "Invoice No."; Code[20])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Invoice No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Job Planning Line Invoice"."Document No." where("Document Type" = filter("Posted Invoice"), "Job No." = field("Job No."), "Job Task No." = field("Job Task No."), "Job Planning Line No." = field("Line No.")));
            Editable = false;
        }
        field(50109; "Total Hours Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Hours Percent';
            Editable = false;
        }
        field(50110; "Actual Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "Actual Payment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50112; FINESTBILLMTH; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50113; "Deliverable Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50115; "ActualBillMth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50116; "ProjRecMth"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key("Customer No."; "Customer No.")
        {
        }
    }
    var
        ContractHdr: Record "Contract Card Header";
        ContractLine: Record "Contract Card Line";
}
