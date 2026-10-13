pageextension 50117 JobLedgerEntriesPageExt extends "Job Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {

            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
            }
            field("Resource Group No."; Rec."Resource Group No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Resource Group No. field.', Comment = '%';
            }
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quantity (Base) field.', Comment = '%';
            }



        }
        addafter(Description)
        {

            field("Job Description"; Rec."Job Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description field.', Comment = '%';
            }
            field(AuxiliaryIndex1; Rec.AuxiliaryIndex1)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the AuxiliaryIndex1 field.', Comment = '%';
            }
        }

    }

}
