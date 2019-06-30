unit LexicalAnalyzer;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
    StdCtrls, TokenHelper;

type
    { LexicalAnalyzerHelper }
    FileStringType = file of char;

    LexicalAnalyzerHelper = class
        FileString: file of char;
        ProgressElement: TMemo;
        procedure setProgressComponent(Element: TMemo);
        procedure run(var StringFile: FileStringType);
        procedure CheckSymbols(symbol: string);
        procedure iterateText();
    end;

var
    TokenReader: TokenReaderHelper;

implementation

procedure LexicalAnalyzerHelper.setProgressComponent(Element: TMemo);
begin
    ProgressElement:= Element;
end;

procedure LexicalAnalyzerHelper.run(var StringFile: FileStringType);
begin
    FileString := StringFile;
    ProgressElement.Lines.Add('Tokenizing start');
    iterateText();
end;

procedure LexicalAnalyzerHelper.CheckSymbols(symbol: string);
begin
    WriteLn(symbol);
end;

procedure LexicalAnalyzerHelper.iterateText();
var
    tempChar: char;
    tempString: string;
    isComment: boolean;
    isString: boolean;
    isNumber: boolean;
begin
    while not EOF(FileString) do
    begin
        read(FileString, tempChar);
        if tempChar = '{' then
            isComment := true
        else if tempChar = #39 then
            isString := true
        else if TokenReader.IsNumeric(tempChar, true) then
            isNumber := true;

        while not EOF(FileString) and (TokenReader.ExcludeSymbols(tempChar) or isComment or isString or isNumber) do
        begin
            tempString += tempChar;
            read(FileString, tempChar);
            if (tempChar = '}') then
                isComment := false
            else if (tempChar = #39) then
                isString := false
            else if (not TokenReader.IsNumeric(tempChar, true)) then
                isNumber := false;
        end;

        WriteLn(tempString);
        tempString := '';
    end;
end;

begin
    TokenReader := TokenReaderHelper.Create;
end.
