unit Wallet.Form.Base;

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
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts;

type
  TBaseSubForm = class(TForm)
    BaseLayout: TLayout;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    Procedure TranslateThis; virtual;
  public
    { Public declarations }
    Procedure InitialiseThis; virtual;
    Function CanClose: Boolean; virtual;
    Procedure TearDown; virtual;
    Function DisplayCaption: String; virtual;
  end;

var
  BaseSubForm: TBaseSubForm;

implementation

{$R *.fmx}

uses Wallet.Shared;

{ TBaseSubForm }


function TBaseSubForm.CanClose: Boolean;
begin
  Result := True;
end;

function TBaseSubForm.DisplayCaption: String;
begin
  Result := Caption;
end;

procedure TBaseSubForm.FormCreate(Sender: TObject);
begin
  if Config.Language <> 'EN' then
     TranslateThis;
end;

procedure TBaseSubForm.InitialiseThis;
begin
  //
end;

procedure TBaseSubForm.TearDown;
begin
//
end;

procedure TBaseSubForm.TranslateThis;
begin

end;

end.
