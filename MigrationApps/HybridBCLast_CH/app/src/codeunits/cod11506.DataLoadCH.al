codeunit 11506 "Data Load CH"
{
    var
        CountryCodeTxt: Label 'CH', Locked = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"W1 Data Load", 'OnAfterW1DataLoadForVersion', '', false, false)]
    local procedure LoadDataForCH(HybridReplicationSummary: Record "Hybrid Replication Summary"; CountryCode: Text; TargetVersion: Decimal)
    begin
        if CountryCode <> CountryCodeTxt then
            exit;

        if TargetVersion <> 15.0 then
            exit;

        // Put logic here to move data from staged tables to real tables.
    end;
}