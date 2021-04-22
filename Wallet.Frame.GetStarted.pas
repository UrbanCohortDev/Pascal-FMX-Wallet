/// <summary>
/// <para>
/// <b>New Key Flow</b><br /><br />KeyOptionTab <br />|--&gt;NewKeyTab <br />
/// | |--&gt;PASAOptionTab <br />| | -----&gt;KeyNameTab <br />|
/// |---------&gt;FinishWithSendPASATab <br />| |
/// ---------&gt;FinishWithPayToKeyTab <br />
/// </para>
/// <para>
/// <b>Import Key Flow</b>
/// </para>
/// <para>
/// KeyOptionTab <br />|--&gt;ImportKeyTab <br />| |--&gt;PASAOptionTab
/// (If no PASA linked to key) <br />| | -----&gt;KeyNameTab <br />|
/// |---------&gt;FinishWithSendPASATab <br />|
/// |---------&gt;FinishWithPayToKeyTab <br />| |
/// ---------&gt;FinishWithExisitngPASA <br /><br /><br /><br />
/// </para>
/// </summary>
Unit Wallet.Frame.GetStarted;

Interface

Uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  Wallet.Frame.Base,
  FMX.Layouts,
  FMX.Objects,
  FMX.Controls.Presentation,
  Wallet.DataModule.Assets,
  FMX.TabControl,
  FMX.ImgList,
  SubjectStand,
  FrameStand,
  Wallet.Shared,
  PascalCoin.KeyUtils,
  PascalCoin.Consts,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  PascalCoin.Utils,
  PascalCoin.RPC.Interfaces,
  FMX.Edit,
  Wallet.DataModule.Main;

Type
  TGetStartedMode = (gsmNewKey, gsmNewPASA);

  TGetStartedFrame = Class(TBaseFrame)
    ButtonLayout: TLayout;
    NextButton: TSpeedButton;
    PreviousButton: TSpeedButton;
    CancelButton: TSpeedButton;
    WizardControl: TTabControl;
    KeyOptionTab: TTabItem;
    ImportKeyRadio: TRadioButton;
    WelcomeLabel: TLabel;
    NewKeyRadio: TRadioButton;
    PASAOptionTab: TTabItem;
    PASALabel: TLabel;
    NewPASARequest: TRadioButton;
    NewPASAPayToKey: TRadioButton;
    ImportKeyTab: TTabItem;
    ImportKeyLabel: TLabel;
    PrivateKeyMemo: TMemo;
    FinishWithSendPASATab: TTabItem;
    SendPASALabel: TLabel;
    Memo1: TMemo;
    KeyNameTab: TTabItem;
    KeyNameLabel: TLabel;
    KeyName: TEdit;
    FinishWithPayToKeyTab: TTabItem;
    Password: TEdit;
    RepeatPassword: TEdit;
    FinishWithExisitingPASATab: TTabItem;
    PayToKeyLabel: TLabel;
    Procedure NextButtonClick(Sender: TObject);
    procedure PayToKeyLabelClick(Sender: TObject);
  Private
    FOnSuccess: TProc;
    FOnCancel: TProc;
    FMode: TGetStartedMode;
    FStartPage: Integer;
    FAfterKeyNameTab: TTabItem;

    FKeyPair: TStringPair;
    FKeyType: TKeyType;
    FKeyName: String;
    FPassword: String;
    FAccounts: IPascalCoinAccounts;
    FKeysSaved: Boolean;

    Procedure SetFinalPageProps;
    Procedure SaveKeysToWallet;
    Procedure FinishWizard;
    Procedure HandleKeyOptionTab;
    Procedure HandleNewKeyOptionTab;
    Procedure HandlKeyImportTab;
    Procedure HandleKeyNameTab;
    Procedure HandlePASAOptionTab;
  Protected
    Procedure TranslateThis; Override;
  Public
    { Public declarations }
    [BeforeShow]
    Procedure BeforeShow;
    Procedure InitialiseThis; Override;
    Property OnSuccess: TProc Read FOnSuccess Write FOnSuccess;
    Property OnCancel: TProc Read FOnCancel Write FOnCancel;
    Property Mode: TGetStartedMode Write FMode;
  End;

Var
  GetStartedFrame: TGetStartedFrame;

Implementation

{$R *.fmx}

Uses
  PascalCoin.Key.Interfaces,
  PascalCoin.Key.Classes,
  System.RTTi,
  FMX.PlatformUtils;
{ TGetStartedFrame }

Procedure TGetStartedFrame.BeforeShow;
Begin

End;

Procedure TGetStartedFrame.FinishWizard;
Begin
  // TODO -cMM: TGetStartedFrame.FinishWizard default body inserted
End;

Procedure TGetStartedFrame.HandleKeyNameTab;
Begin
  If Password.Text.Trim = '' Then
  Begin
    ShowMessage(Config.LanguageManager.GetText('TGetStartedFrame.MSG.ENTER_PASSWORD'));
    Exit;
  End;
  If Password.Text.Trim <> RepeatPassword.Text.Trim Then
  Begin
    ShowMessage(Config.LanguageManager.GetText('TGetStartedFrame.MSG.PASSWORDS_DIFFERENT'));
    Exit;
  End;

  FKeyName := KeyName.Text.Trim;
  FPassword := Password.Text.Trim;

  WizardControl.ActiveTab := FAfterKeyNameTab;
