Unit Wallet.Frame.Settings;

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
  PascalCoin.Consts,
  FMX.ListBox,
  FMX.Controls.Presentation,
  FMX.Layouts,
  UC.Language.Interfaces,
  System.Actions,
  FMX.ActnList, FMX.Objects;

Type
  TSettingsFrame = Class(TBaseFrame)
    LanguageLayout: TLayout;
    LanguageCaption: TLabel;
    LanguageList: TComboBox;
    ThemeLayout: TLayout;
    ThemeCaption: TLabel;
    ThemeList: TComboBox;
    BottomButtons: TLayout;
    SaveButton: TButton;
    FiatLayout: TLayout;
    CurrencyCaption: TLabel;
    CurrencyList: TComboBox;
    SettingsActions: TActionList;
    SaveAction: TAction;
    NodeLayout: TLayout;
    NodeCaption: TLabel;
    NodeList: TComboBox;
    NodeStatusLabel: TLabel;
    InfoLayout: TLayout;
    ConfigPathLayout: TLayout;
    ConfigPathCaption: TLabel;
    ConfigPathValue: TLabel;
    Layout1: TLayout;
    LocalIPCaption: TLabel;
    LocalIPValue: TLabel;
    PublicIPLayout: TLayout;
    PublicIPCaption: TLabel;
    PublicIPValue: TLabel;
    Line1: TLine;
    AddNodeButton: TSpeedButton;
    AddNodeAction: TAction;
    DisplayIPAction: TAction;
    NodeSubLayout: TLayout;
    procedure AddNodeActionExecute(Sender: TObject);
    Procedure CurrencyListChange(Sender: TObject);
    procedure DisplayIPActionExecute(Sender: TObject);
    Procedure LanguageListChange(Sender: TObject);
    Procedure NodeListChange(Sender: TObject);
    Procedure SaveActionExecute(Sender: TObject);
  Private
    { Private declarations }
    FLanguages: ILanguagesSupported;
    FInitialising: Boolean;
    Function DataHasChanged: Boolean;
    Function SelectedServer: TStringPair;
  Protected
  Public
    { Public declarations }
    Constructor Create(AOwner: TComponent); Override;
    Function CanClose: Boolean; Override;
    Procedure InitialiseThis; Override;

  End;

Var
  SettingsFrame: TSettingsFrame;

Implementation

{$R *.fmx}

Uses
  FMX.DialogService,
  System.JSON,
  Wallet.Shared,
  Wallet.Language.Support,
  Wallet.Utils.Misc,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.Exceptions,
  UC.Internet.Support;

{ TSettingsFrame }

Function TSettingsFrame.CanClose: Boolean;
Begin
  If DataHasChanged Then
  Begin
    Result := Confirm(Config.LanguageManager.GetText('SETTINGS_HAVE_CHANGED')) = mrYes;
  End
  Else
    Result := True;
End;

Constructor TSettingsFrame.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  FLanguages := TLanguagesSupported.Create(Config.LanguageManager.LanguagePath);
End;

procedure TSettingsFrame.AddNodeActionExecute(Sender: TObject);
begin
  inherited;
  //
end;

Procedure TSettingsFrame.CurrencyListChange(Sender: TObject);
Begin
  Inherited;
  SaveAction.Enabled := DataHasChanged;
End;

Function TSettingsFrame.DataHasChanged: Boolean;
Var
  lPair: TStringPair;
Begin
  If FInitialising Then
    Exit(False);
  lPair := SelectedServer;
  Result := (Config.Language <> FLanguages[LanguageList.ItemIndex].Code) OR
    (Config.BaseCurrency <> CurrencyList.Items[CurrencyList.ItemIndex]) OR
    (Config.ThemeName <> ThemeList.Items[ThemeList.ItemIndex].ToUpper) OR (Config.Server.Value <> lPair.Value);
End;

