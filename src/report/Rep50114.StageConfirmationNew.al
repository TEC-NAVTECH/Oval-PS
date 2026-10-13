report 50114 "Stage Confirmation New"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Stage Confirmation New.rdl';
    Caption = 'Stage Confirmation New';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = Administration;

    dataset
    {
        dataitem("Job Planning Line"; "Job Planning Line")
        {
            column(StageCode; StageCode)
            {
            }
            column(StageName; StageName)
            {
            }
            column(SCC_issue_date; FORMAT("SCC issue date"))
            {
            }
            column(Deliverable_Date; FORMAT("Deliverable Date"))
            {
            }
            column(Job_No_; "Job No.")
            {
            }
            column(ContractName; ContractName)
            {
            }
            column(ClientName; ClientName)
            {
            }
            trigger OnAfterGetRecord()
            begin
                ContractHdr.Get("Contract Code");
                ContractName:=ContractHdr."Contract Name EN";
                ClientName:=ContractHdr."Contract Client Name";
                if ContractLine.Get("Contract Code", "Stage Payment Code", "Contract Line No.")then begin
                    StageCode:=ContractLine."Project Stage";
                    StageName:=ContractLine."Stage Details Description";
                end;
            end;
        }
    }
    var ContractHdr: Record "Contract Card Header";
    ContractName: Text;
    ClientName: Text;
    ContractLine: Record "Contract Card Line";
    StageCode: Code[10];
    StageName: Code[100];
}
