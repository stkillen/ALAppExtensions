codeunit 11737 "Transformation CA"
{
    var
        CountryCodeCATxt: Label 'CA', Locked = true;
        BaseAppExtensionIdTxt: Label '437dbf0e-84ff-417a-965d-ed2bb9650972', Locked = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"W1 Management", 'OnAfterPopulateW1TableMappingForVersion', '', false, false)]
    local procedure PopulateTableMappingsCA_16x(CountryCode: Text; TargetVersion: Decimal)
    var
        DataExchDef: Record "Data Exch. Def";
        StgDataExchDef: Record "Stg Data Exch Def CA";
        SourceTableMapping: Record "Source Table Mapping";
        HybridBCLastManagement: Codeunit "Hybrid BC Last Management";
        ExtensionInfo: ModuleInfo;
        W1AppId: Guid;
    begin
        if CountryCode <> CountryCodeCATxt then
            exit;

        if TargetVersion <> 16.0 then
            exit;

        NavApp.GetCurrentModuleInfo(ExtensionInfo);
        W1AppId := HybridBCLastManagement.GetAppId();
        with SourceTableMapping do begin
            SetRange("Country Code", CountryCodeCATxt);
            DeleteAll();

            MapTable(DataExchDef.TableName(), CountryCodeCATxt, StgDataExchDef.TableName(), true, BaseAppExtensionIdTxt, ExtensionInfo.Id());
            MapTable(DataExchDef.TableName(), CountryCodeCATxt, DataExchDef.TableName(), false, BaseAppExtensionIdTxt, BaseAppExtensionIdTxt);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"W1 Transformation", 'OnAfterW1TransformationForVersion', '', false, false)]
    local procedure TransformTablesForCA_16x(CountryCode: Text; TargetVersion: Decimal)
    begin
        if CountryCode <> CountryCodeCATxt then
            exit;

        if TargetVersion <> 16.0 then
            exit;

        TransformDataExchDef();
    end;

    local procedure TransformDataExchDef()
    var
        StgDataExchDef: Record "Stg Data Exch Def CA";
        DataExchDefType: Enum "Data Exchange Definition Type";
    begin
        // This code is based on app upgrade logic for NA.
        // Matching file: .\App\Layers\NA\BaseApp\Upgrade\UPGDataExchDefinition.Codeunit.al
        // Based on commit: 2c1c901e
        StgDataExchDef.SetRange(Type, 5);
        StgDataExchDef.ModifyAll(Type, DataExchDefType::"EFT Payment Export");

        StgDataExchDef.SetRange(Type, 6);
        StgDataExchDef.ModifyAll(Type, DataExchDefType::"Generic Export");
    end;
}