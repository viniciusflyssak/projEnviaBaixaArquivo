object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Principal'
  ClientHeight = 137
  ClientWidth = 774
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 774
    Height = 137
    Align = alClient
    TabOrder = 0
    object lblNomeArquivo: TLabel
      Left = 16
      Top = 24
      Width = 435
      Height = 35
      Caption = 'Nenhum arquivo selecionado!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = lblNomeArquivoClick
    end
    object pnlBotoes: TPanel
      Left = 1
      Top = 77
      Width = 772
      Height = 59
      Align = alBottom
      TabOrder = 0
      object btnEnviarArquivo: TSpeedButton
        Left = 634
        Top = 1
        Width = 137
        Height = 57
        Align = alRight
        Caption = 'Enviar Arquivo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnEnviarArquivoClick
        ExplicitLeft = 624
      end
      object btnBaixarArquivo: TSpeedButton
        Left = 497
        Top = 1
        Width = 137
        Height = 57
        Align = alRight
        Caption = 'Baixar arquivo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnBaixarArquivoClick
        ExplicitLeft = 624
      end
      object edtTitulo: TEdit
        Left = 1
        Top = 1
        Width = 490
        Height = 57
        Hint = 'Nome do arquivo que deseja enviar/baixar'
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -37
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnKeyPress = edtTituloKeyPress
        ExplicitHeight = 53
      end
    end
  end
end
