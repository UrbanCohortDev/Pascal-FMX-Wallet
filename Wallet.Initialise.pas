Unit Wallet.Initialise;

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
  System.SysUtils, Wallet.Shared;

    Procedure InitialiseApp();

Implementation

Procedure InitialiseApp();
Begin
//  Let's  load Config straightaway
  Config;
  Config.LocaleCurrency := FormatSettings.CurrencyString;

  FormatSettings.CurrencyString := 'P';
  FormatSettings.CurrencyFormat := 0;
  FormatSettings.CurrencyDecimals := 4;


End;

End.
