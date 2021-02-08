codeunit 11736 "UPG SII ES 16X"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"W1 Company Handler", 'OnUpgradePerCompanyDataForVersion', '', false, false)]
    local procedure OnCompanyMigrationUpgrade(TargetVersion: Decimal)
    begin
        if TargetVersion <> 16.0 then
            exit;

        PopulatedNewFields();
    end;

    local procedure PopulatedNewFields()
    var
        SIISetup: Record "SII Setup";
    begin
        // This code is based on app upgrade logic for ES.
        // Matching file: .\App\Layers\ES\BaseApp\Upgrade\UPGSII.Codeunit.al
        // Based on commit: 2c1c901e
        if SIISetup.Get() then
            SIISetup.SetDefaults();
    end;
}

