Unit PascalCoin.Key.Classes;

Interface

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.Key.Interfaces,
  PascalCoin.Consts;

Type

  TPascalPublicKey = Class(TInterfacedObject, IPascalPublicKey)
  Private
    FKey: String;
    FKeyType: TKeyType;
  Protected
    Function GetKey: String;
    Procedure SetKey(Const Value: String);
    Function GetAsBase58: String;
    Procedure SetAsBase58(Const Value: String);
    Function GetKeyType: TKeyType;
    Procedure SetKeyType(Const Value: TKeyType);
  Public
    constructor Create(Const AKey: String; Const AKeyType: TKeyType);
  End;

  TPascalPrivateKey = Class(TInterfacedObject, IPascalPrivateKey)
  Private
    FKey: String;
  Protected
    Function GetKey: String;
    Procedure SetKey(Value: String);
    Procedure EncryptKey(Const AOldPassword, ANewPassword: String);
  Public
    Constructor Create(Const AKey: String);
  End;

  TPascalKey = Class(TInterfacedObject, IPascalKey)
  Private
    FPublicKey: IPascalPublicKey;
    FPrivateKey: IPascalPrivateKey;
    FEncryptionState: TEncryptionState;
    FName: String;
    FPassword: String;
  Protected
    Function GetKeyType: TKeyType;
    Procedure SetKeyType(Const Value: TKeyType);
    Function GetName: String;
    Procedure SetName(Const Value: String);
    Function GetPublicKey: IPascalPublicKey;
    Function GetPrivateKey: IPascalPrivateKey;
    Procedure Unlock(Const APassword: String);
    Procedure Lock;
    Procedure EncryptKey(Const AOldPassword, ANewPassword: String);
    Function GetDecryptedPrivateKey: String;
  Public
    Constructor Create(Const AEncryptedState: TEncryptionState); Overload;
    Constructor Create(AJSON: TJSONValue; Const AEncryptedState: TEncryptionState); Overload;
    constructor Create(APrivateKey: IPascalPrivateKey; APublicKey:
        IPascalPublicKey; Const AName: String = ''; Const AEncryptedState:
        TEncryptionState = esPlainText); overload;
  End;

  TPascalKeyRing = Class(TInterfacedObject, IPascalKeyRing)
  Private
    FKeys: TList<IPascalKey>;
    FPassword: String;
    FEncryptionState: TEncryptionState;
    FFileName: String;
    FName: String;
  Protected
    Function GetKey(Const Index: Integer): IPascalKey;
    Function GetKeyByName(Const AName: String): IPascalKey;
    Function GetEncryptionState: TEncryptionState;
    Function GetName: String;
    Procedure SetName(Const Value: String);

    Function AddKey(Value: IPascalKey): Integer;
    Function KeyCount: Integer;

    Procedure SetPassword(Const Value: String);
    Procedure UnlockWallet(Const APassword: String);
    Procedure LockWallet;
    Procedure EncryptWallet(Const AOldPassword, ANewPassword: String);
    Procedure SaveAs(Const AFileName: String);
    Procedure Save;
  Public
    Constructor Create(Const AFileName: String);
    Destructor Destroy; Override;
  End;

Implementation

Uses
  System.IOUtils,
  System.SysUtils,
  System.Rtti,
  System.StrUtils,
  REST.JSON,
  PascalCoin.KeyUtils,
  Wallet.Config,
  Wallet.Exceptions, UC.Utils;

{ TPascalPublicKey }

constructor TPascalPublicKey.Create(Const AKey: String; Const AKeyType: TKeyType);
Begin
  Inherited Create;
  FKey := AKey;
  FKeyType := AKeyType;
End;

Function TPascalPublicKey.GetAsBase58: String;
Begin
  Result := TKeyUtils.GetPascalCoinPublicKeyAsBase58(FKey);
End;

Function TPascalPublicKey.GetKey: String;
Begin
  Result := FKey;
