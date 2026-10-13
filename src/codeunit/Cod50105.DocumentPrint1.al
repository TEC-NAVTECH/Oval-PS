codeunit 50105 "Document-Print1"
{
    procedure PrintSalesHeader(SalesHeader: Record "Sales Header")
    begin
        DoPrintSalesHeader(SalesHeader, false);
    end;
    procedure DoPrintSalesHeader(SalesHeader: Record "Sales Header"; SendAsEmail: Boolean)
    var
        ReportSelections: Record "Report Selections";
        IsPrinted: Boolean;
        ReportUsage: Enum "Report Selection Usage";
    begin
        ReportUsage:=GetSalesDocTypeUsage(SalesHeader);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeader.SetRange("No.", SalesHeader."No.");
        SalesHeader.SETRANGE("No.", SalesHeader."No.");
        CalcSalesDisc(SalesHeader);
        //OnBeforeDoPrintSalesHeader(SalesHeader, GetSalesDocTypeUsage(SalesHeader), SendAsEmail, IsPrinted);
        if IsPrinted then exit;
        //IF SendAsEmail THEN
        //    ReportSelections.SendEmailToCust(
        //       GetSalesDocTypeUsage(SalesHeader), SalesHeader, SalesHeader."No.", SalesHeader.GetDocTypeTxt, TRUE, SalesHeader.GetBillToNo)
        //ELSE
        //ReportSelections.Print(GetSalesDocTypeUsage(SalesHeader), SalesHeader, SalesHeader.FIELDNO("Bill-to Customer No."));
        ReportSelections.PrintForCust(ReportUsage, SalesHeader, SalesHeader.FieldNo("Bill-to Customer No."));
    end;
    procedure CalcSalesDisc(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        //OnBeforeCalcSalesDisc(SalesHeader, IsHandled);
        if IsHandled then exit;
        SalesSetup.GET();
        if SalesSetup."Calc. Inv. Discount" then begin
            SalesLine.RESET();
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.FINDFIRST();
            CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount", SalesLine);
            SalesHeader.GET(SalesHeader."Document Type", SalesHeader."No.");
            COMMIT();
        end;
    end;
    procedure GetSalesDocTypeUsage(SalesHeader: Record "Sales Header")ReportSelectionUsage: Enum "Report Selection Usage" var
        ReportSelections: Record "Report Selections";
    begin
        case SalesHeader."Document Type" of SalesHeader."Document Type"::Quote: exit(ReportSelections.Usage::"S.Quote");
        SalesHeader."Document Type"::"Blanket Order": exit(ReportSelections.Usage::"S.Blanket");
        SalesHeader."Document Type"::Order: exit(ReportSelections.Usage::"S.Order");
        SalesHeader."Document Type"::"Return Order": exit(ReportSelections.Usage::"S.Return");
        SalesHeader."Document Type"::Invoice: exit(ReportSelections.Usage::"S.Invoice Draft");
        SalesHeader."Document Type"::"Credit Memo": exit(ReportSelections.Usage::"S.Cr.Memo");
        else
            ERROR('');
        end;
    end;
    var SalesSetup: Record "Sales & Receivables Setup";
}
