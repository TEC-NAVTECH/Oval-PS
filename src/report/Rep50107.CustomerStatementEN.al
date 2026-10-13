report 50107 "Customer-Statement_EN"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Customer-Statement.rdl';
    //ApplicationArea = #Basic,#Suite;
    Caption = 'Customer-Statement_EN';
    PreviewMode = PrintLayout;

    //UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Job Planning Line"; "Job Planning Line")
        {
            RequestFilterFields = "Job No.", "Customer No.";

            column(Stage; Stage)
            {
            }
            column(Description; Description)
            {
            }
            column(Unit_Price; "Unit Price")
            {
            }
            column(InvAmt; InvAmt)
            {
            }
            column(Actual_Invoice_Date; "Actual Invoice Date")
            {
            }
            column(Invoice_No_; "Invoice No.")
            {
            }
            column(PaidAmt; PaidAmt)
            {
            }
            column(OSAmt; OSAmt)
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(Filters; Filters)
            {
            }
            column(AsOfDate; FORMAT(AsOfDate))
            {
            }
            column(Customer_No_; "Customer No.")
            {
            }
            column(Text001; Text001)
            {
            }
            column(Text002; Text002)
            {
            }
            column(Text003; Text003)
            {
            }
            column(Text004; Text004)
            {
            }
            column(Text005; Text005)
            {
            }
            column(Text006; Text006)
            {
            }
            column(Text007; Text007)
            {
            }
            column(Text008; Text008)
            {
            }
            column(Text009; Text009)
            {
            }
            trigger OnPreDataItem()
            begin
                Filters:="Job Planning Line".GetFilters;
                "Job Planning Line".SetRange("Actual Invoice Date", 0D, AsOfDate);
            end;
            trigger OnAfterGetRecord()
            begin
                cuLanguage.get('ZHH');
                CurrReport.LANGUAGE:=cuLanguage."Windows Language ID";
                //CurrReport.LANGUAGE:=Language.GetLanguageID('ZHH');
                CalcFields("Qty. Invoiced");
                InvAmt:="Qty. Invoiced" * "Unit Price";
                PaidAmt:=0;
                OSAmt:=0;
                Remarks:='';
                CustLedgEntry.Reset();
                CustLedgEntry.SetRange("Document No.", "Invoice No.");
                if CustLedgEntry.FindFirst()then begin
                    CustLedgEntry.CalcFields(Amount, "Remaining Amount");
                    PaidAmt:=CustLedgEntry.Amount - CustLedgEntry."Remaining Amount";
                    OSAmt:=CustLedgEntry."Remaining Amount";
                    if Today < CustLedgEntry."Due Date" then Remarks:=''
                    else
                        Remarks:=FORMAT(Today - CustLedgEntry."Due Date") + ' Days';
                end;
                Stage:='';
                if ContractLine.Get("Contract Code", "Stage Payment Code", "Contract Line No.")then Stage:=ContractLine."Project Stage";
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("As of Date"; AsOfDate)
                    {
                        ApplicationArea = All;
                        Caption = 'As of Date';
                    }
                }
            }
        }
    }
    labels
    {
    Text0011='ENU = Statement of Account as of;CHS = 对账单至';
    }
    var Stage: Code[10];
    InvAmt: Decimal;
    PaidAmt: Decimal;
    OSAmt: Decimal;
    Remarks: Text;
    CustLedgEntry: Record "Cust. Ledger Entry";
    cuLanguage: Record Language;
    Filters: Text;
    AsOfDate: Date;
    ContractLine: Record "Contract Card Line";
    Text001: TextConst ENU = 'Statement of Account as of', CHS = '对账单至';
    Text002: TextConst ENU = 'Stages', CHS = '阶段';
    Text003: TextConst ENU = 'Design Fee', CHS = '服务费用';
    Text004: TextConst ENU = 'Invoiced Amount', CHS = '已请款金额';
    Text005: TextConst ENU = 'Invoice Date', CHS = '请款日期';
    Text006: TextConst ENU = 'Invoice No.', CHS = '账单编号';
    Text007: TextConst ENU = 'Paid Amount', CHS = '已支付金额';
    Text008: TextConst ENU = 'O/S Amount', CHS = '尚欠金额';
    Text009: TextConst ENU = 'Remarks', CHS = '备注';
}
