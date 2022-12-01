unit ProdutosController;

interface

uses
  Horse,
  Horse.Jhonson, System.JSON, dm;

type
  TControllerProdutos = class
    class procedure Registry;
    class procedure GetProdutos(Req: THorseRequest; Res: THorseResponse;
      Next: TProc);
  end;

implementation

{ TControllerProdutos }

class procedure TControllerProdutos.GetProdutos(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
var
  aJson: TJSONArray;
  oJson: TJSONObject;
begin

  DataModule1.CadproTable.Close;
  DataModule1.CadproTable.SQL.Clear;
  DataModule1.CadproTable.SQL.Add
    ('select pdcodpro,pdnome,pdmarca,pdclassif,lpqtd from cadpro inner join lotpro on lpcodpro= pdcodpro and lpqtd>0');
  DataModule1.CadproTable.Open;
  // where pdmarca = '+ QuotedStr('BIOTEXTIL')
  if not DataModule1.CadproTable.IsEmpty then
  begin
    aJson := TJSONArray.Create;
    DataModule1.CadproTable.first;

    while not DataModule1.CadproTable.eof do
    begin

      // DataModule1.CadproTable.Fields[0].AsString;
      // Montando JSon
      oJson := TJSONObject.Create;
      oJson.AddPair('codigo',
        TJsonNumber.Create(DataModule1.CadproTable.FieldByName('pdcodpro')
        .AsInteger));
      oJson.AddPair('nome', DataModule1.CadproTable.FieldByName('pdnome')
        .AsString);
      oJson.AddPair('marca', DataModule1.CadproTable.FieldByName('pdmarca')
        .AsString);
      oJson.AddPair('ncm', DataModule1.CadproTable.FieldByName('pdclassif')
        .AsString);
      oJson.AddPair('qtd',
        TJsonNumber.Create(DataModule1.CadproTable.FieldByName('lpqtd')
        .AsInteger));

      // add array
      aJson.AddElement(oJson);
      DataModule1.CadproTable.Next;
    end;
    Res.Send<TJSONArray>(aJson).Status(200);
  end
  else
  begin
    Res.Send<TJSONObject>(TJSONObject.Create.AddPair('msg', 'Vasio'))
      .Status(400);
  end;

end;

class procedure TControllerProdutos.Registry;
begin
  THorse.Get('/produtos', GetProdutos);
end;

end.
