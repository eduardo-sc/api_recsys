unit ClienteController;

interface

uses Horse, System.Json, Horse.Jhonson, dm;

type
  TClienteController = class
    class procedure Registry;
    class procedure GetClietes(Req: THorseRequest; Res: THorseResponse;
      Next: TProc);
  end;

implementation

{ TClienteController }

class procedure TClienteController.GetClietes(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
Paramen:string;
  ClientesObjetos: TJSONObject;
  ClientesEnderecoObjetos: TJSONObject;
  ClientesArray: TJSONArray;
  CodigoVendedor: String;
begin
  Paramen:=Req.Query.Field('codigo').AsString;


  dmPrincipal.CadcliTable.Close;
  dmPrincipal.CadcliTable.SQL.Clear;
  dmPrincipal.CadcliTable.SQL.Add
    ('select ccodcli, crazao as razao, ccgc as cnpj,ccodven ,cfone,cie,cbairro,cendc,'
    + '(select lnome from cadloc where lcodloc=ccodloc) as cidade from cadcli cli where cli.ccodven='+Paramen);
  dmPrincipal.CadcliTable.Open;

  if not dmPrincipal.CadcliTable.IsEmpty then
  begin
    dmPrincipal.CadcliTable.First;
    ClientesArray := TJSONArray.Create;
    while not dmPrincipal.CadcliTable.Eof do
    begin
      // criando objeto
      ClientesObjetos := TJSONObject.Create;

      ClientesObjetos.AddPair('codigo',
        TJSONNumber.Create(dmPrincipal.CadcliTable.FieldByName('ccodcli')
        .AsInteger));
      ClientesObjetos.AddPair('razao',
        dmPrincipal.CadcliTable.FieldByName('razao').AsString);
      ClientesObjetos.AddPair('cnpj',
        dmPrincipal.CadcliTable.FieldByName('cnpj').AsString);
      ClientesObjetos.AddPair('telefone',
        dmPrincipal.CadcliTable.FieldByName('cfone').AsString);
      ClientesObjetos.AddPair('ie', dmPrincipal.CadcliTable.FieldByName('cie')
        .AsString);

      // criar objeto endere�o
      ClientesEnderecoObjetos := TJSONObject.Create;
      ClientesEnderecoObjetos.AddPair('complemento',
        dmPrincipal.CadcliTable.FieldByName('cendc').AsString);
      ClientesEnderecoObjetos.AddPair('bairro',
        dmPrincipal.CadcliTable.FieldByName('cbairro').AsString);
      ClientesEnderecoObjetos.AddPair('cidade',
        dmPrincipal.CadcliTable.FieldByName('cidade').AsString);

      // adicionando objeto ende�o no objeto clientes
      ClientesObjetos.AddPair('endereco', ClientesEnderecoObjetos);
    //adicionando objeto cliente dentro de uma array clientes
      ClientesArray.AddElement(ClientesObjetos);
      dmPrincipal.CadcliTable.Next;
    end;

    Res.Send<TJSONArray>(ClientesArray).Status(200);
  end
  else
  begin
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('msg', 'Vasio'))
      .Status(400);
  end;

end;

class procedure TClienteController.Registry;
begin
  THorse.Post('/clientes', GetClietes);
end;

end.
