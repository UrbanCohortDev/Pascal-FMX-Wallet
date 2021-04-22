Unit Wallet.DataModule.Main;

(* ***********************************************************************
  copyright 2019-2021  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http://www.opensource.org/licenses/mit-license.php.

  PascalCoin website http://pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https://github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23
  BitCoin: 3DPfDtw455qby75TgL3tXTwBuHcWo4BgjL (now isn't the Pascal way easier?)

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  System.SysUtils,
  System.Classes,
  Spring,
  PascalCoin.Key.Interfaces, Data.DB, Datasnap.DBClient;

Type
  TMainData = Class(TDataModule)
    Accounts: TClientDataSet;
    AccountsAccountNumChkSum: TStringField;
    AccountsAccountNumber: TIntegerField;
    AccountsCheckSum: TIntegerField;
    AccountsAccountName: TStringField;
    AccountsBalance: TCurrencyField;
    AccountsNOps: TIntegerField;
    AccountsAccountState: TStringField;
    AccountsPending: TCurrencyField;
    procedure DataModuleCreate(Sender: TObject);
  Private
    { Private declarations }
    FKeyRing: IPascalKeyRing;
  Public
    { Public declarations }
    Procedure InitialiseThis;
    property KeyRing: IPascalKeyRing Read FKeyRing;
  End;

Var
  MainData: TMainData;

Implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses Wallet.Config, PascalCoin.Key.Classes, Wallet.Shared;
{$R *.dfm}

procedure TMainData.DataModuleCreate(Sender: TObject);
begin
  FKeyRing := TPascalKeyRing.Create(Config.Wallet.Value);
end;

procedure TMainData.InitialiseThis;
begin

end;

End.
