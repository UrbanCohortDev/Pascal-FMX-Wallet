Unit Wallet.Utils.Misc;

Interface

Uses
  System.Classes, System.UITypes;

Function ResourceToStream(Const AResId: String; AStream: TStream): boolean;
Function ResourceAsString(Const AResId: String): String;
Function Confirm(const AMessage: String): TModalResult;

Implementation

Uses
  System.Types, FMX.DialogService, FMX.Forms;

Function ResourceToStream(Const AResId: String; AStream: TStream): boolean;
Var
  Stream: TResourceStream;
Begin
  result := False;
  If (FindResource(hInstance, PChar(AResId), RT_RCDATA) <> 0) Then
  Begin
    Stream := TResourceStream.Create(hInstance, AResId, RT_RCDATA);
    Try
      Stream.SaveToStream(AStream);
    Finally
      Stream.Free;
    End;
    result := True;
  End;
End;

Function ResourceAsString(Const AResId: String): String;
Var
  S: TStringStream;
Begin
  result := '';
  S := TStringStream.Create;
  Try
    If ResourceToStream(AResId, S) Then
      result := S.DataString;
  Finally
    S.Free;
  End;
End;

Function Confirm(const AMessage: String): TModalResult;
var mr: TModalResult;
begin
  mr := mrNone;

  TDialogService.MessageDialog(AMessage, TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], TMsgDlgBtn.mbNo, 0,
    Procedure(Const AResult: TModalResult)
    Begin
      mr := AResult
    End
    );

  while mr = mrNone do
    Application.ProcessMessages;

  Result := mr;

end;


End.
