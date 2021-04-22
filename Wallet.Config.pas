unit Wallet.Config;

interface
Uses
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  PascalCoin.Consts,
  UC.Language.Interfaces;

Type

  TWalletConfig = Class
  Private
    FConfigFolder: String;
    FConfigFile: String;
    FServers: TStringPairList;
    FServer: TStringPair;
    FWallets: TStringPairList;
    FWallet: TStringPair;
    FIsTestNet: Boolean;
    FLanguage: String;
    FThemeName: String;
    FBaseCurrency: String;
    FLocaleCurrency: String;
    FLanguageManager: ILanguageManager;
    FTranslateEnabled: Boolean;
    FTranslateLanguage: string;

    Function GetServers: TStringPairList;
    Function GetConfigFolder: String;
    Function GetRPCClient: IPascalCoinRPCClient;
    Function GetExplorerAPI: IPascalCoinExplorerAPI;
    Function GetNodeAPI: IPascalCoinNodeAPI;
    Function GetWalletAPI: IPascalCoinWalletAPI;
    function GetOperationsAPI: IPascalCoinOperationsAPI;
    function GetWallet: TStringPair;
    function GetWallets: TStringPairList;
    function GetServer: TStringPair;
    function GetIsTestNet: Boolean;
    function GetLanguage: String;
    procedure SetLanguage(const Value: String);
    function GetLanguageManager: ILanguageManager;
    function GetThemeName: String;
    procedure SetThemeName(const Value: String);
    function GetBaseCurrency: String;
    procedure SetBaseCurrency(const Value: String);
    function GetLocaleCurrency: String;
    procedure SetLocaleCurrency(const Value: String);
    function UseAsBaseCurrency: String;
    function GetTranslateEnabled: Boolean;
    procedure SetTranslateEnabled(const Value: Boolean);
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Save;
    Procedure Load;
    procedure AddServer(Const AName, AURI: String);
    procedure UpdateServer(Const AKey, AValue: String); overload;
    procedure UpdateServer(const Value: TStringPair); overload;
    function SupportedCurrency(const Value: String): Boolean;
    function ServerNodeAPI(const AServer: TStringPair): IPascalCoinNodeAPI;

    Property ConfigFolder: String Read GetConfigFolder;
    /// <summary>
    ///   List of registred servers
    /// </summary>
    Property Servers: TStringPairList Read GetServers;
    /// <summary>
    ///   Current active server
    /// </summary>
    Property Server: TStringPair Read GetServer;
    /// <summary>
    ///   List of registered wallets
    /// </summary>
    Property Wallets: TStringPairList Read GetWallets;
    /// <summary>
    ///   Active Wallet
    /// </summary>
    Property Wallet: TStringPair read GetWallet;

    Property IsTestNet: Boolean read GetIsTestNet;
    Property BaseCurrency: String read GetBaseCurrency write SetBaseCurrency;
    Property LocaleCurrency: String read GetLocaleCurrency write SetLocaleCurrency;
    Property Language: String read GetLanguage write SetLanguage;
    Property ThemeName: String Read GetThemeName write SetThemeName;
    Property LanguageManager: ILanguageManager read GetLanguageManager;
    Property TranslateEnabled: Boolean read GetTranslateEnabled write SetTranslateEnabled;

    Property ExplorerAPI: IPascalCoinExplorerAPI Read GetExplorerAPI;
    Property NodeAPI: IPascalCoinNodeAPI Read GetNodeAPI;
    Property WalletAPI: IPascalCoinWalletAPI Read GetWalletAPI;
    Property OperationsAPI: IPascalCoinOperationsAPI read GetOperationsAPI;

  End;

Implementation

Uses
  System.IOUtils,
  System.SysUtils,
  System.JSON,
  Rest.Json,
  UC.Net.Interfaces,
  UC.HTTPClient.Delphi,
  PascalCoin.RPC.Client,
  PascalCoin.RPC.API.Node,
  PascalCoin.RPC.API.Explorer,
  PascalCoin.RPC.API.Wallet,
  PascalCoin.RPC.API.Operations,
  Wallet.Exceptions, Wallet.Utils.Misc,
  Wallet.Language.Support, Wallet.Shared;

Const
C_SUPPORTED_CURRENCIES = 'GBP;USD;EUR;BTC;';

{ TDevAppConfig }

Procedure TWalletConfig.AddServer(Const AName, AURI: String);
Begin
  FServers.Add(TStringPair.Create(AName, AURI));
  Save;
End;

