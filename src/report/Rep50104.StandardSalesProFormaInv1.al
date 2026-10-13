report 50104 "Standard Sales-Pro Forma Inv1"
{
    // version NAVW113.03
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Standard Sales - Pro Forma Inv.rdl';
    //WordLayout = './Standard Sales - Pro Forma Inv.docx';
    Caption = 'Pro Forma Invoice';
    UsageCategory = None; //Upgrade OP Code

    dataset
    {
        dataitem(Header; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Pro Forma Invoice';

            column(DocumentDate; FORMAT("Document Date", 0, 4))
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyEMail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(CompanyPhoneNo; CompanyInformation."Phone No.")
            {
            }
            column(CompanyVATRegNo; CompanyInformation."VAT Registration No.")
            {
            }
            column(CompanyAddress1; CompanyAddress[1])
            {
            }
            column(CompanyAddress2; CompanyAddress[2])
            {
            }
            column(CompanyAddress3; CompanyAddress[3])
            {
            }
            column(CompanyAddress4; CompanyAddress[4])
            {
            }
            column(CompanyAddress5; CompanyAddress[5])
            {
            }
            column(CompanyAddress6; CompanyAddress[6])
            {
            }
            column(CustomerAddress1; CustomerAddress[1])
            {
            }
            column(CustomerAddress2; CustomerAddress[2])
            {
            }
            column(CustomerAddress3; CustomerAddress[3])
            {
            }
            column(CustomerAddress4; CustomerAddress[4])
            {
            }
            column(CustomerAddress5; CustomerAddress[5])
            {
            }
            column(CustomerAddress6; CustomerAddress[6])
            {
            }
            column(CustomerAddress7; CustomerAddress[7])
            {
            }
            column(CustomerAddress8; CustomerAddress[8])
            {
            }
            column(YourReference; "Your Reference")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(DocumentNo; "No.")
            {
            }
            column(CompanyLegalOffice;'')
            {
            }
            column(SalesPersonName; SalespersonPurchaserName)
            {
            }
            column(ShipmentMethodDescription; ShipmentMethodDescription)
            {
            }
            column(Currency; CurrencyCode)
            {
            }
            column(CustomerVATRegNo; CustomerVATRegistrationNo)
            {
            }
            column(PageLbl; PageLbl)
            {
            }
            column(DocumentTitleLbl; DocumentTitleLbl)
            {
            }
            column(YourReferenceLbl; FIELDCAPTION("Your Reference"))
            {
            }
            column(ExternalDocumentNoLbl; FIELDCAPTION("External Document No."))
            {
            }
            column(CompanyLegalOfficeLbl;'')
            {
            }
            column(SalesPersonLbl; SalesPersonLblText)
            {
            }
            column(EMailLbl; CompanyInformation.FIELDCAPTION("E-Mail"))
            {
            }
            column(HomePageLbl; CompanyInformation.FIELDCAPTION("Home Page"))
            {
            }
            column(CompanyPhoneNoLbl; CompanyInformation.FIELDCAPTION("Phone No."))
            {
            }
            column(ShipmentMethodDescriptionLbl; DummyShipmentMethod.TABLECAPTION)
            {
            }
            column(CurrencyLbl; DummyCurrency.TABLECAPTION)
            {
            }
            column(ItemLbl; Item.TABLECAPTION)
            {
            }
            column(TariffLbl; Item.FIELDCAPTION("Tariff No."))
            {
            }
            column(UnitPriceLbl; Item.FIELDCAPTION("Unit Price"))
            {
            }
            column(CountryOfManufactuctureLbl; CountryOfManufactuctureLbl)
            {
            }
            column(AmountLbl; Line.FIELDCAPTION(Amount))
            {
            }
            column(VATPctLbl; Line.FIELDCAPTION("VAT %"))
            {
            }
            column(VATAmountLbl; DummyVATAmountLine.VATAmountText())
            {
            }
            column(TotalWeightLbl; TotalWeightLbl)
            {
            }
            column(TotalAmountLbl; TotalAmountLbl)
            {
            }
            column(TotalAmountInclVATLbl; TotalAmountInclVATLbl)
            {
            }
            column(QuantityLbl; Line.FIELDCAPTION(Quantity))
            {
            }
            column(NetWeightLbl; Line.FIELDCAPTION("Net Weight"))
            {
            }
            column(DeclartionLbl; DeclartionLbl)
            {
            }
            column(SignatureLbl; SignatureLbl)
            {
            }
            column(SignatureNameLbl; SignatureNameLbl)
            {
            }
            column(SignaturePositionLbl; SignaturePositionLbl)
            {
            }
            column(VATRegNoLbl; CompanyInformation.FIELDCAPTION("VAT Registration No."))
            {
            }
            dataitem(Line; "Sales Line")
            {
                DataItemLink = "Document Type"=field("Document Type"), "Document No."=field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");

                column(ItemDescription; Description)
                {
                }
                column(CountryOfManufacturing; Item."Country/Region of Origin Code")
                {
                }
                column(Tariff; Item."Tariff No.")
                {
                }
                column(Quantity; "Qty. to Invoice")
                {
                }
                column(Price; FormattedLinePrice)
                {
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 2;
                }
                column(NetWeight; "Net Weight")
                {
                }
                column(LineAmount; FormattedLineAmount)
                {
                AutoFormatExpression = "Currency Code";
                AutoFormatType = 1;
                }
                column(VATPct; "VAT %")
                {
                }
                column(VATAmount; FormattedVATAmount)
                {
                }
                trigger OnAfterGetRecord()
                var
                    AutoFormatType: Enum "Auto Format";
                begin
                    Item.GET("No.");
                    OnBeforeLineOnAfterGetRecord(Header, Line);
                    if Quantity = 0 then begin
                        LinePrice:="Unit Price";
                        LineAmount:=0;
                        VATAmount:=0;
                    end
                    else
                    begin
                        LinePrice:=ROUND(Amount / Quantity, Currency."Unit-Amount Rounding Precision");
                        LineAmount:=ROUND(Amount * "Qty. to Invoice" / Quantity, Currency."Amount Rounding Precision");
                        VATAmount:=ROUND(("Amount Including VAT" - Amount) * "Qty. to Invoice" / Quantity, Currency."Amount Rounding Precision");
                        TotalAmount+=LineAmount;
                        TotalWeight+=ROUND("Qty. to Invoice" * "Net Weight");
                        TotalVATAmount+=VATAmount;
                        TotalAmountInclVAT+=ROUND("Amount Including VAT" * "Qty. to Invoice" / Quantity, Currency."Amount Rounding Precision");
                    end;
                    //FormattedLinePrice := FORMAT(LinePrice, 0, AutoFormatManagement.AutoFormatTranslate(2, CurrencyCode));
                    //FormattedLineAmount := FORMAT(LineAmount, 0, AutoFormatManagement.AutoFormatTranslate(1, CurrencyCode));
                    //FormattedVATAmount := FORMAT(VATAmount, 0, AutoFormatManagement.AutoFormatTranslate(1, CurrencyCode));
                    FormattedLinePrice:=Format(LinePrice, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::UnitAmountFormat, CurrencyCode));
                    FormattedLineAmount:=Format(LineAmount, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                    FormattedVATAmount:=Format(VATAmount, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                end;
                trigger OnPreDataItem()
                begin
                    TotalWeight:=0;
                    TotalAmount:=0;
                    TotalVATAmount:=0;
                    TotalAmountInclVAT:=0;
                    SETRANGE(Type, Type::Item);
                    OnAfterLineOnPreDataItem(Header, Line);
                end;
            }
            dataitem(Totals; Integer)
            {
                MaxIteration = 1;

                column(TotalWeight; TotalWeight)
                {
                }
                column(TotalValue; FormattedTotalAmount)
                {
                }
                column(TotalVATAmount; FormattedTotalVATAmount)
                {
                }
                column(TotalAmountInclVAT; FormattedTotalAmountInclVAT)
                {
                }
                trigger OnPreDataItem()
                var
                    AutoFormatType: Enum "Auto Format";
                begin
                    // FormattedTotalAmount := FORMAT(TotalAmount, 0, AutoFormatManagement.AutoFormatTranslate(1, CurrencyCode));
                    // FormattedTotalVATAmount := FORMAT(TotalVATAmount, 0, AutoFormatManagement.AutoFormatTranslate(1, CurrencyCode));
                    // FormattedTotalAmountInclVAT := FORMAT(TotalAmountInclVAT, 0, AutoFormatManagement.AutoFormatTranslate(1, CurrencyCode));
                    FormattedTotalAmount:=Format(TotalAmount, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                    FormattedTotalVATAmount:=Format(TotalVATAmount, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                    FormattedTotalAmountInclVAT:=Format(TotalAmountInclVAT, 0, AutoFormat.ResolveAutoFormat(AutoFormatType::AmountFormat, CurrencyCode));
                end;
            }
            trigger OnAfterGetRecord()
            begin
                FormatDocumentFields(Header);
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
    end;
    var CompanyInformation: Record "Company Information";
    DocumentTitleLbl: Label 'Draft Invoice';
    PageLbl: Label 'Page';
    Item: Record Item;
    DummyVATAmountLine: Record "VAT Amount Line";
    DummyShipmentMethod: Record "Shipment Method";
    DummyCurrency: Record Currency;
    Currency: Record Currency;
    AutoFormat: Codeunit "Auto Format";
    //AutoFormatManagement: Codeunit AutoFormatManagement;
    CompanyAddress: array[8]of Text[90];
    CustomerAddress: array[8]of Text[90];
    SalesPersonLblText: Text[50];
    CountryOfManufactuctureLbl: Label 'Country';
    TotalWeightLbl: Label 'Total Weight';
    SalespersonPurchaserName: Text;
    ShipmentMethodDescription: Text;
    CustomerVATRegistrationNo: Text;
    TotalAmountLbl: Text[50];
    TotalAmountInclVATLbl: Text[50];
    FormattedLinePrice: Text;
    FormattedLineAmount: Text;
    FormattedVATAmount: Text;
    FormattedTotalAmount: Text;
    FormattedTotalVATAmount: Text;
    FormattedTotalAmountInclVAT: Text;
    CurrencyCode: Code[10];
    TotalWeight: Decimal;
    TotalAmount: Decimal;
    DeclartionLbl: Label 'For customs purposes only.';
    SignatureLbl: Label 'For and on behalf of the above named company:';
    SignatureNameLbl: Label 'Name (in print) Signature';
    SignaturePositionLbl: Label 'Position in company';
    TotalVATAmount: Decimal;
    TotalAmountInclVAT: Decimal;
    LinePrice: Decimal;
    LineAmount: Decimal;
    VATAmount: Decimal;
    salesInvProforma: Report "Standard Sales - Pro Forma Inv";
    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        ShipmentMethod: Record "Shipment Method";
        ResponsibilityCenter: Record "Responsibility Center";
        Customer: Record Customer;
        FormatDocument: Codeunit "Format Document";
        FormatAddress: Codeunit "Format Address";
        TotalAmounExclVATLbl: Text[50];
    begin
        //WITH SalesHeader DO BEGIN
        Customer.GET(SalesHeader."Sell-to Customer No.");
        CustomerVATRegistrationNo:=Customer."VAT Registration No.";
        FormatDocument.SetSalesPerson(SalespersonPurchaser, SalesHeader."Salesperson Code", SalesPersonLblText);
        SalespersonPurchaserName:=SalespersonPurchaser.Name;
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesHeader."Shipment Method Code", SalesHeader."Language Code");
        ShipmentMethodDescription:=ShipmentMethod.Description;
        FormatAddress.GetCompanyAddr(SalesHeader."Responsibility Center", ResponsibilityCenter, CompanyInformation, CompanyAddress);
        FormatAddress.SalesHeaderBillTo(CustomerAddress, SalesHeader);
        if SalesHeader."Currency Code" = '' then begin
            GeneralLedgerSetup.GET();
            GeneralLedgerSetup.TESTFIELD("LCY Code");
            CurrencyCode:=GeneralLedgerSetup."LCY Code";
            Currency.InitRoundingPrecision();
        end
        else
        begin
            CurrencyCode:=SalesHeader."Currency Code";
            Currency.GET(SalesHeader."Currency Code");
        end;
        FormatDocument.SetTotalLabels(SalesHeader."Currency Code", TotalAmountLbl, TotalAmountInclVATLbl, TotalAmounExclVATLbl);
    //END;
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterLineOnPreDataItem(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeLineOnAfterGetRecord(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;
}
