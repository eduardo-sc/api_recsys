object dmPrincipal: TdmPrincipal
  OldCreateOrder = False
  Height = 291
  Width = 412
  object RecsysConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=RECSYS')
    Connected = True
    LoginPrompt = False
    Left = 11
    Top = 10
  end
  object CadproTable: TFDQuery
    Connection = RecsysConnection
    Left = 155
    Top = 8
  end
  object CadvenTable: TFDQuery
    Connection = RecsysConnection
    SQL.Strings = (
      'SELECT * FROM RECSYS.CADVEN')
    Left = 97
    Top = 6
  end
  object CadcliTable: TFDQuery
    Connection = RecsysConnection
    SQL.Strings = (
      'SELECT * FROM RECSYS.CADCLI')
    Left = 184
    Top = 126
  end
end
