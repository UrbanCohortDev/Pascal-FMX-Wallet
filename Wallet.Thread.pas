Unit Wallet.Thread;

Interface

Uses
  System.Classes,
  System.Generics.Collections,
  PascalCoin.Consts,
  PascalCoin.RPC.Interfaces,
  PascalCoin.Key.Interfaces;

Type

  TPublicKeyRec = Record
    Key: String;
    KeyType: TKeyType;
    Constructor Create(Const AKey: String; Const AKeyType: TKeyType);
  End;

  TPublicKeyList = TList<TPublicKeyRec>;

  TWalletThread = Class(TThread)
  Private
    FExplorer: IPascalCoinWalletAPI;
    FAccounts: TDictionary<String, IPascalCoinAccounts>;
    FKeys: TPublicKeyList;
    Procedure ProcessKeys;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(AExplorerAPI: IPascalCoinWalletAPI; Const APublicKeyList: TPublicKeyList); Overload;
    Destructor Destroy; Override;
  End;

Implementation

{ TPublicKeyRec }

Constructor TPublicKeyRec.Create(Const AKey: String; Const AKeyType: TKeyType);
Begin
  Key := AKey;
  KeyType := AKeyType;
End;

{ TWalletThread }

Constructor TWalletThread.Create(AExplorerAPI: IPascalCoinWalletAPI; Const APublicKeyList: TPublicKeyList);
Begin
  Inherited Create(True);
  FExplorer := AExplorerAPI;
  FKeys := APublicKeyList;
  FAccounts := TDictionary<String, IPascalCoinAccounts>.Create;
End;

Destructor TWalletThread.Destroy;
Begin
  FAccounts.Free;
  FKeys.Free;
  FExplorer := Nil;
  Inherited;
End;

Procedure TWalletThread.Execute;
Begin
  Inherited;

End;

Procedure TWalletThread.ProcessKeys;
Var
  K: String;
  I: Integer;
Begin
  // for I := 0 to FKeys.Count - 1 do
  // begin
  //
  // end;
  //
  // for S in FKeys do
  // begin
  // if FAccounts.ContainsKey(S) then
  // Process
  //
  //
  // end;
End;

End.
