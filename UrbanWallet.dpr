program UrbanWallet;

{$R 'WalletFiles.res' 'WalletFiles.rc'}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  System.StartUpCopy,
  FMX.Forms,
  Wallet.Form.Main in 'Wallet.Form.Main.pas' {MainForm},
  Wallet.DataModule.Main in 'Wallet.DataModule.Main.pas' {MainData: TDataModule},
  Wallet.Form.Base in 'Wallet.Form.Base.pas' {BaseSubForm},
  Wallet.Initialise in 'Wallet.Initialise.pas',
  Wallet.DataModule.Assets in 'Wallet.DataModule.Assets.pas' {AssetsData: TDataModule},
  Wallet.Config in 'Wallet.Config.pas',
  Wallet.Shared in 'Wallet.Shared.pas',
  Wallet.Exceptions in 'Wallet.Exceptions.pas',
  Wallet.Language.Support in 'Wallet.Language.Support.pas',
  Wallet.Utils.Misc in 'Wallet.Utils.Misc.pas',
  Wallet.Form.FirstRun in 'Wallet.Form.FirstRun.pas' {BaseSubForm1},
  PascalCoin.Consts in '..\..\RPC-Client\Foundation\PascalCoin.Consts.pas',
  Wallet.Interfaces in 'Wallet.Interfaces.pas',
  PascalCoin.Key.Classes in 'PascalCoin.Key.Classes.pas',
  PascalCoin.KeyUtils in '..\..\RPC-Client\Foundation\PascalCoin.KeyUtils.pas',
  Wallet.Frame.Base in 'Wallet.Frame.Base.pas' {BaseFrame: TFrame},
  Wallet.Frame.Settings in 'Wallet.Frame.Settings.pas' {SettingsFrame: TFrame},
  Wallet.Frame.Dashboard in 'Wallet.Frame.Dashboard.pas' {DashboardFrame: TFrame},
  PascalCoin.RPC.Interfaces in '..\..\RPC-Client\Foundation\PascalCoin.RPC.Interfaces.pas',
  PascalCoin.RPC.Exceptions in '..\..\RPC-Client\Foundation\PascalCoin.RPC.Exceptions.pas',
  UC.Language.Interfaces in '..\..\RPC-Client\AppUtils\UC.Language.Interfaces.pas',
  FMX.PlatformUtils in '..\..\RPC-Client\AppUtils\FMX.PlatformUtils.pas',
  Wallet.Framelet.AddNode in 'Wallet.Framelet.AddNode.pas' {AddNodeFrame: TFrame},
  PascalCoin.Key.Interfaces in '..\..\RPC-Client\Foundation\PascalCoin.Key.Interfaces.pas',
  Wallet.Thread in 'Wallet.Thread.pas',
  Wallet.Frame.GetStarted in 'Wallet.Frame.GetStarted.pas' {GetStartedFrame: TFrame},
  PascalCoin.Utils in '..\..\RPC-Client\Foundation\PascalCoin.Utils.pas',
  UC.Utils in '..\..\RPC-Client\AppUtils\UC.Utils.pas';

{$R *.res}

begin
  InitialiseApp();
  Application.Initialize;
  Application.CreateForm(TAssetsData, AssetsData);
  Application.CreateForm(TMainData, MainData);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
