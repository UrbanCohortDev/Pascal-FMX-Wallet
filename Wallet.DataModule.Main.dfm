object MainData: TMainData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 267
  Width = 388
  object Accounts: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 16
    object AccountsAccountNumber: TIntegerField
      FieldName = 'AccountNumber'
      Visible = False
    end
    object AccountsNOps: TIntegerField
      FieldName = 'NOps'
    end
    object AccountsAccountNumChkSum: TStringField
      DisplayLabel = 'Account'
      DisplayWidth = 35
      FieldKind = fkInternalCalc
      FieldName = 'AccountNumChkSum'
      Size = 25
    end
    object AccountsCheckSum: TIntegerField
      FieldName = 'CheckSum'
      Visible = False
    end
    object AccountsAccountName: TStringField
      DisplayLabel = 'Account Name'
      FieldName = 'AccountName'
      Size = 75
    end
    object AccountsBalance: TCurrencyField
      DisplayWidth = 20
      FieldName = 'Balance'
    end
    object AccountsPending: TCurrencyField
      FieldName = 'Pending'
    end
    object AccountsAccountState: TStringField
      DisplayLabel = 'State'
      DisplayWidth = 15
      FieldName = 'AccountState'
      Size = 10
    end
  end
end
