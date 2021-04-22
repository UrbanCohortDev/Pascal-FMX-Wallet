Unit Wallet.Exceptions;

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
  System.SysUtils;

Type

  EPascalWalletException = Class(Exception)
  public
    Constructor Create(Const AMessageKey: String);
  End;

  EInvalidCode = Class(EPascalWalletException);
  EUnrecognisedLanguageCode = Class(EPascalWalletException);

  EPrivateKeyDecryptionException = Class(EPascalWalletException);

  EWalletLockedException = Class(EPascalWalletException)
  public
    constructor Create;
  end;

Implementation

uses Wallet.Shared;

{ EPascalWalletException }

constructor EPascalWalletException.Create(const AMessageKey: String);
begin
  inherited Create(Config.LanguageManager.GetText(AMessageKey));
end;

{ EWalletLockedException }

constructor EWalletLockedException.Create;
begin
  inherited Create('WALLET_LOCKED');
end;

End.
