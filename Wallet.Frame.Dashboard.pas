unit Wallet.Frame.Dashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, Wallet.Frame.Base, FMX.Layouts,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FMX.Controls.Presentation, FMX.Objects;

type
  TDashboardFrame = class(TBaseFrame)
    GridPanelLayout1: TGridPanelLayout;
    BalanceLayout: TLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    PascBalLayout: TLayout;
    PASCBalance: TLabel;
    PascLogo: TImage;
    WalletBalLayout: TLayout;
    WalletBal: TLabel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DashboardFrame: TDashboardFrame;

implementation

{$R *.fmx}

end.