End;

Function TPascalPublicKey.GetKeyType: TKeyType;
Begin
  Result := FKeyType;
End;

Procedure TPascalPublicKey.SetAsBase58(Const Value: String);
Begin
  FKey := TKeyUtils.GetPascalCoinPublicKeyFromBase58(Value);
End;

Procedure TPascalPublicKey.SetKey(Const Value: String);
Begin
  FKey := Value;
End;

Procedure TPascalPublicKey.SetKeyType(Const Value: TKeyType);
Begin
  FKeyType := Value;
End;

{ TPascalPrivateKey }

Constructor TPascalPrivateKey.Create(Const AKey: String);
Begin
  Inherited Create;
  FKey := AKey;
End;

Procedure TPascalPrivateKey.EncryptKey(Const AOldPassword, ANewPassword: String);
Var
  lKey: String;
Begin
  If AOldPassword = '' Then
    lKey := FKey
  Else
  Begin
    If Not TKeyUtils.DecryptPascalCoinPrivateKey(FKey, AOldPassword, lKey) Then
      Raise EPrivateKeyDecryptionException.Create('UNABLE_TO_DECRYPT_KEY');
  End;
  IF ANewPassword = '' Then
    FKey := lKey
  Else
    FKey := TKeyUtils.EncryptPascalCoinPrivateKey(lKey, ANewPassword);
End;

Function TPascalPrivateKey.GetKey: String;
Begin
  Result := FKey;
End;

Procedure TPascalPrivateKey.SetKey(Value: String);
Begin
  FKey := Value;
End;

{ TPascalKey }

Constructor TPascalKey.Create(Const AEncryptedState: TEncryptionState);
Begin
  Inherited Create;
  FEncryptionState := AEncryptedState;
End;

Constructor TPascalKey.Create(AJSON: TJSONValue; Const AEncryptedState: TEncryptionState);
Var
  lObj: TJSONObject;
  lKeyType: TKeyType;
Begin
  Create(AEncryptedState);
  lObj := AJSON As TJSONObject;
  lKeyType := TRttiEnumerationType.GetValue<TKeyType>(lObj.GetValue<String>('KeyType'));
  FPublicKey := TPascalPublicKey.Create(lObj.GetValue<String>('PublicKey'), lKeyType);
  FPrivateKey := TPascalPrivateKey.Create(lObj.GetValue<String>('PrivateKey'));

  FName := lObj.GetValue<String>('Name');
End;

constructor TPascalKey.Create(APrivateKey: IPascalPrivateKey; APublicKey: IPascalPublicKey; Const AName: String = ''; Const AEncryptedState: TEncryptionState = esPlainText);
begin
  Create(AEncryptedState);
  FPrivateKey := APrivateKey;
  FPublicKey := APublicKey;
  FName := AName;
end;

Procedure TPascalKey.EncryptKey(Const AOldPassword, ANewPassword: String);
Begin
  FPrivateKey.EncryptKey(AOldPassword, ANewPassword);
  If ANewPassword <> '' Then
    FEncryptionState := esEncrypted;
  FPassword := ANewPassword;
End;

Function TPascalKey.GetDecryptedPrivateKey: String;
Begin
  Case FEncryptionState Of
    esPlainText:
      Result := FPrivateKey.Key;
    esEncrypted:
      Begin
        If FPassword = '' Then
        Begin
          Raise EWalletLockedException.Create;
        End;
        If Not TKeyUtils.DecryptPascalCoinPrivateKey(FPrivateKey.Key, FPassword, Result) Then
          Raise EPrivateKeyDecryptionException.Create('UNABLE_TO_DECRYPT_KEY');
      End;
  End;
End;

Function TPascalKey.GetKeyType: TKeyType;
Begin
  Result := FPublicKey.KeyType;
End;

Function TPascalKey.GetName: String;
Begin
  Result := FName;
End;

