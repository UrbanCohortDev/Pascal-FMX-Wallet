unit Wallet.Form.FirstRun;

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

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, Wallet.Form.Base,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TBaseSubForm1 = class(TBaseSubForm)
    TitleLayout: TLayout;
    TitleLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BaseSubForm1: TBaseSubForm1;

implementation

{$R *.fmx}

end.
