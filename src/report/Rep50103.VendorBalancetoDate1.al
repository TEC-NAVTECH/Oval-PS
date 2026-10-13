report 50103 "Vendor - Balance to Date1"
{
    // version NAVW113.03
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Vendor - Balance to Date.rdl';
    //ApplicationArea = #Basic,#Suite;
    Caption = 'Vendor - Balance to Date';
    PreviewMode = PrintLayout;
    UsageCategory = None; //ReportsAndAnalysis; //Upgrade OP Code

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", Blocked, "Date Filter";

            column(StrNoVenGetMaxDtFilter; STRSUBSTNO(Text000, FORMAT(GETRANGEMAX("Date Filter"))))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DISPLAYNAME())
            {
            }
            column(VendFilter; VendFilter)
            {
            }
            column(PrintAmountInLCY; PrintAmountInLCY)
            {
            }
            column(PrintOnePrPage; PrintOnePrPage)
            {
            }
            column(VendorCaption; TABLECAPTION + ': ' + VendFilter)
            {
            }
            column(No_Vendor; "No.")
            {
            }
            column(Name_Vendor; Name)
            {
            }
            column(PhoneNo_Vendor; "Phone No.")
            {
            IncludeCaption = true;
            }
            column(VendorBalancetoDateCptn; VendorBalancetoDateCptnLbl)
            {
            }
            column(PageNoCaption; PageNoCaptionLbl)
            {
            }
            column(AllamountsareinLCYCaption; AllamountsareinLCYCaptionLbl)
            {
            }
            column(PostingDateCption; PostingDateCptionLbl)
            {
            }
            column(OriginalAmtCaption; OriginalAmtCaptionLbl)
            {
            }
            dataitem(VendLedgEntry3; "Vendor Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");

                column(PostDt_VendLedgEntry3; FORMAT("Posting Date"))
                {
                }
                column(DocType_VendLedgEntry3; "Document Type")
                {
                IncludeCaption = true;
                }
                column(DocNo_VendLedgEntry3; "Document No.")
                {
                IncludeCaption = true;
                }
                column(Desc_VendLedgEntry3; Description)
                {
                IncludeCaption = true;
                }
                column(OriginalAmt; OriginalAmt)
                {
                AutoFormatExpression = CurrencyCode;
                AutoFormatType = 1;
                }
                column(EntryNo_VendLedgEntry3; "Entry No.")
                {
                IncludeCaption = true;
                }
                column(CurrencyCode; CurrencyCode)
                {
                }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No."=field("Entry No."), "Posting Date"=field("Date Filter");
                    DataItemTableView = sorting("Vendor Ledger Entry No.", "Posting Date")where("Entry Type"=filter(<>"Initial Entry"));

                    column(EntryTp_DtldVendLedgEntry; "Entry Type")
                    {
                    }
                    column(PostDate_DtldVendLedEnt; FORMAT("Posting Date"))
                    {
                    }
                    column(DocType_DtldVendLedEnt; "Document Type")
                    {
                    }
                    column(DocNo_DtldVendLedgEntry; "Document No.")
                    {
                    }
                    column(Amt; Amt)
                    {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    }
                    column(CurrencyCode1; CurrencyCode)
                    {
                    }
                    column(DtldVendtLedgEntryNum; DtldVendtLedgEntryNum)
                    {
                    }
                    column(RemainingAmt; RemainingAmt)
                    {
                    AutoFormatExpression = CurrencyCode;
                    AutoFormatType = 1;
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if not PrintUnappliedEntries then if Unapplied then CurrReport.SKIP();
                        if PrintAmountInLCY then begin
                            Amt:="Amount (LCY)";
                            CurrencyCode:='';
                        end
                        else
                        begin
                            Amt:=Amount;
                            CurrencyCode:="Currency Code";
                        end;
                        if Amt = 0 then CurrReport.SKIP();
                        DtldVendtLedgEntryNum:=DtldVendtLedgEntryNum + 1;
                    end;
                    trigger OnPreDataItem()
                    begin
                        DtldVendtLedgEntryNum:=0;
                        VendLedgEntry3.COPYFILTER("Posting Date", "Posting Date");
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    if PrintAmountInLCY then begin
                        CALCFIELDS("Original Amt. (LCY)", "Remaining Amt. (LCY)");
                        OriginalAmt:="Original Amt. (LCY)";
                        RemainingAmt:="Remaining Amt. (LCY)";
                        CurrencyCode:='';
                    end
                    else
                    begin
                        CALCFIELDS("Original Amount", "Remaining Amount");
                        OriginalAmt:="Original Amount";
                        RemainingAmt:="Remaining Amount";
                        CurrencyCode:="Currency Code";
                    end;
                end;
                trigger OnPreDataItem()
                begin
                    RESET();
                    FilterDetailedVendLedgerEntry(DtldVendLedgEntry, STRSUBSTNO('%1..%2', MaxDate + 1, DMY2DATE(31, 12, 9999)));
                    if DtldVendLedgEntry.FIND('-')then repeat "Entry No.":=DtldVendLedgEntry."Vendor Ledger Entry No.";
                            if CheckVendEntryIncluded("Entry No.")then MARK(true);
                        until DtldVendLedgEntry.NEXT() = 0;
                    FilterVendorLedgerEntry(VendLedgEntry3);
                    if FIND('-')then repeat MARK(true);
                        until NEXT() = 0;
                    SETCURRENTKEY("Entry No.");
                    SETRANGE(Open);
                    MARKEDONLY(true);
                    SETRANGE("Date Filter", 0D, MaxDate);
                    AddVendorDimensionFilter(VendLedgEntry3);
                    CalcTotalVendorAmount();
                end;
            }
            dataitem(Integer2; Integer)
            {
                DataItemTableView = sorting(Number)where(Number=filter(1..));

                column(Name1_Vendor; Vendor.Name)
                {
                }
                column(CurrTotalBufferTotalAmt; CurrencyTotalBuffer."Total Amount")
                {
                AutoFormatExpression = CurrencyTotalBuffer."Currency Code";
                AutoFormatType = 1;
                }
                column(CurrTotalBufferCurrCode; CurrencyTotalBuffer."Currency Code")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then OK:=CurrencyTotalBuffer.FIND('-')
                    else
                        OK:=CurrencyTotalBuffer.NEXT() <> 0;
                    if not OK then CurrReport.BREAK();
                    CurrencyTotalBuffer2.UpdateTotal(CurrencyTotalBuffer."Currency Code", CurrencyTotalBuffer."Total Amount", 0, Counter1);
                end;
                trigger OnPostDataItem()
                begin
                    CurrencyTotalBuffer.DELETEALL();
                end;
                trigger OnPreDataItem()
                begin
                    if not ShowEntriesWithZeroBalance then CurrencyTotalBuffer.SETFILTER("Total Amount", '<>0');
                end;
            }
            trigger OnAfterGetRecord()
            begin
                MaxDate:=GETRANGEMAX("Date Filter");
                SETRANGE("Date Filter", 0D, MaxDate);
                CALCFIELDS("Net Change (LCY)", "Net Change");
                if(PrintAmountInLCY and ("Net Change (LCY)" = 0) or (not PrintAmountInLCY) and ("Net Change" = 0)) and (not ShowEntriesWithZeroBalance)then CurrReport.SKIP();
            end;
            trigger OnPreDataItem()
            begin
            //CurrReport.NEWPAGEPERRECORD := PrintOnePrPage;
            end;
        }
        dataitem(Integer3; Integer)
        {
            DataItemTableView = sorting(Number)where(Number=filter(1..));

            column(CurrTotalBuffer2CurrCode; CurrencyTotalBuffer2."Currency Code")
            {
            }
            column(CurrTotalBuffer2TotalAmt; CurrencyTotalBuffer2."Total Amount")
            {
            AutoFormatExpression = CurrencyTotalBuffer2."Currency Code";
            AutoFormatType = 1;
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            trigger OnAfterGetRecord()
            begin
                if Number = 1 then OK:=CurrencyTotalBuffer2.FIND('-')
                else
                    OK:=CurrencyTotalBuffer2.NEXT() <> 0;
                if not OK then CurrReport.BREAK();
            end;
            trigger OnPostDataItem()
            begin
                CurrencyTotalBuffer2.DELETEALL();
            end;
            trigger OnPreDataItem()
            begin
                CurrencyTotalBuffer2.SETFILTER("Total Amount", '<>0');
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

                    field(ShowAmountsInLCY; PrintAmountInLCY)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Show Amounts in LCY';
                        ToolTip = 'Specifies if amounts in the report are displayed in LCY. If you leave the check box blank, amounts are shown in foreign currencies.';
                    }
                    field(PrintOnePrPage_; PrintOnePrPage)
                    {
                        ApplicationArea = Suite;
                        Caption = 'New Page per Vendor';
                        ToolTip = 'Specifies that you want to print each vendor balance on a separate page, if you have chosen two or more vendors to be included in the report.';
                    }
                    field(PrintUnappliedEntries_; PrintUnappliedEntries)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Include Unapplied Entries';
                        ToolTip = 'Specifies if unapplied entries are included in the report.';
                    }
                    field(ShowEntriesWithZeroBalance_; ShowEntriesWithZeroBalance)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Show Entries with Zero Balance';
                        ToolTip = 'Specifies if the report must include entries with a balance of 0. By default, the report only includes entries with a positive or negative balance.';
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
    trigger OnPreReport()
    var
    //CaptionManagement: Codeunit CaptionManagement;
    begin
        VendFilter:=Vendor.GetFilters;
    end;
    var Text000: Label 'Balance on %1';
    DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    CurrencyTotalBuffer: Record "Currency Total Buffer" temporary;
    CurrencyTotalBuffer2: Record "Currency Total Buffer" temporary;
    PrintAmountInLCY: Boolean;
    PrintOnePrPage: Boolean;
    VendFilter: Text;
    MaxDate: Date;
    OriginalAmt: Decimal;
    Amt: Decimal;
    RemainingAmt: Decimal;
    Counter1: Integer;
    DtldVendtLedgEntryNum: Integer;
    OK: Boolean;
    CurrencyCode: Code[10];
    PrintUnappliedEntries: Boolean;
    VendorBalancetoDateCptnLbl: Label 'Vendor - Balance to Date';
    PageNoCaptionLbl: Label 'Page';
    AllamountsareinLCYCaptionLbl: Label 'All amounts are in LCY.';
    PostingDateCptionLbl: Label 'Posting Date';
    OriginalAmtCaptionLbl: Label 'Amount';
    TotalCaptionLbl: Label 'Total';
    ShowEntriesWithZeroBalance: Boolean;
    procedure InitializeRequest(NewPrintAmountInLCY: Boolean; NewPrintOnePrPage: Boolean; NewPrintUnappliedEntries: Boolean)
    begin
        PrintAmountInLCY:=NewPrintAmountInLCY;
        PrintOnePrPage:=NewPrintOnePrPage;
        PrintUnappliedEntries:=NewPrintUnappliedEntries;
    end;
    local procedure FilterDetailedVendLedgerEntry(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; DateFilter: Text)
    begin
        // WITH DetailedVendorLedgEntry DO BEGIN
        DetailedVendorLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Entry Type");
        DetailedVendorLedgEntry.SETRANGE("Vendor No.", Vendor."No.");
        DetailedVendorLedgEntry.SETFILTER("Posting Date", DateFilter);
        DetailedVendorLedgEntry.SETRANGE("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
    //END;
    end;
    local procedure FilterVendorLedgerEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        //WITH VendorLedgerEntry DO BEGIN
        VendorLedgerEntry.SETCURRENTKEY("Vendor No.", Open);
        VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
        VendorLedgerEntry.SETRANGE(Open, true);
        VendorLedgerEntry.SETRANGE("Posting Date", 0D, MaxDate);
    //END;
    end;
    local procedure AddVendorDimensionFilter(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        //WITH VendorLedgerEntry DO BEGIN
        if Vendor.GETFILTER("Global Dimension 1 Filter") <> '' then VendorLedgerEntry.SETRANGE("Global Dimension 1 Code", Vendor.GETFILTER("Global Dimension 1 Filter"));
        if Vendor.GETFILTER("Global Dimension 2 Filter") <> '' then VendorLedgerEntry.SETRANGE("Global Dimension 2 Code", Vendor.GETFILTER("Global Dimension 2 Filter"));
        if Vendor.GETFILTER("Currency Filter") <> '' then VendorLedgerEntry.SETRANGE("Currency Code", Vendor.GETFILTER("Currency Filter"));
    //END;
    end;
    local procedure CalcTotalVendorAmount()
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        //WITH TempVendorLedgerEntry DO BEGIN
        FilterDetailedVendLedgerEntry(DetailedVendorLedgEntry, '');
        if DetailedVendorLedgEntry.FINDSET()then repeat VendorLedgerEntry.GET(DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                if not TempVendorLedgerEntry.GET(VendorLedgerEntry."Entry No.")then if CheckVendEntryIncluded(VendorLedgerEntry."Entry No.")then begin
                        TempVendorLedgerEntry:=VendorLedgerEntry;
                        TempVendorLedgerEntry.INSERT();
                    end;
            until DetailedVendorLedgEntry.NEXT() = 0;
        FilterVendorLedgerEntry(VendorLedgerEntry);
        if VendorLedgerEntry.FINDSET()then repeat if not TempVendorLedgerEntry.GET(VendorLedgerEntry."Entry No.")then begin
                    TempVendorLedgerEntry:=VendorLedgerEntry;
                    TempVendorLedgerEntry.INSERT();
                end;
            until VendorLedgerEntry.NEXT() = 0;
        TempVendorLedgerEntry.SETCURRENTKEY("Entry No.");
        TempVendorLedgerEntry.SETRANGE("Date Filter", 0D, MaxDate);
        AddVendorDimensionFilter(TempVendorLedgerEntry);
        if TempVendorLedgerEntry.FINDSET()then repeat if PrintAmountInLCY then begin
                    TempVendorLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                    RemainingAmt:=TempVendorLedgerEntry."Remaining Amt. (LCY)";
                    CurrencyCode:='';
                end
                else
                begin
                    TempVendorLedgerEntry.CALCFIELDS("Remaining Amount");
                    RemainingAmt:=TempVendorLedgerEntry."Remaining Amount";
                    CurrencyCode:=TempVendorLedgerEntry."Currency Code";
                end;
                if RemainingAmt <> 0 then CurrencyTotalBuffer.UpdateTotal(CurrencyCode, RemainingAmt, 0, Counter1);
            until TempVendorLedgerEntry.NEXT() = 0;
    //END;
    end;
    local procedure CheckVendEntryIncluded(EntryNo: Integer): Boolean var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if VendorLedgerEntry.GET(EntryNo) and (VendorLedgerEntry."Posting Date" <= MaxDate)then begin
            VendorLedgerEntry.SETRANGE("Date Filter", 0D, MaxDate);
            VendorLedgerEntry.CALCFIELDS("Remaining Amount");
            if VendorLedgerEntry."Remaining Amount" <> 0 then exit(true);
            if PrintUnappliedEntries then exit(CheckUnappliedEntryExists(EntryNo));
        end;
        exit(false);
    end;
    local procedure CheckUnappliedEntryExists(EntryNo: Integer): Boolean var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        //WITH DetailedVendorLedgEntry DO BEGIN
        DetailedVendorLedgEntry.SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type", "Posting Date");
        DetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", EntryNo);
        DetailedVendorLedgEntry.SETRANGE("Entry Type", DetailedVendorLedgEntry."Entry Type"::Application);
        DetailedVendorLedgEntry.SETFILTER("Posting Date", '>%1', MaxDate);
        DetailedVendorLedgEntry.SETRANGE(Unapplied, true);
        exit(not DetailedVendorLedgEntry.ISEMPTY);
    //END;
    end;
}
