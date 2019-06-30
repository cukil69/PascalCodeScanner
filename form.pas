unit Form;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
    StdCtrls, Grids, LexicalAnalyzer, FileHelper;

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
    private

    public

    end;

var
    Form1: TForm1;
    Lexical: LexicalAnalyzerHelper;
    FileReader: ReadFileHeper;
    FileString: file of char;

implementation

{$R *.lfm}

procedure TForm1.BTN_FILEClick(Sender: TObject);
begin
    Lexical.setProgressComponent(PARSING_TABLE);
    if FileReader.setFileString(FILE_DIALOG) then
    begin
        CODE_TABLE.Lines.LoadFromFile(FileReader.ObjDialog.Filename);
        Lexical.run(FileReader.FileString);
        FileReader.setCloseFile();
    end;
end;

begin
    Lexical := LexicalAnalyzerHelper.Create;
    FileReader := ReadFileHeper.Create;
end.


