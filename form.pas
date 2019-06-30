unit Form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    BTN_FILE: TButton;
    CODE_TABLE: TMemo;
    PARSING_TABLE: TMemo;
    Label1: TLabel;
    LABEL_TOKEN: TLabel;
    Label3: TLabel;
    SUCCESS_SEMANTIC: TLabel;
    FILE_DIALOG: TOpenDialog;
    Panel1: TPanel;
    PARSING_PROCESS: TLabel;
    TOKEN_TABLE: TStringGrid;
    procedure BTN_FILEClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BTN_FILEClick(Sender: TObject);
begin

end;

end.