Constructor TWalletConfig.Create;
Begin
  Inherited Create;

  FServers := TStringPairList.Create;
  FWallets := TStringPairList.Create;

  {$IFDEF TESTNET}
   FConfigFolder := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'PascalCoin_UrbanCohort_TestNet'), 'Wallet');
  {$ELSE}
  FConfigFolder := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'PascalCoin_UrbanCohort'), 'Wallet');
  {$ENDIF}

  TDirectory.CreateDirectory(FConfigFolder);

  FConfigFile := TPath.Combine(FConfigFolder, 'Config.json');

  If TFile.Exists(FConfigFile) Then
  begin
    Load;
  end
  Else
  begin
    { TODO : Make this Locale Based? }
    FLanguage := 'ENG';
    FBaseCurrency := UseAsBaseCurrency;
    FThemeName := THEME_PASCAL;
    FWallet := TStringPair.Create('DefaultWallet', TPath.Combine(FConfigFolder, 'DefaultWallet.json'));
    FWallets.Add(FWallet);
   FTranslateEnabled := False;
   FTranslateLanguage := '';
    {$IFDEF TESTNET}
    FIsTestNet := True;
    FServer := TStringPair.Create('localhost','http://127.0.0.1:4203');
    FServers.Add(FServer);
    {$ELSE}
    FIsTestNet := False;
    {$IFDEF DEVMODE}
    FServer := TStringPair.Create('localhost','http://127.0.0.1:4003');
    {$ELSE}
    FServer := TStringPair.Create('localhost','http://127.0.0.1:4003');
    {$ENDIF}
    FServers.Add(FServer);
    {$ENDIF}
    Save;
  end;

  FLanguageManager := TLanguageManager.Create(FLanguage, FConfigFolder);
End;

Destructor TWalletConfig.Destroy;
Begin
  FServers.Free;
  FWallets.Free;
  FLanguageManager := Nil;
  Inherited;
End;

Function TWalletConfig.GetConfigFolder: String;
Begin
  Result := TPath.GetDirectoryName(FConfigFile);
End;

Function TWalletConfig.GetExplorerAPI: IPascalCoinExplorerAPI;
Begin
  Result := TPascalCoinExplorerAPI.Create(GetRPCClient);
  Result.NodeURI := FServer.Value;
End;

function TWalletConfig.GetBaseCurrency: String;
begin
  if FBaseCurrency = '' then
  { TODO : Make this Locale Based? }
     FBaseCurrency := 'GBP';
  result := FBaseCurrency;
end;

function TWalletConfig.GetIsTestNet: Boolean;
begin
  Result := FIsTestNet;
end;

function TWalletConfig.GetLanguage: String;
begin
  if FLanguage = '' then
     FLanguage := 'ENG';
  Result := FLanguage;
end;

function TWalletConfig.GetLanguageManager: ILanguageManager;
begin
  Result := FLanguageManager;
end;

function TWalletConfig.GetLocaleCurrency: String;
begin
  result := FLocaleCurrency;
end;

Function TWalletConfig.GetNodeAPI: IPascalCoinNodeAPI;
Begin
  Result := TPascalCoinNodeAPI.Create(GetRPCClient);
  Result.NodeURI := FServer.Value;
End;

function TWalletConfig.GetOperationsAPI: IPascalCoinOperationsAPI;
begin
  Result := TPascalCoinOperationsAPI.Create(GetRPCClient);
  Result.NodeURI := FServer.Value;
end;

Function TWalletConfig.GetRPCClient: IPascalCoinRPCClient;
Begin
  Result := TPascalCoinRPCClient.Create(TDelphiHTTP.Create);
End;

function TWalletConfig.GetServer: TStringPair;
begin
  Result := FServer;
end;

function TWalletConfig.GetServers: TStringPairList;
Begin
  Result := FServers;
End;

function TWalletConfig.GetThemeName: String;
begin
  Result := FThemeName;
end;

function TWalletConfig.GetTranslateEnabled: Boolean;
begin
  Result := FTranslateEnabled;
end;

function TWalletConfig.GetWallet: TStringPair;
begin
  Result := FWallet;
end;

Function TWalletConfig.GetWalletAPI: IPascalCoinWalletAPI;
Begin
  Result := TPascalCoinWalletAPI.Create(GetRPCClient);
  Result.NodeURI := FServer.Value;
End;

function TWalletConfig.GetWallets: TStringPairList;
begin
  Result := FWallets;
end;

procedure TWalletConfig.Load;
    function StringPairFromObj(const AObj: TJSONObject): TStringPair;
    begin
      Result := TStringPair.Create(AObj.GetValue<String>('Key'), AObj.GetValue<String>('Value'));
    end;

var lConfigData: TJSONObject;
    lArray: TJSONArray;
    lObj: TJSONObject;
    lValue: TJSONValue;
