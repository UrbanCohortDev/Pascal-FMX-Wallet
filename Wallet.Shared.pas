unit Wallet.Shared;

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

interface

uses Spring, Wallet.Config;

Type

TPascalCoinBooleanEvent = procedure(const AValue: Boolean) of object;
TPascalCoinCurrencyEvent = procedure(const AValue: Currency) of object;
TPascalCoinIntEvent = procedure(const AValue: Int64) of object;

Function Config: TWalletConfig;

const

DEFAULT_LANGUAGE = 'ENG';

THEME_PASCAL = 'PASCAL';
THEME_DARK = 'DARK';
THEME_LIGHT = 'LIGHT';

C_TESTNET: Array[Boolean] of string = ('', ' [TESTNET]');

Implementation

Var
  _Config: TWalletConfig;

Function Config: TWalletConfig;
Begin
  If Not Assigned(_Config) Then
    _Config := TWalletConfig.Create();
  Result := _Config;
End;

Initialization

Finalization

If Assigned(_Config) Then
  _Config.Free;
end.