Function TPascalKey.GetPrivateKey: IPascalPrivateKey;
Begin
  Result := FPrivateKey;
End;

Function TPascalKey.GetPublicKey: IPascalPublicKey;
Begin
  Result := FPublicKey;
End;

Procedure TPascalKey.Lock;
Begin
  FPassword := '';
End;

Procedure TPascalKey.SetKeyType(Const Value: TKeyType);
Begin
  FPublicKey.KeyType := Value;
End;

Procedure TPascalKey.SetName(Const Value: String);
Begin
  FName := Value;
End;

Procedure TPascalKey.Unlock(Const APassword: String);
Begin
  FPassword := APassword;
End;

{ TPascalKeyRing }

Function TPascalKeyRing.AddKey(Value: IPascalKey): Integer;
Begin
  Result := FKeys.Add(Value);
End;

Constructor TPascalKeyRing.Create(Const AFileName: String);
Var
  lKeyRing: TJSONObject;
  lKeys: TJSONArray;
  lKey: TJSONValue;
  S: String;
Begin
  Inherited Create;
  FFileName := AFileName;
  FKeys := TList<IPascalKey>.Create;
  FEncryptionState := TEncryptionState.esPlainText;

  If TFile.Exists(FFileName) Then
  Begin
    lKeyRing := TJSONObject.ParseJSONValue(TFile.ReadAllText(FFileName)) As TJSONObject;
    If Not lKeyRing.TryGetValue<String>('Name', FName) Then
      FName := 'Unamed Key Ring';
    If lKeyRing.TryGetValue<String>('State', S) Then
      FEncryptionState := TRttiEnumerationType.GetValue<TEncryptionState>(S);
    lKeys := lKeyRing.GetValue<TJSONArray>('Keys');
    For lKey In lKeys Do
      AddKey(TPascalKey.Create(lKey, FEncryptionState));
  End;
End;

Destructor TPascalKeyRing.Destroy;
Begin
  FKeys.Free;
  Inherited;
End;

Procedure TPascalKeyRing.EncryptWallet(Const AOldPassword, ANewPassword: String);
Var
  lKey: IPascalKey;
Begin
  For lKey In FKeys Do
  Begin
    lKey.EncryptKey(AOldPassword, ANewPassword);
  End;
End;

Function TPascalKeyRing.GetEncryptionState: TEncryptionState;
Begin
  Result := FEncryptionState;
End;

Function TPascalKeyRing.GetKey(Const Index: Integer): IPascalKey;
Begin
  Result := FKeys[Index];
End;

Function TPascalKeyRing.GetKeyByName(Const AName: String): IPascalKey;
Var
  lKey: IPascalKey;
Begin
  Result := Nil;
  For lKey In FKeys Do
  Begin
    If SameText(lKey.Name, AName) Then
      Exit(lKey);
  End;
End;

Function TPascalKeyRing.GetName: String;
Begin
  Result := FName;
End;

Function TPascalKeyRing.KeyCount: Integer;
Begin
  Result := FKeys.Count;
End;

Procedure TPascalKeyRing.LockWallet;
Var
  lKey: IPascalKey;
Begin
  For lKey In FKeys Do
  Begin
    lKey.Lock;
  End;
End;

Procedure TPascalKeyRing.Save;
Begin
  SaveAs(FFileName);
End;

Procedure TPascalKeyRing.SaveAs(Const AFileName: String);
Var
  lKeyRing: TJSONObject;
  lKeys: TJSONArray;
Begin

End;

Procedure TPascalKeyRing.SetName(Const Value: String);
Begin
  FName := Value
End;

Procedure TPascalKeyRing.SetPassword(Const Value: String);
Begin
  FPassword := Value;
End;

Procedure TPascalKeyRing.UnlockWallet(Const APassword: String);
Var
  lKey: IPascalKey;
Begin
  FPassword := APassword;
  For lKey In FKeys Do
  Begin
    lKey.Unlock(FPassword);
  End;
End;

End.