begin
  lConfigData := TJSONObject.ParseJSONValue(TFile.ReadAllText(FConfigFile)) As TJSONObject;
  FLanguage := lConfigData.GetValue<String>('Language');
  lConfigData.TryGetValue<String>('BaseCurrency', FBaseCurrency);
  if FBaseCurrency = '' then
     FBaseCurrency := UseAsBaseCurrency;
  FThemeName := lConfigData.GetValue<String>('Theme');
  FTranslateEnabled := False;
  lConfigData.TryGetValue<Boolean>('Translate', FTranslateEnabled);
  FTranslateLanguage := '';
  lConfigData.TryGetValue<string>('TranslateLanguage', FTranslateLanguage);

  lObj := lConfigData.GetValue<TJSONObject>('Wallet');
  FWallet := StringPairFromObj(lObj);
  lArray := lConfigData.GetValue<TJSONArray>('Wallets');
  for lValue in lArray do
    begin
      lObj := lValue as TJSONObject;
      FWallets.Add(StringPairFromObj(lObj));
    end;

  lObj := lConfigData.GetValue<TJSONObject>('Server');
  FServer := StringPairFromObj(lObj);
  lArray := lConfigData.GetValue<TJSONArray>('Servers');
  for lValue in lArray do
    begin
      lObj := lValue as TJSONObject;
      FServers.Add(StringPairFromObj(lObj));
    end;


end;

Procedure TWalletConfig.Save;
  Function ObjFromStringPair(const APair: TStringPair): TJSONObject;
  begin
    Result := TJSONObject.Create;
    Result.AddPair(TJSONPair.Create('Key', APair.Key));
    Result.AddPair(TJSONPair.Create('Value', APair.Value));
  end;
var
lConfigData: TJSONObject;
WalletArray, ServerArray: TJSONArray;
lPair: TStringPair;
Begin

  lConfigData := TJSONObject.Create;
  lConfigData.AddPair('Language', FLanguage);
  lConfigData.AddPair('BaseCurrency', FBaseCurrency);
  lConfigData.AddPair('Theme', FThemeName);

  lConfigData.AddPair('Wallet', ObjFromStringPair(FWallet));
  WalletArray := TJSONArray.Create;
  for lPair in FWallets do
   WalletArray.Add(ObjFromStringPair(lPair));
  lConfigData.AddPair('Wallets', WalletArray);

  lConfigData.AddPair('Server', ObjFromStringPair(FServer));
  ServerArray := TJSONArray.Create;
  for lPair in FServers do
   ServerArray.Add(ObjFromStringPair(lPair));
  lConfigData.AddPair('Servers', ServerArray);
  lConfigData.AddPair('Translate', TJSONBool.Create(FTranslateEnabled));
  lConfigData.AddPair('TranslateLanguage', FTranslateLanguage);

  TFile.WriteAllText(FConfigFile, lConfigData.ToJSON);
End;

function TWalletConfig.ServerNodeAPI(const AServer: TStringPair): IPascalCoinNodeAPI;
begin
  Result := TPascalCoinNodeAPI.Create(GetRPCClient);
  Result.NodeURI := AServer.Value;
end;

procedure TWalletConfig.SetBaseCurrency(const Value: String);
begin
  if Value.Length <> 3 then
     Raise EInvalidCode.Create(FLanguageManager.GetText('INVALID_CURRENCY_CODE'));
  FBaseCurrency := Value;
end;

procedure TWalletConfig.SetLanguage(const Value: String);
begin
  if Value.Length <> 3 then
     Raise EInvalidCode.Create(FLanguageManager.GetText('INVALID_LANGUAGE_CODE'));
  FLanguage := Value;
end;

procedure TWalletConfig.SetLocaleCurrency(const Value: String);
begin
  if Value = '£' then
     FLocaleCurrency := 'GBP'
  else if Value = '$' then
     FLocaleCurrency := 'USD'
  else if Value = '€' then
     FLocaleCurrency := 'EUR'
  else
     FLocaleCurrency := Value;
end;

procedure TWalletConfig.SetThemeName(const Value: String);
begin
  FThemeName := Value;
end;

procedure TWalletConfig.SetTranslateEnabled(const Value: Boolean);
begin
  FTranslateEnabled := Value;
end;

function TWalletConfig.SupportedCurrency(const Value: String): Boolean;
begin
  Result := C_SUPPORTED_CURRENCIES.Contains(Value + ';');
end;

procedure TWalletConfig.UpdateServer(const Value: TStringPair);
begin
  UpdateServer(Value.Key, Value.Value);
end;

function TWalletConfig.UseAsBaseCurrency: String;
begin
    if SupportedCurrency(FLocaleCurrency) then
       Result := FLocaleCurrency
    else
       Result := 'GBP';
end;

procedure TWalletConfig.UpdateServer(const AKey, AValue: String);
begin
  FServer.Key := AKey;
  FServer.Value := Avalue;
end;

end.
