unit LexicalAnalyzer;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
    Grids, StdCtrls, TokenHelper, fgl;

type
    { LexicalAnalyzerHelper }
    FileStringType = file of char;
    TokenMaps = specialize TFPGMap<String, String>;
    TokenCategory = specialize TFPGMap<String, Integer>;

    LexicalAnalyzerHelper = class
        FileString: file of char;
        ProgressElement: TMemo;
        TableTokenElement: TStringGrid;
        ArrayToken: array of TokenMaps;
        ArrayCategory: TokenCategory;
        procedure setProgressComponent(Element: TMemo);
        procedure setTableTokenElement(Element: TStringGrid);
        procedure run(var StringFile: FileStringType);
        procedure WriteData(token, description, identifier: string);
        procedure CheckSymbols(symbol: char);
        procedure CheckKeywords(character: string);
        procedure iterateText();
        procedure reset();
    end;

var
    TokenReader: TokenReaderHelper;
    ArrayToken: array of TokenMaps;
    RowTable: integer;

implementation

procedure LexicalAnalyzerHelper.setProgressComponent(Element: TMemo);
begin
    ProgressElement:= Element;
end;

procedure LexicalAnalyzerHelper.setTableTokenElement(Element: TStringGrid);
begin
    TableTokenElement:= Element;
end;

procedure LexicalAnalyzerHelper.run(var StringFile: FileStringType);
begin
    FileString := StringFile;
    ArrayCategory := TokenCategory.Create;
    reset();
    ProgressElement.Lines.Add('Tokenizing start');
    iterateText();
    ProgressElement.Lines.Add('Total: ' + IntToStr(length(ArrayToken)) + ' tokens');
    ProgressElement.Lines.Add('Tokenizing done');
end;

procedure LexicalAnalyzerHelper.WriteData(token, description, identifier: string);
var
    result: TokenMaps;
begin
    result := TokenMaps.Create;
    result['token'] := token;
    result['name'] := description;
    result['identifier'] := identifier;

    if ArrayCategory.IndexOf(identifier) >= 0 then
        ArrayCategory[identifier] := ArrayCategory[identifier] + 1
    else
        ArrayCategory[identifier] := 1;
    
    setLength(ArrayToken, length(ArrayToken) + 1);
    ArrayToken[high(ArrayToken)] := result;
    TableTokenElement.InsertRowWithValues(RowTable, [IntToStr(length(ArrayToken) - 1), token]);
    RowTable := RowTable + 1;
end;

procedure LexicalAnalyzerHelper.CheckSymbols(symbol: char);
begin
    if (symbol = ',') then
        WriteData(symbol, 'comma', 'comma')
    else if (symbol = '.') then
        WriteData(symbol, 'period', 'period')
    else if (symbol = ';') then
        WriteData(symbol, 'semicolon', 'semicolon')
    else if (symbol = '+') then
        WriteData(symbol, 'operator +', 'plus')
    else if (symbol = '-') then
        WriteData(symbol, 'operator -', 'minus')
    else if (symbol = '*') then
        WriteData(symbol, 'operator *', 'times')
    else if (symbol = '/') then
        WriteData(symbol, 'operator /', 'idiv')
    else if (symbol = '=') then
        WriteData(symbol, 'operator =', '=')
    else if (symbol = '(') then
        WriteData(symbol, 'lparent', 'lparent')
    else if (symbol = ')') then
        WriteData(symbol, 'rparent', 'rparent')
    else if (symbol = '[') then
        WriteData(symbol, 'lbrack', 'lbrack')
    else if (symbol = ']') then
        WriteData(symbol, 'rbrack', 'rbrack')
    else if (symbol = ']') then
        WriteData(symbol, 'rbrack', 'rbrack')
    else if (symbol = '<') then
    begin
        read(FileString, symbol);
        if (symbol = '=') then
            WriteData('<=', 'leg', 'leg')
        else
        begin
            WriteData('<', 'lss', 'lss');
            CheckKeywords(symbol);
        end;
    end
    else if (symbol = '>') then
    begin
        read(FileString, symbol);
        if (symbol = '=') then
            WriteData('>=', 'geg', 'geg')
        else
        begin
            WriteData('>', 'gtr', 'gtr');
            CheckKeywords(symbol);
        end;
    end
    else if (symbol = ':') then
    begin
        read(FileString, symbol);
        if (symbol = '=') then
            WriteData(':=', 'operator :=', 'becomes')
        else
        begin
            WriteData(':', 'colon', 'colon');
            CheckKeywords(symbol);
        end;
    end;
