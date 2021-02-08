codeunit 11738 "Data Load CA"
{
    var
        CountryCodeTxt: Label 'CA', Locked = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"W1 Data Load", 'OnAfterW1DataLoadForVersion', '', false, false)]
    local procedure LoadDataForCA_16x(HybridReplicationSummary: Record "Hybrid Replication Summary"; CountryCode: Text; TargetVersion: Decimal)
    begin
        if CountryCode <> CountryCodeTxt then
            exit;

        if TargetVersion <> 16.0 then
            exit;

        LoadDataExchDef(HybridReplicationSummary);
    end;

    local procedure LoadDataExchDef(HybridReplicationSummary: Record "Hybrid Replication Summary")
    var
        DataExchDef: Record "Data Exch. Def";
        StgDataExchDef: Record "Stg Data Exch Def CA";
        W1DataLoad: Codeunit "W1 Data Load";
    begin
        if StgDataExchDef.FindSet(false, false) then
            repeat
                DataExchDef.SetRange(Code, StgDataExchDef.Code);
                if DataExchDef.FindFirst() then begin
                    DataExchDef.TransferFields(StgDataExchDef);
                    DataExchDef.Modify();
                end;
            until StgDataExchDef.Next() = 0;

        W1DataLoad.OnAfterCompanyTableLoad(StgDataExchDef.RecordId().TableNo(), HybridReplicationSummary."Synced Version");
        StgDataExchDef.Reset();
        StgDataExchDef.DeleteAll();
    end;
}