procedure TSettingsFrame.DisplayIPActionExecute(Sender: TObject);
begin
  inherited;

  LocalIPValue.Text := TInternetSupport.GetLocalIP;
  PublicIPValue.Text := TInternetSupport.GetPublicIP;

  PublicIPValue.StyledSettings := DefaultStyledSettings;
  PublicIPValue.Cursor := crDefault;
  PublicIPValue.HitTest := False;

  LocalIPValue.StyledSettings := DefaultStyledSettings;
  LocalIPValue.Cursor := crDefault;
  LocalIPValue.OnClick := Nil;
  LocalIPValue.HitTest := False;
end;

Procedure TSettingsFrame.InitialiseThis;
Var
  I, iIndex: Integer;
  lPair: TStringPair;
  lLangPair: TLanguageData;
Begin
  Inherited;
  FInitialising := True;
  Try
    iIndex := -1;
    For I := 0 To FLanguages.Count - 1 Do
    Begin
      lLangPair := FLanguages.Languages[I];
      LanguageList.Items.Add(lLangPair.Name);
      If lLangPair.Code = Config.Language Then
        iIndex := I;
    End;

    LanguageList.ItemIndex := iIndex;
    ThemeList.ItemIndex := ThemeList.Items.IndexOf(Config.ThemeName);
    CurrencyList.ItemIndex := CurrencyList.Items.IndexOf(Config.BaseCurrency);

    iIndex := -1;
    For I := 0 To Config.Servers.Count - 1 Do
    Begin
      lPair := Config.Servers[I];
      NodeList.Items.Add(lPair.Key + ' | ' + lPair.Value);
      If Config.Server.Value = lPair.Value Then
        iIndex := I;
    End;

    NodeList.ItemIndex := iIndex;
    ConfigPathValue.Text := Config.ConfigFolder;

  Finally
    FInitialising := False;
  End;
End;

Procedure TSettingsFrame.LanguageListChange(Sender: TObject);
Begin
  SaveAction.Enabled := DataHasChanged;
End;

Procedure TSettingsFrame.NodeListChange(Sender: TObject);
Var
  NS: IPascalCoinNodeStatus;
  JO: TJSONObject;
Begin
  Inherited;
  SaveAction.Enabled := DataHasChanged;
  Try
    NS := Config.ServerNodeAPI(SelectedServer).NodeStatus;
    NodeStatusLabel.Text := NS.status_s + C_TESTNET[NS.GetIsTestNet];
  Except
    On e: ENotAllowedException Do
    Begin
      NodeStatusLabel.Text := Config.LanguageManager.GetText('ACTIVE_BUT_NOT_SUPPORTED');
      Exit;
    End;
    On e: exception Do
    Begin
      NodeStatusLabel.Text := Config.LanguageManager.GetText('OOPS');
      If e.Message.StartsWith('{') Then
      Begin
        JO := TJSONObject.ParseJSONValue(e.Message) As TJSONObject;
        showmessage(JO.GetValue<String>('StatusMessage'));
      End
      Else
        showmessage(e.Message);
    End;
  End;
End;

Procedure TSettingsFrame.SaveActionExecute(Sender: TObject);
Var
  lPair: TStringPair;
Begin
  Config.Language := FLanguages[LanguageList.ItemIndex].Code;
  Config.BaseCurrency := CurrencyList.Items[CurrencyList.ItemIndex];
  Config.ThemeName := ThemeList.Items[ThemeList.ItemIndex];

  lPair := SelectedServer;

  Config.UpdateServer(lPair);

  Config.Save;
  SaveAction.Enabled := DataHasChanged;
End;

Function TSettingsFrame.SelectedServer: TStringPair;
Var
  lValue: TArray<String>;
  lVal: String;
Begin
  lVal := NodeList.Items[NodeList.ItemIndex];
  lValue := lVal.Split(['|']);
  Result := TStringPair.Create(lValue[0].Trim, lValue[1].Trim);
End;

End.
