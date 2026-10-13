page 50114 "Sales Invoice List New"
{
    // version NAVW113.03
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Invoices New';
    CardPageId = "Sales Invoice New";
    DataCaptionFields = "Sell-to Customer No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Release,Posting,Invoice,Request Approval';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type"=const(Invoice));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater("")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the customer.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the customer.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the customer''s main address.';
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region code of the customer''s main address.';
                    Visible = false;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the contact person at the customer''s main address.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the customer that you send or sent the invoice or credit memo to.';
                    Visible = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the customer that you send or sent the invoice or credit memo to.';
                    Visible = false;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the customer''s billing address.';
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region code of the customer''s billing address.';
                    Visible = false;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the contact person at the customer''s billing address.';
                    Visible = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';
                    Visible = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the customer at the address that the items are shipped to.';
                    Visible = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the address that the items are shipped to.';
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region code of the address that the items are shipped to.';
                    Visible = false;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the contact person at the address that the items are shipped to.';
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the sales person who is assigned to the customer.';
                    Visible = false;
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency of amounts on the sales document.';
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the campaign that the document is linked to.';
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.';
                    Visible = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment discount percentage granted if the customer pays on or before the date entered in the Pmt. Discount Date field.';
                    Visible = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                    Visible = false;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the shipping agent who is transporting the items.';
                    Visible = false;
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.';
                    Visible = false;
                }
                field("Package Tracking No."; Rec."Package Tracking No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the shipping agent''s package number.';
                    Visible = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
                    Visible = false;
                }
                field("Job Queue Status"; Rec."Job Queue Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of a job queue entry or task that handles the posting of sales invoices.';
                    Visible = JobQueueActive;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sum of amounts in the Line Amount field on the sales order lines. It is used to calculate the invoice discount of the sales order.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(CustStatFactBox; "Customer Statistics FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No."=field("Bill-to Customer No."), "Date Filter"=field("Date Filter");
            }
            part(CustDetFactBox; "Customer Details FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No."=field("Bill-to Customer No."), "Date Filter"=field("Date Filter");
            }
            part(IncomingDocAttachFactBox;193)
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
                Visible = false;
            }
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;

                action(Statistics)
                {
                    ApplicationArea = Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ShortcutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                    trigger OnAction()
                    begin
                        Rec.CalcInvDiscForHeader();
                        COMMIT();
                        PAGE.RUNMODAL(PAGE::"Sales Statistics", Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = page 67;
                    RunPageLink = "Document Type"=field("Document Type"), "No."=field("No."), "Document Line No."=const(0);
                    ToolTip = 'View or add comments for the record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = tabledata 348=R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ShortcutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim();
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = tabledata 454=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        // WorkflowsEntriesBuffer.RunWorkflowEntriesPage(Rec.RECORDID, DATABASE::"Sales Header", Rec."Document Type", Rec."No.");
                        ApprovalsMgmt.RunWorkflowEntriesPage(Rec.RECORDID, DATABASE::"Sales Header", "Approval Document Type".FromInteger(2), Rec."No.");
                    end;
                }
                action(Customer)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page 21;
                    RunPageLink = "No."=field("Sell-to Customer No.");
                    Scope = Repeater;
                    ShortcutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer.';
                }
            }
        }
        area(processing)
        {
            group(Invoice)
            {
                Caption = '&Invoice';
                Image = Invoice;
            }
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;

                action("Re&lease")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ShortcutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = "Action";

                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckSalesApprovalPossible(Rec)then ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookManagement.FindAndCancel(Rec.RECORDID);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;

                action("Test Report")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        ReportPrint.PrintSalesHeader(Rec);
                    end;
                }
                action("Post Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortcutKey = 'F9';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        SalesBatchPostMgt: Codeunit "Sales Batch Post Mgt.";
                    begin
                        CurrPage.SETSELECTIONFILTER(SalesHeader);
                        if SalesHeader.COUNT > 1 then SalesBatchPostMgt.RunWithUI(SalesHeader, Rec.COUNT, ReadyToPostQst)
                        else
                            Post(CODEUNIT::"Sales-Post (Yes/No)");
                    end;
                }
                action("Post &Batch")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post &Batch';
                    Ellipsis = true;
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Post several documents at once. A report request window opens where you can specify which documents to post.';

                    trigger OnAction()
                    begin
                        REPORT.RUNMODAL(REPORT::"Batch Post Sales Invoices", true, true, Rec);
                        CurrPage.UPDATE(false);
                    end;
                }
                action(PostAndSend)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post and &Send';
                    Ellipsis = true;
                    Image = PostSendTo;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Finalize and prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                    trigger OnAction()
                    begin
                        LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
                        Post(CODEUNIT::"Sales-Post and Send");
                    end;
                }
                action("Remove From Job Queue")
                {
                    ApplicationArea = All;
                    Caption = 'Remove From Job Queue';
                    Image = RemoveLine;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category5;
                    ToolTip = 'Remove the scheduled processing of this record from the job queue.';
                    Visible = JobQueueActive;

                    trigger OnAction()
                    begin
                        Rec.CancelBackgroundPosting();
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Preview Posting';
                    Image = ViewPostedOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    ToolTip = 'Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction()
                    begin
                        ShowPreview();
                    end;
                }
            }
        }
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';
                Image = "Report";

                group(FinanceReports)
                {
                    Caption = 'Finance Reports';
                    Image = "Report";

                    action("Report Statement")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Statement';
                        Image = "Report";
                        ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';

                        trigger OnAction()
                        var
                            Customer: Record Customer;
                        begin
                            CODEUNIT.RUN(CODEUNIT::"Customer Layout - Statement", Customer);
                        end;
                    }
                    action("Customer - Balance to Date")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Balance to Date';
                        Image = "Report";
                        RunObject = report 121;
                        ToolTip = 'View a list with customers'' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.';
                    }
                    action("Customer - Trial Balance")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Trial Balance';
                        Image = "Report";
                        RunObject = report 129;
                        ToolTip = 'View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.';
                    }
                    action("Customer - Detail Trial Bal.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Detail Trial Bal.';
                        Image = "Report";
                        RunObject = report 104;
                        ToolTip = 'View the balance for customers with balances on a specified date. The report can be used at the close of an accounting period, for example, or for an audit.';
                    }
                    action("Customer - Summary Aging")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Summary Aging';
                        Image = "Report";
                        RunObject = report 105;
                        ToolTip = 'View, print, or save a summary of each customer''s total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer''s creditworthiness, or to prepare liquidity analyses.';
                    }
                    action("Customer - Detailed Aging")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Detailed Aging';
                        Image = "Report";
                        RunObject = report 106;
                        ToolTip = 'View, print, or save a detailed list of each customer''s total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer''s creditworthiness, or to prepare liquidity analyses.';
                    }
                    action("Aged Accounts Receivable")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged Accounts Receivable';
                        Image = "Report";
                        RunObject = report 120;
                        ToolTip = 'View an overview of when customer payments are due or overdue, divided into four periods. You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
                    }
                    action("Customer - Payment Receipt")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Customer - Payment Receipt';
                        Image = "Report";
                        RunObject = report 211;
                        ToolTip = 'View a document showing which customer ledger entries that a payment has been applied to. This report can be used as a payment receipt that you send to the customer.';
                    }
                }
                group(SalesReports)
                {
                    Caption = 'Sales Reports';
                    Image = "Report";

                    action("Customer - Top 10 List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Top 10 List';
                        Image = "Report";
                        RunObject = report 111;
                        ToolTip = 'View which customers purchase the most or owe the most in a selected period. Only customers that have either purchases during the period or a balance at the end of the period will be included.';
                    }
                    action("Customer - Sales List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Sales List';
                        Image = "Report";
                        RunObject = report 119;
                        ToolTip = 'View customer sales for a period, for example, to report sales activity to customs and tax authorities. You can choose to include only customers with total sales that exceed a minimum amount. You can also specify whether you want the report to show address details for each customer.';
                    }
                    action("Sales Statistics")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Statistics';
                        Image = "Report";
                        RunObject = report 112;
                        ToolTip = 'View the customer''s total cost, sale, and profit over time, for example, to analyze earnings trends. The report shows amounts for original and adjusted cost, sales, profit, invoice discount, payment discount, and profit percentage in three adjustable periods.';
                    }
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance();
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;
    trigger OnOpenPage()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        Rec.SetSecurityFilterOnRespCenter();
        JobQueueActive:=SalesSetup.JobQueueActive();
        Rec.CopySellToCustomerFilter();
    end;
    var ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    ReportPrint: Codeunit "Test Report-Print";
    LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
    JobQueueActive: Boolean;
    OpenApprovalEntriesExist: Boolean;
    OpenPostedSalesInvQst: Label 'The invoice is posted as number %1 and moved to the Posted Sales Invoice window.\\Do you want to open the posted invoice?', Comment = '%1 = posted document number';
    CanCancelApprovalForRecord: Boolean;
    ReadyToPostQst: Label '%1 out of %2 selected invoices are ready for post. \Do you want to continue and post them?', Comment = '%1 - selected count, %2 - total count';
    CanRequestApprovalForFlow: Boolean;
    CanCancelApprovalForFlow: Boolean;
    procedure ShowPreview()
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;
    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExist:=ApprovalsMgmt.HasOpenApprovalEntries(Rec.RECORDID);
        CanCancelApprovalForRecord:=ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RECORDID);
        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
    local procedure Post(PostingCodeunitID: Integer)
    var
        PreAssignedNo: Code[20];
    begin
        if ApplicationAreaMgmtFacade.IsFoundationEnabled()then begin
            LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(Rec);
            PreAssignedNo:=Rec."No.";
        end;
        Rec.SendToPosting(PostingCodeunitID);
        if ApplicationAreaMgmtFacade.IsFoundationEnabled()then ShowPostedConfirmationMessage(PreAssignedNo);
    end;
    local procedure ShowPostedConfirmationMessage(PreAssignedNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin
        SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
        SalesInvoiceHeader.SETRANGE("Pre-Assigned No.", PreAssignedNo);
        if SalesInvoiceHeader.FINDFIRST()then if InstructionMgt.ShowConfirm(STRSUBSTNO(OpenPostedSalesInvQst, SalesInvoiceHeader."No."), InstructionMgt.ShowPostedConfirmationMessageCode())then PAGE.RUN(PAGE::"Posted Sales Invoice", SalesInvoiceHeader);
    end;
}
