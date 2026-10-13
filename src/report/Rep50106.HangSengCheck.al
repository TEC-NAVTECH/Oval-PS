report 50106 "Hang Seng Check"
{
    // version NAVW113.05
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Hang Seng Check.rdl';
    Caption = 'Hang Seng Check';
    Permissions = tabledata 270=m;
    UsageCategory = None; //Upgrade OP Code

    dataset
    {
        dataitem(VoidGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;
            trigger OnPreDataItem()
            begin
                //IF CurrReport.PREVIEW THEN
                //    ERROR(Text000);
                if UseCheckNo = '' then ERROR(Text001);
                if TestPrint then CurrReport.BREAK();
                if not ReprintChecks then CurrReport.BREAK();
                //IF (GETFILTER("Line No.") <> '') OR (GETFILTER("Document No.") <> '') THEN
                //  ERROR(
                //  Text002, FIELDCAPTION("Line No."), FIELDCAPTION("Document No."));
                SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SETRANGE("Check Printed", true);
            end;
        }
        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");

            column(JournalTempName_GenJnlLine; "Journal Template Name")
            {
            }
            column(JournalBatchName_GenJnlLine; "Journal Batch Name")
            {
            }
            column(LineNo_GenJnlLine; "Line No.")
            {
            }
            dataitem(CheckPages; Integer)
            {
                DataItemTableView = sorting(Number);

                column(CheckToAddr1; CheckToAddr[1])
                {
                }
                column(CheckDateText; CheckDateText)
                {
                }
                column(CheckDate; CheckDate)
                {
                }
                column(CheckDateMonth; CheckDateMonth)
                {
                }
                column(CheckDateYear; CheckDateYear)
                {
                }
                column(CheckNoText; CheckNoText)
                {
                }
                column(FirstPage; FirstPage)
                {
                }
                column(PreprintedStub; PreprintedStub)
                {
                }
                column(CheckNoTextCaption; CheckNoTextCaptionLbl)
                {
                }
                dataitem(PrintSettledLoop; Integer)
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 30;

                    column(NetAmount; NetAmount)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(TotalLineDiscountLineDiscount; TotalLineDiscount - LineDiscount)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(TotalLineAmountLineAmount; TotalLineAmount - LineAmount)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(TotalLineAmountLineAmount2; TotalLineAmount - LineAmount2)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(LineAmount; LineAmount)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(LineDiscount; LineDiscount)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(LineAmountLineDiscount; LineAmount + LineDiscount)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(DocNo; DocNo)
                    {
                    }
                    column(DocDate; DocDate)
                    {
                    }
                    column(CurrencyCode2; CurrencyCode2)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(CurrentLineAmount; CurrentLineAmount)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(ExtDocNo; ExtDocNo)
                    {
                    }
                    column(LineAmountCaption; LineAmountCaptionLbl)
                    {
                    }
                    column(LineDiscountCaption; LineDiscountCaptionLbl)
                    {
                    }
                    column(AmountCaption; AmountCaptionLbl)
                    {
                    }
                    column(DocNoCaption; DocNoCaptionLbl)
                    {
                    }
                    column(DocDateCaption; DocDateCaptionLbl)
                    {
                    }
                    column(CurrencyCodeCaption; CurrencyCodeCaptionLbl)
                    {
                    }
                    column(YourDocNoCaption; YourDocNoCaptionLbl)
                    {
                    }
                    column(TransportCaption; TransportCaptionLbl)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if not TestPrint then begin
                            if FoundLast or not AddedRemainingAmount then begin
                                if RemainingAmount <> 0 then begin
                                    AddedRemainingAmount:=true;
                                    FoundLast:=true;
                                    DocNo:='';
                                    ExtDocNo:='';
                                    DocDate:=0D;
                                    LineAmount:=RemainingAmount;
                                    LineAmount2:=RemainingAmount;
                                    CurrentLineAmount:=LineAmount2;
                                    LineDiscount:=0;
                                    RemainingAmount:=0;
                                end
                                else
                                    CurrReport.BREAK();
                            end
                            else
                                case ApplyMethod of ApplyMethod::OneLineOneEntry: begin
                                    case BalancingType of BalancingType::Customer: PrintOneLineOneEntryOnAfterGetRecordForCustomer(CustLedgEntry);
                                    BalancingType::Vendor: PrintOneLineOneEntryOnAfterGetRecordForVendor(VendLedgEntry);
                                    BalancingType::Employee: PrintOneLineOneEntryOnAfterGetRecordForEmployee(EmployeeLedgerEntry);
                                    end;
                                    RemainingAmount:=RemainingAmount - LineAmount2;
                                    CurrentLineAmount:=LineAmount2;
                                    FoundLast:=true;
                                end;
                                ApplyMethod::OneLineID: begin
                                    case BalancingType of BalancingType::Customer: begin
                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                        FoundLast:=(CustLedgEntry.NEXT() = 0) or (RemainingAmount <= 0);
                                        if FoundLast and not FoundNegative then begin
                                            CustLedgEntry.SETRANGE(Positive, false);
                                            FoundLast:=not CustLedgEntry.FIND('-');
                                            FoundNegative:=true;
                                        end;
                                    end;
                                    BalancingType::Vendor: begin
                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                        FoundLast:=(VendLedgEntry.NEXT() = 0) or (RemainingAmount <= 0);
                                        if FoundLast and not FoundNegative then begin
                                            VendLedgEntry.SETRANGE(Positive, false);
                                            FoundLast:=not VendLedgEntry.FIND('-');
                                            FoundNegative:=true;
                                        end;
                                    end;
                                    end;
                                    RemainingAmount:=RemainingAmount - LineAmount2;
                                    CurrentLineAmount:=LineAmount2;
                                    AddedRemainingAmount:=not(FoundLast and (RemainingAmount > 0));
                                end;
                                ApplyMethod::MoreLinesOneEntry: begin
                                    CurrentLineAmount:=GenJnlLine2.Amount;
                                    LineAmount2:=CurrentLineAmount;
                                    if GenJnlLine2."Applies-to ID" <> '' then ERROR(Text016);
                                    GenJnlLine2.TESTFIELD("Check Printed", false);
                                    GenJnlLine2.TESTFIELD("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");
                                    if BankAcc2."Currency Code" <> GenJnlLine2."Currency Code" then ERROR(Text005);
                                    if GenJnlLine2."Applies-to Doc. No." = '' then begin
                                        DocNo:='';
                                        ExtDocNo:='';
                                        DocDate:=0D;
                                        LineAmount:=CurrentLineAmount;
                                        LineDiscount:=0;
                                    end
                                    else
                                        case BalancingType of BalancingType::"G/L Account": begin
                                            DocNo:=GenJnlLine2."Document No.";
                                            ExtDocNo:=GenJnlLine2."External Document No.";
                                            LineAmount:=CurrentLineAmount;
                                            LineDiscount:=0;
                                        end;
                                        BalancingType::Customer: begin
                                            CustLedgEntry.RESET();
                                            CustLedgEntry.SETCURRENTKEY("Document No.");
                                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                            CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                            CustLedgEntry.FIND('-');
                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                            LineAmount:=CurrentLineAmount;
                                        end;
                                        BalancingType::Vendor: begin
                                            VendLedgEntry.RESET();
                                            if GenJnlLine2."Source Line No." <> 0 then VendLedgEntry.SETRANGE("Entry No.", GenJnlLine2."Source Line No.")
                                            else
                                            begin
                                                VendLedgEntry.SETCURRENTKEY("Document No.");
                                                VendLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                VendLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                            end;
                                            VendLedgEntry.FIND('-');
                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                            LineAmount:=CurrentLineAmount;
                                        end;
                                        BalancingType::"Bank Account": begin
                                            DocNo:=GenJnlLine2."Document No.";
                                            ExtDocNo:=GenJnlLine2."External Document No.";
                                            LineAmount:=CurrentLineAmount;
                                            LineDiscount:=0;
                                        end;
                                        BalancingType::Employee: begin
                                            EmployeeLedgerEntry.RESET();
                                            if GenJnlLine2."Source Line No." <> 0 then EmployeeLedgerEntry.SETRANGE("Entry No.", GenJnlLine2."Source Line No.")
                                            else
                                            begin
                                                EmployeeLedgerEntry.SETCURRENTKEY("Document No.");
                                                EmployeeLedgerEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                EmployeeLedgerEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                EmployeeLedgerEntry.SETRANGE("Employee No.", BalancingNo);
                                            end;
                                            EmployeeLedgerEntry.FINDFIRST();
                                            EmployeeUpdateAmounts(EmployeeLedgerEntry, CurrentLineAmount);
                                            LineAmount:=CurrentLineAmount;
                                        end;
                                        end;
                                    FoundLast:=GenJnlLine2.NEXT() = 0;
                                end;
                                end;
                            TotalLineAmount:=TotalLineAmount + LineAmount2;
                            TotalLineDiscount:=TotalLineDiscount + LineDiscount;
                        end
                        else
                        begin
                            if FoundLast then CurrReport.BREAK();
                            FoundLast:=true;
                            DocNo:=Text010;
                            ExtDocNo:=Text010;
                            LineAmount:=0;
                            LineDiscount:=0;
                        end;
                    end;
                    trigger OnPreDataItem()
                    begin
                        if not TestPrint then if FirstPage then begin
                                FoundLast:=true;
                                case ApplyMethod of ApplyMethod::OneLineOneEntry: FoundLast:=false;
                                ApplyMethod::OneLineID: case BalancingType of BalancingType::Customer: begin
                                        CustLedgEntry.RESET();
                                        CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
                                        CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                        CustLedgEntry.SETRANGE(Open, true);
                                        CustLedgEntry.SETRANGE(Positive, true);
                                        CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                        FoundLast:=not CustLedgEntry.FIND('-');
                                        if FoundLast then begin
                                            CustLedgEntry.SETRANGE(Positive, false);
                                            FoundLast:=not CustLedgEntry.FIND('-');
                                            FoundNegative:=true;
                                        end
                                        else
                                            FoundNegative:=false;
                                    end;
                                    BalancingType::Vendor: begin
                                        VendLedgEntry.RESET();
                                        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                                        VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                        VendLedgEntry.SETRANGE(Open, true);
                                        VendLedgEntry.SETRANGE(Positive, true);
                                        VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                        FoundLast:=not VendLedgEntry.FIND('-');
                                        if FoundLast then begin
                                            VendLedgEntry.SETRANGE(Positive, false);
                                            FoundLast:=not VendLedgEntry.FIND('-');
                                            FoundNegative:=true;
                                        end
                                        else
                                            FoundNegative:=false;
                                    end;
                                    end;
                                ApplyMethod::MoreLinesOneEntry: FoundLast:=false;
                                end;
                            end
                            else
                                FoundLast:=false;
                        if DocNo = '' then CurrencyCode2:=GenJnlLine."Currency Code";
                        if PreprintedStub then TotalText:=''
                        else
                            TotalText:=Text019;
                        if GenJnlLine."Currency Code" <> '' then NetAmount:=STRSUBSTNO(Text063, GenJnlLine."Currency Code")
                        else
                        begin
                            GLSetup.GET();
                            NetAmount:=STRSUBSTNO(Text063, GLSetup."LCY Code");
                        end;
                    end;
                }
                dataitem(PrintCheck; Integer)
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 1;

                    column(CheckAmountText; CheckAmountText)
                    {
                    }
                    column(CheckDateTextControl2; CheckDateText)
                    {
                    }
                    column(DescriptionLine2; DescriptionLine[2])
                    {
                    }
                    column(DescriptionLine1; DescriptionLine[1])
                    {
                    }
                    column(CheckToAddr1Control7; CheckToAddr[1])
                    {
                    }
                    column(CheckToAddr2; CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr4; CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr3; CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr5; CheckToAddr[5])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr8; CompanyAddr[8])
                    {
                    }
                    column(CompanyAddr7; CompanyAddr[7])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CheckNoTextControl21; CheckNoText)
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(TotalLineAmount; TotalLineAmount)
                    {
                    AutoFormatExpression = GenJnlLine."Currency Code";
                    AutoFormatType = 1;
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(VoidText; VoidText)
                    {
                    }
                    trigger OnAfterGetRecord()
                    var
                        Decimals: Decimal;
                        CheckLedgEntryAmount: Decimal;
                    begin
                        if not TestPrint then begin
                            //WITH GenJnlLine DO BEGIN
                            CheckLedgEntry.INIT();
                            CheckLedgEntry."Bank Account No.":=BankAcc2."No.";
                            CheckLedgEntry."Posting Date":=GenJnlLine."Posting Date";
                            CheckLedgEntry."Document Type":=GenJnlLine."Document Type";
                            CheckLedgEntry."Document No.":=UseCheckNo;
                            CheckLedgEntry.Description:=GenJnlLine.Description;
                            CheckLedgEntry."Bank Payment Type":=GenJnlLine."Bank Payment Type";
                            CheckLedgEntry."Bal. Account Type":=BalancingType;
                            CheckLedgEntry."Bal. Account No.":=BalancingNo;
                            if FoundLast and AddedRemainingAmount then begin
                                if TotalLineAmount <= 0 then ERROR(Text020, UseCheckNo, TotalLineAmount);
                                CheckLedgEntry."Entry Status":=CheckLedgEntry."Entry Status"::Printed;
                                CheckLedgEntry.Amount:=TotalLineAmount;
                            end
                            else
                            begin
                                CheckLedgEntry."Entry Status":=CheckLedgEntry."Entry Status"::Voided;
                                CheckLedgEntry.Amount:=0;
                            end;
                            CheckLedgEntry."Check Date":=GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No.":=UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, RECORDID);
                            if FoundLast and AddedRemainingAmount then begin
                                if BankAcc2."Currency Code" <> '' then Currency.GET(BankAcc2."Currency Code")
                                else
                                    Currency.InitRoundingPrecision();
                                CheckLedgEntryAmount:=CheckLedgEntry.Amount;
                                Decimals:=CheckLedgEntry.Amount - ROUND(CheckLedgEntry.Amount, 1, '<');
                                if STRLEN(FORMAT(Decimals)) < STRLEN(FORMAT(Currency."Amount Rounding Precision"))then if Decimals = 0 then CheckAmountText:=FORMAT(CheckLedgEntryAmount, 0, 0) + COPYSTR(FORMAT(0.01), 2, 1) + PADSTR('', STRLEN(FORMAT(Currency."Amount Rounding Precision")) - 2, '0')
                                    else
                                        CheckAmountText:=Copystr(FORMAT(CheckLedgEntryAmount, 0, 0) + PADSTR('', STRLEN(FORMAT(Currency."Amount Rounding Precision")) - STRLEN(FORMAT(Decimals)), '0'), 1, MaxStrLen(CheckAmountText)) //
                                else
                                    CheckAmountText:=FORMAT(CheckLedgEntryAmount, 0, 0);
                                FormatNoText(DescriptionLine, CheckLedgEntry.Amount, BankAcc2."Currency Code");
                                if StrPos(DescriptionLine[1], 'AND 0/100') <> 0 then DescriptionLine[1]:=copystr(DelStr(DescriptionLine[1], StrLen(DescriptionLine[1]) - 8, 9) + 'ONLY', 1, MaxStrLen(DescriptionLine[1])); //
                                if StrPos(DescriptionLine[2], 'AND 0/100') <> 0 then DescriptionLine[2]:=Copystr(DelStr(DescriptionLine[2], StrLen(DescriptionLine[2]) - 8, 9) + 'ONLY', 1, MaxStrLen(DescriptionLine[2])); //
                                VoidText:='';
                            end
                            else
                            begin
                                CLEAR(CheckAmountText);
                                CLEAR(DescriptionLine);
                                TotalText:=Text065;
                                DescriptionLine[1]:=Copystr(Text021, 1, MaxStrLen(DescriptionLine[1])); //
                                DescriptionLine[2]:=Copystr(DescriptionLine[1], 1, MaxStrLen(DescriptionLine[2])); //
                                VoidText:=Text022;
                            end;
                        //END;
                        end
                        else
                        begin
                            //WITH GenJnlLine. DO BEGIN
                            CheckLedgEntry.INIT();
                            CheckLedgEntry."Bank Account No.":=BankAcc2."No.";
                            CheckLedgEntry."Posting Date":=GenJnlLine."Posting Date";
                            CheckLedgEntry."Document No.":=UseCheckNo;
                            CheckLedgEntry.Description:=Text023;
                            CheckLedgEntry."Bank Payment Type":="Bank Payment Type"::"Computer Check";
                            CheckLedgEntry."Entry Status":=CheckLedgEntry."Entry Status"::"Test Print";
                            CheckLedgEntry."Check Date":=GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No.":=UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, RECORDID);
                            CheckAmountText:=Text024;
                            DescriptionLine[1]:=Text025;
                            DescriptionLine[2]:=DescriptionLine[1];
                            VoidText:=Text022;
                        end;
                        ChecksPrinted:=ChecksPrinted + 1;
                        FirstPage:=false;
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    if FoundLast and AddedRemainingAmount then CurrReport.BREAK();
                    UseCheckNo:=INCSTR(UseCheckNo);
                    if not TestPrint then CheckNoText:=UseCheckNo
                    else
                        CheckNoText:=Text011;
                end;
                trigger OnPostDataItem()
                var
                    RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
                begin
                    if not TestPrint then begin
                        if UseCheckNo <> GenJnlLine."Document No." then begin
                            GenJnlLine3.RESET();
                            GenJnlLine3.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3.SETRANGE("Document No.", UseCheckNo);
                            if GenJnlLine3.FIND('-')then GenJnlLine3.FIELDERROR("Document No.", STRSUBSTNO(Text013, UseCheckNo));
                        end;
                        if ApplyMethod <> ApplyMethod::MoreLinesOneEntry then begin
                            GenJnlLine3:=GenJnlLine;
                            GenJnlLine3.TESTFIELD("Posting No. Series", '');
                            GenJnlLine3."Document No.":=UseCheckNo;
                            GenJnlLine3."Check Printed":=true;
                            GenJnlLine3.MODIFY();
                        end
                        else
                        begin
                            if GenJnlLine2.FIND('-')then begin
                                HighestLineNo:=GenJnlLine2."Line No.";
                                repeat RecordRestrictionMgt.CheckRecordHasUsageRestrictions(GenJnlLine2);
                                    if GenJnlLine2."Line No." > HighestLineNo then HighestLineNo:=GenJnlLine2."Line No.";
                                    GenJnlLine3:=GenJnlLine2;
                                    GenJnlLine3.TESTFIELD("Posting No. Series", '');
                                    GenJnlLine3."Bal. Account No.":='';
                                    GenJnlLine3."Bank Payment Type":=GenJnlLine3."Bank Payment Type"::" ";
                                    GenJnlLine3."Document No.":=UseCheckNo;
                                    GenJnlLine3."Check Printed":=true;
                                    GenJnlLine3.VALIDATE(Amount);
                                    GenJnlLine3.MODIFY();
                                until GenJnlLine2.NEXT() = 0;
                            end;
                            GenJnlLine3.RESET();
                            GenJnlLine3:=GenJnlLine;
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3."Line No.":=HighestLineNo;
                            if GenJnlLine3.NEXT() = 0 then GenJnlLine3."Line No.":=HighestLineNo + 10000
                            else
                            begin
                                while GenJnlLine3."Line No." = HighestLineNo + 1 do begin
                                    HighestLineNo:=GenJnlLine3."Line No.";
                                    if GenJnlLine3.NEXT() = 0 then GenJnlLine3."Line No.":=HighestLineNo + 20000;
                                end;
                                GenJnlLine3."Line No.":=(GenJnlLine3."Line No." + HighestLineNo) div 2;
                            end;
                            GenJnlLine3.INIT();
                            GenJnlLine3.VALIDATE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3."Document Type":=GenJnlLine."Document Type";
                            GenJnlLine3."Document No.":=UseCheckNo;
                            GenJnlLine3."Account Type":=GenJnlLine3."Account Type"::"Bank Account";
                            GenJnlLine3.VALIDATE("Account No.", BankAcc2."No.");
                            if BalancingType <> BalancingType::"G/L Account" then GenJnlLine3.Description:=StrSubstNo(Text014, BalancingType, BalancingNo);
                            GenJnlLine3.VALIDATE(Amount, -TotalLineAmount);
                            GenJnlLine3."Bank Payment Type":=GenJnlLine3."Bank Payment Type"::"Computer Check";
                            GenJnlLine3."Check Printed":=true;
                            GenJnlLine3."Source Code":=GenJnlLine."Source Code";
                            GenJnlLine3."Reason Code":=GenJnlLine."Reason Code";
                            GenJnlLine3."Allow Zero-Amount Posting":=true;
                            GenJnlLine3.INSERT();
                            if CheckGenJournalBatchAndLineIsApproved(GenJnlLine)then RecordRestrictionMgt.AllowRecordUsage(GenJnlLine3);
                        end;
                    end;
                    BankAcc2."Last Check No.":=UseCheckNo;
                    BankAcc2.MODIFY();
                    CLEAR(CheckManagement);
                end;
                trigger OnPreDataItem()
                begin
                    FirstPage:=true;
                    FoundLast:=false;
                    TotalLineAmount:=0;
                    TotalLineDiscount:=0;
                    AddedRemainingAmount:=true;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if OneCheckPrVendor and ("Currency Code" <> '') and ("Currency Code" <> Currency.Code)then begin
                    Currency.GET("Currency Code");
                    Currency.TESTFIELD("Conv. LCY Rndg. Debit Acc.");
                    Currency.TESTFIELD("Conv. LCY Rndg. Credit Acc.");
                end;
                JournalPostingDate:="Posting Date";
                if "Bank Payment Type" = "Bank Payment Type"::"Computer Check" then TESTFIELD("Exported to Payment File", false);
                if not TestPrint then begin
                    if Amount = 0 then CurrReport.SKIP();
                    TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                    if "Bal. Account No." <> BankAcc2."No." then CurrReport.SKIP();
                    if("Account No." <> '') and ("Bal. Account No." <> '')then begin
                        BalancingType:="Account Type";
                        BalancingNo:="Account No.";
                        RemainingAmount:=Amount;
                        if OneCheckPrVendor then begin
                            ApplyMethod:=ApplyMethod::MoreLinesOneEntry;
                            GenJnlLine2.RESET();
                            GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine2.SETRANGE("Journal Template Name", "Journal Template Name");
                            GenJnlLine2.SETRANGE("Journal Batch Name", "Journal Batch Name");
                            GenJnlLine2.SETRANGE("Posting Date", "Posting Date");
                            GenJnlLine2.SETRANGE("Document No.", "Document No.");
                            GenJnlLine2.SETRANGE("Account Type", "Account Type");
                            GenJnlLine2.SETRANGE("Account No.", "Account No.");
                            GenJnlLine2.SETRANGE("Bal. Account Type", "Bal. Account Type");
                            GenJnlLine2.SETRANGE("Bal. Account No.", "Bal. Account No.");
                            GenJnlLine2.SETRANGE("Bank Payment Type", "Bank Payment Type");
                            GenJnlLine2.FIND('-');
                            RemainingAmount:=0;
                        end
                        else if "Applies-to Doc. No." <> '' then ApplyMethod:=ApplyMethod::OneLineOneEntry
                            else if "Applies-to ID" <> '' then ApplyMethod:=ApplyMethod::OneLineID
                                else
                                    ApplyMethod:=ApplyMethod::Payment;
                    end
                    else if "Account No." = '' then FIELDERROR("Account No.", Text004)
                        else
                            FIELDERROR("Bal. Account No.", Text004);
                    CLEAR(CheckToAddr);
                    CLEAR(SalesPurchPerson);
                    case BalancingType of BalancingType::"G/L Account": CheckToAddr[1]:=Description;
                    BalancingType::Customer: begin
                        Cust.GET(BalancingNo);
                        if Cust."Privacy Blocked" then ERROR(Cust.GetPrivacyBlockedGenericErrorText(Cust));
                        if Cust.Blocked = Cust.Blocked::All then ERROR(Text064, Cust.FIELDCAPTION(Blocked), Cust.Blocked, Cust.TABLECAPTION, Cust."No.");
                        Cust.Contact:='';
                        FormatAddr.Customer(CheckToAddr, Cust);
                        if BankAcc2."Currency Code" <> "Currency Code" then ERROR(Text005);
                        if Cust."Salesperson Code" <> '' then SalesPurchPerson.GET(Cust."Salesperson Code");
                    end;
                    BalancingType::Vendor: begin
                        Vend.GET(BalancingNo);
                        if Vend."Privacy Blocked" then ERROR(Vend.GetPrivacyBlockedGenericErrorText(Vend));
                        if Vend.Blocked in[Vend.Blocked::All, Vend.Blocked::Payment]then ERROR(Text064, Vend.FIELDCAPTION(Blocked), Vend.Blocked, Vend.TABLECAPTION, Vend."No.");
                        Vend.Contact:='';
                        FormatAddr.Vendor(CheckToAddr, Vend);
                        if BankAcc2."Currency Code" <> "Currency Code" then ERROR(Text005);
                        if Vend."Purchaser Code" <> '' then SalesPurchPerson.GET(Vend."Purchaser Code");
                    end;
                    BalancingType::"Bank Account": begin
                        BankAcc.GET(BalancingNo);
                        BankAcc.TESTFIELD(Blocked, false);
                        BankAcc.Contact:='';
                        FormatAddr.BankAcc(CheckToAddr, BankAcc);
                        if BankAcc2."Currency Code" <> BankAcc."Currency Code" then ERROR(Text008);
                        if BankAcc."Our Contact Code" <> '' then SalesPurchPerson.GET(BankAcc."Our Contact Code");
                    end;
                    BalancingType::Employee: begin
                        Employee.GET(BalancingNo);
                        if Employee."Privacy Blocked" then ERROR(BlockedEmplForCheckErr, Employee."No.");
                        FormatAddr.Employee(CheckToAddr, Employee);
                        if BankAcc2."Currency Code" <> "Currency Code" then ERROR(Text005);
                        if Employee."Salespers./Purch. Code" <> '' then SalesPurchPerson.GET(Employee."Salespers./Purch. Code");
                    end end;
                    CheckDateText:=FORMAT("Posting Date", 0, 4);
                    CheckDate:=Format(Date2DMY("Posting Date", 1));
                    CheckDateMonth:=Format(Date2DMY("Posting Date", 2));
                    CheckDateYear:=Format(Date2DMY("Posting Date", 3));
                end
                else
                begin
                    if ChecksPrinted > 0 then CurrReport.BREAK();
                    BalancingType:=BalancingType::Vendor;
                    BalancingNo:=Text010;
                    CLEAR(CheckToAddr);
                    for i:=1 to 5 do CheckToAddr[i]:=Text003;
                    CLEAR(SalesPurchPerson);
                    CheckNoText:=Text011;
                    CheckDateText:=Text012;
                end;
            end;
            trigger OnPreDataItem()
            begin
                COPY(VoidGenJnlLine);
                CompanyInfo.GET();
                if not TestPrint then begin
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.GET(BankAcc2."No.");
                    BankAcc2.TESTFIELD(Blocked, false);
                    COPY(VoidGenJnlLine);
                    SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                    SETRANGE("Check Printed", false);
                end
                else
                begin
                    CLEAR(CompanyAddr);
                    for i:=1 to 5 do CompanyAddr[i]:=Text003;
                end;
                ChecksPrinted:=0;
                SETRANGE("Account Type", "Account Type"::"Fixed Asset");
                if FIND('-')then FIELDERROR("Account Type");
                SETRANGE("Account Type");
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

                    field(BankAccount; BankAcc2."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Account';
                        TableRelation = "Bank Account";
                        ToolTip = 'Specifies the bank account that the printed checks will be drawn from.';

                        trigger OnValidate()
                        begin
                            InputBankAccount();
                        end;
                    }
                    field(LastCheckNo; UseCheckNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Last Check No.';
                        ToolTip = 'Specifies the value of the Last Check No. field on the bank account card.';
                    }
                    field(OneCheckPerVendorPerDocumentNo; OneCheckPrVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'One Check per Vendor per Document No.';
                        MultiLine = true;
                        ToolTip = 'Specifies if only one check is printed per vendor for each document number.';
                    }
                    field(ReprintChecks_; ReprintChecks)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reprint Checks';
                        ToolTip = 'Specifies if checks are printed again if you canceled the printing due to a problem.';
                    }
                    field(TestPrinting; TestPrint)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Test Print';
                        ToolTip = 'Specifies if you want to print the checks on blank paper before you print them on check forms.';
                    }
                    field(PreprintedStub_; PreprintedStub)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Preprinted Stub';
                        ToolTip = 'Specifies if you use check forms with preprinted stubs.';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()
        begin
            if BankAcc2."No." <> '' then if BankAcc2.GET(BankAcc2."No.")then UseCheckNo:=BankAcc2."Last Check No."
                else
                begin
                    BankAcc2."No.":='';
                    UseCheckNo:='';
                end;
        end;
    }
    labels
    {
    }
    trigger OnPreReport()
    begin
        InitTextVariable();
    end;
    var Text000: Label 'Preview is not allowed.';
    Text001: Label 'Last Check No. must be filled in.';
    Text002: Label 'Filters on %1 and %2 are not allowed.';
    Text003: Label 'XXXXXXXXXXXXXXXX';
    Text004: Label 'must be entered.';
    Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
    Text008: Label 'Both Bank Accounts must have the same currency.';
    Text010: Label 'XXXXXXXXXX';
    Text011: Label 'XXXX';
    Text012: Label 'XX.XXXXXXXXXX.XXXX';
    Text013: Label '%1 already exists.';
    Text014: Label 'Check for %1 %2';
    Text016: Label 'In the Check report, One Check per Vendor and Document No.\must not be activated when Applies-to ID is specified in the journal lines.';
    Text019: Label 'Total';
    Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
    Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
    Text022: Label 'NON-NEGOTIABLE';
    Text023: Label 'Test print';
    Text024: Label 'XXXX.XX';
    Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Text026: Label 'ZERO';
    Text027: Label 'HUNDRED';
    Text028: Label 'AND';
    Text029: Label '%1 results in a written number that is too long.';
    Text030: Label ' is already applied to %1 %2 for customer %3.';
    Text031: Label ' is already applied to %1 %2 for vendor %3.';
    Text032: Label 'ONE';
    Text033: Label 'TWO';
    Text034: Label 'THREE';
    Text035: Label 'FOUR';
    Text036: Label 'FIVE';
    Text037: Label 'SIX';
    Text038: Label 'SEVEN';
    Text039: Label 'EIGHT';
    Text040: Label 'NINE';
    Text041: Label 'TEN';
    Text042: Label 'ELEVEN';
    Text043: Label 'TWELVE';
    Text044: Label 'THIRTEEN';
    Text045: Label 'FOURTEEN';
    Text046: Label 'FIFTEEN';
    Text047: Label 'SIXTEEN';
    Text048: Label 'SEVENTEEN';
    Text049: Label 'EIGHTEEN';
    Text050: Label 'NINETEEN';
    Text051: Label 'TWENTY';
    Text052: Label 'THIRTY';
    Text053: Label 'FORTY';
    Text054: Label 'FIFTY';
    Text055: Label 'SIXTY';
    Text056: Label 'SEVENTY';
    Text057: Label 'EIGHTY';
    Text058: Label 'NINETY';
    Text059: Label 'THOUSAND';
    Text060: Label 'MILLION';
    Text061: Label 'BILLION';
    CompanyInfo: Record "Company Information";
    CurrencyExchangeRate: Record "Currency Exchange Rate";
    SalesPurchPerson: Record "Salesperson/Purchaser";
    GenJnlLine2: Record "Gen. Journal Line";
    GenJnlLine3: Record "Gen. Journal Line";
    Cust: Record Customer;
    CustLedgEntry: Record "Cust. Ledger Entry";
    Vend: Record Vendor;
    VendLedgEntry: Record "Vendor Ledger Entry";
    BankAcc: Record "Bank Account";
    BankAcc2: Record "Bank Account";
    CheckLedgEntry: Record "Check Ledger Entry";
    Currency: Record Currency;
    GLSetup: Record "General Ledger Setup";
    Employee: Record Employee;
    EmployeeLedgerEntry: Record "Employee Ledger Entry";
    FormatAddr: Codeunit "Format Address";
    CheckManagement: Codeunit CheckManagement;
    CompanyAddr: array[8]of Text[50];
    CheckToAddr: array[8]of Text[100]; //
    OnesText: array[20]of Text[30];
    TensText: array[10]of Text[30];
    ExponentText: array[5]of Text[30];
    //BalancingType: Option "G/L Account",Customer,Vendor,"Bank Account",,,Employee;
    BalancingType: Enum "Gen. Journal Account Type";
    BalancingNo: Code[20];
    CheckNoText: Text[30];
    CheckDateText: Text[30];
    CheckDate: Text[30];
    CheckDateMonth: Text[30];
    CheckDateYear: Text[30];
    CheckAmountText: Text[30];
    DescriptionLine: array[2]of Text[60];
    DocNo: Text[30];
    ExtDocNo: Text[35];
    VoidText: Text[30];
    LineAmount: Decimal;
    LineDiscount: Decimal;
    TotalLineAmount: Decimal;
    TotalLineDiscount: Decimal;
    RemainingAmount: Decimal;
    CurrentLineAmount: Decimal;
    UseCheckNo: Code[20];
    FoundLast: Boolean;
    ReprintChecks: Boolean;
    TestPrint: Boolean;
    FirstPage: Boolean;
    OneCheckPrVendor: Boolean;
    FoundNegative: Boolean;
    AddedRemainingAmount: Boolean;
    ApplyMethod: Option Payment, OneLineOneEntry, OneLineID, MoreLinesOneEntry;
    ChecksPrinted: Integer;
    HighestLineNo: Integer;
    PreprintedStub: Boolean;
    TotalText: Text[10];
    DocDate: Date;
    JournalPostingDate: Date;
    i: Integer;
    Text062: Label 'G/L Account,Customer,Vendor,Bank Account,,,Employee';
    CurrencyCode2: Code[10];
    NetAmount: Text[30];
    LineAmount2: Decimal;
    Text063: Label 'Net Amount %1';
    Text064: Label '%1 must not be %2 for %3 %4.';
    Text065: Label 'Subtotal';
    CheckNoTextCaptionLbl: Label 'Check No.';
    LineAmountCaptionLbl: Label 'Net Amount';
    LineDiscountCaptionLbl: Label 'Discount';
    AmountCaptionLbl: Label 'Amount';
    DocNoCaptionLbl: Label 'Document No.';
    DocDateCaptionLbl: Label 'Document Date';
    CurrencyCodeCaptionLbl: Label 'Currency Code';
    YourDocNoCaptionLbl: Label 'Your Doc. No.';
    TransportCaptionLbl: Label 'Transport';
    BlockedEmplForCheckErr: Label 'You cannot print check because employee %1 is blocked due to privacy.', Comment = '%1 - Employee no.';
    AlreadyAppliedToEmployeeErr: Label ' is already applied to %1 %2 for employee %3.', Comment = '%1 = Document type, %2 = Document No., %3 = Employee No.';
    procedure FormatNoText(var NoText: array[2]of Text[60]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
    begin
        CLEAR(NoText);
        NoTextIndex:=1;
        NoText[1]:='****';
        GLSetup.GET();
        if No < 1 then AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else
            for Exponent:=4 downto 1 do begin
                PrintExponent:=false;
                Ones:=No div POWER(1000, Exponent - 1);
                Hundreds:=Ones div 100;
                Tens:=(Ones mod 100) div 10;
                Ones:=Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end
                else if(Tens * 10 + Ones) > 0 then AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1)then AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No:=No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            end;
        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        DecimalPosition:=GetAmtDecimalPosition();
        AddToNoText(NoText, NoTextIndex, PrintExponent, (FORMAT(No * DecimalPosition) + '/' + FORMAT(DecimalPosition)));
        if CurrencyCode <> '' then AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;
    local procedure AddToNoText(var NoText: array[2]of Text[60]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent:=true;
        while STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1])do begin
            NoTextIndex:=NoTextIndex + 1;
            if NoTextIndex > ARRAYLEN(NoText)then ERROR(Text029, AddText);
        end;
        NoText[NoTextIndex]:=Copystr(DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<'), 1, MaxStrLen(NoText[NoTextIndex])); //
    end;
    local procedure CustUpdateAmounts(var CustLedgEntry2: Record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    var
        AmountToApply: Decimal;
    begin
        if(ApplyMethod = ApplyMethod::OneLineOneEntry) or (ApplyMethod = ApplyMethod::MoreLinesOneEntry)then begin
            GenJnlLine3.RESET();
            GenJnlLine3.SETCURRENTKEY("Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            CheckGLEntriesForCustomers(CustLedgEntry2);
        end;
        DocNo:=CustLedgEntry2."Document No.";
        ExtDocNo:=CustLedgEntry2."External Document No.";
        DocDate:=CustLedgEntry2."Posting Date";
        CurrencyCode2:=CustLedgEntry2."Currency Code";
        CustLedgEntry2.CALCFIELDS("Remaining Amount");
        LineAmount:=-ABSMin(CustLedgEntry2."Remaining Amount" - CustLedgEntry2."Remaining Pmt. Disc. Possible" - CustLedgEntry2."Accepted Payment Tolerance", CustLedgEntry2."Amount to Apply");
        LineAmount2:=ROUND(ExchangeAmt(GenJnlLine."Currency Code", CurrencyCode2, LineAmount), Currency."Amount Rounding Precision");
        if((CustLedgEntry2."Document Type" in[CustLedgEntry2."Document Type"::Invoice, CustLedgEntry2."Document Type"::"Credit Memo"]) and (CustLedgEntry2."Remaining Pmt. Disc. Possible" <> 0) and (CustLedgEntry2."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) or CustLedgEntry2."Accepted Pmt. Disc. Tolerance" then begin
            LineDiscount:=-CustLedgEntry2."Remaining Pmt. Disc. Possible";
            if CustLedgEntry2."Accepted Payment Tolerance" <> 0 then LineDiscount:=LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        end
        else
        begin
            AmountToApply:=ROUND(-ExchangeAmt(GenJnlLine."Currency Code", CurrencyCode2, CustLedgEntry2."Amount to Apply"), Currency."Amount Rounding Precision");
            if RemainingAmount2 >= AmountToApply then LineAmount2:=AmountToApply
            else
            begin
                LineAmount2:=RemainingAmount2;
                LineAmount:=ROUND(ExchangeAmt(CurrencyCode2, GenJnlLine."Currency Code", LineAmount2), Currency."Amount Rounding Precision");
            end;
            LineDiscount:=0;
        end;
    end;
    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    var
        AmountToApply: Decimal;
    begin
        if(ApplyMethod = ApplyMethod::OneLineOneEntry) or (ApplyMethod = ApplyMethod::MoreLinesOneEntry)then begin
            GenJnlLine3.RESET();
            GenJnlLine3.SETCURRENTKEY("Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            CheckGLEntiresForVendors(VendLedgEntry2);
        end;
        DocNo:=VendLedgEntry2."Document No.";
        ExtDocNo:=VendLedgEntry2."External Document No.";
        DocDate:=VendLedgEntry2."Posting Date";
        CurrencyCode2:=VendLedgEntry2."Currency Code";
        VendLedgEntry2.CALCFIELDS("Remaining Amount");
        LineAmount:=-ABSMin(VendLedgEntry2."Remaining Amount" - VendLedgEntry2."Remaining Pmt. Disc. Possible" - VendLedgEntry2."Accepted Payment Tolerance", VendLedgEntry2."Amount to Apply");
        LineAmount2:=ROUND(ExchangeAmt(GenJnlLine."Currency Code", CurrencyCode2, LineAmount), Currency."Amount Rounding Precision");
        if((VendLedgEntry2."Document Type" in[VendLedgEntry2."Document Type"::Invoice, VendLedgEntry2."Document Type"::"Credit Memo"]) and (VendLedgEntry2."Remaining Pmt. Disc. Possible" <> 0) and (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) or VendLedgEntry2."Accepted Pmt. Disc. Tolerance" then begin
            LineDiscount:=-VendLedgEntry2."Remaining Pmt. Disc. Possible";
            if VendLedgEntry2."Accepted Payment Tolerance" <> 0 then LineDiscount:=LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        end
        else
        begin
            AmountToApply:=ROUND(-ExchangeAmt(GenJnlLine."Currency Code", CurrencyCode2, VendLedgEntry2."Amount to Apply"), Currency."Amount Rounding Precision");
            if ABS(RemainingAmount2) >= ABS(AmountToApply)then begin
                LineAmount2:=AmountToApply;
                LineAmount:=ROUND(ExchangeAmt(CurrencyCode2, GenJnlLine."Currency Code", LineAmount2), Currency."Amount Rounding Precision");
            end
            else
            begin
                LineAmount2:=RemainingAmount2;
                LineAmount:=ROUND(ExchangeAmt(CurrencyCode2, GenJnlLine."Currency Code", LineAmount2), Currency."Amount Rounding Precision");
            end;
            LineDiscount:=0;
        end;
    end;
    local procedure EmployeeUpdateAmounts(var EmployeeLedgerEntry2: Record "Employee Ledger Entry"; RemainingAmount2: Decimal)
    var
        AmountToApply: Decimal;
    begin
        if(ApplyMethod = ApplyMethod::OneLineOneEntry) or (ApplyMethod = ApplyMethod::MoreLinesOneEntry)then begin
            GenJnlLine3.RESET();
            GenJnlLine3.SETCURRENTKEY("Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            CheckGLEntriesForEmployee(EmployeeLedgerEntry2);
        end;
        DocNo:=EmployeeLedgerEntry2."Document No.";
        DocDate:=EmployeeLedgerEntry2."Posting Date";
        CurrencyCode2:=EmployeeLedgerEntry2."Currency Code";
        EmployeeLedgerEntry2.CALCFIELDS("Remaining Amount");
        LineAmount:=-EmployeeLedgerEntry2."Remaining Amount";
        LineAmount2:=ROUND(ExchangeAmt(GenJnlLine."Currency Code", CurrencyCode2, LineAmount), Currency."Amount Rounding Precision");
        AmountToApply:=ROUND(-ExchangeAmt(GenJnlLine."Currency Code", CurrencyCode2, EmployeeLedgerEntry2."Amount to Apply"), Currency."Amount Rounding Precision");
        if(RemainingAmount2 >= AmountToApply) and (RemainingAmount2 > 0)then LineAmount2:=AmountToApply
        else
            LineAmount2:=RemainingAmount2;
        LineAmount:=ROUND(ExchangeAmt(CurrencyCode2, GenJnlLine."Currency Code", LineAmount2), Currency."Amount Rounding Precision");
        LineDiscount:=0;
    end;
    procedure InitTextVariable()
    begin
        OnesText[1]:=Text032;
        OnesText[2]:=Text033;
        OnesText[3]:=Text034;
        OnesText[4]:=Text035;
        OnesText[5]:=Text036;
        OnesText[6]:=Text037;
        OnesText[7]:=Text038;
        OnesText[8]:=Text039;
        OnesText[9]:=Text040;
        OnesText[10]:=Text041;
        OnesText[11]:=Text042;
        OnesText[12]:=Text043;
        OnesText[13]:=Text044;
        OnesText[14]:=Text045;
        OnesText[15]:=Text046;
        OnesText[16]:=Text047;
        OnesText[17]:=Text048;
        OnesText[18]:=Text049;
        OnesText[19]:=Text050;
        TensText[1]:='';
        TensText[2]:=Text051;
        TensText[3]:=Text052;
        TensText[4]:=Text053;
        TensText[5]:=Text054;
        TensText[6]:=Text055;
        TensText[7]:=Text056;
        TensText[8]:=Text057;
        TensText[9]:=Text058;
        ExponentText[1]:='';
        ExponentText[2]:=Text059;
        ExponentText[3]:=Text060;
        ExponentText[4]:=Text061;
    end;
    procedure InitializeRequest(pBankAcc: Code[20]; pLastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean) //
    begin
        if pBankAcc <> '' then if BankAcc2.GET(pBankAcc)then begin
                UseCheckNo:=pLastCheckNo;
                OneCheckPrVendor:=NewOneCheckPrVend;
                ReprintChecks:=NewReprintChecks;
                TestPrint:=NewTestPrint;
                PreprintedStub:=NewPreprintedStub;
            end;
    end;
    local procedure ExchangeAmt(CurrencyCode: Code[10]; _recCurrencyCode2: Code[10]; Amount: Decimal)Amount2: Decimal //
 begin
        if(CurrencyCode <> '') and (_recCurrencyCode2 = '')then Amount2:=CurrencyExchangeRate.ExchangeAmtLCYToFCY(JournalPostingDate, CurrencyCode, Amount, CurrencyExchangeRate.ExchangeRate(JournalPostingDate, CurrencyCode))
        else if(CurrencyCode = '') and (_recCurrencyCode2 <> '')then Amount2:=CurrencyExchangeRate.ExchangeAmtFCYToLCY(JournalPostingDate, _recCurrencyCode2, Amount, CurrencyExchangeRate.ExchangeRate(JournalPostingDate, _recCurrencyCode2))
            else if(CurrencyCode <> '') and (_recCurrencyCode2 <> '') and (CurrencyCode <> _recCurrencyCode2)then Amount2:=CurrencyExchangeRate.ExchangeAmtFCYToFCY(JournalPostingDate, _recCurrencyCode2, CurrencyCode, Amount)
                else
                    Amount2:=Amount;
    end;
    local procedure ABSMin(Decimal1: Decimal; Decimal2: Decimal): Decimal begin
        if ABS(Decimal1) < ABS(Decimal2)then exit(Decimal1);
        exit(Decimal2);
    end;
    procedure InputBankAccount()
    begin
        if BankAcc2."No." <> '' then begin
            BankAcc2.GET(BankAcc2."No.");
            BankAcc2.TESTFIELD("Last Check No.");
            UseCheckNo:=BankAcc2."Last Check No.";
        end;
    end;
    local procedure GetAmtDecimalPosition(): Decimal var
        _recCurrency: Record Currency; //
    begin
        if GenJnlLine."Currency Code" = '' then _recCurrency.InitRoundingPrecision()
        else
        begin
            _recCurrency.GET(GenJnlLine."Currency Code");
            _recCurrency.TESTFIELD("Amount Rounding Precision");
        end;
        exit(1 / _recCurrency."Amount Rounding Precision");
    end;
    local procedure CheckGenJournalBatchAndLineIsApproved(GenJournalLine: Record "Gen. Journal Line"): Boolean var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        GenJournalBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");
        exit(VerifyRecordIdIsApproved(DATABASE::"Gen. Journal Batch", GenJournalBatch.RECORDID) or VerifyRecordIdIsApproved(DATABASE::"Gen. Journal Line", GenJournalLine.RECORDID));
    end;
    local procedure VerifyRecordIdIsApproved(TableNo: Integer; RecordId: RecordId): Boolean var
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        ApprovalEntry.SETRANGE("Table ID", TableNo);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordId);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.SETRANGE("Related to Change", false);
        if ApprovalEntry.ISEMPTY then exit(false);
        exit(not ApprovalsMgmt.HasOpenOrPendingApprovalEntries(RecordId));
    end;
    local procedure PrintOneLineOneEntryOnAfterGetRecordForCustomer(CustLedgEntry1: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry1.RESET();
        CustLedgEntry1.SETCURRENTKEY("Document No.");
        CustLedgEntry1.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
        CustLedgEntry1.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
        CustLedgEntry1.SETRANGE("Customer No.", BalancingNo);
        CustLedgEntry1.FINDFIRST();
        CustUpdateAmounts(CustLedgEntry1, RemainingAmount);
    end;
    local procedure PrintOneLineOneEntryOnAfterGetRecordForVendor(VendLedgEntry1: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry1.RESET();
        VendLedgEntry1.SETCURRENTKEY("Document No.");
        VendLedgEntry1.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
        VendLedgEntry1.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
        VendLedgEntry1.SETRANGE("Vendor No.", BalancingNo);
        VendLedgEntry1.FINDFIRST();
        VendUpdateAmounts(VendLedgEntry1, RemainingAmount);
    end;
    local procedure PrintOneLineOneEntryOnAfterGetRecordForEmployee(EmployeeLedgerEntry1: Record "Employee Ledger Entry")
    begin
        EmployeeLedgerEntry1.RESET();
        EmployeeLedgerEntry1.SETCURRENTKEY("Document No.");
        EmployeeLedgerEntry1.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
        EmployeeLedgerEntry1.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
        EmployeeLedgerEntry1.SETRANGE("Employee No.", BalancingNo);
        EmployeeLedgerEntry1.FINDFIRST();
        EmployeeUpdateAmounts(EmployeeLedgerEntry1, RemainingAmount);
    end;
    local procedure CheckGLEntriesForEmployee(var EmployeeLedgerEntry3: Record "Employee Ledger Entry")
    begin
        GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Employee);
        GenJnlLine3.SETRANGE("Account No.", EmployeeLedgerEntry3."Employee No.");
        GenJnlLine3.SETRANGE("Applies-to Doc. Type", EmployeeLedgerEntry3."Document Type");
        GenJnlLine3.SETRANGE("Applies-to Doc. No.", EmployeeLedgerEntry3."Document No.");
        if ApplyMethod = ApplyMethod::OneLineOneEntry then GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
        else
            GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
        if EmployeeLedgerEntry3."Document Type" <> EmployeeLedgerEntry3."Document Type"::" " then if GenJnlLine3.FIND('-')then GenJnlLine3.FIELDERROR("Applies-to Doc. No.", STRSUBSTNO(AlreadyAppliedToEmployeeErr, EmployeeLedgerEntry3."Document Type", EmployeeLedgerEntry3."Document No.", EmployeeLedgerEntry3."Employee No."));
    end;
    local procedure CheckGLEntriesForCustomers(var CustLedgEntry3: Record "Cust. Ledger Entry")
    begin
        GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Customer);
        GenJnlLine3.SETRANGE("Account No.", CustLedgEntry3."Customer No.");
        GenJnlLine3.SETRANGE("Applies-to Doc. Type", CustLedgEntry3."Document Type");
        GenJnlLine3.SETRANGE("Applies-to Doc. No.", CustLedgEntry3."Document No.");
        if ApplyMethod = ApplyMethod::OneLineOneEntry then GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
        else
            GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
        if CustLedgEntry3."Document Type" <> CustLedgEntry3."Document Type"::" " then if GenJnlLine3.FIND('-')then GenJnlLine3.FIELDERROR("Applies-to Doc. No.", STRSUBSTNO(Text030, CustLedgEntry3."Document Type", CustLedgEntry3."Document No.", CustLedgEntry3."Customer No."));
    end;
    local procedure CheckGLEntiresForVendors(var VendLedgEntry3: Record "Vendor Ledger Entry")
    begin
        GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Vendor);
        GenJnlLine3.SETRANGE("Account No.", VendLedgEntry3."Vendor No.");
        GenJnlLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry3."Document Type");
        GenJnlLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry3."Document No.");
        if ApplyMethod = ApplyMethod::OneLineOneEntry then GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
        else
            GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
        if VendLedgEntry3."Document Type" <> VendLedgEntry3."Document Type"::" " then if GenJnlLine3.FIND('-')then GenJnlLine3.FIELDERROR("Applies-to Doc. No.", STRSUBSTNO(Text031, VendLedgEntry3."Document Type", VendLedgEntry3."Document No.", VendLedgEntry3."Vendor No."));
    end;
}
