unit LoginController;

interface

uses
  Horse,
  Horse.Jhonson, System.JSON, dm;

type
  TLoginController = class
    class procedure Registry;
    class procedure GetLogin(Req: THorseRequest; Res: THorseResponse;
      Next: TProc);
  end;

implementation

{ TLoginController }

class procedure TLoginController.GetLogin(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  LBody: TJSONValue;
  Lcodigo: string;
  Lsenha: string;
  oJson: TJSONObject;
  LsenhaBanco: string;
begin
  LBody := Req.Body<TJSONObject>;
  Lcodigo := LBody.GetValue<string>('codigo');
  Lsenha := LBody.GetValue<string>('senha');
  dmPrincipal.CadvenTable.Close;
  dmPrincipal.CadvenTable.SQL.Clear;
  dmPrincipal.CadvenTable.SQL.Add
    ('select cfcodven, cfnome,senha_login_android as senha from cadven where cfcodven='
    + Lcodigo);
  dmPrincipal.CadvenTable.Open;
  dmPrincipal.CadvenTable.First;

  if not dmPrincipal.CadvenTable.IsEmpty then
  begin
    while not dmPrincipal.CadvenTable.Eof do
    begin
      oJson := TJSONObject.Create;
      oJson.AddPair('codigo',
        TJSONNumber.Create(dmPrincipal.CadvenTable.FieldByName('cfcodven')
        .AsInteger));
      oJson.AddPair('nome', dmPrincipal.CadvenTable.FieldByName('cfnome')
        .AsString);
      dmPrincipal.CadvenTable.Next;
    end;
    LsenhaBanco := dmPrincipal.CadvenTable.FieldByName('senha').AsString;
    if Lsenha = LsenhaBanco then
    begin
      Res.Send<TJSONObject>(oJson).Status(200);
    end
    else
    begin
      Res.Send<TJSONObject>(TJSONObject.Create.AddPair('msg', 'senha Invalida'))
        .Status(400);
    end;

  end
  else
  begin
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('msg', 'Nao Encontrado'))
      .Status(400);
  end;

end;

class procedure TLoginController.Registry;
begin
  THorse.Post('/login', GetLogin);
end;

end.
