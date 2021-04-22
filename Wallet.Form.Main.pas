Unit Wallet.Form.Main;

Interface

Uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Ani,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls.Presentation,
  Wallet.DataModule.Main,
  SubjectStand,
  FormStand,
  System.Actions,
  FMX.ActnList,
  FrameStand,
  Wallet.Frame.Base,
  FMX.Objects,
  Wallet.Frame.GetStarted, FMX.ImgList;

Type
  TMainForm = Class(TForm)
    MainButtons: TGridLayout;
    MainLayout: TLayout;
    ToolBar1: TToolBar;
    MainFormStand: TFormStand;
    StyleDark: TStyleBook;
    StyleLight: TStyleBook;
    StylePascal: TStyleBook;
    ActionList1: TActionList;
    SettingsAction: TAction;
    DashboardAction: TAction;
    SendAction: TAction;
    ReceiveAction: TAction;
    AboutAction: TAction;
    SubFormCaption: TLabel;
    ContentLayout: TLayout;
    MainFrameStand: TFrameStand;
    WalletAction: TAction;
    DashboardButton: TButton;
    WalletButton: TButton;
    SendButton: TButton;
    ReceiveButton: TButton;
    SettingsButton: TButton;
    AboutButton: TButton;
    PascalLogo: TGlyph;
    FooterLayout: TLayout;
    Procedure FormCreate(Sender: TObject);
    Procedure DashboardActionExecute(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure SettingsActionExecute(Sender: TObject);
  Private
    { Private declarations }
    FDisplayedFrame: TClass;
    Procedure ChangeTheme(Const AThemeName: String);
    Function CloseDisplayedFrame: Boolean;
    Procedure NewWallet;
    Procedure DisplayFrame(Value: TBaseFrame);
  Public
    { Public declarations }
  End;

Var
  MainForm: TMainForm;

Implementation

{$R *.fmx}

Uses
  Wallet.DataModule.Assets,
  Wallet.Shared,
  Wallet.Frame.Dashboard,
  Wallet.Form.FirstRun,
  Wallet.Frame.Settings,
  Wallet.Form.Base;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin

End;

{ TMainForm }

Procedure TMainForm.ChangeTheme(Const AThemeName: String);
Begin
  If AThemeName = THEME_PASCAL Then
    StyleBook := StylePascal
  Else If AThemeName = THEME_DARK Then
    StyleBook := StyleDark
  Else If AThemeName = THEME_LIGHT Then
    StyleBook := StyleLight
  Else
    Exit;
  MainFormStand.StyleBook := StyleBook;
End;

Function TMainForm.CloseDisplayedFrame: Boolean;
Begin
  If Assigned(FDisplayedFrame) Then
  Begin
    If (MainFrameStand.LastShownFrame Is TBaseFrame) And (Not TBaseFrame(MainFrameStand.LastShownFrame).CanClose) Then
      Exit(False);

    If (MainFrameStand.LastShownFrame Is TBaseFrame) Then
      TBaseFrame(MainFrameStand.LastShownFrame).Teardown;

    MainFrameStand.HideAndCloseAll([FDisplayedFrame]);
    FDisplayedFrame := Nil;
    Result := True;
  End
  Else
  Begin
    Result := True;
  End;
End;

Procedure TMainForm.DashboardActionExecute(Sender: TObject);
Var
  LFrameInfo: TFrameInfo<TDashboardFrame>;
Begin
  If Not CloseDisplayedFrame Then
    Exit;

  LFrameInfo := MainFrameStand.GetFrameInfo<TDashboardFrame>(True, ContentLayout);
  DisplayFrame(LFrameInfo.Frame);
  If Not LFrameInfo.IsVisible Then
    LFrameInfo.Show;
End;

procedure TMainForm.DisplayFrame(Value: TBaseFrame);
begin
  Value.InitialiseThis;
  FDisplayedFrame := Value.ClassType;
  SubFormCaption.Text := Value.DisplayCaption;
end;

Procedure TMainForm.FormShow(Sender: TObject);
Begin
  If FDisplayedFrame = Nil Then
  Begin

    If MainData.KeyRing.KeyCount = 0 Then
    Begin
      NewWallet;
    End
    Else
      DashboardAction.Execute;
  End;
End;

Procedure TMainForm.NewWallet;
Var
  LFrameInfo: TFrameInfo<TGetStartedFrame>;
Begin
  MainButtons.Enabled := False;

  LFrameInfo := MainFrameStand.GetFrameInfo<TGetStartedFrame>(True, ContentLayout);
  LFrameInfo.Frame.Mode := gsmNewKey;
  LFrameInfo.Frame.OnSuccess := Procedure
    Begin
      MainButtons.Enabled := True;
      DashboardAction.Execute;
    End;

  LFrameInfo.Frame.OnCancel := Procedure
    Begin
      Application.Terminate;
    End;

  DisplayFrame(LFrameInfo.Frame);
  If Not LFrameInfo.IsVisible Then
    LFrameInfo.Show;

End;

Procedure TMainForm.SettingsActionExecute(Sender: TObject);
Var
  LFrameInfo: TFrameInfo<TSettingsFrame>;
Begin
  If Not CloseDisplayedFrame Then
    Exit;

  LFrameInfo := MainFrameStand.GetFrameInfo<TSettingsFrame>(True, ContentLayout);

  DisplayFrame(LFrameInfo.Frame);

  If Not LFrameInfo.IsVisible Then
    LFrameInfo.Show;

End;

End.
