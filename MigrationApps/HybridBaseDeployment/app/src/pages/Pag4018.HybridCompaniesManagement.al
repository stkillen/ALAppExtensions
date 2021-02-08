page 4018 "Hybrid Companies Management"
{
    PageType = NavigatePage;
    SourceTable = "Hybrid Company";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = true;
    Caption = 'Select companies to migrate';

    layout
    {
        area(Content)
        {
            repeater(Companies)
            {
                ShowCaption = false;
                field("Replicate"; "Replicate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replicate';
                    Visible = true;
                    Tooltip = 'Specifies whether to migrate the data from this company.';
                    Width = 5;
                    Editable = true;
                }
                field("Name"; "Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the company.';
                    Visible = true;
                    Editable = false;
                }
                field("Display Name"; "Display Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the display name of the company.';
                    Visible = true;
                    Editable = false;
                    Width = 10;
                }
                field("Estimated Size"; Rec."Estimated Size")
                {
                    Caption = 'Estimated Size (GB)';
                    ApplicationArea = Basic, Suite;
                    Visible = DisplayDatabaseSize;
                    Editable = false;
                    ToolTip = 'Estimated size in GB of the company data to migrate.';
                }
            }

            field(SelectAll; ChooseAll)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Migrate all companies';
                ToolTip = 'Selects all companies in the list.';
                trigger OnValidate();
                begin
                    SetSelected(ChooseAll);
                    CurrPage.Update(false);
                end;
            }

            group("Instructions")
            {
                ShowCaption = false;
                InstructionalText = 'If you have selected a company that does not exist in Business Central, it will automatically be created for you. This may take a few minutes.';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(OK)
            {
                ApplicationArea = All;
                Caption = 'OK';
                Image = Approve;
                ToolTip = 'Accept the changes.';
                InFooterBar = true;

                trigger OnAction()
                var
                    HybridCompany: Record "Hybrid Company";
                begin
                    if not VerifyCompanySelection() then
                        exit;

                    Rec.FindSet();
                    repeat
                        HybridCompany := Rec;
                        HybridCompany.Modify();
                    until Rec.Next() = 0;
                    CurrPage.Close();

                    HybridCloudManagement.CreateCompanies();
                    Message(UpdatedReplicationCompaniesMsg);
                end;
            }

            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                ToolTip = 'Cancel the changes.';
                Image = Cancel;
                InFooterBar = true;

                trigger OnAction()
                begin
                    if Dialog.Confirm(CancelConfirmMsg, false) then
                        CurrPage.Close();
                end;
            }
        }
    }

    trigger OnInit()
    begin
        if not HybridCloudManagement.CanSetupIntelligentCloud() then
            Error(RunWizardPermissionErr);
    end;

    trigger OnOpenPage()
    var
        HybridCompany: Record "Hybrid Company";
    begin
        if HybridCompany.FindSet() then
            repeat
                Rec := HybridCompany;
                DisplayDatabaseSize := DisplayDatabaseSize or (Rec."Estimated Size" > 0);
                Insert();
            until HybridCompany.Next() = 0;
    end;

    var
        HybridCloudManagement: Codeunit "Hybrid Cloud Management";
        ChooseAll: Boolean;
        DisplayDatabaseSize: Boolean;
        NoCompaniesSelectedErr: Label 'You must select at least one company to migrate to continue.';
        RunWizardPermissionErr: Label 'You do not have permissions to execute this task. Contact your system administrator.';
        UpdatedReplicationCompaniesMsg: Label 'Company selection changes will be reflected on your next migration.';
        CancelConfirmMsg: Label 'Exit without saving company selection changes?';

    local procedure VerifyCompanySelection(): Boolean
    var
        DatabaseSizeTooLargeDialog: Page "Database Size Too Large Dialog";
    begin
        Reset();
        Rec.SetRange(Replicate, true);

        if not Rec.FindSet() then
            Error(NoCompaniesSelectedErr);

        if Rec.GetTotalMigrationSize() > 30 then
            if DatabaseSizeTooLargeDialog.RunModal() = Action::No then begin
                Rec.Reset();
                exit;
            end;

        Rec.Reset();
        exit(true);
    end;
}