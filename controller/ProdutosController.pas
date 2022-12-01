unit ProdutosController;

interface

uses
  Horse,
  Horse.Jhonson, System.JSON, dm,SysUtils;

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

    dmPrincipal.CadproTable.Close;
    dmPrincipal.CadproTable.SQL.Clear;
    dmPrincipal.CadproTable.SQL.Add
      ('SELECT PDCODPRO CODIGO,PDNOME NOME,PDUND UNIDADE,PDPRECO PRECO,pdclassif ,(SELECT SUM( LPQTD) FROM LOTPRO WHERE LPCODPRO=PDCODPRO )AS ESTOQUE  FROM CADPRO'
      + ' WHERE (SELECT SUM( LPQTD) FROM LOTPRO WHERE LPCODPRO=PDCODPRO )>0 order by PDCODPRO' );
    dmPrincipal.CadproTable.Open;
    // where pdmarca = '+ QuotedStr('BIOTEXTIL')

    if not dmPrincipal.CadproTable.IsEmpty then
    begin

      dmPrincipal.CadproTable.first;
      aJson := TJSONArray.Create;
      while not dmPrincipal.CadproTable.eof do
      begin

        // DataModule1.CadproTable.Fields[0].AsString;
        // Montando JSon
        oJson := TJSONObject.Create;
        oJson.AddPair('codigo',
          dmPrincipal.CadproTable.FieldByName('CODIGO')
          .AsString);
        oJson.AddPair('nome', dmPrincipal.CadproTable.FieldByName('NOME')
          .AsString).ToJSON;
        oJson.AddPair('unidade', dmPrincipal.CadproTable.FieldByName('UNIDADE')
          .AsString);
        oJson.AddPair('preco',FormatFloat('0.00', dmPrincipal.CadproTable.FieldByName('PRECO').AsFloat));
        oJson.AddPair('ncm', dmPrincipal.CadproTable.FieldByName('pdclassif')
          .AsString);
        oJson.AddPair('qtd',
          TJsonNumber.Create(dmPrincipal.CadproTable.FieldByName('ESTOQUE')
          .AsInteger));

        // add array
        aJson.AddElement(oJson);

        dmPrincipal.CadproTable.Next;
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
