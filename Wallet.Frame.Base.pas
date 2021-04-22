Unit Wallet.Frame.Base;

Interface

Uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts, Wallet.DataModule.Assets, FMX.ImgList;

Type
  TBaseFrame = Class(TFrame)
    FrameLayout: TLayout;
    Translate: TGlyph;
  Private
    FInitialising: Boolean;
    Procedure TranslateForm;
    { Private declarations }
  Protected
    FDisplayCaption: String;
    Procedure TranslateThis; Virtual;
  Public
    { Public declarations }
    Constructor Create(AOwner: TComponent); override;
    Procedure InitialiseThis; virtual;
    Function CanClose: Boolean; Virtual;
    Procedure TearDown; Virtual;
    Function DisplayCaption: String; Virtual;
    property Initialising: Boolean read FInitialising;
  End;

Implementation

{$R *.fmx}

uses Wallet.Shared;

{ TBaseFrame }

Function TBaseFrame.CanClose: Boolean;
Begin
  Result := True;
End;

constructor TBaseFrame.Create(AOwner: TComponent);
begin
  inherited;
  Translate.Visible := Config.TranslateEnabled;
end;

Function TBaseFrame.DisplayCaption: String;
var lClassName: String;
Begin
  if FDisplayCaption <> '' then
     Exit(FDisplayCaption);
  lClassName := Self.ClassName;
  Result := lClassName.Substring(1, lClassName.Length - 6);
End;

procedure TBaseFrame.InitialiseThis;
begin
  TranslateForm;
end;

Procedure TBaseFrame.TearDown;
Begin

End;

procedure TBaseFrame.TranslateForm;
begin
  if (Config.Language <> DEFAULT_LANGUAGE) then
     TranslateThis;

end;

procedure TBaseFrame.TranslateThis;
begin
end;

End.

