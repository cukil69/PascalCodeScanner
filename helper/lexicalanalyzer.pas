unit LexicalAnalyzer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type
  { LexicalAnalyzerHelper }
  FileStringType = file of char;

  LexicalAnalyzerHelper = class
    FileString: FileStringType;
    ProgressElement: TMemo;
    procedure setProgressComponent(Element: TMemo);
    procedure run(var StringFile: FileStringType);
    procedure CheckSymbols(symbol: string);
  
  end;


implementation

procedure LexicalAnalyzerHelper.setProgressComponent(Element: TMemo);
begin
  ProgressElement:= Element;
end;

procedure LexicalAnalyzerHelper.run(var StringFile: FileStringType);
begin
  FileString := StringFile;
  ProgressElement.Lines.Add('Tokenizing start');
end;

procedure LexicalAnalyzerHelper.CheckSymbols(symbol: string);
begin
  WriteLn(symbol);
end;

end.


