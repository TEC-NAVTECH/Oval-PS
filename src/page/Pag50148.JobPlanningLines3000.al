page 50148 "Job Planning Lines 3000"
{
    // version NAVW113.00
    AutoSplitKey = true;
    Caption = 'Job Planning Lines New';
    //DataCaptionExpression = Caption;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Outlook';
    SourceTable = "Job Planning Line";
    ApplicationArea = Basic, Suite, Service;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related job.';
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the related job task.';
                //Visible = JobTaskNoVisible;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the type of planning line.';
                    Visible = false;
                }
                field("Usage Link"; Rec."Usage Link")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the Usage Link field applies to the job planning line. When this check box is selected, usage entries are linked to the job planning line. Selecting this check box creates a link to the job planning line from places where usage has been posted, such as the job journal or a purchase line. You can select this check box only if the line type of the job planning line is Budget or Both Budget and Billable.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UsageLinkOnAfterValidate();
                    end;
                }
                field("Planning Date"; Rec."Planning Date")
                {
                    ApplicationArea = Jobs;
                    //Editable = PlanningDateEditable;
                    Visible = false;
                    ToolTip = 'Specifies the date of the planning line. You can use the planning date for filtering the totals of the job, for example, if you want to see the scheduled usage for a specific month of the year.';

                    trigger OnValidate()
                    begin
                        PlanningDateOnAfterValidate();
                    end;
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = Jobs;
                    Visible = false;
                    ToolTip = 'Specifies the date that is planned to deliver the item connected to the job planning line. For a resource, the planned delivery date is the date that the resource performs services with respect to the job.';
                }
                field("Currency Date"; Rec."Currency Date")
                {
                    ApplicationArea = Jobs;
                    //Editable = CurrencyDateEditable;
                    ToolTip = 'Specifies the date that will be used to find the exchange rate for the currency in the Currency Date field.';
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Jobs;
                    //Editable = DocumentNoEditable;
                    //Visible = false;
                    ToolTip = 'Specifies a document number for the planning line.';
                //Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Jobs;
                    //Editable = TypeEditable;
                    ToolTip = 'Specifies the type of account to which the planning line relates.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate();
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Jobs;
                    //Editable = NoEditable;
                    ToolTip = 'Specifies the number of the account to which the resource, item or general ledger account is posted, depending on your selection in the Type field.';

                    trigger OnValidate()
                    begin
                        NoOnAfterValidate();
                    end;
                }
                field("Currency Code 2"; Rec."Currency Code 2")
                {
                    ApplicationArea = Jobs;
                    //Editable = false;
                    Caption = 'Currency Code';
                    Visible = false;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of units of the resource, item, or general ledger account that should be specified on the planning line. If you later change the No., the quantity you have entered remains on the line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate();
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Jobs;
                    //Editable = UnitPriceEditable;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                    Visible = false;
                }
                field("Total Price"; Rec."Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price in the job currency on the planning line.';
                    Visible = false;
                }
                field("Tax expense FCY"; Rec."Tax expense FCY")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Subcon expense FCY"; Rec."Subcon expense FCY")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bank Charge FCY"; Rec."Bank Charge FCY")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Net amount FCY"; Rec."Net amount FCY")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Net Amount LCY"; Rec."Net Amount LCY")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("SCC issue date"; Rec."SCC issue date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Contract Code"; Rec."Contract Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Projected Bill Date"; Rec."Projected Bill Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(FINESTBILLMTH; Rec.FINESTBILLMTH)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Projected Payment Date"; Rec."Projected Payment Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Stage Payment Code"; Rec."Stage Payment Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Total Hours Percent"; Rec."Total Hours Percent")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the planning line''s entry number.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Jobs;
                    //Editable = DescriptionEditable;
                    ToolTip = 'Specifies the name of the resource, item, or G/L account to which this entry applies. You can change the description. A maximum of 50 characters, both numbers and letters, are allowed.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    //Editable = VariantCodeEditable;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        VariantCodeOnAfterValidate();
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    //Editable = LocationCodeEditable;
                    ToolTip = 'Specifies a location code for an item.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate();
                    end;
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    ApplicationArea = Jobs;
                    //Editable = WorkTypeCodeEditable;
                    ToolTip = 'Specifies which work type the resource applies to. Prices are updated based on this entry.';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    //Editable = UnitOfMeasureCodeEditable;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValida();
                    end;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies whether or not a reservation can be made for items on the current line. The field is not applicable if the Type field is set to Resource, Cost, or G/L Account.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveOnAfterValidate();
                    end;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies the quantity of the item that is reserved for the job planning line.';
                    Visible = false;
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity expressed in the base units of measure.';
                    Visible = false;
                }
                field("Remaining Qty."; Rec."Remaining Qty.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the remaining quantity of the resource, item, or G/L Account that remains to complete a job. The quantity is calculated as the difference between Quantity and Qty. Posted.';
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the cost, in the local currency, of one unit of the selected item or resource.';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Jobs;
                    //Editable = UnitCostEditable;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the cost, in LCY, of one unit of the item or resource on the line.';
                    Visible = false;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost for the planning line. The total cost is in the job currency, which comes from the Currency Code field in the Job Card.';
                }
                field("Remaining Total Cost"; Rec."Remaining Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the remaining total cost for the planning line. The total cost is in the job currency, which comes from the Currency Code field in the Job Card.';
                    Visible = false;
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost for the planning line. The amount is in the local currency.';
                    Visible = false;
                }
                field("Remaining Total Cost (LCY)"; Rec."Remaining Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the remaining total cost (LCY) for the planning line. The amount is in the local currency.';
                    Visible = false;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                    Visible = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Jobs;
                    //Editable = LineAmountEditable;
                    ToolTip = 'Specifies the amount that will be posted to the job ledger.';
                    Visible = false;
                }
                field("Remaining Line Amount"; Rec."Remaining Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount that will be posted to the job ledger.';
                    Visible = false;
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount in the local currency that will be posted to the job ledger.';
                    Visible = false;
                }
                field("Remaining Line Amount (LCY)"; Rec."Remaining Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount in the local currency that will be posted to the job ledger.';
                    Visible = false;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Jobs;
                    //Editable = LineDiscountAmountEditable;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                    Visible = false;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Jobs;
                    //Editable = LineDiscountPctEditable;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
                    Visible = false;
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total price on the planning line. The total price is in the local currency.';
                    Visible = false;
                }
                field("Qty. Posted"; Rec."Qty. Posted")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that has been posted to the job ledger, if the Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Qty. to Transfer to Journal"; Rec."Qty. to Transfer to Journal")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity you want to transfer to the job journal. Its default value is calculated as quantity minus the quantity that has already been posted, if the Apply Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Posted Total Cost"; Rec."Posted Total Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost that has been posted to the job ledger, if the Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Posted Total Cost (LCY)"; Rec."Posted Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost (LCY) that has been posted to the job ledger, if the Usage Link check box has been selected.';
                    Visible = false;
                }
                field("Posted Line Amount"; Rec."Posted Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount that has been posted to the job ledger. This field is only filled in if the Apply Usage Link check box selected on the job card.';
                    Visible = false;
                }
                field("Posted Line Amount (LCY)"; Rec."Posted Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the amount in the local currency that has been posted to the job ledger. This field is only filled in if the Apply Usage Link check box selected on the job card.';
                    Visible = false;
                }
                field("Qty. Transferred to Invoice"; Rec."Qty. Transferred to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that has been transferred to a sales invoice or credit memo.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownJobInvoices();
                    end;
                }
                field("Qty. to Transfer to Invoice"; Rec."Qty. to Transfer to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity you want to transfer to the sales invoice or credit memo. The value in this field is calculated as Quantity - Qty. Transferred to Invoice.';
                    Visible = false;
                }
                field("Qty. Invoiced"; Rec."Qty. Invoiced")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that been posted through a sales invoice.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownJobInvoices();
                    end;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                    Visible = false;
                }
                field("Invoiced Amount (LCY)"; Rec."Invoiced Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in local currency, the sales amount that was invoiced for this planning line.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownJobInvoices();
                    end;
                }
                field("Invoiced Cost Amount (LCY)"; Rec."Invoiced Cost Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies, in the local currency, the cost amount that was invoiced for this planning line.';
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.DrillDownJobInvoices();
                    end;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the serial number that is applied to the posted item if the planning line was created from the posting of a job journal line.';
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the lot number that is applied to the posted item if the planning line was created from the posting of a job journal line.';
                    Visible = false;
                }
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry number of the job planning line that the sales line is linked to.';
                    Visible = false;
                }
                field("Ledger Entry Type"; Rec."Ledger Entry Type")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry type of the job ledger entry associated with the planning line.';
                    Visible = false;
                }
                field("Ledger Entry No."; Rec."Ledger Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry number of the job ledger entry associated with the job planning line.';
                    Visible = false;
                }
                field("System-Created Entry"; Rec."System-Created Entry")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies that an entry has been created by Business Central and is related to a job ledger entry. The check box is selected automatically.';
                    Visible = false;
                }
                field(Overdue; Rec.Overdue())
                {
                    ApplicationArea = Jobs;
                    Caption = 'Overdue';
                    Editable = false;
                    ToolTip = 'Specifies that the job is overdue. ';
                    Visible = false;
                }
                field(ActualInvDate; ActualInvDate)
                {
                    ApplicationArea = All;
                    Caption = 'Actual Invoice Date';
                    Editable = false;
                    Visible = false;
                }
                field(ActualPymntDate; ActualPymntDate)
                {
                    ApplicationArea = All;
                    Caption = 'Actual Payment Date';
                    Editable = false;
                    Visible = false;
                }
                field("Actual Invoice Date"; Rec."Actual Invoice Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Actual Payment Date"; Rec."Actual Payment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice No.';
                    Editable = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(PostedSalesInvDetailFactbox; "Posted Invoice Details Factbox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Job No."=field("Job No."), "Job Task No."=field("Job Task No."), "Job Planning Line No."=field("Line No."), "Document Type"=filter("Posted Credit Memo"|"Posted Invoice");
                Visible = false;
            }
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("Job Planning &Line")
            {
                Caption = 'Job Planning &Line';
                Image = Line;

                action("Linked Job Ledger E&ntries")
                {
                    ApplicationArea = Suite;
                    Caption = 'Linked Job Ledger E&ntries';
                    Image = JobLedger;
                    ShortcutKey = 'Ctrl+F7';
                    ToolTip = 'View job ledger entries related to the job planning line.';

                    trigger OnAction()
                    var
                        JobLedgerEntry: Record "Job Ledger Entry";
                        JobUsageLink: Record "Job Usage Link";
                    begin
                        JobUsageLink.SETRANGE("Job No.", rec."Job No.");
                        JobUsageLink.SETRANGE("Job Task No.", rec."Job Task No.");
                        JobUsageLink.SETRANGE("Line No.", rec."Line No.");
                        if JobUsageLink.FINDSET()then repeat JobLedgerEntry.GET(JobUsageLink."Entry No.");
                                JobLedgerEntry.MARK:=true;
                            until JobUsageLink.NEXT() = 0;
                        JobLedgerEntry.MARKEDONLY(true);
                        PAGE.RUN(PAGE::"Job Ledger Entries", JobLedgerEntry);
                    end;
                }
                action("&Reservation Entries")
                {
                    AccessByPermission = tabledata 27=R;
                    ApplicationArea = Reservation;
                    Caption = '&Reservation Entries';
                    Image = ReservationLedger;
                    ToolTip = 'View all reservations that are made for the item, either manually or automatically.';

                    trigger OnAction()
                    begin
                        rec.ShowReservationEntries(true);
                    end;
                }
                action(OrderPromising)
                {
                    ApplicationArea = OrderPromising;
                    Caption = 'Order &Promising';
                    Image = OrderPromising;
                    ToolTip = 'Calculate the shipment and delivery dates based on the item''s known and expected availability dates, and then promise the dates to the customer.';

                    trigger OnAction()
                    begin
                        rec.ShowOrderPromisingLine();
                    end;
                }
                action(SendToCalendar)
                {
                    AccessByPermission = tabledata 1034=RIM;
                    ApplicationArea = Jobs;
                    Caption = 'Send to Calendar';
                    Image = CalendarChanged;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = codeunit 1034;
                    RunPageOnRec = true;
                    ToolTip = 'Create a calendar appointment for the resource on each job planning line.';
                //Visible = CanSendToCalendar;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";

                action(CreateJobJournalLines)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Create Job &Journal Lines';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Use a batch job to help you create sales journal lines for the involved job planning lines.';

                    trigger OnAction()
                    var
                        JobPlanningLine: Record "Job Planning Line";
                        JobJnlLine: Record "Job Journal Line";
                        JobTransferLine: Codeunit "Job Transfer Line";
                        JobTransferJobPlanningLine: Page "Job Transfer Job Planning Line";
                    begin
                        if JobTransferJobPlanningLine.RUNMODAL() = ACTION::OK then begin
                            JobPlanningLine.COPY(Rec);
                            CurrPage.SETSELECTIONFILTER(JobPlanningLine);
                            if JobPlanningLine.FINDSET()then repeat JobTransferLine.FromPlanningLineToJnlLine(JobPlanningLine, JobTransferJobPlanningLine.GetPostingDate(), JobTransferJobPlanningLine.GetJobJournalTemplateName(), JobTransferJobPlanningLine.GetJobJournalBatchName(), JobJnlLine);
                                until JobPlanningLine.NEXT() = 0;
                            CurrPage.UPDATE(false);
                            MESSAGE(Text002, JobPlanningLine.TABLECAPTION, JobJnlLine.TABLECAPTION);
                        end;
                    end;
                }
                action("&Open Job Journal")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Open Job Journal';
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Job Journal";
                    RunPageLink = "Job No."=field("Job No."), "Job Task No."=field("Job Task No.");
                    ToolTip = 'Open the job journal, for example, to post usage for a job.';
                }
                action("Create &Sales Invoice")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Create &Sales Invoice';
                    Ellipsis = true;
                    Image = JobSalesInvoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Use a batch job to help you create sales invoices for the involved job tasks.';

                    trigger OnAction()
                    begin
                        CreateSalesInvoice(false);
                    end;
                }
                action("Consolidate Lines Per Momth")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Consolidate Lines Per Month';
                    //Ellipsis = true;
                    Image = Default;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ConsolLines: Report "Consolidate Lines";
                    begin
                        ConsolLines.SetValues(Rec."Job No.", Rec."Job Task No.");
                        ConsolLines.Run();
                    end;
                }
                action("Get Contract Details")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Get Contract Details';
                    //Ellipsis = true;
                    Image = GetLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ContractRec: Record "Contract Card Header";
                        ContractNo: Code[25];
                        ContractLines: Record "Contract Card Line";
                        ContractLines1: Page "Contract Lines";
                        JobPlanLine: Record "Job Planning Line";
                        LineNo: Integer;
                        jobSetup: Record "Jobs Setup";
                        Currfactor: Decimal;
                        RecCurrExRate: Record "Currency Exchange Rate";
                    begin
                        rec.TestField("Job Task No.", '1000');
                        ContractRec.Reset();
                        ContractNo:='';
                        if Page.RunModal(50107, ContractRec) = Action::LookupOK then begin
                            ContractNo:=ContractRec."Contract Code Full";
                            //ContractLines.Reset();
                            //ContractLines.FilterGroup(2);
                            //ContractLines.SetRange("Contract Code Full", ContractNo);
                            //ContractLines.SetRange(Selected, false);
                            //ContractLines.FilterGroup(0);
                            //ContractLines1.LookupMode(true);
                            //ContractLines1.SetTableView(ContractLines);
                            //if ContractLines1.RunModal() <> Action::LookupOK then
                            //    exit;
                            //ContractLines1.SetSelectionFilter(ContractLines);
                            jobSetup.Get();
                            LineNo:=0;
                            JobPlanLine.Reset();
                            JobPlanLine.SetRange("Job No.", Rec."Job No.");
                            JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
                            JobPlanLine.SetRange("Contract Code", ContractNo);
                            if JobPlanLine.FindFirst()then begin
                                ContractLines.Reset();
                                ContractLines.SetRange("Contract Code Full", ContractNo);
                                if ContractLines.FindSet()then repeat JobPlanLine1.reset();
                                        JobPlanLine1.SetRange("Contract Code", ContractLines."Contract Code Full");
                                        JobPlanLine1.SetRange("Stage Payment Code", ContractLines."Stage Payment Code");
                                        JobPlanLine1.SetRange("Contract Line No.", ContractLines."Line No.");
                                        if JobPlanLine1.FindFirst()then begin
                                            if JobPlanLine1."Invoice No." = '' then begin
                                                JobPlanLine1.Validate("Currency Code 2", ContractLines.Currency);
                                                JobPlanLine1.Validate("Unit Price", ContractLines."Stage Amount");
                                                JobPlanLine1.Validate(Description, ContractLines."Stage Details Description");
                                                JobPlanLine1.Modify(true);
                                                LineNo:=JobPlanLine1."Line No." + 1;
                                            end;
                                        end
                                        else
                                        begin
                                            JobPlanLine1.Init();
                                            JobPlanLine1.Validate("Job No.", Rec."Job No.");
                                            JobPlanLine1.Validate("Job Task No.", Rec."Job Task No.");
                                            JobPlanLine1."Line No.":=LineNo;
                                            JobPlanLine1.Validate("Line Type", JobPlanLine1."Line Type"::Billable);
                                            JobPlanLine1.Validate("Contract Code", ContractLines."Contract Code Full");
                                            JobPlanLine1.Validate("Stage Payment Code", ContractLines."Stage Payment Code");
                                            JobPlanLine1.Validate(Type, JobPlanLine1.Type::"G/L Account");
                                            JobPlanLine1.Validate("No.", jobSetup."Job Planning Line Account No.");
                                            JobPlanLine1.Validate(Quantity, 1);
                                            JobPlanLine1.Validate("Currency Code 2", ContractLines.Currency);
                                            JobPlanLine1.Validate("Unit Price", ContractLines."Stage Amount");
                                            JobPlanLine1.Validate(Description, ContractLines."Stage Details Description");
                                            JobPlanLine1."Contract Line No.":=ContractLines."Line No.";
                                            JobPlanLine1.Insert(true);
                                            LineNo:=LineNo + 1;
                                        end;
                                    until ContractLines.Next() = 0;
                            end
                            else
                            begin
                                JobPlanLine.Reset();
                                JobPlanLine.SetRange("Job No.", Rec."Job No.");
                                JobPlanLine.SetRange("Job Task No.", Rec."Job Task No.");
                                if JobPlanLine.FindLast()then LineNo:=JobPlanLine."Line No." + 10000
                                else
                                    LineNo:=10000;
                                ContractLines.Reset();
                                ContractLines.SetRange("Contract Code Full", ContractNo);
                                if ContractLines.FindSet()then repeat JobPlanLine1.Init();
                                        JobPlanLine1.Validate("Job No.", Rec."Job No.");
                                        JobPlanLine1.Validate("Job Task No.", Rec."Job Task No.");
                                        JobPlanLine1."Line No.":=LineNo;
                                        JobPlanLine1.Validate("Line Type", JobPlanLine1."Line Type"::Billable);
                                        JobPlanLine1.Validate("Contract Code", ContractLines."Contract Code Full");
                                        JobPlanLine1.Validate("Stage Payment Code", ContractLines."Stage Payment Code");
                                        JobPlanLine1.Validate(Type, JobPlanLine1.Type::"G/L Account");
                                        JobPlanLine1.Validate("No.", jobSetup."Job Planning Line Account No.");
                                        JobPlanLine1.Validate(Quantity, 1);
                                        JobPlanLine1.Validate("Currency Code 2", ContractLines.Currency);
                                        JobPlanLine1.Validate("Unit Price", ContractLines."Stage Amount");
                                        JobPlanLine1.Validate(Description, ContractLines."Stage Details Description");
                                        JobPlanLine1."Contract Line No.":=ContractLines."Line No.";
                                        JobPlanLine1.Insert(true);
                                        LineNo+=10000;
                                    until ContractLines.Next() = 0;
                            end;
                        end;
                    end;
                }
                action("Create Sales &Credit Memo")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Create Sales &Credit Memo';
                    Ellipsis = true;
                    Image = CreditMemo;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create a sales credit memo for the selected job planning line.';

                    trigger OnAction()
                    begin
                        CreateSalesInvoice(true);
                    end;
                }
                action("Sales &Invoices/Credit Memos")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Sales &Invoices/Credit Memos';
                    Ellipsis = true;
                    Image = GetSourceDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'View sales invoices or sales credit memos that are related to the selected job.';

                    trigger OnAction()
                    begin
                        JobCreateInvoice.GetJobPlanningLineInvoices(Rec);
                    end;
                }
                action(Reservation)
                {
                    ApplicationArea = Reservation;
                    Caption = '&Reservation';
                    Ellipsis = true;
                    Image = Reserve;
                    ToolTip = 'Reserve one or more units of the item on the job planning line, either from inventory or from incoming supply.';

                    trigger OnAction()
                    begin
                        rec.ShowReservation();
                    end;
                }
                action("Order &Tracking")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Order &Tracking';
                    Image = OrderTracking;
                    ToolTip = 'Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.';

                    trigger OnAction()
                    begin
                        rec.ShowTracking();
                    end;
                }
                action(DemandOverview)
                {
                    ApplicationArea = Planning;
                    Caption = '&Demand Overview';
                    Image = Forecast;
                    ToolTip = 'Get an overview of demand planning related to jobs, such as the availability of spare parts or other items that you may use in a job. For example, you can determine whether the item you need is in stock, and if it is not, you can determine when the item will be in stock.';

                    trigger OnAction()
                    var
                        DemandOverview: Page "Demand Overview";
                    begin
                        DemandOverview.SetCalculationParameter(true);
                        //DemandOverview.Initialize(0D, 3, rec."Job No.", '', ''); Closed by SS
                        DemandOverview.SetParameters(0D, Enum::"Demand Order Source Type"::"Job Demand", Rec."Job No.", '', '');
                        DemandOverview.RUNMODAL();
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Job Actual to Budget")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Actual to Budget';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Actual To Budget";
                ToolTip = 'Compare scheduled and usage amounts for selected jobs. All lines of the selected job show quantity, total cost, and line amount.';
            }
            action("Job Analysis")
            {
                ApplicationArea = Jobs;
                Caption = 'Job Analysis';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Analysis";
                ToolTip = 'Analyze the job, such as the scheduled prices, usage prices, and contract prices, and then compares the three sets of prices.';
            }
            action("Job - Planning Lines")
            {
                ApplicationArea = Jobs;
                Caption = 'Job - Planning Lines';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job - Planning Lines";
                ToolTip = 'View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (Budget) or you can specify what you actually agreed with your customer that he should pay for the job (Billable).';
            }
            action("Job - Suggested Billing")
            {
                ApplicationArea = Jobs;
                Caption = 'Job - Suggested Billing';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = report "Job Suggested Billing";
                ToolTip = 'View a list of all jobs, grouped by customer, how much the customer has already been invoiced, and how much remains to be invoiced, that is, the suggested billing.';
            }
            action("Jobs - Transaction Detail")
            {
                ApplicationArea = Jobs;
                Caption = 'Jobs - Transaction Detail';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = report "Job - Transaction Detail";
                ToolTip = 'View all postings with entries for a selected job for a selected period, which have been charged to a certain job. At the end of each job list, the amounts are totaled separately for the Sales and Usage entry types.';
            }
            action("Stage Confirmation Template")
            {
                ApplicationArea = All;
                Caption = 'Stage Confirmation Tmeplate';
                Image = "Report";
                Promoted = false;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                //RunObject = Report "Job - Transaction Detail";
                //ToolTip = 'View all postings with entries for a selected job for a selected period, which have been charged to a certain job. At the end of each job list, the amounts are totaled separately for the Sales and Usage entry types.';
                trigger OnAction()
                var
                    JobPlanLine: Record "Job Planning Line";
                begin
                    JobPlanLine.Reset();
                    JobPlanLine.SetRange("Job No.", rec."Job No.");
                    JobPlanLine.SetRange("Job Task No.", rec."Job Task No.");
                    JobPlanLine.SetRange("Line No.", rec."Line No.");
                    Report.RunModal(50114, true, true, JobPlanLine);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        ActualPymntDate:=0D;
        ActualInvDate:=0D;
        rec."Invoice No.":='';
        JobPlanLineInv.Reset();
        JobPlanLineInv.SetRange("Job No.", Rec."Job No.");
        JobPlanLineInv.SetRange("Job Task No.", Rec."Job Task No.");
        JobPlanLineInv.SetRange("Job Planning Line No.", Rec."Line No.");
        JobPlanLineInv.SetFilter("Document Type", '%1|%2', JobPlanLineInv."Document Type"::"Posted Credit Memo", JobPlanLineInv."Document Type"::"Posted Invoice");
        if JobPlanLineInv.FindLast()then begin
            ActualInvDate:=JobPlanLineInv."Invoiced Date";
            //"Invoice No." := JobPlanLineInv."Document No.";
            CustLedgEntry.Reset();
            CustLedgEntry.SetRange("Document No.", Rec."Document No.");
            if CustLedgEntry.FindFirst()then begin
                DetailCustLedgEntry.Reset();
                DetailCustLedgEntry.SetRange("Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                DetailCustLedgEntry.SetRange(Unapplied, false);
                DetailCustLedgEntry.SetFilter("Document Type", '%1|%2', DetailCustLedgEntry."Document Type"::Payment, DetailCustLedgEntry."Document Type"::Refund);
                if DetailCustLedgEntry.FindFirst()then ActualPymntDate:=DetailCustLedgEntry."Posting Date";
            end;
        end;
    end;
    trigger OnAfterGetCurrRecord()
    begin
        SetEditable(rec."Qty. Transferred to Invoice" = 0);
    end;
    trigger OnInit()
    var
        // SMTPMailSetup: Record "SMTP Mail Setup";
        EmailAccount: Codeunit "Email Account";
        MailManagement: Codeunit "Mail Management";
    begin
        UnitCostEditable:=true;
        LineAmountEditable:=true;
        LineDiscountPctEditable:=true;
        LineDiscountAmountEditable:=true;
        UnitPriceEditable:=true;
        WorkTypeCodeEditable:=true;
        LocationCodeEditable:=true;
        VariantCodeEditable:=true;
        UnitOfMeasureCodeEditable:=true;
        DescriptionEditable:=true;
        NoEditable:=true;
        TypeEditable:=true;
        DocumentNoEditable:=true;
        CurrencyDateEditable:=true;
        PlanningDateEditable:=true;
        JobTaskNoVisible:=true;
        CanSendToCalendar:=EmailAccount.IsAnyAccountRegistered();
    // CanSendToCalendar := MailManagement.IsSMTPEnabled AND NOT SMTPMailSetup.ISEMPTY;
    end;
    trigger OnModifyRecord(): Boolean begin
        if rec."System-Created Entry" then if CONFIRM(Text001, false)then rec."System-Created Entry":=false
            else
                ERROR('');
    end;
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec.SetUpNewLine(xRec);
    end;
    trigger OnOpenPage()
    var
        Job: Record job;
    begin
        rec.FILTERGROUP:=2;
        if Job.GET(rec.GETFILTER("Job No."))then CurrPage.EDITABLE(not(Job.Blocked = Job.Blocked::All));
        rec.FILTERGROUP:=0;
    end;
    var JobCreateInvoice: Codeunit "Job Create-Invoice1";
    Text001: Label 'This job planning line was automatically generated. Do you want to continue?';
    JobTaskNoVisible: Boolean;
    PlanningDateEditable: Boolean;
    CurrencyDateEditable: Boolean;
    DocumentNoEditable: Boolean;
    TypeEditable: Boolean;
    NoEditable: Boolean;
    DescriptionEditable: Boolean;
    UnitOfMeasureCodeEditable: Boolean;
    VariantCodeEditable: Boolean;
    LocationCodeEditable: Boolean;
    WorkTypeCodeEditable: Boolean;
    UnitPriceEditable: Boolean;
    LineDiscountAmountEditable: Boolean;
    LineDiscountPctEditable: Boolean;
    LineAmountEditable: Boolean;
    UnitCostEditable: Boolean;
    Text002: Label 'The %1 was successfully transferred to a %2.';
    CanSendToCalendar: Boolean;
    ActualInvDate: Date;
    ActualPymntDate: Date;
    InvNo: Code[20];
    CustLedgEntry: Record "Cust. Ledger Entry";
    DetailCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    JobPlanLineInv: Record "Job Planning Line Invoice";
    JobPlanLine1: Record "Job Planning Line";
    local procedure CreateSalesInvoice(CrMemo: Boolean)
    var
        JobPlanningLine: Record "Job Planning Line";
        _cuJobCreateInvoice: Codeunit "Job Create-Invoice1"; //
    begin
        rec.TESTFIELD("Line No.");
        JobPlanningLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(JobPlanningLine);
        JobPlanningLine.SetCurrentKey("Customer No.");
        _cuJobCreateInvoice.CreateSalesInvoice(JobPlanningLine, CrMemo)end;
    local procedure SetEditable(Edit: Boolean)
    begin
        PlanningDateEditable:=Edit;
        CurrencyDateEditable:=Edit;
        DocumentNoEditable:=Edit;
        TypeEditable:=Edit;
        NoEditable:=Edit;
        DescriptionEditable:=Edit;
        UnitOfMeasureCodeEditable:=Edit;
        VariantCodeEditable:=Edit;
        LocationCodeEditable:=Edit;
        WorkTypeCodeEditable:=Edit;
        UnitPriceEditable:=Edit;
        LineDiscountAmountEditable:=Edit;
        LineDiscountPctEditable:=Edit;
        LineAmountEditable:=Edit;
        UnitCostEditable:=Edit;
    end;
    procedure SetJobTaskNoVisible(NewJobTaskNoVisible: Boolean)
    begin
        JobTaskNoVisible:=NewJobTaskNoVisible;
    end;
    local procedure PerformAutoReserve()
    begin
        if(rec.Reserve = rec.Reserve::Always) and (rec."Remaining Qty. (Base)" <> 0)then begin
            CurrPage.SAVERECORD();
            rec.AutoReserve();
            CurrPage.UPDATE(false);
        end;
    end;
    local procedure UsageLinkOnAfterValidate()
    begin
        PerformAutoReserve();
    end;
    local procedure PlanningDateOnAfterValidate()
    begin
        if rec."Planning Date" <> xRec."Planning Date" then PerformAutoReserve();
    end;
    local procedure NoOnAfterValidate()
    begin
        if rec."No." <> xRec."No." then PerformAutoReserve();
    end;
    local procedure VariantCodeOnAfterValidate()
    begin
        if rec."Variant Code" <> xRec."Variant Code" then PerformAutoReserve();
    end;
    local procedure LocationCodeOnAfterValidate()
    begin
        if rec."Location Code" <> xRec."Location Code" then PerformAutoReserve();
    end;
    local procedure UnitofMeasureCodeOnAfterValida()
    begin
        PerformAutoReserve();
    end;
    local procedure ReserveOnAfterValidate()
    begin
        PerformAutoReserve();
    end;
    local procedure QuantityOnAfterValidate()
    begin
        PerformAutoReserve();
        if(rec.Type = rec.Type::Item) and (rec.Quantity <> xRec.Quantity)then CurrPage.UPDATE(true);
    end;
}
