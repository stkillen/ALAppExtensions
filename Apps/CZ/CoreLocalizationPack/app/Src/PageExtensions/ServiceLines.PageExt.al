pageextension 31006 "Service Lines CZL" extends "Service Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Tariff No. CZL"; Rec."Tariff No. CZL")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a code for the item''s tariff number.';
                Visible = false;
            }
            field("Statistic Indication CZL"; Rec."Statistic Indication CZL")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the statistic indication code.';
                Visible = false;
            }
        }
    }
}
