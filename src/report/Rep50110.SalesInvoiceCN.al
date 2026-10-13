report 50110 "Sales Invoice_CN"
{
    // version NAVW113.04
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Order Confirmation.rdl';
    Caption = 'Sales Invoice_CN';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = Administration;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.")where("Document Type"=const(Invoice));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';

            column(DocType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            column(Bill_to_Contact; "Bill-to Contact")
            {
            }
            column(JobNo; JobNo)
            {
            }
            column(TotalAmtDesc; TotalAmtDesc)
            {
            }
            column(TotalLineAmt; TotalLineAmt)
            {
            }
            column(TotalLineAmt1; TotalLineAmt1)
            {
            }
            column(ContractName; ContractName)
            {
            }
            column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
            {
            }
            column(YearTxt; GLSetup."Year in Chinese Text")
            {
            }
            column(MonthTxt; GLSetup."Month in Chinese Text")
            {
            }
            column(DateTxt; GLSetup."Date in Chinese Text")
            {
            }
            column(CurrDesc; CurrDesc)
            {
            }
            column(CurrDesc1; CurrDesc1)
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(Email; CompInfo."E-Mail")
            {
            }
            column(HomePage; CompInfo."Home Page")
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(VATPercentageCaption; VATPercentageCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(VATAmtCaption; VATAmtCaptionLbl)
            {
            }
            column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
            {
            }
            column(LineAmtCaption; LineAmtCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(UnitPriceCaption; UnitPriceCaptionLbl)
            {
            }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            {
            }
            column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(AllowInvDiscCaption; AllowInvDiscCaptionLbl)
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number);

                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = sorting(Number)where(Number=const(1));

                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(OrderConfirmCopyCaption; STRSUBSTNO(Text004, CopyText))
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    //column(CustAddr3; CustAddr[3])
                    //{
                    //}
                    column(CustAddr3; "Sales Header"."Sell-to Contact")
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    //column(CustAddr4; CustAddr[4])
                    //{
                    //}
                    column(CustAddr4; "Sales Header"."Sell-to Address")
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    //column(CustAddr5; CustAddr[5])
                    //{
                    //}
                    column(CustAddr5; "Sales Header"."Sell-to Address 2")
                    {
                    }
                    column(CompanyInfoPhNo; CompanyInfo."Phone No.")
                    {
                    IncludeCaption = false;
                    }
                    column(CompanyInfoFax; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfoName; CompanyInfo.Name)
                    {
                    }
                    column(BankAddress; CompanyInfo."Bank Address")
                    {
                    }
                    column(BankAddress2; CompanyInfo."Bank Address 2")
                    {
                    }
                    column(CompanySwift; CompanyInfo."SWIFT Code")
                    {
                    }
                    column(CompanyPhone; CompanyPhone)
                    {
                    }
                    column(CompanyFax; CompanyFax)
                    {
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyCHBankName; CompanyInfo."Ship-to Name")
                    {
                    }
                    column(CompanyCHBankAddr; CompanyInfo."Ship-to Address")
                    {
                    }
                    column(CompanyCHBankAddr2; CompanyInfo."Ship-to Address 2")
                    {
                    }
                    column(CompanyCHBankCity; CompanyInfo."Ship-to City")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(DocDate_SalesHeader; FORMAT(Date2DMY("Sales Header"."Document Date", 3)) + GLSetup."Year in Chinese Text" + FORMAT(Date2DMY("Sales Header"."Document Date", 2)) + GLSetup."Month in Chinese Text" + FORMAT(Date2DMY("Sales Header"."Document Date", 1)) + GLSetup."Date in Chinese Text")
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    {
                    }
                    column(ShptDate_SalesHeader; FORMAT("Sales Header"."Shipment Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText; "Sales Header".FIELDCAPTION("External Document No."))
                    {
                    }
                    column(SalesOrderReference_SalesHeader; "Sales Header"."External Document No.")
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(PricesInclVAT_SalesHeader; "Sales Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption; PageCaptionCap)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PmntTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(ShptMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PricesInclVATYesNo_SalesHeader; FORMAT("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankCaption; BankCaptionLbl)
                    {
                    }
                    column(AccountNoCaption; AccountNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(EmailCaption; EmailCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Bill-to Customer No."))
                    {
                    }
                    column(PricesInclVAT_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting(Number)where(Number=filter(1..));

                        column(DimText; DimText)
                        {
                        }
                        column(DimensionLoop1Number; Number)
                        {
                        }
                        column(HeaderDimCaption; HeaderDimCaptionLbl)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FIND('-')then CurrReport.BREAK();
                            end
                            else if not Continue then CurrReport.BREAK();
                            CLEAR(DimText);
                            Continue:=false;
                            repeat OldDimText:=DimText;
                                if DimText = '' then DimText:=STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText:=STRSUBSTNO('%1, %2 %3', DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if STRLEN(DimText) > MAXSTRLEN(OldDimText)then begin
                                    DimText:=OldDimText;
                                    Continue:=true;
                                    exit;
                                end;
                            until DimSetEntry1.NEXT() = 0;
                        end;
                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then CurrReport.BREAK();
                        end;
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type"=field("Document Type"), "Document No."=field("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                        trigger OnPreDataItem()
                        begin
                            CurrReport.BREAK();
                        end;
                    }
                    dataitem(RoundLoop; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(SalesLineAmt; SalesLine."Line Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(Desc_SalesLine; "Sales Line".Description)
                        {
                        }
                        column(NNCSalesLineLineAmt; NNCSalesLineLineAmt)
                        {
                        }
                        column(NNCSalesLineInvDiscAmt; NNCSalesLineInvDiscAmt)
                        {
                        }
                        column(NNCTotalLCY; NNCTotalLCY)
                        {
                        }
                        column(NNCTotalExclVAT; NNCTotalExclVAT)
                        {
                        }
                        column(NNCVATAmt; NNCVATAmt)
                        {
                        }
                        column(NNCTotalInclVAT; NNCTotalInclVAT)
                        {
                        }
                        column(NNCPmtDiscOnVAT; NNCPmtDiscOnVAT)
                        {
                        }
                        column(NNCTotalInclVAT2; NNCTotalInclVAT2)
                        {
                        }
                        column(NNCVATAmt2; NNCVATAmt2)
                        {
                        }
                        column(NNCTotalExclVAT2; NNCTotalExclVAT2)
                        {
                        }
                        column(VATBaseDisc_SalesHeader; "Sales Header"."VAT Base Discount %")
                        {
                        }
                        column(DisplayAssemblyInfo; DisplayAssemblyInformation)
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(No2_SalesLine; "Sales Line"."No.")
                        {
                        }
                        column(Qty_SalesLine; "Sales Line".Quantity)
                        {
                        }
                        column(StageNo; StageNo)
                        {
                        }
                        column(StageDesc; StageDesc)
                        {
                        }
                        column(CurrCode; SalesLine."Currency Code")
                        {
                        }
                        column(AmtDesc1; AmtDesc[1])
                        {
                        }
                        column(AmtDesc2; AmtDesc[2])
                        {
                        }
                        column(UOM_SalesLine; "Sales Line"."Unit of Measure")
                        {
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 2;
                        IncludeCaption = false;
                        }
                        column(LineDisc_SalesLine; "Sales Line"."Line Discount %")
                        {
                        }
                        column(LineAmt_SalesLine; "Sales Line"."Line Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        //column(CurrDesc; CurrDesc) { }
                        column(AllowInvDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        {
                        }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesLine; FORMAT("Sales Line".Type))
                        {
                        }
                        column(No_SalesLine; "Sales Line"."Line No.")
                        {
                        }
                        column(AllowInvDiscountYesNo_SalesLine; FORMAT("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                        {
                        }
                        column(SalesLineInvDiscAmt; SalesLine."Inv. Discount Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(SalsLinAmtExclLineDiscAmt; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(VATAmtLineVATAmtText3; VATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(VATAmount; VATAmount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(SalesLineAmtExclLineDisc; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount" + VATAmount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(VATDiscountAmount; VATDiscountAmount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(DiscountPercentCaption; DiscountPercentCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PaymentDiscountVATCaption; PaymentDiscountVATCaptionLbl)
                        {
                        }
                        column(Desc_SalesLineCaption; "Sales Line".FIELDCAPTION(Description))
                        {
                        }
                        column(No2_SalesLineCaption; "Sales Line".FIELDCAPTION("No."))
                        {
                        }
                        column(Qty_SalesLineCaption; "Sales Line".FIELDCAPTION(Quantity))
                        {
                        }
                        column(UOM_SalesLineCaption; "Sales Line".FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_SalesLineCaption; "Sales Line".FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = sorting(Number)where(Number=filter(1..));

                            column(DimText2; DimText)
                            {
                            }
                            column(LineDimCaption; LineDimCaptionLbl)
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FINDSET()then CurrReport.BREAK();
                                end
                                else if not Continue then CurrReport.BREAK();
                                CLEAR(DimText);
                                Continue:=false;
                                repeat OldDimText:=DimText;
                                    if DimText = '' then DimText:=STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText:=STRSUBSTNO('%1, %2 %3', DimText, DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if STRLEN(DimText) > MAXSTRLEN(OldDimText)then begin
                                        DimText:=OldDimText;
                                        Continue:=true;
                                        exit;
                                    end;
                                until DimSetEntry2.NEXT() = 0;
                            end;
                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then CurrReport.BREAK();
                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }
                        dataitem(AsmLoop; Integer)
                        {
                            DataItemTableView = sorting(Number);

                            column(AsmLineType; AsmLine.Type)
                            {
                            }
                            column(AsmLineNo; BlanksForIndent() + AsmLine."No.")
                            {
                            }
                            column(AsmLineDescription; BlanksForIndent() + AsmLine.Description)
                            {
                            }
                            column(AsmLineQuantity; AsmLine.Quantity)
                            {
                            }
                            column(AsmLineUOMText; GetUnitOfMeasureDescr(AsmLine."Unit of Measure Code"))
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then AsmLine.FINDSET()
                                else
                                    AsmLine.NEXT();
                            end;
                            trigger OnPreDataItem()
                            begin
                                if not DisplayAssemblyInformation then CurrReport.BREAK();
                                if not AsmInfoExistsForLine then CurrReport.BREAK();
                                AsmLine.SETRANGE("Document Type", AsmHeader."Document Type");
                                AsmLine.SETRANGE("Document No.", AsmHeader."No.");
                                SETRANGE(Number, 1, AsmLine.COUNT);
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then SalesLine.FIND('-')
                            else
                                SalesLine.NEXT();
                            "Sales Line":=SalesLine;
                            if DisplayAssemblyInformation then AsmInfoExistsForLine:=SalesLine.AsmToOrderExists(AsmHeader);
                            if not "Sales Header"."Prices Including VAT" and (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")then SalesLine."Line Amount":=0;
                            if(SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo)then "Sales Line"."No.":='';
                            NNCSalesLineLineAmt+=SalesLine."Line Amount";
                            NNCSalesLineInvDiscAmt+=SalesLine."Inv. Discount Amount";
                            NNCTotalLCY:=NNCSalesLineLineAmt - NNCSalesLineInvDiscAmt;
                            NNCTotalExclVAT:=NNCTotalLCY;
                            NNCVATAmt:=VATAmount;
                            NNCTotalInclVAT:=NNCTotalLCY - NNCVATAmt;
                            NNCPmtDiscOnVAT:=-VATDiscountAmount;
                            NNCTotalInclVAT2:=TotalAmountInclVAT;
                            NNCVATAmt2:=VATAmount;
                            NNCTotalExclVAT2:=VATBaseAmount;
                            //ContractName := '';
                            StageDesc:='';
                            StageNo:='';
                            JobPlanLineInv.Reset();
                            JobPlanLineInv.SetRange("Job No.", SalesLine."Job No.");
                            JobPlanLineInv.SetRange("Job Task No.", SalesLine."Job Task No.");
                            JobPlanLineInv.SetRange("Document Type", JobPlanLineInv."Document Type"::Invoice);
                            JobPlanLineInv.SetRange("Document No.", SalesLine."Document No.");
                            JobPlanLineInv.SetRange("Line No.", SalesLine."Line No.");
                            if JobPlanLineInv.FindFirst()then begin
                                JobPlanLine.Get(JobPlanLineInv."Job No.", JobPlanLineInv."Job Task No.", JobPlanLineInv."Job Planning Line No.");
                                //if ContractHdr.Get(JobPlanLine."Contract Code") then
                                //    ContractName := ContractHdr."Contract Name EN";
                                if ContractLine.Get(JobPlanLine."Contract Code", JobPlanLine."Stage Payment Code", JobPlanLine."Contract Line No.")then begin
                                    StageNo:=ContractLine."Project Stage";
                                    StageDesc:=ContractLine."Stage Details Description" end;
                            end;
                        //Message(ContractName);
                        //CurrDesc := '';
                        /* if CurrDesc = '' then begin
                                                               if "Sales Line"."Currency Code" <> '' then begin
                                                                   if CurrRec.get("Sales Line"."Currency Code") then
                                                                       if CurrRec.Description <> '' then
                                                                           CurrDesc := ' (' + CurrRec.Description + ')';
                                                               end
                                                               else begin
                                                                   if "Sales Header"."Currency Code" <> '' then begin
                                                                       if CurrRec.get("Sales Header"."Currency Code") then
                                                                           if CurrRec.Description <> '' then
                                                                               CurrDesc := ' (' + CurrRec.Description + ')';
                                                                   end;
                                                               end;
                                                           end;*/
                        end;
                        trigger OnPostDataItem()
                        begin
                            SalesLine.DELETEALL();
                        end;
                        trigger OnPreDataItem()
                        begin
                            MoreLines:=SalesLine.FIND('+');
                            while MoreLines and (SalesLine.Description = '') and (SalesLine."Description 2" = '') and (SalesLine."No." = '') and (SalesLine.Quantity = 0) and (SalesLine.Amount = 0)do MoreLines:=SalesLine.NEXT(-1) <> 0;
                            if not MoreLines then CurrReport.BREAK();
                            SalesLine.SETRANGE("Line No.", 0, SalesLine."Line No.");
                            SETRANGE(Number, 1, SalesLine.COUNT);
                        //CurrReport.CREATETOTALS(SalesLine."Line Amount", SalesLine."Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(VATAmountLineVATBase; VATAmountLine."VAT Base")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(VATAmtLineVATPercentage; VATAmountLine."VAT %")
                        {
                        DecimalPlaces = 0: 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(VATIdentifierCaption; VATIdentifierCaptionLbl)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;
                        trigger OnPreDataItem()
                        begin
                            if VATAmount = 0 then CurrReport.BREAK();
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                        //CurrReport.CREATETOTALS(VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount", VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                        AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                        AutoFormatType = 1;
                        }
                        column(VATAmtLineVATPercentage2; VATAmountLine."VAT %")
                        {
                        DecimalPlaces = 0: 5;
                        }
                        column(VATAmtLineVATIdentifier2; VATAmountLine."VAT Identifier")
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY:=VATAmountLine.GetBaseLCY("Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                            VALVATAmountLCY:=VATAmountLine.GetAmountLCY("Sales Header"."Posting Date", "Sales Header"."Currency Code", "Sales Header"."Currency Factor");
                        end;
                        trigger OnPreDataItem()
                        begin
                            if(not GLSetup."Print VAT specification in LCY") or ("Sales Header"."Currency Code" = '') or (VATAmountLine.GetTotalVATAmount() = 0)then CurrReport.BREAK();
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            //CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);
                            if GLSetup."LCY Code" = '' then VALSpecLCYHeader:=Text007 + Text008
                            else
                                VALSpecLCYHeader:=Text007 + FORMAT(GLSetup."LCY Code");
                            CurrExchRate.FindCurrency("Sales Header"."Posting Date", "Sales Header"."Currency Code", 1);
                            VALExchRate:=STRSUBSTNO(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = sorting(Number)where(Number=const(1));

                        column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShiptoAddrCaption; ShiptoAddrCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FIELDCAPTION("Sell-to Customer No."))
                        {
                        }
                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then CurrReport.BREAK();
                        end;
                    }
                    dataitem(PrepmtLoop; Integer)
                    {
                        DataItemTableView = sorting(Number)where(Number=filter(1..));

                        column(PrepmtLineAmount; PrepmtLineAmount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PrepmtInvBufDesc; PrepmtInvBuf.Description)
                        {
                        }
                        column(PrepmtInvBufGLAccNo; PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(TotalExclVATText2; TotalExclVATText)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmtTxt; PrepmtVATAmountLine.VATAmountText())
                        {
                        }
                        column(TotalInclVATText2; TotalInclVATText)
                        {
                        }
                        column(PrepmtInvAmount; PrepmtInvBuf.Amount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PrepmtVATAmount; PrepmtVATAmount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PrepmtInvAmtInclVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText2; VATAmountLine.VATAmountText())
                        {
                        }
                        column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PrepmtLoopNumber; Number)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(GLAccountNoCaption; GLAccountNoCaptionLbl)
                        {
                        }
                        column(PrepaymentSpecCaption; PrepaymentSpecCaptionLbl)
                        {
                        }
                        dataitem(PrepmtDimLoop; Integer)
                        {
                            DataItemTableView = sorting(Number)where(Number=filter(1..));

                            column(DimText3; DimText)
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not TempPrepmtDimSetEntry.FIND('-')then CurrReport.BREAK();
                                end
                                else if not Continue then CurrReport.BREAK();
                                CLEAR(DimText);
                                Continue:=false;
                                repeat OldDimText:=DimText;
                                    if DimText = '' then DimText:=STRSUBSTNO('%1 %2', TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code")
                                    else
                                        DimText:=STRSUBSTNO('%1, %2 %3', DimText, TempPrepmtDimSetEntry."Dimension Code", TempPrepmtDimSetEntry."Dimension Value Code");
                                    if STRLEN(DimText) > MAXSTRLEN(OldDimText)then begin
                                        DimText:=OldDimText;
                                        Continue:=true;
                                        exit;
                                    end;
                                until TempPrepmtDimSetEntry.NEXT() = 0;
                            end;
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not PrepmtInvBuf.FIND('-')then CurrReport.BREAK();
                            end
                            else if PrepmtInvBuf.NEXT() = 0 then CurrReport.BREAK();
                            if ShowInternalInfo then DimMgt.GetDimensionSet(TempPrepmtDimSetEntry, PrepmtInvBuf."Dimension Set ID");
                            if "Sales Header"."Prices Including VAT" then PrepmtLineAmount:=PrepmtInvBuf."Amount Incl. VAT"
                            else
                                PrepmtLineAmount:=PrepmtInvBuf.Amount;
                        end;
                        trigger OnPreDataItem()
                        begin
                        //CurrReport.CREATETOTALS(PrepmtInvBuf.Amount, PrepmtInvBuf."Amount Incl. VAT", PrepmtVATAmountLine."Line Amount", PrepmtVATAmountLine."VAT Base", PrepmtVATAmountLine."VAT Amount", PrepmtLineAmount);
                        end;
                    }
                    dataitem(PrepmtVATCounter; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(PrepmtVATAmtLineVATAmt; PrepmtVATAmountLine."VAT Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATBase; PrepmtVATAmountLine."VAT Base")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineLineAmt; PrepmtVATAmountLine."Line Amount")
                        {
                        AutoFormatExpression = "Sales Header"."Currency Code";
                        AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATPerc; PrepmtVATAmountLine."VAT %")
                        {
                        DecimalPlaces = 0: 5;
                        }
                        column(PrepmtVATAmtLineVATIdent; PrepmtVATAmountLine."VAT Identifier")
                        {
                        }
                        column(PrepmtVATCounterNumber; Number)
                        {
                        }
                        column(PrepaymentVATAmtSpecCap; PrepaymentVATAmtSpecCapLbl)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;
                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, PrepmtVATAmountLine.COUNT);
                        end;
                    }
                    dataitem(PrepmtTotal; Integer)
                    {
                        DataItemTableView = sorting(Number)where(Number=const(1));

                        column(PrepmtPmtTermsDesc; PrepmtPaymentTerms.Description)
                        {
                        }
                        column(PrepmtPmtTermsDescCaption; PrepmtPmtTermsDescCaptionLbl)
                        {
                        }
                        trigger OnPreDataItem()
                        begin
                            if not PrepmtInvBuf.FIND('-')then CurrReport.BREAK();
                        end;
                    }
                }
                trigger OnAfterGetRecord()
                var
                    PrepmtSalesLine: Record "Sales Line" temporary;
                    TempSalesLine: Record "Sales Line" temporary;
                    SalesPost: Codeunit "Sales-Post";
                begin
                    CLEAR(SalesLine);
                    CLEAR(SalesPost);
                    VATAmountLine.DELETEALL();
                    SalesLine.DELETEALL();
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount:=VATAmountLine.GetTotalVATAmount();
                    VATBaseAmount:=VATAmountLine.GetTotalVATBase();
                    VATDiscountAmount:=VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT:=VATAmountLine.GetTotalAmountInclVAT();
                    PrepmtInvBuf.DELETEALL();
                    SalesPostPrepmt.GetSalesLines("Sales Header", 0, PrepmtSalesLine);
                    if not PrepmtSalesLine.ISEMPTY then begin
                        SalesPostPrepmt.GetSalesLinesToDeduct("Sales Header", TempSalesLine);
                        if not TempSalesLine.ISEMPTY then SalesPostPrepmt.CalcVATAmountLines("Sales Header", TempSalesLine, PrepmtVATAmountLineDeduct, 1);
                    end;
                    SalesPostPrepmt.CalcVATAmountLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    PrepmtVATAmountLine.DeductVATAmountLine(PrepmtVATAmountLineDeduct);
                    SalesPostPrepmt.UpdateVATOnLines("Sales Header", PrepmtSalesLine, PrepmtVATAmountLine, 0);
                    SalesPostPrepmt.BuildInvLineBuffer("Sales Header", PrepmtSalesLine, 0, PrepmtInvBuf);
                    PrepmtVATAmount:=PrepmtVATAmountLine.GetTotalVATAmount();
                    PrepmtVATBaseAmount:=PrepmtVATAmountLine.GetTotalVATBase();
                    PrepmtTotalAmountInclVAT:=PrepmtVATAmountLine.GetTotalAmountInclVAT();
                    if Number > 1 then begin
                        CopyText:=FormatDocument.GetCOPYText();
                        OutputNo+=1;
                    end;
                    //CurrReport.PAGENO := 1;
                    NNCTotalLCY:=0;
                    NNCTotalExclVAT:=0;
                    NNCVATAmt:=0;
                    NNCTotalInclVAT:=0;
                    NNCPmtDiscOnVAT:=0;
                    NNCTotalInclVAT2:=0;
                    NNCVATAmt2:=0;
                    NNCTotalExclVAT2:=0;
                    NNCSalesLineLineAmt:=0;
                    NNCSalesLineInvDiscAmt:=0;
                    if "Sales Header"."Currency Code" <> '' then if CurrRec.get("Sales Header"."Currency Code")then if CurrRec.Description <> '' then begin
                                CurrDesc:=CurrRec.Description + ')';
                                CurrDesc1:='合共税后 ' + CurrRec.Description + ' ';
                            end;
                end;
                trigger OnPostDataItem()
                begin
                    if Print then CODEUNIT.RUN(CODEUNIT::"Sales-Printed", "Sales Header");
                end;
                trigger OnPreDataItem()
                begin
                    NoOfLoops:=ABS(NoOfCopies) + 1;
                    CopyText:='';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo:=1;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                CurrReport.LANGUAGE:=cuLanguage.GetLanguageID("Language Code"); //
                FormatAddressFields("Sales Header");
                FormatDocumentFields("Sales Header");
                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");
                JobNo:='';
                ContractName:='';
                TotalLineAmt:=0;
                SalesLine1.Reset();
                SalesLine1.SetRange("Document Type", "Document Type");
                SalesLine1.SetRange("Document No.", "No.");
                if SalesLine1.FindSet()then begin
                    if SalesLine1."Job No." <> '' then begin
                        JobNo:=SalesLine1."Job No.";
                        JobPlanLineInv.Reset();
                        JobPlanLineInv.SetRange("Job No.", SalesLine1."Job No.");
                        JobPlanLineInv.SetRange("Job Task No.", SalesLine1."Job Task No.");
                        JobPlanLineInv.SetRange("Document Type", JobPlanLineInv."Document Type"::Invoice);
                        JobPlanLineInv.SetRange("Document No.", SalesLine1."Document No.");
                        JobPlanLineInv.SetRange("Line No.", SalesLine1."Line No.");
                        if JobPlanLineInv.FindFirst()then begin
                            JobPlanLine.Get(JobPlanLineInv."Job No.", JobPlanLineInv."Job Task No.", JobPlanLineInv."Job Planning Line No.");
                            if ContractHdr.Get(JobPlanLine."Contract Code")then ContractName:=ContractHdr."Contract Name CN";
                        end;
                    end;
                    repeat TotalLineAmt+=SalesLine1."Line Amount";
                    until SalesLine1.Next() = 0;
                end;
                TotalLineAmt1:=Format(TotalLineAmt, 0, '<Integer Thousand><Decimals,3>') + ' 元正';
                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(AmtDesc, TotalLineAmt, "Sales Header"."Currency Code");
                TotalAmtDesc:=AmtDesc[1] + ' ' + AmtDesc[2] + ' ONLY';
                //Message(TotalAmtDesc);
                //Message(AmtDesc[1]);
                //Message(AmtDesc[2]);
                if Print then if CurrReport.USEREQUESTPAGE and ArchiveDocument or not CurrReport.USEREQUESTPAGE and SalesSetup."Archive Orders" then ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);
            end;
            trigger OnPostDataItem()
            begin
                OnAfterPostDataItem("Sales Header");
            end;
            trigger OnPreDataItem()
            begin
                Print:=Print or not IsReportInPreviewMode();
                AsmInfoExistsForLine:=false;
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
                    Caption = 'Options';

                    field(NoOfCopies_; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo_; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(ArchiveDocument_; ArchiveDocument)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Document';
                        ToolTip = 'Specifies if the document is archived after you print it.';

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then LogInteraction:=false;
                        end;
                    }
                    field(LogInteraction_; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';

                        trigger OnValidate()
                        begin
                            if LogInteraction then ArchiveDocument:=ArchiveDocumentEnable;
                        end;
                    }
                    field(ShowAssemblyComponents_; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnInit()
        begin
            LogInteractionEnable:=true;
            ArchiveDocument:=SalesSetup."Archive Orders";
        end;
        trigger OnOpenPage()
        begin
            InitLogInteraction();
            LogInteractionEnable:=LogInteraction;
        end;
    }
    labels
    {
    }
    trigger OnInitReport()
    begin
        GLSetup.GET();
        CompanyInfo.GET();
        SalesSetup.GET();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
        CompanyInfo3.Get();
        CompanyInfo3.CalcFields(Picture);
        OnAfterInitReport();
        CompanyPhone:='T ' + CompanyInfo."Phone No.";
        CompanyFax:='F ' + CompanyInfo."Fax No.";
    end;
    trigger OnPostReport()
    begin
        if LogInteraction and Print then if "Sales Header".FINDSET()then repeat "Sales Header".CALCFIELDS("No. of Archived Versions");
                    if "Sales Header"."Bill-to Contact No." <> '' then SegManagement.LogDocument("Sales Header"."Document Type"::Order.AsInteger(), "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence", "Sales Header"."No. of Archived Versions", DATABASE::Contact, "Sales Header"."Bill-to Contact No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", "Sales Header"."Opportunity No.")
                    else
                        SegManagement.LogDocument("Sales Header"."Document Type"::Order.AsInteger(), "Sales Header"."No.", "Sales Header"."Doc. No. Occurrence", "Sales Header"."No. of Archived Versions", DATABASE::Customer, "Sales Header"."Bill-to Customer No.", "Sales Header"."Salesperson Code", "Sales Header"."Campaign No.", "Sales Header"."Posting Description", "Sales Header"."Opportunity No.");
                until "Sales Header".NEXT() = 0;
    end;
    trigger OnPreReport()
    begin
        if not CurrReport.USEREQUESTPAGE then InitLogInteraction();
        CompInfo.get();
    end;
    var Text004: Label 'Order Confirmation %1', Comment = '%1 = Document No.';
    PageCaptionCap: Label 'Page %1 of %2';
    GLSetup: Record "General Ledger Setup";
    CurrDesc1: Text;
    TotalLineAmt1: Text;
    CompInfo: Record "Company Information";
    ShipmentMethod: Record "Shipment Method";
    PaymentTerms: Record "Payment Terms";
    PrepmtPaymentTerms: Record "Payment Terms";
    SalesPurchPerson: Record "Salesperson/Purchaser";
    CompanyInfo: Record "Company Information";
    CompanyInfo1: Record "Company Information";
    CompanyInfo2: Record "Company Information";
    CompanyInfo3: Record "Company Information";
    SalesSetup: Record "Sales & Receivables Setup";
    VATAmountLine: Record "VAT Amount Line" temporary;
    PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
    PrepmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
    SalesLine: Record "Sales Line" temporary;
    ContractName: Text;
    StageNo: Code[10];
    StageDesc: Text;
    DimSetEntry1: Record "Dimension Set Entry";
    DimSetEntry2: Record "Dimension Set Entry";
    TempPrepmtDimSetEntry: Record "Dimension Set Entry" temporary;
    PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
    RespCenter: Record "Responsibility Center";
    //Language: Record Language;
    cuLanguage: Codeunit Language;
    JobPlanLine: Record "Job Planning Line";
    CurrExchRate: Record "Currency Exchange Rate";
    AsmHeader: Record "Assembly Header";
    CheckReport: Report Check;
    AsmLine: Record "Assembly Line";
    FormatAddr: Codeunit "Format Address";
    SegManagement: Codeunit SegManagement;
    ArchiveManagement: Codeunit ArchiveManagement;
    FormatDocument: Codeunit "Format Document";
    SalesPostPrepmt: Codeunit "Sales-Post Prepayments";
    DimMgt: Codeunit DimensionManagement;
    CustAddr: array[8]of Text[50];
    ShipToAddr: array[8]of Text[50];
    CompanyAddr: array[8]of Text[50];
    SalesPersonText: Text[30];
    VATNoText: Text[80];
    TotalText: Text[50];
    JobNo: Code[20];
    ContractHdr: Record "Contract Card Header";
    ContractLine: Record "Contract Card Line";
    TotalExclVATText: Text[50];
    TotalInclVATText: Text[50];
    MoreLines: Boolean;
    NoOfCopies: Integer;
    NoOfLoops: Integer;
    CopyText: Text[30];
    ShowShippingAddr: Boolean;
    DimText: Text[120];
    OldDimText: Text[75];
    ShowInternalInfo: Boolean;
    SalesLine1: Record "Sales Line";
    Continue: Boolean;
    ArchiveDocument: Boolean;
    LogInteraction: Boolean;
    VATAmount: Decimal;
    VATBaseAmount: Decimal;
    VATDiscountAmount: Decimal;
    TotalAmountInclVAT: Decimal;
    VALVATBaseLCY: Decimal;
    VALVATAmountLCY: Decimal;
    VALSpecLCYHeader: Text[80];
    Text007: Label 'VAT Amount Specification in ';
    Text008: Label 'Local Currency';
    Text009: Label 'Exchange rate: %1/%2';
    VALExchRate: Text[50];
    PrepmtVATAmount: Decimal;
    CompanyPhone: Text;
    CompanyFax: Text;
    PrepmtVATBaseAmount: Decimal;
    PrepmtTotalAmountInclVAT: Decimal;
    PrepmtLineAmount: Decimal;
    OutputNo: Integer;
    NNCTotalLCY: Decimal;
    NNCTotalExclVAT: Decimal;
    NNCVATAmt: Decimal;
    NNCTotalInclVAT: Decimal;
    NNCPmtDiscOnVAT: Decimal;
    NNCTotalInclVAT2: Decimal;
    NNCVATAmt2: Decimal;
    NNCTotalExclVAT2: Decimal;
    NNCSalesLineLineAmt: Decimal;
    NNCSalesLineInvDiscAmt: Decimal;
    JobPlanLineInv: Record "Job Planning Line Invoice";
    Print: Boolean;
    ArchiveDocumentEnable: Boolean;
    LogInteractionEnable: Boolean;
    DisplayAssemblyInformation: Boolean;
    AsmInfoExistsForLine: Boolean;
    TotalLineAmt: Decimal;
    AmtDesc: array[2]of Text[80];
    TotalAmtDesc: Text;
    InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
    VATRegNoCaptionLbl: Label 'VAT Registration No.';
    GiroNoCaptionLbl: Label 'Giro No.';
    BankCaptionLbl: Label 'Bank';
    AccountNoCaptionLbl: Label 'Account No.';
    ShipmentDateCaptionLbl: Label 'Shipment Date';
    OrderNoCaptionLbl: Label 'Order No.';
    HomePageCaptionLbl: Label 'Home Page';
    EmailCaptionLbl: Label 'Email';
    HeaderDimCaptionLbl: Label 'Header Dimensions';
    DiscountPercentCaptionLbl: Label 'Discount %';
    SubtotalCaptionLbl: Label 'Subtotal';
    PaymentDiscountVATCaptionLbl: Label 'Payment Discount on VAT';
    LineDimCaptionLbl: Label 'Line Dimensions';
    InvDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
    VATIdentifierCaptionLbl: Label 'VAT Identifier';
    ShiptoAddrCaptionLbl: Label 'Ship-to Address';
    DescriptionCaptionLbl: Label 'Description';
    GLAccountNoCaptionLbl: Label 'G/L Account No.';
    PrepaymentSpecCaptionLbl: Label 'Prepayment Specification';
    PrepaymentVATAmtSpecCapLbl: Label 'Prepayment VAT Amount Specification';
    PrepmtPmtTermsDescCaptionLbl: Label 'Prepmt. Payment Terms';
    PhoneNoCaptionLbl: Label 'Phone No.';
    AmountCaptionLbl: Label 'Amount';
    VATPercentageCaptionLbl: Label 'VAT %';
    VATBaseCaptionLbl: Label 'VAT Base';
    VATAmtCaptionLbl: Label 'VAT Amount';
    VATAmtSpecCaptionLbl: Label 'VAT Amount Specification';
    LineAmtCaptionLbl: Label 'Line Amount';
    TotalCaptionLbl: Label 'Total';
    UnitPriceCaptionLbl: Label 'Unit Price';
    PaymentTermsCaptionLbl: Label 'Payment Terms';
    ShipmentMethodCaptionLbl: Label 'Shipment Method';
    DocumentDateCaptionLbl: Label 'Document Date';
    AllowInvDiscCaptionLbl: Label 'Allow Invoice Discount';
    CurrDesc: Text;
    CurrRec: Record Currency;
    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies:=NoOfCopiesFrom;
        ShowInternalInfo:=ShowInternalInfoFrom;
        ArchiveDocument:=ArchiveDocumentFrom;
        LogInteraction:=LogInteractionFrom;
        Print:=PrintFrom;
        DisplayAssemblyInformation:=DisplayAsmInfo;
    end;
    local procedure IsReportInPreviewMode(): Boolean var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.PREVIEW or MailManagement.IsHandlingGetEmailBody());
    end;
    local procedure InitLogInteraction()
    begin
        // LogInteraction:=SegManagement.FindInteractTmplCode(3) <> '';
        LogInteraction:=SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Inv.") <> '';
    end;
    local procedure FormatAddressFields(var SalesHeader: Record "Sales Header")
    begin
        FormatAddr.GetCompanyAddr(SalesHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.SalesHeaderBillTo(CustAddr, SalesHeader);
        ShowShippingAddr:=FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, SalesHeader);
    end;
    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        //WITH SalesHeader DO BEGIN
        FormatDocument.SetTotalLabels(SalesHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalesPurchPerson, SalesHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesHeader."Payment Terms Code", SalesHeader."Language Code");
        FormatDocument.SetPaymentTerms(PrepmtPaymentTerms, SalesHeader."Prepmt. Payment Terms Code", SalesHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesHeader."Shipment Method Code", SalesHeader."Language Code");
        VATNoText:=FormatDocument.SetText(SalesHeader."VAT Registration No." <> '', SalesHeader.FIELDCAPTION("VAT Registration No."));
    //END;
    end;
    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.GET(UOMCode)then exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;
    procedure BlanksForIndent(): Text[10]begin
        exit(PADSTR('', 2, ' '));
    end;
    local procedure OnAfterInitReport()
    begin
    end;
    local procedure OnAfterPostDataItem(var SalesHeader: Record "Sales Header")
    begin
    end;
}
