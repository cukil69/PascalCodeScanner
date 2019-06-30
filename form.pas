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
    TOKEN_LABEL: TLabel;
    LABEL_TOKEN: TLabel;
    SEMANTIC_LABEL: TLabel;
    SUCCESS_SEMANTIC: TLabel;
    FILE_DIALOG: TOpenDialog;
    MAIN_PANEL: TPanel;
    PARSING_PROCESS: TLabel;
    TOKEN_TABLE: TStringGrid;

    procedure BTN_FILEClick(Sender: TObject);
    procedure SET_FILESTRING(DIALOG: TOpenDialog);
    procedure SET_CLOSEFILE();
  private

  public

  end;

var
  Form1: TForm1;
  asa: String;
  FileString: file of char;

implementation

{$R *.lfm}

procedure TForm1.BTN_FILEClick(Sender: TObject);
begin
  if FILE_DIALOG.Execute then
  begin
    SET_FILESTRING(FILE_DIALOG);
    CODE_TABLE.Lines.LoadFromFile(FILE_DIALOG.Filename);
    reset(FileString);
    SET_CLOSEFILE();
  end;
end;

procedure TForm1.SET_FILESTRING(DIALOG: TOpenDialog);
begin
  system.Assign(FileString, DIALOG.Filename);
end;

procedure TForm1.SET_CLOSEFILE();
begin
  closefile(FileString);
end;

end.