end;

procedure LexicalAnalyzerHelper.CheckKeywords(character: string);
begin
    if (character = 'integer') then
        WriteData(character, 'intcon', 'intcon')
    else if (character = 'real') then
        WriteData(character, 'realcon', 'realcon')
    else if (character = 'char') then
        WriteData(character, 'charcon', 'charcon')
    else if (character = 'string') then
        WriteData(character, 'stringt', 'stringt')
    else if (character = 'not') then
        WriteData(character, 'notsy', 'notsy')
    else if (character = 'div') then
        WriteData(character, 'div', 'div')
    else if (character = 'mod') then
        WriteData(character, 'mod', 'mod')
    else if (character = 'and') then
        WriteData(character, 'and', 'andsy')
    else if (character = 'or') then
        WriteData(character, 'or', 'orsy')
    else if (character = 'program') then
        WriteData(character, 'program', 'programsy')
    else if (character = 'var') then
        WriteData(character, 'var', 'varsy')
    else if (character = 'begin') then
        WriteData(character, 'begin', 'beginsy')
    else if (character = 'end') then
        WriteData(character, 'end', 'endsy')
    else if (character = 'if') then
        WriteData(character, 'if', 'ifsy')
    else if (character = 'else') then
        WriteData(character, 'else', 'elsesy')
    else if (character = 'then') then
        WriteData(character, 'then', 'thensy')
    else if (character = 'for') then
        WriteData(character, 'for', 'forsy')
    else if (character = 'to') then
        WriteData(character, 'to', 'tosy')
    else if (character = 'downto') then
        WriteData(character, 'downto', 'downtosy')
    else if (character = 'while') then
        WriteData(character, 'while', 'whilesy')
    else if (character = 'do') then
        WriteData(character, 'do', 'dosy')
    else if (character = 'until') then
        WriteData(character, 'until', 'untilsy')
    else if (character = 'repeat') then
        WriteData(character, 'repeat', 'repeatsy')
    else if (character = 'of') then
        WriteData(character, 'of', 'ofsy')
    else if (character = 'case') then
        WriteData(character, 'case', 'casesy')
    else if (character = 'array') then
        WriteData(character, 'array', 'arraysy')
    else if (character = 'procedure') then
        WriteData(character, 'procedure', 'proceduresy')
    else if (character = 'function') then
        WriteData(character, 'function', 'functionsy')
    else if (character = 'const') then
        WriteData(character, 'const', 'constsy')
    else if (character = 'type') then
        WriteData(character, 'type', 'typesy')
    else if (LeftStr(character, 1) = '{') and (RightStr(character, 1) = '}') then
        WriteData(character, 'operator {}', 'comment')
    else if (LeftStr(character, 1) = #39) and (RightStr(character, 1) = #39) and (length(character) = 3) then
        WriteData(character, 'typechar', 'typechar')
    else if (LeftStr(character, 1) = #39) and (RightStr(character, 1) = #39) then
        WriteData(character, 'typestring', 'typestring')
    else if (TokenReader.IsNumeric(character, true)) then
    begin
        if (pos('.', character) = 0) then
            WriteData(character, 'typeinteger', 'typeinteger')
        else
            WriteData(character, 'typereal', 'typereal');
    end
    else if (Length(Trim(character)) > 0) then
        WriteData(Trim(character), 'identifier', 'ident');
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

        while TokenReader.ExcludeSymbols(tempChar) and (isComment or isString or isNumber) do
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

        CheckKeywords(tempString);
        tempString := '';
        CheckSymbols(tempChar);
    end;
end;

procedure LexicalAnalyzerHelper.reset();
var
    index: integer;
begin
    for index := 0 to ArrayCategory.Count - 1 do
        ArrayCategory[ArrayCategory.Keys[index]] := 0;

    setLength(ArrayToken, 0);
    TableTokenElement.RowCount := 1;
    ProgressElement.Lines.Clear();
    RowTable := 0;
end;

begin
    TokenReader := TokenReaderHelper.Create;
end.
