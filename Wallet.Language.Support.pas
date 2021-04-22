unit Wallet.Language.Support;

interface

uses System.Generics.Collections, PascalCoin.Consts, UC.Language.Interfaces;

type

/// <summary>
///   This is a temporary solution, and is really a placeholder for a slicker
///   approach in future. Supported Languages will eventually be
/// </summary>
TLanguageManager = class(TInterfacedObject, ILanguageManager)
private
  FLanguagePath: String;
  FDictionary: TDictionary<string,string>;
  protected
    Function GetLanguagePath: String;
    procedure LoadLanguage(const ALanguageCode: String);
  function GetText(const AKey: String): String;

  public
  constructor Create(const ALanguageCode, ALanguagePath: String);
  Destructor Destroy; override;
end;

TLanguagesSupported = class(TInterfacedObject, ILanguagesSupported)
private
  FLanguages: TList<TLanguageData>;
  FLanguagePath: String;
protected
  function GetLanguages(const Index: Integer): TLanguageData;
  function Count: Integer;
  Procedure Load;
public
  constructor Create(Const ALanguagePath: String);
  Destructor Destroy; override;
end;

implementation

{ TLanguageManager }

uses System.Classes, System.IOUtils, Wallet.Utils.Misc;

constructor TLanguageManager.Create(const ALanguageCode, ALanguagePath: String);
begin
  inherited Create;
  FDictionary := TDictionary<string,string>.Create;

  FLanguagePath := ALanguagePath;

  if ALanguageCode <> '' then
     LoadLanguage(ALanguageCode);
end;

destructor TLanguageManager.Destroy;
begin
  FDictionary.Free;
  inherited;
end;

function TLanguageManager.GetLanguagePath: String;
begin
  Result := FLanguagePath;
end;

function TLanguageManager.GetText(const AKey: String): String;
begin
  if not FDictionary.TryGetValue(AKey, Result) then
     Result := AKey;
end;

procedure TLanguageManager.LoadLanguage(const ALanguageCode: String);
var TS: TStringList;
  I: Integer;
begin
  FDictionary.Clear;
  TS := TStringList.Create;
  Try
  if (ALanguageCode = 'ENG') Or (ALanguageCode = '') then
     TS.Text := ResourceAsString('language_eng')
  else
     TS.LoadFromFile(TPath.Combine(FLanguagePath, 'Language_' + ALanguageCode + '.txt'));
     for I := 0 to TS.Count - 1 do
     begin
        if TS[I] <> '' then
           FDictionary.TryAdd(TS.Names[I], TS.ValueFromIndex[I]);
     end;
  Finally
    TS.Free;
  End;
end;

{ TLanguagesSupported }

constructor TLanguagesSupported.Create(Const ALanguagePath: String);
begin
  inherited Create;
  FLanguagePath := ALanguagePath;
  FLanguages := TList<TLanguageData>.Create;
  Load;
end;

destructor TLanguagesSupported.Destroy;
begin
  FLanguages.Free;

  inherited;
end;

function TLanguagesSupported.GetLanguages(const Index: Integer): TLanguageData;
begin
  Result := FLanguages[Index];
end;

procedure TLanguagesSupported.Load;
begin
  FLanguages.Add(TLanguageData.Create('English', 'ENG'));

end;

function TLanguagesSupported.Count: Integer;
begin
  Result := FLanguages.Count;

end;

end.
