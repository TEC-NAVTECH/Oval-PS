report 50102 "General Journal - Test1"
{
    // version NAVW113.05
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/General Journal - Test.rdl';
    Caption = 'General Journal - Test';
    PreviewMode = PrintLayout;
    UsageCategory = None; //

    dataset
    {
        dataitem("Gen. Journal Batch"; "Gen. Journal Batch")
        {
            DataItemTableView = sorting("Journal Template Name", Name);

            column(JnlTmplName_GenJnlBatch; "Journal Template Name")
            {
            }
            column(Name_GenJnlBatch; Name)
            {
            }
            column(CompanyName; COMPANYPROPERTY.DISPLAYNAME())
            {
            }
            column(GeneralJnlTestCaption; GeneralJnlTestCap)
            {
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = sorting(Number)where(Number=const(1));
                PrintOnlyIfDetail = true;

                column(JnlTemplateName_GenJnlBatch; "Gen. Journal Batch"."Journal Template Name")
                {
                }
                column(JnlName_GenJnlBatch; "Gen. Journal Batch".Name)
                {
                }
                column(GenJnlLineFilter; GenJnlLineFilter)
                {
                }
                column(GenJnlLineFilterTableCaption; "Gen. Journal Line".TABLECAPTION + ': ' + GenJnlLineFilter)
                {
                }
                column(Number_Integer; Number)
                {
                }
                column(PageNoCaption; PageNoCap)
                {
                }
                column(JnlTmplNameCaption_GenJnlBatch; "Gen. Journal Batch".FIELDCAPTION("Journal Template Name"))
                {
                }
                column(JournalBatchCaption; JnlBatchNameCap)
                {
                }
                column(PostingDateCaption; PostingDateCap)
                {
                }
                column(DocumentTypeCaption; DocumentTypeCap)
                {
                }
                column(DocNoCaption_GenJnlLine; "Gen. Journal Line".FIELDCAPTION("Document No."))
                {
                }
                column(AccountTypeCaption; AccountTypeCap)
                {
                }
                column(AccNoCaption_GenJnlLine; "Gen. Journal Line".FIELDCAPTION("Account No."))
                {
                }
                column(AccNameCaption; AccNameCap)
                {
                }
                column(DescCaption_GenJnlLine; "Gen. Journal Line".FIELDCAPTION(Description))
                {
                }
                column(PostingTypeCaption; GenPostingTypeCap)
                {
                }
                column(GenBusPostGroupCaption; GenBusPostingGroupCap)
                {
                }
                column(GenProdPostGroupCaption; GenProdPostingGroupCap)
                {
                }
                column(AmountCaption_GenJnlLine; "Gen. Journal Line".FIELDCAPTION(Amount))
                {
                }
                column(BalAccNoCaption_GenJnlLine; "Gen. Journal Line".FIELDCAPTION("Bal. Account No."))
                {
                }
                column(BalLCYCaption_GenJnlLine; "Gen. Journal Line".FIELDCAPTION("Balance (LCY)"))
                {
                }
                dataitem("Gen. Journal Line"; "Gen. Journal Line")
                {
                    DataItemLink = "Journal Template Name"=field("Journal Template Name"), "Journal Batch Name"=field(Name);
                    DataItemLinkReference = "Gen. Journal Batch";
                    DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
                    RequestFilterFields = "Posting Date";

                    column(PostingDate_GenJnlLine; FORMAT("Posting Date"))
                    {
                    }
                    column(DocType_GenJnlLine; "Document Type")
                    {
                    }
                    column(DocNo_GenJnlLine; "Document No.")
                    {
                    }
                    column(ExtDocNo_GenJnlLine; "External Document No.")
                    {
                    }
                    column(AccountType_GenJnlLine; "Account Type")
                    {
                    }
                    column(AccountNo_GenJnlLine; "Account No.")
                    {
                    }
                    column(AccName; AccName)
                    {
                    }
                    column(Description_GenJnlLine; Description)
                    {
                    }
                    column(GenPostType_GenJnlLine; "Gen. Posting Type")
                    {
                    }
                    column(GenBusPosGroup_GenJnlLine; "Gen. Bus. Posting Group")
                    {
                    }
                    column(GenProdPostGroup_GenJnlLine; "Gen. Prod. Posting Group")
                    {
                    }
                    column(Amount_GenJnlLine; Amount)
                    {
                    }
                    column(CurrencyCode_GenJnlLine; "Currency Code")
                    {
                    }
                    column(BalAccNo_GenJnlLine; "Bal. Account No.")
                    {
                    }
                    column(BalanceLCY_GenJnlLine; "Balance (LCY)")
                    {
                    }
                    column(AmountLCY; AmountLCY)
                    {
                    }
                    column(BalanceLCY; BalanceLCY)
                    {
                    }
                    column(AmountLCY_GenJnlLine; "Amount (LCY)")
                    {
                    }
                    column(JnlTmplName_GenJnlLine; "Journal Template Name")
                    {
                    }
                    column(JnlBatchName_GenJnlLine; "Journal Batch Name")
                    {
                    }
                    column(LineNo_GenJnlLine; "Line No.")
                    {
                    }
                    column(TotalLCYCaption; AmountLCYCap)
                    {
                    }
                    dataitem(DimensionLoop; Integer)
                    {
                        DataItemTableView = sorting(Number)where(Number=filter(1..));

                        column(DimText; DimText)
                        {
                        }
                        column(Number_DimensionLoop; Number)
                        {
                        }
                        column(DimensionsCaption; DimensionsCap)
                        {
                        }
                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry.FINDSET()then CurrReport.BREAK();
                            end
                            else if not Continue then CurrReport.BREAK();
                            DimText:=GetDimensionText(DimSetEntry);
                        end;
                        trigger OnPreDataItem()
                        begin
                            if not ShowDim then CurrReport.BREAK();
                            DimSetEntry.RESET();
                            DimSetEntry.SETRANGE("Dimension Set ID", "Gen. Journal Line"."Dimension Set ID")end;
                    }
                    dataitem("Gen. Jnl. Allocation"; "Gen. Jnl. Allocation")
                    {
                        DataItemLink = "Journal Template Name"=field("Journal Template Name"), "Journal Batch Name"=field("Journal Batch Name"), "Journal Line No."=field("Line No.");
                        DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Journal Line No.", "Line No.");

                        column(AccountNo_GenJnlAllocation; "Account No.")
                        {
                        }
                        column(AccountName_GenJnlAllocation; "Account Name")
                        {
                        }
                        column(AllocationQuantity_GenJnlAllocation; "Allocation Quantity")
                        {
                        }
                        column(AllocationPct_GenJnlAllocation; "Allocation %")
                        {
                        }
                        column(Amount_GenJnlAllocation; Amount)
                        {
                        }
                        column(JournalLineNo_GenJnlAllocation; "Journal Line No.")
                        {
                        }
                        column(LineNo_GenJnlAllocation; "Line No.")
                        {
                        }
                        column(JournalBatchName_GenJnlAllocation; "Journal Batch Name")
                        {
                        }
                        column(AccountNoCaption_GenJnlAllocation; FIELDCAPTION("Account No."))
                        {
                        }
                        column(AccountNameCaption_GenJnlAllocation; FIELDCAPTION("Account Name"))
                        {
                        }
                        column(AllocationQuantityCaption_GenJnlAllocation; FIELDCAPTION("Allocation Quantity"))
                        {
                        }
                        column(AllocationPctCaption_GenJnlAllocation; FIELDCAPTION("Allocation %"))
                        {
                        }
                        column(AmountCaption_GenJnlAllocation; FIELDCAPTION(Amount))
                        {
                        }
                        column(Recurring_GenJnlTemplate; GenJnlTemplate.Recurring)
                        {
                        }
                        dataitem(DimensionLoopAllocations; Integer)
                        {
                            DataItemTableView = sorting(Number)where(Number=filter(1..));

                            column(AllocationDimText; AllocationDimText)
                            {
                            }
                            column(Number_DimensionLoopAllocations; Number)
                            {
                            }
                            column(DimensionAllocationsCaption; DimensionAllocationsCap)
                            {
                            }
                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry.FINDFIRST()then CurrReport.BREAK();
                                end
                                else if not Continue then CurrReport.BREAK();
                                AllocationDimText:=GetDimensionText(DimSetEntry);
                            end;
                            trigger OnPreDataItem()
                            begin
                                if not ShowDim then CurrReport.BREAK();
                                DimSetEntry.RESET();
                                DimSetEntry.SETRANGE("Dimension Set ID", "Gen. Jnl. Allocation"."Dimension Set ID")end;
                        }
                    }
                    dataitem(ErrorLoop; Integer)
                    {
                        DataItemTableView = sorting(Number);

                        column(ErrorTextNumber; ErrorText[Number])
                        {
                        }
                        column(WarningCaption; WarningCap)
                        {
                        }
                        trigger OnPostDataItem()
                        begin
                            ErrorCounter:=0;
                        end;
                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, ErrorCounter);
                        end;
                    }
                    trigger OnAfterGetRecord()
                    var
                        PaymentTerms: Record "Payment Terms";
                        DimMgt: Codeunit DimensionManagement;
                        UserSetupManagement: Codeunit "User Setup Management";
                        TableID: array[10]of Integer;
                        No: array[10]of Code[20];
                    begin
                        if "Currency Code" = '' then "Amount (LCY)":=Amount;
                        UpdateLineBalance();
                        AccName:='';
                        BalAccName:='';
                        if not EmptyLine()then begin
                            MakeRecurringTexts("Gen. Journal Line");
                            AmountError:=false;
                            if("Account No." = '') and ("Bal. Account No." = '')then AddError(STRSUBSTNO(Text001, FIELDCAPTION("Account No."), FIELDCAPTION("Bal. Account No.")))
                            else if("Account Type" <> "Account Type"::"Fixed Asset") and ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")then TestFixedAssetFields("Gen. Journal Line");
                            CheckICDocument();
                            if "Account No." <> '' then case "Account Type" of "Account Type"::"G/L Account": begin
                                    if("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')then if "Gen. Posting Type" = "Gen. Posting Type"::" " then AddError(STRSUBSTNO(Text002, FIELDCAPTION("Gen. Posting Type")));
                                    if("Gen. Posting Type" <> "Gen. Posting Type"::" ") and ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")then begin
                                        if "VAT Amount" + "VAT Base Amount" <> Amount then AddError(STRSUBSTNO(Text003, FIELDCAPTION("VAT Amount"), FIELDCAPTION("VAT Base Amount"), FIELDCAPTION(Amount)));
                                        if "Currency Code" <> '' then if "VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)" then AddError(STRSUBSTNO(Text003, FIELDCAPTION("VAT Amount (LCY)"), FIELDCAPTION("VAT Base Amount (LCY)"), FIELDCAPTION("Amount (LCY)")));
                                    end;
                                    TestJobFields("Gen. Journal Line");
                                end;
                                "Account Type"::Customer, "Account Type"::Vendor: begin
                                    if "Gen. Posting Type" <> "Gen. Posting Type"::" " then AddError(STRSUBSTNO(Text004, FIELDCAPTION("Gen. Posting Type"), FIELDCAPTION("Account Type"), "Account Type"));
                                    if("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')then AddError(STRSUBSTNO(Text005, FIELDCAPTION("Gen. Bus. Posting Group"), FIELDCAPTION("Gen. Prod. Posting Group"), FIELDCAPTION("VAT Bus. Posting Group"), FIELDCAPTION("VAT Prod. Posting Group"), FIELDCAPTION("Account Type"), "Account Type"));
                                    if "Document Type" <> "Document Type"::" " then if "Account Type" = "Account Type"::Customer then case "Document Type" of "Document Type"::"Credit Memo": WarningIfPositiveAmt("Gen. Journal Line");
                                            "Document Type"::Payment: if("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") and ("Applies-to Doc. No." <> '')then WarningIfNegativeAmt("Gen. Journal Line")
                                                else
                                                    WarningIfPositiveAmt("Gen. Journal Line");
                                            "Document Type"::Refund: WarningIfNegativeAmt("Gen. Journal Line");
                                            else
                                                WarningIfNegativeAmt("Gen. Journal Line");
                                            end
                                        else
                                            case "Document Type" of "Document Type"::"Credit Memo": WarningIfNegativeAmt("Gen. Journal Line");
                                            "Document Type"::Payment: if("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") and ("Applies-to Doc. No." <> '')then WarningIfPositiveAmt("Gen. Journal Line")
                                                else
                                                    WarningIfNegativeAmt("Gen. Journal Line");
                                            "Document Type"::Refund: WarningIfPositiveAmt("Gen. Journal Line");
                                            else
                                                WarningIfPositiveAmt("Gen. Journal Line");
                                            end;
                                    if Amount * "Sales/Purch. (LCY)" < 0 then AddError(STRSUBSTNO(Text008, FIELDCAPTION("Sales/Purch. (LCY)"), FIELDCAPTION(Amount)));
                                    if "Job No." <> '' then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Job No.")));
                                end;
                                "Account Type"::"Bank Account": begin
                                    if("Gen. Posting Type" <> "Gen. Posting Type"::" ")then AddError(STRSUBSTNO(Text004, FIELDCAPTION("Gen. Posting Type"), FIELDCAPTION("Account Type"), "Account Type"));
                                    if("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')then AddError(STRSUBSTNO(Text005, FIELDCAPTION("Gen. Bus. Posting Group"), FIELDCAPTION("Gen. Prod. Posting Group"), FIELDCAPTION("VAT Bus. Posting Group"), FIELDCAPTION("VAT Prod. Posting Group"), FIELDCAPTION("Account Type"), "Account Type"));
                                    if "Job No." <> '' then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Job No.")));
                                    if(Amount < 0) and ("Bank Payment Type" = "Bank Payment Type"::"Computer Check")then if not "Check Printed" then AddError(STRSUBSTNO(Text010, FIELDCAPTION("Check Printed")));
                                end;
                                "Account Type"::"Fixed Asset": TestFixedAsset("Gen. Journal Line");
                                end;
                            if "Bal. Account No." <> '' then case "Bal. Account Type" of "Bal. Account Type"::"G/L Account": begin
                                    if("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') or ("Bal. VAT Bus. Posting Group" <> '') or ("Bal. VAT Prod. Posting Group" <> '')then if("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::" ")then AddError(STRSUBSTNO(Text002, FIELDCAPTION("Bal. Gen. Posting Type")));
                                    if("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ") and ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")then begin
                                        if "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount then AddError(STRSUBSTNO(Text011, FIELDCAPTION("Bal. VAT Amount"), FIELDCAPTION("Bal. VAT Base Amount"), FIELDCAPTION(Amount)));
                                        if "Currency Code" <> '' then if "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" then AddError(STRSUBSTNO(Text011, FIELDCAPTION("Bal. VAT Amount (LCY)"), FIELDCAPTION("Bal. VAT Base Amount (LCY)"), FIELDCAPTION("Amount (LCY)")));
                                    end;
                                end;
                                "Bal. Account Type"::Customer, "Bal. Account Type"::Vendor: begin
                                    if("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ")then AddError(STRSUBSTNO(Text004, FIELDCAPTION("Bal. Gen. Posting Type"), FIELDCAPTION("Bal. Account Type"), "Bal. Account Type"));
                                    if("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') or ("Bal. VAT Bus. Posting Group" <> '') or ("Bal. VAT Prod. Posting Group" <> '')then AddError(STRSUBSTNO(Text005, FIELDCAPTION("Bal. Gen. Bus. Posting Group"), FIELDCAPTION("Bal. Gen. Prod. Posting Group"), FIELDCAPTION("Bal. VAT Bus. Posting Group"), FIELDCAPTION("Bal. VAT Prod. Posting Group"), FIELDCAPTION("Bal. Account Type"), "Bal. Account Type"));
                                    if "Document Type" <> "Document Type"::" " then if("Bal. Account Type" = "Bal. Account Type"::Customer) = ("Document Type" in["Document Type"::Payment, "Document Type"::"Credit Memo"])then WarningIfNegativeAmt("Gen. Journal Line")
                                        else
                                            WarningIfPositiveAmt("Gen. Journal Line");
                                    if Amount * "Sales/Purch. (LCY)" > 0 then AddError(STRSUBSTNO(Text012, FIELDCAPTION("Sales/Purch. (LCY)"), FIELDCAPTION(Amount)));
                                    if "Job No." <> '' then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Job No.")));
                                end;
                                "Bal. Account Type"::"Bank Account": begin
                                    if("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ")then AddError(STRSUBSTNO(Text004, FIELDCAPTION("Bal. Gen. Posting Type"), FIELDCAPTION("Bal. Account Type"), "Bal. Account Type"));
                                    if("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') or ("Bal. VAT Bus. Posting Group" <> '') or ("Bal. VAT Prod. Posting Group" <> '')then AddError(STRSUBSTNO(Text005, FIELDCAPTION("Bal. Gen. Bus. Posting Group"), FIELDCAPTION("Bal. Gen. Prod. Posting Group"), FIELDCAPTION("Bal. VAT Bus. Posting Group"), FIELDCAPTION("Bal. VAT Prod. Posting Group"), FIELDCAPTION("Bal. Account Type"), "Bal. Account Type"));
                                    if "Job No." <> '' then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Job No.")));
                                    if(Amount > 0) and ("Bank Payment Type" = "Bank Payment Type"::"Computer Check")then if not "Check Printed" then AddError(STRSUBSTNO(Text010, FIELDCAPTION("Check Printed")));
                                end;
                                "Bal. Account Type"::"Fixed Asset": TestFixedAsset("Gen. Journal Line");
                                end;
                            if("Account No." <> '') and not "System-Created Entry" and (Amount = 0) and not GenJnlTemplate.Recurring and not "Allow Zero-Amount Posting" and ("Account Type" <> "Account Type"::"Fixed Asset")then WarningIfZeroAmt("Gen. Journal Line");
                            CheckRecurringLine("Gen. Journal Line");
                            CheckAllocations("Gen. Journal Line");
                            if "Posting Date" = 0D then AddError(STRSUBSTNO(Text002, FIELDCAPTION("Posting Date")))
                            else
                            begin
                                if "Posting Date" <> NORMALDATE("Posting Date")then if("Account Type" <> "Account Type"::"G/L Account") or ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")then AddError(STRSUBSTNO(Text013, FIELDCAPTION("Posting Date")));
                                if not UserSetupManagement.TestAllowedPostingDate("Posting Date", TempErrorText)then AddError(TempErrorText);
                                if "Gen. Journal Batch"."No. Series" <> '' then begin
                                    if NoSeries."Date Order" and ("Posting Date" < LastEntrdDate)then AddError(Text015);
                                    LastEntrdDate:="Posting Date";
                                end;
                            end;
                            if "Document Date" <> 0D then if("Document Date" <> NORMALDATE("Document Date")) and (("Account Type" <> "Account Type"::"G/L Account") or ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account"))then AddError(STRSUBSTNO(Text013, FIELDCAPTION("Document Date")));
                            if "Document No." = '' then AddError(STRSUBSTNO(Text002, FIELDCAPTION("Document No.")))
                            else if "Gen. Journal Batch"."No. Series" <> '' then if IsGapInNosForDocNo("Gen. Journal Line")then AddError(Text016);
                            if("Account Type" in["Account Type"::Customer, "Account Type"::Vendor, "Account Type"::"Fixed Asset"]) and ("Bal. Account Type" in["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor, "Bal. Account Type"::"Fixed Asset"])then AddError(STRSUBSTNO(Text017, FIELDCAPTION("Account Type"), FIELDCAPTION("Bal. Account Type")));
                            if Amount * "Amount (LCY)" < 0 then AddError(STRSUBSTNO(Text008, FIELDCAPTION("Amount (LCY)"), FIELDCAPTION(Amount)));
                            if("Account Type" = "Account Type"::"G/L Account") and ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")then if "Applies-to Doc. No." <> '' then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Applies-to Doc. No.")));
                            if(("Account Type" = "Account Type"::"G/L Account") and ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) or ("Document Type" <> "Document Type"::Invoice)then if PaymentTerms.GET("Payment Terms Code")then begin
                                    if("Document Type" = "Document Type"::"Credit Memo") and (not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")then begin
                                        if "Pmt. Discount Date" <> 0D then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Pmt. Discount Date")));
                                        if "Payment Discount %" <> 0 then AddError(STRSUBSTNO(Text018, FIELDCAPTION("Payment Discount %")));
                                    end;
                                end
                                else
                                begin
                                    if "Pmt. Discount Date" <> 0D then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Pmt. Discount Date")));
                                    if "Payment Discount %" <> 0 then AddError(STRSUBSTNO(Text018, FIELDCAPTION("Payment Discount %")));
                                end;
                            if(("Account Type" = "Account Type"::"G/L Account") and ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) or ("Applies-to Doc. No." <> '')then if "Applies-to ID" <> '' then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Applies-to ID")));
                            if("Account Type" <> "Account Type"::"Bank Account") and ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")then if GenJnlLine2."Bank Payment Type" <> GenJnlLine2."Bank Payment Type"::" " then AddError(STRSUBSTNO(Text009, FIELDCAPTION("Bank Payment Type")));
                            if("Account No." <> '') and ("Bal. Account No." <> '')then begin
                                PurchPostingType:=false;
                                SalesPostingType:=false;
                            end;
                            if "Account No." <> '' then CheckAccountTypes("Account Type", AccName);
                            if "Bal. Account No." <> '' then begin
                                CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", "Gen. Journal Line");
                                CheckAccountTypes("Account Type", BalAccName);
                                CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", "Gen. Journal Line");
                            end;
                            if not DimMgt.CheckDimIDComb("Dimension Set ID")then AddError(DimMgt.GetDimCombErr());
                            TableID[1]:=DimMgt.TypeToTableID1("Account Type".AsInteger());
                            No[1]:="Account No.";
                            TableID[2]:=DimMgt.TypeToTableID1("Bal. Account Type".AsInteger());
                            No[2]:="Bal. Account No.";
                            TableID[3]:=DATABASE::Job;
                            No[3]:="Job No.";
                            TableID[4]:=DATABASE::"Salesperson/Purchaser";
                            No[4]:="Salespers./Purch. Code";
                            TableID[5]:=DATABASE::Campaign;
                            No[5]:="Campaign No.";
                            if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID")then AddError(DimMgt.GetDimValuePostingErr());
                        end;
                        CheckBalance();
                        AmountLCY+="Amount (LCY)";
                        BalanceLCY+="Balance (LCY)";
                    end;
                    trigger OnPreDataItem()
                    begin
                        // If simple view is used then order gen. journal lines by doc no. and line no.
                        if GenJnlManagement.GetJournalSimplePageModePreference(PAGE::"General Journal")then SETCURRENTKEY("Document No.", "Line No.");
                        COPYFILTER("Journal Batch Name", "Gen. Journal Batch".Name);
                        GenJnlLineFilter:=GETFILTERS;
                        GenJnlTemplate.GET("Gen. Journal Batch"."Journal Template Name");
                        if GenJnlTemplate.Recurring then begin
                            if GETFILTER("Posting Date") <> '' then AddError(STRSUBSTNO(Text000, FIELDCAPTION("Posting Date")));
                            SETRANGE("Posting Date", 0D, WORKDATE());
                            if GETFILTER("Expiration Date") <> '' then AddError(STRSUBSTNO(Text000, FIELDCAPTION("Expiration Date")));
                            SETFILTER("Expiration Date", '%1 | %2..', 0D, WORKDATE());
                        end;
                        LastEnteredDocNo:='';
                        if "Gen. Journal Batch"."No. Series" <> '' then begin
                            NoSeries.GET("Gen. Journal Batch"."No. Series");
                            LastEnteredDocNo:=GetLastEnteredDocumentNo("Gen. Journal Line");
                            LastEntrdDate:=0D;
                        end;
                        TempGenJournalLineCustVendIC.RESET();
                        TempGenJournalLineCustVendIC.DELETEALL();
                        VATEntryCreated:=false;
                        GenJnlLine2.RESET();
                        GenJnlLine2.COPYFILTERS("Gen. Journal Line");
                        GLAccNetChange.DELETEALL();
                    //CurrReport.CREATETOTALS("Amount (LCY)", "Balance (LCY)");
                    end;
                }
                dataitem(ReconcileLoop; Integer)
                {
                    DataItemTableView = sorting(Number);

                    column(GLAccNetChangeNo; GLAccNetChange."No.")
                    {
                    }
                    column(GLAccNetChangeName; GLAccNetChange.Name)
                    {
                    }
                    column(GLAccNetChangeNetChangeJnl; GLAccNetChange."Net Change in Jnl.")
                    {
                    }
                    column(GLAccNetChangeBalafterPost; GLAccNetChange."Balance after Posting")
                    {
                    }
                    column(ReconciliationCaption; ReconciliationCap)
                    {
                    }
                    column(NoCaption; NoCap)
                    {
                    }
                    column(NameCaption; NameCap)
                    {
                    }
                    column(NetChangeinJnlCaption; NetChangeinJnlCap)
                    {
                    }
                    column(BalafterPostingCaption; BalafterPostingCap)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then GLAccNetChange.FIND('-')
                        else
                            GLAccNetChange.NEXT();
                    end;
                    trigger OnPostDataItem()
                    begin
                        GLAccNetChange.DELETEALL();
                    end;
                    trigger OnPreDataItem()
                    begin
                        SETRANGE(Number, 1, GLAccNetChange.COUNT);
                    end;
                }
            }
            trigger OnPreDataItem()
            begin
                GLSetup.GET();
                SalesSetup.GET();
                PurchSetup.GET();
                AmountLCY:=0;
                BalanceLCY:=0;
                "Gen. Journal Line".COPYFILTER("Journal Batch Name", Name);
                "Gen. Journal Line".COPYFILTER("Journal Template Name", "Journal Template Name");
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

                    field(ShowDim_; ShowDim)
                    {
                        ApplicationArea = Dimensions;
                        Caption = 'Show Dimensions';
                        ToolTip = 'Specifies if you want dimensions information for the journal lines to be included in the report.';
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    var Text000: Label '%1 cannot be filtered when you post recurring journals.';
    Text001: Label '%1 or %2 must be specified.';
    Text002: Label '%1 must be specified.';
    Text003: Label '%1 + %2 must be %3.';
    Text004: Label '%1 must be " " when %2 is %3.';
    Text005: Label '%1, %2, %3 or %4 must not be completed when %5 is %6.';
    Text006: Label '%1 must be negative.';
    Text007: Label '%1 must be positive.';
    Text008: Label '%1 must have the same sign as %2.';
    Text009: Label '%1 cannot be specified.';
    Text010: Label '%1 must be Yes.';
    Text011: Label '%1 + %2 must be -%3.';
    Text012: Label '%1 must have a different sign than %2.';
    Text013: Label '%1 must only be a closing date for G/L entries.';
    Text015: Label 'The lines are not listed according to Posting Date because they were not entered in that order.';
    Text016: Label 'There is a gap in the number series.';
    Text017: Label '%1 or %2 must be G/L Account or Bank Account.';
    Text018: Label '%1 must be 0.';
    Text019: Label '%1 cannot be specified when using recurring journals.';
    Text020: Label '%1 must not be %2 when %3 = %4.';
    Text021: Label 'Allocations can only be used with recurring journals.';
    Text022: Label 'Specify %1 in the %2 allocation lines.';
    Text023: Label '<Month Text>';
    Text024: Label '%1 %2 posted on %3, must be separated by an empty line.', Comment = '%1 - document type, %2 - document number, %3 - posting date';
    Text025: Label '%1 %2 is out of balance by %3.';
    Text026: Label 'The reversing entries for %1 %2 are out of balance by %3.';
    Text027: Label 'As of %1, the lines are out of balance by %2.';
    Text028: Label 'As of %1, the reversing entries are out of balance by %2.';
    Text029: Label 'The total of the lines is out of balance by %1.';
    Text030: Label 'The total of the reversing entries is out of balance by %1.';
    Text031: Label '%1 %2 does not exist.';
    Text032: Label '%1 must be %2 for %3 %4.';
    Text036: Label '%1 %2 %3 does not exist.';
    Text037: Label '%1 must be %2.';
    Text038: Label 'The currency %1 cannot be found. Check the currency table.';
    Text039: Label 'Sales %1 %2 already exists.';
    Text040: Label 'Purchase %1 %2 already exists.';
    Text041: Label '%1 must be entered.';
    Text042: Label '%1 must not be filled when %2 is different in %3 and %4.';
    Text043: Label '%1 %2 must not have %3 = %4.';
    Text044: Label '%1 must not be specified in fixed asset journal lines.';
    Text045: Label '%1 must be specified in fixed asset journal lines.';
    Text046: Label '%1 must be different than %2.';
    Text047: Label '%1 and %2 must not both be %3.';
    Text049: Label '%1 must not be specified when %2 = %3.';
    Text050: Label 'must not be specified together with %1 = %2.';
    Text051: Label '%1 must be identical to %2.';
    Text052: Label '%1 cannot be a closing date.';
    Text053: Label '%1 is not within your range of allowed posting dates.';
    Text054: Label 'Insurance integration is not activated for %1 %2.';
    Text055: Label 'must not be specified when %1 is specified.';
    Text056: Label 'When G/L integration is not activated, %1 must not be posted in the general journal.';
    Text057: Label 'When G/L integration is not activated, %1 must not be specified in the general journal.';
    Text058: Label '%1 must not be specified.';
    Text059: Label 'The combination of Customer and Gen. Posting Type Purchase is not allowed.';
    Text060: Label 'The combination of Vendor and Gen. Posting Type Sales is not allowed.';
    Text061: Label 'The Balance and Reversing Balance recurring methods can be used only with Allocations.';
    Text062: Label '%1 must not be 0.';
    GLSetup: Record "General Ledger Setup";
    SalesSetup: Record "Sales & Receivables Setup";
    PurchSetup: Record "Purchases & Payables Setup";
    UserSetup: Record "User Setup";
    AccountingPeriod: Record "Accounting Period";
    GLAcc: Record "G/L Account";
    Currency: Record Currency;
    Cust: Record Customer;
    Vend: Record Vendor;
    BankAccPostingGr: Record "Bank Account Posting Group";
    BankAcc: Record "Bank Account";
    GenJnlTemplate: Record "Gen. Journal Template";
    GenJnlLine2: Record "Gen. Journal Line";
    TempGenJnlLine: Record "Gen. Journal Line" temporary;
    TempGenJournalLineCustVendIC: Record "Gen. Journal Line" temporary;
    GenJnlAlloc: Record "Gen. Jnl. Allocation";
    OldCustLedgEntry: Record "Cust. Ledger Entry";
    OldVendLedgEntry: Record "Vendor Ledger Entry";
    VATPostingSetup: Record "VAT Posting Setup";
    NoSeries: Record "No. Series";
    FA: Record "Fixed Asset";
    ICPartner: Record "IC Partner";
    DeprBook: Record "Depreciation Book";
    FADeprBook: Record "FA Depreciation Book";
    FASetup: Record "FA Setup";
    GLAccNetChange: Record "OP G/L Account Net Change" temporary; //
    DimSetEntry: Record "Dimension Set Entry";
    Employee: Record Employee;
    GenJnlManagement: Codeunit GenJnlManagement;
    GenJnlLineFilter: Text;
    AllowFAPostingFrom: Date;
    AllowFAPostingTo: Date;
    LastDate: Date;
    //LastDocType: Option Document,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
    LastDocType: Enum "Gen. Journal Document Type";
    LastDocNo: Code[20];
    LastEnteredDocNo: Code[20];
    LastEntrdDate: Date;
    BalanceLCY: Decimal;
    AmountLCY: Decimal;
    DocBalanceReverse: Decimal;
    DateBalanceReverse: Decimal;
    TotalBalanceReverse: Decimal;
    AccName: Text[100]; //
    LastLineNo: Integer;
    Day: Integer;
    Week: Integer;
    Month: Integer;
    MonthText: Text[30];
    AmountError: Boolean;
    ErrorCounter: Integer;
    ErrorText: array[50]of Text[250];
    TempErrorText: Text[250];
    BalAccName: Text[100]; //
    VATEntryCreated: Boolean;
    CustPosting: Boolean;
    VendPosting: Boolean;
    SalesPostingType: Boolean;
    PurchPostingType: Boolean;
    DimText: Text[75];
    AllocationDimText: Text[75];
    ShowDim: Boolean;
    Continue: Boolean;
    Text063: Label 'Document,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
    Text064: Label '%1 %2 is already used in line %3 (%4 %5).';
    Text065: Label '%1 must not be blocked with type %2 when %3 is %4.';
    CurrentICPartner: Code[20];
    Text066: Label 'You cannot enter G/L Account or Bank Account in both %1 and %2.';
    Text067: Label '%1 %2 is linked to %3 %4.';
    Text069: Label '%1 must not be specified when %2 is %3.';
    Text070: Label '%1 must not be specified when the document is not an intercompany transaction.';
    Text071: Label '%1 %2 does not exist.';
    Text072: Label '%1 must not be %2 for %3 %4.';
    Text073: Label '%1 %2 already exists.';
    GeneralJnlTestCap: Label 'General Journal - Test';
    PageNoCap: Label 'Page';
    JnlBatchNameCap: Label 'Journal Batch';
    PostingDateCap: Label 'Posting Date';
    DocumentTypeCap: Label 'Document Type';
    AccountTypeCap: Label 'Account Type';
    AccNameCap: Label 'Name';
    GenPostingTypeCap: Label 'Gen. Posting Type';
    GenBusPostingGroupCap: Label 'Gen. Bus. Posting Group';
    GenProdPostingGroupCap: Label 'Gen. Prod. Posting Group';
    AmountLCYCap: Label 'Total (LCY)';
    DimensionsCap: Label 'Dimensions';
    WarningCap: Label 'Warning!';
    ReconciliationCap: Label 'Reconciliation';
    NoCap: Label 'No.';
    NameCap: Label 'Name';
    NetChangeinJnlCap: Label 'Net Change in Jnl.';
    BalafterPostingCap: Label 'Balance after Posting';
    DimensionAllocationsCap: Label 'Allocation Dimensions';
    local procedure CheckRecurringLine(pGenJnlLine2: Record "Gen. Journal Line")
    begin
        if GenJnlTemplate.Recurring then begin
            if pGenJnlLine2."Recurring Method" = "Gen. Journal Recurring Method"::" " then AddError(STRSUBSTNO(Text002, pGenJnlLine2.FIELDCAPTION("Recurring Method")));
            if FORMAT(GenJnlLine2."Recurring Frequency") = '' then AddError(STRSUBSTNO(Text002, pGenJnlLine2.FIELDCAPTION("Recurring Frequency")));
            if pGenJnlLine2."Bal. Account No." <> '' then AddError(STRSUBSTNO(Text019, pGenJnlLine2.FIELDCAPTION("Bal. Account No.")));
            case pGenJnlLine2."Recurring Method" of pGenJnlLine2."Recurring Method"::"V  Variable", pGenJnlLine2."Recurring Method"::"RV Reversing Variable", pGenJnlLine2."Recurring Method"::"F  Fixed", pGenJnlLine2."Recurring Method"::"RF Reversing Fixed": WarningIfZeroAmt("Gen. Journal Line");
            pGenJnlLine2."Recurring Method"::"B  Balance", pGenJnlLine2."Recurring Method"::"RB Reversing Balance": WarningIfNonZeroAmt("Gen. Journal Line");
            end;
            if pGenJnlLine2."Recurring Method".AsInteger() > pGenJnlLine2."Recurring Method"::"V  Variable".AsInteger()then begin
                if pGenJnlLine2."Account Type" = pGenJnlLine2."Account Type"::"Fixed Asset" then AddError(STRSUBSTNO(Text020, pGenJnlLine2.FIELDCAPTION("Recurring Method"), pGenJnlLine2."Recurring Method", pGenJnlLine2.FIELDCAPTION("Account Type"), pGenJnlLine2."Account Type"));
                if pGenJnlLine2."Bal. Account Type" = pGenJnlLine2."Bal. Account Type"::"Fixed Asset" then AddError(STRSUBSTNO(Text020, pGenJnlLine2.FIELDCAPTION("Recurring Method"), pGenJnlLine2."Recurring Method", pGenJnlLine2.FIELDCAPTION("Bal. Account Type"), pGenJnlLine2."Bal. Account Type"));
            end;
        end
        else
        begin
            if pGenJnlLine2."Recurring Method" <> "Gen. Journal Recurring Method"::" " then AddError(STRSUBSTNO(Text009, pGenJnlLine2.FIELDCAPTION("Recurring Method")));
            if FORMAT(pGenJnlLine2."Recurring Frequency") <> '' then AddError(STRSUBSTNO(Text009, pGenJnlLine2.FIELDCAPTION("Recurring Frequency")));
        end;
    end;
    local procedure CheckAllocations(pGenJnlLine2: Record "Gen. Journal Line")
    begin
        //WITH GenJnlLine2 DO BEGIN
        if pGenJnlLine2."Recurring Method" in[pGenJnlLine2."Recurring Method"::"B  Balance", pGenJnlLine2."Recurring Method"::"RB Reversing Balance"]then begin
            GenJnlAlloc.RESET();
            GenJnlAlloc.SETRANGE("Journal Template Name", pGenJnlLine2."Journal Template Name");
            GenJnlAlloc.SETRANGE("Journal Batch Name", pGenJnlLine2."Journal Batch Name");
            GenJnlAlloc.SETRANGE("Journal Line No.", pGenJnlLine2."Line No.");
            if not GenJnlAlloc.FINDFIRST()then AddError(Text061);
        end;
        GenJnlAlloc.RESET();
        GenJnlAlloc.SETRANGE("Journal Template Name", pGenJnlLine2."Journal Template Name");
        GenJnlAlloc.SETRANGE("Journal Batch Name", pGenJnlLine2."Journal Batch Name");
        GenJnlAlloc.SETRANGE("Journal Line No.", pGenJnlLine2."Line No.");
        GenJnlAlloc.SETFILTER(Amount, '<>0');
        if GenJnlAlloc.FINDFIRST()then if not GenJnlTemplate.Recurring then AddError(Text021)
            else
            begin
                GenJnlAlloc.SETRANGE("Account No.", '');
                if GenJnlAlloc.FINDFIRST()then AddError(STRSUBSTNO(Text022, GenJnlAlloc.FIELDCAPTION("Account No."), GenJnlAlloc.COUNT));
            end;
    //END;
    end;
    local procedure MakeRecurringTexts(var pGenJnlLine2: Record "Gen. Journal Line")
    begin
        if(pGenJnlLine2."Posting Date" <> 0D) and (pGenJnlLine2."Account No." <> '') and (pGenJnlLine2."Recurring Method" <> "Gen. Journal Recurring Method"::" ")then begin
            Day:=DATE2DMY(pGenJnlLine2."Posting Date", 1);
            Week:=DATE2DWY(pGenJnlLine2."Posting Date", 2);
            Month:=DATE2DMY(pGenJnlLine2."Posting Date", 2);
            MonthText:=FORMAT(pGenJnlLine2."Posting Date", 0, Text023);
            AccountingPeriod.SETRANGE("Starting Date", 0D, pGenJnlLine2."Posting Date");
            if not AccountingPeriod.FINDLAST()then AccountingPeriod.Name:='';
            pGenJnlLine2."Document No.":=Copystr(DELCHR(PADSTR(STRSUBSTNO(pGenJnlLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name), MAXSTRLEN(pGenJnlLine2."Document No.")), '>'), 1, MaxStrLen(pGenJnlLine2."Document No.")); //
            pGenJnlLine2.Description:=Copystr(DELCHR(PADSTR(STRSUBSTNO(pGenJnlLine2.Description, Day, Week, Month, MonthText, AccountingPeriod.Name), MAXSTRLEN(pGenJnlLine2.Description)), '>'), 1, MaxStrLen(pGenJnlLine2.Description)); //
        end;
    end;
    local procedure CheckBalance()
    var
        GenJnlLine: Record "Gen. Journal Line";
        NextGenJnlLine: Record "Gen. Journal Line";
        DocBalance: Decimal;
        DateBalance: Decimal;
        TotalBalance: Decimal;
    begin
        GenJnlLine.COPY("Gen. Journal Line");
        LastLineNo:="Gen. Journal Line"."Line No.";
        NextGenJnlLine.COPY("Gen. Journal Line");
        NextGenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        NextGenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
        if NextGenJnlLine.NEXT() = 0 then;
        MakeRecurringTexts(NextGenJnlLine);
        if not GenJnlLine.EmptyLine()then begin
            DocBalance:=CalculateDocBalance(GenJnlLine);
            DateBalance:=CalculateDateBalance(GenJnlLine);
            TotalBalance:=CalculateTotalBalance(GenJnlLine);
            if GenJnlLine."Recurring Method".AsInteger() >= GenJnlLine."Recurring Method"::"RF Reversing Fixed".AsInteger()then begin
                DocBalanceReverse:=DocBalanceReverse + GenJnlLine."Balance (LCY)";
                DateBalanceReverse:=DateBalanceReverse + GenJnlLine."Balance (LCY)";
                TotalBalanceReverse:=TotalBalanceReverse + GenJnlLine."Balance (LCY)";
            end;
            LastDocType:=GenJnlLine."Document Type";
            LastDocNo:=GenJnlLine."Document No.";
            LastDate:=GenJnlLine."Posting Date";
            if TotalBalance = 0 then VATEntryCreated:=false;
            if GenJnlTemplate."Force Doc. Balance" then begin
                VATEntryCreated:=VATEntryCreated or ((GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") and (GenJnlLine."Account No." <> '') and (GenJnlLine."Gen. Posting Type" in[GenJnlLine."Gen. Posting Type"::Purchase, GenJnlLine."Gen. Posting Type"::Sale])) or ((GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"G/L Account") and (GenJnlLine."Bal. Account No." <> '') and (GenJnlLine."Bal. Gen. Posting Type" in[GenJnlLine."Bal. Gen. Posting Type"::Purchase, GenJnlLine."Bal. Gen. Posting Type"::Sale]));
                TempGenJournalLineCustVendIC.IsCustVendICAdded(GenJnlLine);
                if(TempGenJournalLineCustVendIC.COUNT > 1) and VATEntryCreated then AddError(STRSUBSTNO(Text024, GenJnlLine."Document Type", GenJnlLine."Document No.", GenJnlLine."Posting Date"));
            end;
        end;
        if(LastDate <> 0D) and (LastDocNo <> '') and ((NextGenJnlLine."Posting Date" <> LastDate) or (NextGenJnlLine."Document Type" <> LastDocType) or (NextGenJnlLine."Document No." <> LastDocNo) or (NextGenJnlLine."Line No." = LastLineNo))then begin
            if GenJnlTemplate."Force Doc. Balance" then begin
                case true of DocBalance <> 0: AddError(StrSubstNo(Text025, LastDocType, LastDocNo, DocBalance));
                //AddError(STRSUBSTNO(Text025, SELECTSTR(LastDocType + 1, Text063), LastDocNo, DocBalance));
                DocBalanceReverse <> 0: AddError(StrSubstNo(Text026, LastDocType, LastDocNo, DocBalanceReverse));
                //AddError(STRSUBSTNO(Text026, SELECTSTR(LastDocType + 1, Text063), LastDocNo, DocBalanceReverse));
                end;
                DocBalanceReverse:=0;
            end;
            if(NextGenJnlLine."Posting Date" <> LastDate) or (NextGenJnlLine."Document Type" <> LastDocType) or (NextGenJnlLine."Document No." <> LastDocNo)then begin
                TempGenJournalLineCustVendIC.RESET();
                TempGenJournalLineCustVendIC.DELETEALL();
                VATEntryCreated:=false;
                CustPosting:=false;
                VendPosting:=false;
                SalesPostingType:=false;
                PurchPostingType:=false;
            end;
        end;
        if(LastDate <> 0D) and ((NextGenJnlLine."Posting Date" <> LastDate) or (NextGenJnlLine."Line No." = LastLineNo))then begin
            case true of DateBalance <> 0: AddError(STRSUBSTNO(Text027, LastDate, DateBalance));
            DateBalanceReverse <> 0: AddError(STRSUBSTNO(Text028, LastDate, DateBalanceReverse));
            end;
            DocBalanceReverse:=0;
            DateBalanceReverse:=0;
        end;
        if NextGenJnlLine."Line No." = LastLineNo then begin
            case true of TotalBalance <> 0: AddError(STRSUBSTNO(Text029, TotalBalance));
            TotalBalanceReverse <> 0: AddError(STRSUBSTNO(Text030, TotalBalanceReverse));
            end;
            DocBalanceReverse:=0;
            DateBalanceReverse:=0;
            TotalBalanceReverse:=0;
            LastDate:=0D;
            LastDocType:=LastDocType::" "; //  0;
            LastDocNo:='';
        end;
    end;
    local procedure CalculateDocBalance(GenJournalLine: Record "Gen. Journal Line"): Decimal var
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        GenJournalLine2.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine2.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLine2.SETRANGE("Document Type", GenJournalLine."Document Type");
        GenJournalLine2.SETRANGE("Document No.", GenJournalLine."Document No.");
        GenJournalLine2.CALCSUMS("Balance (LCY)");
        exit(GenJournalLine2."Balance (LCY)");
    end;
    local procedure CalculateDateBalance(GenJournalLine: Record "Gen. Journal Line"): Decimal var
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        GenJournalLine2.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine2.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLine2.SETRANGE("Posting Date", GenJournalLine."Posting Date");
        GenJournalLine2.CALCSUMS("Balance (LCY)");
        exit(GenJournalLine2."Balance (LCY)");
    end;
    local procedure CalculateTotalBalance(GenJournalLine: Record "Gen. Journal Line"): Decimal var
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        GenJournalLine2.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine2.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
        GenJournalLine2.CALCSUMS("Balance (LCY)");
        exit(GenJournalLine2."Balance (LCY)");
    end;
    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter:=ErrorCounter + 1;
        ErrorText[ErrorCounter]:=Text;
    end;
    local procedure ReconcileGLAccNo(GLAccNo: Code[20]; ReconcileAmount: Decimal)
    begin
        if not GLAccNetChange.GET(GLAccNo)then begin
            GLAcc.GET(GLAccNo);
            GLAcc.CALCFIELDS("Balance at Date");
            GLAccNetChange.INIT();
            GLAccNetChange."No.":=GLAcc."No.";
            GLAccNetChange.Name:=GLAcc.Name;
            GLAccNetChange."Balance after Posting":=GLAcc."Balance at Date";
            GLAccNetChange.INSERT();
        end;
        GLAccNetChange."Net Change in Jnl.":=GLAccNetChange."Net Change in Jnl." + ReconcileAmount;
        GLAccNetChange."Balance after Posting":=GLAccNetChange."Balance after Posting" + ReconcileAmount;
        GLAccNetChange.MODIFY();
    end;
    local procedure CheckGLAcc(var GenJnlLine: Record "Gen. Journal Line"; var pAccName: Text[100]) //
    begin
        if not GLAcc.GET(GenJnlLine."Account No.")then AddError(STRSUBSTNO(Text031, GLAcc.TABLECAPTION, GenJnlLine."Account No."))
        else
        begin
            pAccName:=GLAcc.Name;
            if GLAcc.Blocked then AddError(STRSUBSTNO(Text032, GLAcc.FIELDCAPTION(Blocked), false, GLAcc.TABLECAPTION, GenJnlLine."Account No."));
            if GLAcc."Account Type" <> GLAcc."Account Type"::Posting then begin
                GLAcc."Account Type":=GLAcc."Account Type"::Posting;
                AddError(STRSUBSTNO(Text032, GLAcc.FIELDCAPTION("Account Type"), GLAcc."Account Type", GLAcc.TABLECAPTION, GenJnlLine."Account No."));
            end;
            if not GenJnlLine."System-Created Entry" then if GenJnlLine."Posting Date" = NORMALDATE(GenJnlLine."Posting Date")then if not GLAcc."Direct Posting" then AddError(STRSUBSTNO(Text032, GLAcc.FIELDCAPTION("Direct Posting"), true, GLAcc.TABLECAPTION, GenJnlLine."Account No."));
            if GenJnlLine."Gen. Posting Type".AsInteger() > 0 then begin
                case GenJnlLine."Gen. Posting Type" of GenJnlLine."Gen. Posting Type"::Sale: SalesPostingType:=true;
                GenJnlLine."Gen. Posting Type"::Purchase: PurchPostingType:=true;
                end;
                TestPostingType();
                if not VATPostingSetup.GET(GenJnlLine."VAT Bus. Posting Group", GenJnlLine."VAT Prod. Posting Group")then AddError(STRSUBSTNO(Text036, VATPostingSetup.TABLECAPTION, GenJnlLine."VAT Bus. Posting Group", GenJnlLine."VAT Prod. Posting Group"))
                else if GenJnlLine."VAT Calculation Type" <> VATPostingSetup."VAT Calculation Type" then AddError(STRSUBSTNO(Text037, GenJnlLine.FIELDCAPTION("VAT Calculation Type"), VATPostingSetup."VAT Calculation Type"))end;
            if GLAcc."Reconciliation Account" then ReconcileGLAccNo(GenJnlLine."Account No.", ROUND(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."VAT %" / 100)));
        end;
    end;
    local procedure CheckCust(var GenJnlLine: Record "Gen. Journal Line"; var pAccName: Text[100]) //
    begin
        if not Cust.GET(GenJnlLine."Account No.")then AddError(STRSUBSTNO(Text031, Cust.TABLECAPTION, GenJnlLine."Account No."))
        else
        begin
            pAccName:=Cust.Name;
            if Cust."Privacy Blocked" then AddError(Cust.GetPrivacyBlockedGenericErrorText(Cust));
            if((Cust.Blocked = Cust.Blocked::All) or ((Cust.Blocked = Cust.Blocked::Invoice) and (GenJnlLine."Document Type" in[GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::" "])))then AddError(STRSUBSTNO(Text065, GenJnlLine."Account Type", Cust.Blocked, GenJnlLine.FIELDCAPTION("Document Type"), GenJnlLine."Document Type"));
            if GenJnlLine."Currency Code" <> '' then if not Currency.GET(GenJnlLine."Currency Code")then AddError(STRSUBSTNO(Text038, GenJnlLine."Currency Code"));
            if(Cust."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany)then if ICPartner.GET(Cust."IC Partner Code")then begin
                    if ICPartner.Blocked then AddError(STRSUBSTNO('%1 %2', STRSUBSTNO(Text067, Cust.TABLECAPTION, GenJnlLine."Account No.", ICPartner.TABLECAPTION, GenJnlLine."IC Partner Code"), STRSUBSTNO(Text032, ICPartner.FIELDCAPTION(Blocked), false, ICPartner.TABLECAPTION, Cust."IC Partner Code")));
                end
                else
                    AddError(STRSUBSTNO('%1 %2', STRSUBSTNO(Text067, Cust.TABLECAPTION, GenJnlLine."Account No.", ICPartner.TABLECAPTION, Cust."IC Partner Code"), STRSUBSTNO(Text031, ICPartner.TABLECAPTION, Cust."IC Partner Code")));
            CustPosting:=true;
            TestPostingType();
            if GenJnlLine."Recurring Method" = "Gen. Journal Recurring Method"::" " then if GenJnlLine."Document Type" in[GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::"Credit Memo", GenJnlLine."Document Type"::"Finance Charge Memo", GenJnlLine."Document Type"::Reminder]then begin
                    OldCustLedgEntry.RESET();
                    OldCustLedgEntry.SETCURRENTKEY("Document No.");
                    OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                    OldCustLedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
                    if OldCustLedgEntry.FINDFIRST()then AddError(STRSUBSTNO(Text039, GenJnlLine."Document Type", GenJnlLine."Document No."));
                    if SalesSetup."Ext. Doc. No. Mandatory" or (GenJnlLine."External Document No." <> '')then begin
                        if GenJnlLine."External Document No." = '' then AddError(STRSUBSTNO(Text041, GenJnlLine.FIELDCAPTION("External Document No.")));
                        OldCustLedgEntry.RESET();
                        OldCustLedgEntry.SETCURRENTKEY("External Document No.");
                        OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                        OldCustLedgEntry.SETRANGE("Customer No.", GenJnlLine."Account No.");
                        OldCustLedgEntry.SETRANGE("External Document No.", GenJnlLine."External Document No.");
                        if OldCustLedgEntry.FINDFIRST()then AddError(STRSUBSTNO(Text039, GenJnlLine."Document Type", GenJnlLine."External Document No."));
                        CheckAgainstPrevLines("Gen. Journal Line");
                    end;
                end;
        end;
    end;
    local procedure CheckVend(var GenJnlLine: Record "Gen. Journal Line"; var pAccName: Text[100]) //
    var
        VendorMgt: Codeunit "Vendor Mgt.";
    begin
        if not Vend.GET(GenJnlLine."Account No.")then AddError(STRSUBSTNO(Text031, Vend.TABLECAPTION, GenJnlLine."Account No."))
        else
        begin
            pAccName:=Vend.Name;
            if Vend."Privacy Blocked" then AddError(Vend.GetPrivacyBlockedGenericErrorText(Vend));
            if((Vend.Blocked = Vend.Blocked::All) or ((Vend.Blocked = Vend.Blocked::Payment) and (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment)))then AddError(STRSUBSTNO(Text065, GenJnlLine."Account Type", Vend.Blocked, GenJnlLine.FIELDCAPTION("Document Type"), GenJnlLine."Document Type"));
            if GenJnlLine."Currency Code" <> '' then if not Currency.GET(GenJnlLine."Currency Code")then AddError(STRSUBSTNO(Text038, GenJnlLine."Currency Code"));
            if(Vend."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany)then if ICPartner.GET(Vend."IC Partner Code")then begin
                    if ICPartner.Blocked then AddError(STRSUBSTNO('%1 %2', STRSUBSTNO(Text067, Vend.TABLECAPTION, GenJnlLine."Account No.", ICPartner.TABLECAPTION, Vend."IC Partner Code"), STRSUBSTNO(Text032, ICPartner.FIELDCAPTION(Blocked), false, ICPartner.TABLECAPTION, Vend."IC Partner Code")));
                end
                else
                    AddError(STRSUBSTNO('%1 %2', STRSUBSTNO(Text067, Vend.TABLECAPTION, GenJnlLine."Account No.", ICPartner.TABLECAPTION, GenJnlLine."IC Partner Code"), STRSUBSTNO(Text031, ICPartner.TABLECAPTION, Vend."IC Partner Code")));
            VendPosting:=true;
            TestPostingType();
            if GenJnlLine."Recurring Method".AsInteger() = 0 then //
 if GenJnlLine."Document Type" in[GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::"Credit Memo", GenJnlLine."Document Type"::"Finance Charge Memo", GenJnlLine."Document Type"::Reminder]then begin
                    OldVendLedgEntry.RESET();
                    OldVendLedgEntry.SETCURRENTKEY("Document No.");
                    OldVendLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
                    OldVendLedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
                    if OldVendLedgEntry.FINDFIRST()then AddError(STRSUBSTNO(Text040, GenJnlLine."Document Type", GenJnlLine."Document No."));
                    if PurchSetup."Ext. Doc. No. Mandatory" or (GenJnlLine."External Document No." <> '')then begin
                        if GenJnlLine."External Document No." = '' then AddError(STRSUBSTNO(Text041, GenJnlLine.FIELDCAPTION("External Document No.")));
                        OldVendLedgEntry.RESET();
                        OldVendLedgEntry.SETCURRENTKEY("External Document No.");
                        VendorMgt.SetFilterForExternalDocNo(OldVendLedgEntry, GenJnlLine."Document Type", GenJnlLine."External Document No.", GenJnlLine."Account No.", GenJnlLine."Document Date");
                        if OldVendLedgEntry.FINDFIRST()then AddError(STRSUBSTNO(Text040, GenJnlLine."Document Type", GenJnlLine."External Document No."));
                        CheckAgainstPrevLines("Gen. Journal Line");
                    end;
                end;
        end;
    end;
    local procedure CheckEmployee(var GenJnlLine: Record "Gen. Journal Line"; var pAccName: Text[100])
    begin
        //WITH GenJnlLine. DO
        if not Employee.GET(GenJnlLine."Account No.")then AddError(STRSUBSTNO(Text031, Employee.TABLECAPTION, GenJnlLine."Account No."))
        else
        begin
            pAccName:=Employee."No.";
            if Employee."Privacy Blocked" then AddError(STRSUBSTNO(Text032, Employee.FIELDCAPTION("Privacy Blocked"), false, Employee.TABLECAPTION, AccName))end;
    end;
    local procedure CheckBankAcc(var GenJnlLine: Record "Gen. Journal Line"; var pAccName: Text[100])
    begin
        //WITH GenJnlLine DO 
        if not BankAcc.GET(GenJnlLine."Account No.")then AddError(STRSUBSTNO(Text031, BankAcc.TABLECAPTION, GenJnlLine."Account No."))
        else
        begin
            pAccName:=BankAcc.Name;
            if BankAcc.Blocked then AddError(STRSUBSTNO(Text032, BankAcc.FIELDCAPTION(Blocked), false, BankAcc.TABLECAPTION, GenJnlLine."Account No."));
            if(GenJnlLine."Currency Code" <> BankAcc."Currency Code") and (BankAcc."Currency Code" <> '')then AddError(STRSUBSTNO(Text037, GenJnlLine.FIELDCAPTION("Currency Code"), BankAcc."Currency Code"));
            if GenJnlLine."Currency Code" <> '' then if not Currency.GET(GenJnlLine."Currency Code")then AddError(STRSUBSTNO(Text038, GenJnlLine."Currency Code"));
            if GenJnlLine."Bank Payment Type" <> "Bank Payment Type"::" " then if(GenJnlLine."Bank Payment Type" = "Bank Payment Type"::"Computer Check") and (GenJnlLine.Amount < 0)then if BankAcc."Currency Code" <> GenJnlLine."Currency Code" then AddError(STRSUBSTNO(Text042, GenJnlLine.FIELDCAPTION("Bank Payment Type"), GenJnlLine.FIELDCAPTION("Currency Code"), GenJnlLine.TABLECAPTION, BankAcc.TABLECAPTION));
            if BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group")then if BankAccPostingGr."G/L Account No." <> '' then ReconcileGLAccNo(BankAccPostingGr."G/L Account No.", Round(GenJnlLine."Amount (LCY)" / (1 + GenJnlLine."VAT %" / 100)));
        end;
    end;
    local procedure CheckFixedAsset(var GenJnlLine: Record "Gen. Journal Line"; var pAccName: Text[100])
    begin
        //WITH GenJnlLine DO 
        if not FA.GET(GenJnlLine."Account No.")then AddError(STRSUBSTNO(Text031, FA.TABLECAPTION, GenJnlLine."Account No."))
        else
        begin
            pAccName:=FA.Description;
            if FA.Blocked then AddError(STRSUBSTNO(Text032, FA.FIELDCAPTION(Blocked), false, FA.TABLECAPTION, GenJnlLine."Account No."));
            if FA.Inactive then AddError(STRSUBSTNO(Text032, FA.FIELDCAPTION(Inactive), false, FA.TABLECAPTION, GenJnlLine."Account No."));
            if FA."Budgeted Asset" then AddError(STRSUBSTNO(Text043, FA.TABLECAPTION, GenJnlLine."Account No.", FA.FIELDCAPTION("Budgeted Asset"), true));
            if DeprBook.GET(GenJnlLine."Depreciation Book Code")then CheckFAIntegration(GenJnlLine)
            else
                AddError(STRSUBSTNO(Text031, DeprBook.TABLECAPTION, GenJnlLine."Depreciation Book Code"));
            if not FADeprBook.GET(FA."No.", GenJnlLine."Depreciation Book Code")then AddError(STRSUBSTNO(Text036, FADeprBook.TABLECAPTION, FA."No.", GenJnlLine."Depreciation Book Code"));
        end;
    end;
    local procedure CheckICPartner(var GenJnlLine: Record "Gen. Journal Line"; var pAccName: Text[100])
    begin
        //WITH GenJnlLine DO 
        if not ICPartner.GET(GenJnlLine."Account No.")then AddError(STRSUBSTNO(Text031, ICPartner.TABLECAPTION, GenJnlLine."Account No."))
        else
        begin
            pAccName:=ICPartner.Name;
            if ICPartner.Blocked then AddError(STRSUBSTNO(Text032, ICPartner.FIELDCAPTION(Blocked), false, ICPartner.TABLECAPTION, GenJnlLine."Account No."));
        end;
    end;
    local procedure TestFixedAsset(var GenJnlLine: Record "Gen. Journal Line")
    begin
        if GenJnlLine."Job No." <> '' then AddError(STRSUBSTNO(Text044, GenJnlLine.FIELDCAPTION("Job No.")));
        if GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::" " then AddError(STRSUBSTNO(Text045, GenJnlLine.FIELDCAPTION("FA Posting Type")));
        if GenJnlLine."Depreciation Book Code" = '' then AddError(STRSUBSTNO(Text045, GenJnlLine.FIELDCAPTION("Depreciation Book Code")));
        if GenJnlLine."Depreciation Book Code" = GenJnlLine."Duplicate in Depreciation Book" then AddError(STRSUBSTNO(Text046, GenJnlLine.FIELDCAPTION("Depreciation Book Code"), GenJnlLine.FIELDCAPTION("Duplicate in Depreciation Book")));
        CheckFADocNo(GenJnlLine);
        if GenJnlLine."Account Type" = GenJnlLine."Bal. Account Type" then AddError(STRSUBSTNO(Text047, GenJnlLine.FIELDCAPTION("Account Type"), GenJnlLine.FIELDCAPTION("Bal. Account Type"), GenJnlLine."Account Type"));
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" then if GenJnlLine."FA Posting Type" in[GenJnlLine."FA Posting Type"::"Acquisition Cost", GenJnlLine."FA Posting Type"::Disposal, GenJnlLine."FA Posting Type"::Maintenance]then begin
                if(GenJnlLine."Gen. Bus. Posting Group" <> '') or (GenJnlLine."Gen. Prod. Posting Group" <> '')then if GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::" " then AddError(STRSUBSTNO(Text002, GenJnlLine.FIELDCAPTION("Gen. Posting Type")));
            end
            else
            begin
                if GenJnlLine."Gen. Posting Type" <> GenJnlLine."Gen. Posting Type"::" " then AddError(STRSUBSTNO(Text049, GenJnlLine.FIELDCAPTION("Gen. Posting Type"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
                if GenJnlLine."Gen. Bus. Posting Group" <> '' then AddError(STRSUBSTNO(Text049, GenJnlLine.FIELDCAPTION("Gen. Bus. Posting Group"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
                if GenJnlLine."Gen. Prod. Posting Group" <> '' then AddError(STRSUBSTNO(Text049, GenJnlLine.FIELDCAPTION("Gen. Prod. Posting Group"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
            end;
        if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Fixed Asset" then if GenJnlLine."FA Posting Type" in[GenJnlLine."FA Posting Type"::"Acquisition Cost", GenJnlLine."FA Posting Type"::Disposal, GenJnlLine."FA Posting Type"::Maintenance]then begin
                if(GenJnlLine."Bal. Gen. Bus. Posting Group" <> '') or (GenJnlLine."Bal. Gen. Prod. Posting Group" <> '')then if GenJnlLine."Bal. Gen. Posting Type" = GenJnlLine."Bal. Gen. Posting Type"::" " then AddError(STRSUBSTNO(Text002, GenJnlLine.FIELDCAPTION("Bal. Gen. Posting Type")));
            end
            else
            begin
                if GenJnlLine."Bal. Gen. Posting Type" <> GenJnlLine."Bal. Gen. Posting Type"::" " then AddError(STRSUBSTNO(Text049, GenJnlLine.FIELDCAPTION("Bal. Gen. Posting Type"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
                if GenJnlLine."Bal. Gen. Bus. Posting Group" <> '' then AddError(STRSUBSTNO(Text049, GenJnlLine.FIELDCAPTION("Bal. Gen. Bus. Posting Group"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
                if GenJnlLine."Bal. Gen. Prod. Posting Group" <> '' then AddError(STRSUBSTNO(Text049, GenJnlLine.FIELDCAPTION("Bal. Gen. Prod. Posting Group"), GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type"));
            end;
        TempErrorText:='%1 ' + STRSUBSTNO(Text050, GenJnlLine.FIELDCAPTION("FA Posting Type"), GenJnlLine."FA Posting Type");
        if GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::"Acquisition Cost" then begin
            if GenJnlLine."Depr. Acquisition Cost" then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Depr. Acquisition Cost")));
            if GenJnlLine."Salvage Value" <> 0 then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Salvage Value")));
            if GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::Maintenance then if GenJnlLine.Quantity <> 0 then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION(Quantity)));
            if GenJnlLine."Insurance No." <> '' then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Insurance No.")));
        end;
        if(GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Maintenance) and GenJnlLine."Depr. until FA Posting Date" then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Depr. until FA Posting Date")));
        if(GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::Maintenance) and (GenJnlLine."Maintenance Code" <> '')then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Maintenance Code")));
        if(GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::Depreciation) and (GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::"Custom 1") and (GenJnlLine."No. of Depreciation Days" <> 0)then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("No. of Depreciation Days")));
        if(GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Disposal) and GenJnlLine."FA Reclassification Entry" then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("FA Reclassification Entry")));
        if(GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Disposal) and (GenJnlLine."Budgeted FA No." <> '')then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Budgeted FA No.")));
        if GenJnlLine."FA Posting Date" = 0D then GenJnlLine."FA Posting Date":=GenJnlLine."Posting Date";
        if DeprBook.GET(GenJnlLine."Depreciation Book Code")then if DeprBook."Use Same FA+G/L Posting Dates" and (GenJnlLine."Posting Date" <> GenJnlLine."FA Posting Date")then AddError(STRSUBSTNO(Text051, GenJnlLine.FIELDCAPTION("Posting Date"), GenJnlLine.FIELDCAPTION("FA Posting Date")));
        if GenJnlLine."FA Posting Date" <> 0D then begin
            if GenJnlLine."FA Posting Date" <> NORMALDATE(GenJnlLine."FA Posting Date")then AddError(STRSUBSTNO(Text052, GenJnlLine.FIELDCAPTION("FA Posting Date")));
            if not(GenJnlLine."FA Posting Date" in[DMY2DATE(1, 1, 2) .. DMY2DATE(31, 12, 9998)])then AddError(STRSUBSTNO(Text053, GenJnlLine.FIELDCAPTION("FA Posting Date")));
            if(AllowFAPostingFrom = 0D) and (AllowFAPostingTo = 0D)then begin
                if USERID <> '' then if UserSetup.GET(USERID)then begin
                        AllowFAPostingFrom:=UserSetup."Allow FA Posting From";
                        AllowFAPostingTo:=UserSetup."Allow FA Posting To";
                    end;
                if(AllowFAPostingFrom = 0D) and (AllowFAPostingTo = 0D)then begin
                    FASetup.GET();
                    AllowFAPostingFrom:=FASetup."Allow FA Posting From";
                    AllowFAPostingTo:=FASetup."Allow FA Posting To";
                end;
                if AllowFAPostingTo = 0D then AllowFAPostingTo:=DMY2DATE(31, 12, 9998);
            end;
            if(GenJnlLine."FA Posting Date" < AllowFAPostingFrom) or (GenJnlLine."FA Posting Date" > AllowFAPostingTo)then AddError(STRSUBSTNO(Text053, GenJnlLine.FIELDCAPTION("FA Posting Date")));
        end;
        FASetup.GET();
        if(GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::"Acquisition Cost") and (GenJnlLine."Insurance No." <> '') and (GenJnlLine."Depreciation Book Code" <> FASetup."Insurance Depr. Book")then AddError(STRSUBSTNO(Text054, GenJnlLine.FIELDCAPTION("Depreciation Book Code"), GenJnlLine."Depreciation Book Code"));
        if GenJnlLine."FA Error Entry No." > 0 then begin
            TempErrorText:='%1 ' + STRSUBSTNO(Text055, GenJnlLine.FIELDCAPTION("FA Error Entry No."));
            if GenJnlLine."Depr. until FA Posting Date" then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Depr. until FA Posting Date")));
            if GenJnlLine."Depr. Acquisition Cost" then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Depr. Acquisition Cost")));
            if GenJnlLine."Duplicate in Depreciation Book" <> '' then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Duplicate in Depreciation Book")));
            if GenJnlLine."Use Duplication List" then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Use Duplication List")));
            if GenJnlLine."Salvage Value" <> 0 then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Salvage Value")));
            if GenJnlLine."Insurance No." <> '' then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Insurance No.")));
            if GenJnlLine."Budgeted FA No." <> '' then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Budgeted FA No.")));
            if GenJnlLine."Recurring Method".AsInteger() > 0 then AddError(STRSUBSTNO(TempErrorText, GenJnlLine.FIELDCAPTION("Recurring Method"))); //
            if GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Maintenance then AddError(STRSUBSTNO(TempErrorText, GenJnlLine."FA Posting Type"));
        end;
    end;
    local procedure CheckFAIntegration(var GenJnlLine: Record "Gen. Journal Line")
    var
        GLIntegration: Boolean;
    begin
        //WITH GenJnlLine DO BEGIN
        if GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::" " then exit;
        case GenJnlLine."FA Posting Type" of GenJnlLine."FA Posting Type"::"Acquisition Cost": GLIntegration:=DeprBook."G/L Integration - Acq. Cost";
        GenJnlLine."FA Posting Type"::Depreciation: GLIntegration:=DeprBook."G/L Integration - Depreciation";
        GenJnlLine."FA Posting Type"::"Write-Down": GLIntegration:=DeprBook."G/L Integration - Write-Down";
        GenJnlLine."FA Posting Type"::Appreciation: GLIntegration:=DeprBook."G/L Integration - Appreciation";
        GenJnlLine."FA Posting Type"::"Custom 1": GLIntegration:=DeprBook."G/L Integration - Custom 1";
        GenJnlLine."FA Posting Type"::"Custom 2": GLIntegration:=DeprBook."G/L Integration - Custom 2";
        GenJnlLine."FA Posting Type"::Disposal: GLIntegration:=DeprBook."G/L Integration - Disposal";
        GenJnlLine."FA Posting Type"::Maintenance: GLIntegration:=DeprBook."G/L Integration - Maintenance";
        end;
        if not GLIntegration then AddError(STRSUBSTNO(Text056, GenJnlLine."FA Posting Type"));
        if not DeprBook."G/L Integration - Depreciation" then begin
            if GenJnlLine."Depr. until FA Posting Date" then AddError(STRSUBSTNO(Text057, GenJnlLine.FIELDCAPTION("Depr. until FA Posting Date")));
            if GenJnlLine."Depr. Acquisition Cost" then AddError(STRSUBSTNO(Text057, GenJnlLine.FIELDCAPTION("Depr. Acquisition Cost")));
        end;
    //END;
    end;
    local procedure TestFixedAssetFields(var GenJnlLine: Record "Gen. Journal Line")
    begin
        //WITH GenJnlLine DO BEGIN
        if GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::" " then AddError(STRSUBSTNO(Text058, GenJnlLine.FIELDCAPTION("FA Posting Type")));
        if GenJnlLine."Depreciation Book Code" <> '' then AddError(STRSUBSTNO(Text058, GenJnlLine.FIELDCAPTION("Depreciation Book Code")));
    //END;
    end;
    procedure TestPostingType()
    begin
        case true of CustPosting and PurchPostingType: AddError(Text059);
        VendPosting and SalesPostingType: AddError(Text060);
        end;
    end;
    local procedure WarningIfNegativeAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if(GenJnlLine.Amount < 0) and not AmountError then begin
            AmountError:=true;
            AddError(STRSUBSTNO(Text007, GenJnlLine.FIELDCAPTION(Amount)));
        end;
    end;
    local procedure WarningIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if(GenJnlLine.Amount > 0) and not AmountError then begin
            AmountError:=true;
            AddError(STRSUBSTNO(Text006, GenJnlLine.FIELDCAPTION(Amount)));
        end;
    end;
    local procedure WarningIfZeroAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if(GenJnlLine.Amount = 0) and not AmountError then begin
            AmountError:=true;
            AddError(STRSUBSTNO(Text002, GenJnlLine.FIELDCAPTION(Amount)));
        end;
    end;
    local procedure WarningIfNonZeroAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if(GenJnlLine.Amount <> 0) and not AmountError then begin
            AmountError:=true;
            AddError(STRSUBSTNO(Text062, GenJnlLine.FIELDCAPTION(Amount)));
        end;
    end;
    local procedure CheckAgainstPrevLines(GenJnlLine: Record "Gen. Journal Line")
    var
        i: Integer;
        AccNo: Code[20];
        ErrorFound: Boolean;
        AccType: Enum "Gen. Journal Account Type";
    begin
        if(GenJnlLine."External Document No." = '') or not(GenJnlLine."Account Type" in[GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor]) and not(GenJnlLine."Bal. Account Type" in[GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor])then exit;
        if GenJnlLine."Account Type" in[GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor]then begin
            AccType:=GenJnlLine."Account Type";
            AccNo:=GenJnlLine."Account No.";
        end
        else
        begin
            AccType:=GenJnlLine."Bal. Account Type";
            AccNo:=GenJnlLine."Bal. Account No.";
        end;
        TempGenJnlLine.RESET();
        TempGenJnlLine.SETRANGE("External Document No.", GenJnlLine."External Document No.");
        while(i < 2) and not ErrorFound do begin
            i:=i + 1;
            if i = 1 then begin
                TempGenJnlLine.SETRANGE("Account Type", AccType);
                TempGenJnlLine.SETRANGE("Account No.", AccNo);
                TempGenJnlLine.SETRANGE("Bal. Account Type");
                TempGenJnlLine.SETRANGE("Bal. Account No.");
            end
            else
            begin
                TempGenJnlLine.SETRANGE("Account Type");
                TempGenJnlLine.SETRANGE("Account No.");
                TempGenJnlLine.SETRANGE("Bal. Account Type", AccType);
                TempGenJnlLine.SETRANGE("Bal. Account No.", AccNo);
            end;
            if TempGenJnlLine.FINDFIRST()then begin
                ErrorFound:=true;
                AddError(STRSUBSTNO(Text064, GenJnlLine.FIELDCAPTION("External Document No."), GenJnlLine."External Document No.", TempGenJnlLine."Line No.", GenJnlLine.FIELDCAPTION("Document No."), TempGenJnlLine."Document No."));
            end;
        end;
        TempGenJnlLine.RESET();
        TempGenJnlLine:=GenJnlLine;
        TempGenJnlLine.INSERT();
    end;
    local procedure CheckICDocument()
    var
        GenJnlLine4: Record "Gen. Journal Line";
        ICGLAccount: Record "IC G/L Account";
    begin
        //WITH "Gen. Journal Line" DO
        if GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany then begin
            if("Gen. Journal Line"."Posting Date" <> LastDate) or ("Gen. Journal Line"."Document Type" <> LastDocType) or ("Gen. Journal Line"."Document No." <> LastDocNo)then begin
                GenJnlLine4.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                GenJnlLine4.SETRANGE("Journal Template Name", "Gen. Journal Line"."Journal Template Name");
                GenJnlLine4.SETRANGE("Journal Batch Name", "Gen. Journal Line"."Journal Batch Name");
                GenJnlLine4.SETRANGE("Posting Date", "Gen. Journal Line"."Posting Date");
                GenJnlLine4.SETRANGE("Document No.", "Gen. Journal Line"."Document No.");
                GenJnlLine4.SETFILTER("IC Partner Code", '<>%1', '');
                if GenJnlLine4.FINDFIRST()then CurrentICPartner:=GenJnlLine4."IC Partner Code"
                else
                    CurrentICPartner:='';
            end;
            if(CurrentICPartner <> '') and ("Gen. Journal Line"."IC Direction" = "Gen. Journal Line"."IC Direction"::Outgoing)then begin
                if("Gen. Journal Line"."Account Type" in["Gen. Journal Line"."Account Type"::"G/L Account", "Gen. Journal Line"."Account Type"::"Bank Account"]) and ("Gen. Journal Line"."Bal. Account Type" in["Gen. Journal Line"."Bal. Account Type"::"G/L Account", "Gen. Journal Line"."Account Type"::"Bank Account"]) and ("Gen. Journal Line"."Account No." <> '') and ("Gen. Journal Line"."Bal. Account No." <> '')then AddError(STRSUBSTNO(Text066, "Gen. Journal Line".FIELDCAPTION("Account No."), "Gen. Journal Line".FIELDCAPTION("Bal. Account No.")))
                else if(("Gen. Journal Line"."Account Type" in["Gen. Journal Line"."Account Type"::"G/L Account", "Gen. Journal Line"."Account Type"::"Bank Account"]) and ("Gen. Journal Line"."Account No." <> '')) xor (("Gen. Journal Line"."Bal. Account Type" in["Gen. Journal Line"."Bal. Account Type"::"G/L Account", "Gen. Journal Line"."Account Type"::"Bank Account"]) and ("Gen. Journal Line"."Bal. Account No." <> ''))then begin
                        if "Gen. Journal Line"."IC Account No." = '' then AddError(STRSUBSTNO(Text002, "Gen. Journal Line".FIELDCAPTION("IC Account No.")))
                        else if ICGLAccount.GET("Gen. Journal Line"."IC Account No.")then if ICGLAccount.Blocked then AddError(STRSUBSTNO(Text032, ICGLAccount.FIELDCAPTION(Blocked), false, "Gen. Journal Line".FIELDCAPTION("IC Account No."), "Gen. Journal Line"."IC Account No."));
                    end
                    else if "Gen. Journal Line"."IC Account No." <> '' then AddError(STRSUBSTNO(Text009, "Gen. Journal Line".FIELDCAPTION("IC Account No.")));
            end
            else if "Gen. Journal Line"."IC Account No." <> '' then begin
                    if "Gen. Journal Line"."IC Direction" = "Gen. Journal Line"."IC Direction"::Incoming then AddError(STRSUBSTNO(Text069, "Gen. Journal Line".FIELDCAPTION("IC Account No."), "Gen. Journal Line".FIELDCAPTION("IC Direction"), FORMAT("Gen. Journal Line"."IC Direction")));
                    if CurrentICPartner = '' then AddError(STRSUBSTNO(Text070, "Gen. Journal Line".FIELDCAPTION("IC Account No.")));
                end;
        //END;
        end;
    end;
    local procedure TestJobFields(var GenJnlLine: Record "Gen. Journal Line")
    var
        Job: Record Job;
        JT: Record "Job Task";
    begin
        //WITH GenJnlLine DO BEGIN
        if(GenJnlLine."Job No." = '') or (GenJnlLine."Account Type" <> GenJnlLine."Account Type"::"G/L Account")then exit;
        if not Job.GET(GenJnlLine."Job No.")then AddError(STRSUBSTNO(Text071, Job.TABLECAPTION, GenJnlLine."Job No."))
        else if Job.Blocked <> Job.Blocked::" " then AddError(STRSUBSTNO(Text072, Job.FIELDCAPTION(Blocked), Job.Blocked, Job.TABLECAPTION, GenJnlLine."Job No."));
        if GenJnlLine."Job Task No." = '' then AddError(STRSUBSTNO(Text002, GenJnlLine.FIELDCAPTION("Job Task No.")))
        else if not JT.GET(GenJnlLine."Job No.", GenJnlLine."Job Task No.")then AddError(STRSUBSTNO(Text071, JT.TABLECAPTION, GenJnlLine."Job Task No.")) //END;
    end;
    local procedure CheckFADocNo(GenJnlLine: Record "Gen. Journal Line")
    var
        _recDeprBook: Record "Depreciation Book";
        FAJnlLine: Record "FA Journal Line";
        OldFALedgEntry: Record "FA Ledger Entry";
        OldMaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        FANo: Code[20];
    begin
        //WITH GenJnlLine DO BEGIN
        if GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Fixed Asset" then FANo:=GenJnlLine."Account No.";
        if GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Fixed Asset" then FANo:=GenJnlLine."Bal. Account No.";
        if(FANo = '') or (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::" ") or (GenJnlLine."Depreciation Book Code" = '') or (GenJnlLine."Document No." = '')then exit;
        if not _recDeprBook.GET(GenJnlLine."Depreciation Book Code")then exit; //
        if _recDeprBook."Allow Identical Document No." then exit; //
        FAJnlLine."FA Posting Type":="FA Journal Line FA Posting Type".FromInteger(GenJnlLine."FA Posting Type".AsInteger() - 1);
        if GenJnlLine."FA Posting Type" <> GenJnlLine."FA Posting Type"::Maintenance then begin
            OldFALedgEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "FA Posting Category", "FA Posting Type", "Document No.");
            OldFALedgEntry.SETRANGE("FA No.", FANo);
            OldFALedgEntry.SETRANGE("Depreciation Book Code", GenJnlLine."Depreciation Book Code");
            OldFALedgEntry.SETRANGE("FA Posting Category", OldFALedgEntry."FA Posting Category"::" ");
            OldFALedgEntry.SETRANGE("FA Posting Type", FAJnlLine.ConvertToLedgEntry(FAJnlLine));
            OldFALedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
            if not OldFALedgEntry.IsEmpty()then //OldFALedgEntry.FINDFIRST() then 
 AddError(STRSUBSTNO(Text073, GenJnlLine.FIELDCAPTION("Document No."), GenJnlLine."Document No."));
        end
        else
        begin
            OldMaintenanceLedgEntry.SETCURRENTKEY("FA No.", "Depreciation Book Code", "Document No.");
            OldMaintenanceLedgEntry.SETRANGE("FA No.", FANo);
            OldMaintenanceLedgEntry.SETRANGE("Depreciation Book Code", GenJnlLine."Depreciation Book Code");
            OldMaintenanceLedgEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
            if not OldMaintenanceLedgEntry.IsEmpty()then //OldMaintenanceLedgEntry.FINDFIRST() then 
 AddError(STRSUBSTNO(Text073, GenJnlLine.FIELDCAPTION("Document No."), GenJnlLine."Document No."));
        end;
    //END;
    end;
    procedure InitializeRequest(NewShowDim: Boolean)
    begin
        ShowDim:=NewShowDim;
    end;
    local procedure GetDimensionText(var DimensionSetEntry: Record "Dimension Set Entry"): Text[75]var
        DimensionText: Text[75];
        Separator: Code[10];
        DimValue: Text[45];
    begin
        Separator:='';
        DimValue:='';
        Continue:=false;
        repeat DimValue:=STRSUBSTNO('%1 - %2', DimensionSetEntry."Dimension Code", DimensionSetEntry."Dimension Value Code");
            if MAXSTRLEN(DimensionText) < STRLEN(DimensionText + Separator + DimValue)then begin
                Continue:=true;
                exit(DimensionText);
            end;
            DimensionText:=Copystr(DimensionText + Separator + DimValue, 1, MaxStrLen(DimensionText)); //
            Separator:='; ';
        until DimSetEntry.NEXT() = 0;
        exit(DimensionText);
    end;
    local procedure CheckAccountTypes(AccountType: Enum "Gen. Journal Account Type"; var Name: Text[100]);
    begin
        case AccountType of AccountType::"G/L Account": CheckGLAcc("Gen. Journal Line", Name);
        AccountType::Customer: CheckCust("Gen. Journal Line", Name);
        AccountType::Vendor: CheckVend("Gen. Journal Line", Name);
        AccountType::"Bank Account": CheckBankAcc("Gen. Journal Line", Name);
        AccountType::"Fixed Asset": CheckFixedAsset("Gen. Journal Line", Name);
        AccountType::"IC Partner": CheckICPartner("Gen. Journal Line", Name);
        AccountType::Employee: CheckEmployee("Gen. Journal Line", Name);
        end;
    end;
    local procedure GetLastEnteredDocumentNo(var FromGenJournalLine: Record "Gen. Journal Line"): Code[20]var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.COPYFILTERS(FromGenJournalLine);
        GenJournalLine.SETCURRENTKEY("Document No.");
        if GenJournalLine.FINDLAST()then;
        exit(GenJournalLine."Document No.");
    end;
    local procedure IsGapInNosForDocNo(var FromGenJournalLine: Record "Gen. Journal Line"): Boolean var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if LastEnteredDocNo = '' then exit(false);
        if FromGenJournalLine."Document No." = LastEnteredDocNo then exit(false);
        GenJournalLine.COPYFILTERS(FromGenJournalLine);
        GenJournalLine.SETRANGE("Document No.", INCSTR(FromGenJournalLine."Document No."));
        exit(GenJournalLine.ISEMPTY);
    end;
}