End;

Procedure TGetStartedFrame.HandleKeyOptionTab;
Begin
  If NewKeyRadio.IsChecked Then
    HandleNewKeyOptionTab
  Else If ImportKeyRadio.IsChecked Then
    WizardControl.ActiveTab := ImportKeyTab
  Else
    ShowMessage(Config.LanguageManager.GetText('TGetStartedFrame.MSG.NO_KEY_METHOD_SELECTED'));
End;

Procedure TGetStartedFrame.HandleNewKeyOptionTab;
Begin
  FKeyType := TKeyType.SECP256K1;
  FKeyPair := TKeyUtils.GenerateKeyPair(FKeyType);
  PASALabel.Text := Config.LanguageManager.GetText('TGetStartedFrame.PASALabel.Text[NEW_KEY]');
  FAfterKeyNameTab := PASAOptionTab;
  WizardControl.ActiveTab := KeyNameTab;
End;

Procedure TGetStartedFrame.HandlePASAOptionTab;
Begin
  If NewPASARequest.IsChecked Then
  Begin
    SetFinalPageProps();
    WizardControl.ActiveTab := FinishWithSendPASATab;
  End
  Else If NewPASAPayToKey.IsChecked Then
  Begin
    SetFinalPageProps();
    WizardControl.ActiveTab := FinishWithPayToKeyTab;
  End
  Else
    ShowMessage(Config.LanguageManager.GetText('TGetStartedFrame.MSG.NO_PASA_METHOD_SELECTED'));
End;

Procedure TGetStartedFrame.HandlKeyImportTab;
Var
  lPrivateKey, lPublicKey: String;
Begin

  lPrivateKey := PrivateKeyMemo.Text.Trim;
  FKeyType := TPascalCoinUtils.KeyTypeFromPascalKey(lPrivateKey);
  lPublicKey := TKeyUtils.GetCorrespondingPublicKey(lPrivateKey, FKeyType);

  FKeyPair.Key := lPrivateKey;
  FKeyPair.Value := lPublicKey;

  FAccounts := Config.ExplorerAPI.FindAccountsByKey(lPublicKey);

  If FAccounts.Count = 0 Then
  Begin
    PASALabel.Text := Config.LanguageManager.GetText('TGetStartedFrame.PASALabel.Text[IMPORTED_KEY]');
    FAfterKeyNameTab := PASAOptionTab;
    WizardControl.ActiveTab := KeyNameTab;
  End
  Else
  Begin
    FAfterKeyNameTab := FinishWithExisitingPASATab;
    WizardControl.ActiveTab := KeyNameTab;
  End;
End;

Procedure TGetStartedFrame.InitialiseThis;
Begin
  Inherited;
  FDisplayCaption := Config.LanguageManager.GetText('WELCOME_TO_PASCAL');

  Case FMode Of
    gsmNewKey:
      Begin
        WizardControl.ActiveTab := KeyOptionTab;
        FStartPage := 0;
      End;
    gsmNewPASA:
      ;
  End;

End;

Procedure TGetStartedFrame.NextButtonClick(Sender: TObject);
Begin

  If NextButton.Tag = 2 Then
  Begin
    FOnSuccess();
    Exit;
  End;

  If WizardControl.ActiveTab = KeyOptionTab Then
    HandleKeyOptionTab
  Else If WizardControl.ActiveTab = PASAOptionTab Then
    HandlePASAOptionTab
  Else If WizardControl.ActiveTab = ImportKeyTab Then
    HandlKeyImportTab
  Else If WizardControl.ActiveTab = KeyNameTab Then
    HandleKeyNameTab;

End;

procedure TGetStartedFrame.PayToKeyLabelClick(Sender: TObject);
begin

  FOnCancel();
end;

Procedure TGetStartedFrame.SaveKeysToWallet;
Var
  lKey: IPascalKey;
  lPrivateKey: IPascalPrivateKey;
  lPublicKey: IPascalPublicKey;
Begin
  If FKeysSaved Then
    Exit;

  lPrivateKey := TPascalPrivateKey.Create(FKeyPair.Key);
  lPublicKey := TPascalPublicKey.Create(FKeyPair.Value, FKeyType);
  lKey := TPascalKey.Create(lPrivateKey, lPublicKey, FKeyName);

  MainData.KeyRing.AddKey(lKey);
  // MainData.KeyRing.EncryptWallet('', FPassword);
  MainData.KeyRing.Save;
End;

Procedure TGetStartedFrame.SetFinalPageProps;
Begin
  NextButton.StyleLookup := 'ForwardToolButton';
  NextButton.Tag := 1;
  PreviousButton.Enabled := False;
  CancelButton.Enabled := False;
End;

Procedure TGetStartedFrame.TranslateThis;
Begin
  Inherited;

End;

End.
