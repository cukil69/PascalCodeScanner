unit ParserAnalyzer;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
    Grids, StdCtrls, fgl;

type
    { ParserAnalyzerHelper }
    TokenMaps = specialize TFPGMap<String, String>;
    ArrayTokenMaps = array of TokenMaps; 

    ParserAnalyzerHelper = class
        ArrayToken: ArrayTokenMaps;
        indexToken: integer;
        ProgressElement: TMemo;
        procedure checkTerminal(clause: string);
        procedure setProgressComponent(Element: TMemo);
        procedure run(token: ArrayTokenMaps);
        procedure gVar();
        procedure gVarType();
        procedure gVarList();
        procedure gOperator();
        procedure gExpression();
        procedure gFunction();
        procedure gIf();
        procedure gWrite();
        procedure gFor();
        procedure gWhile();
        procedure gRepeat();
        procedure gStmt();
        procedure gStmtList();
        procedure gProgram();
    end;

implementation

procedure ParserAnalyzerHelper.checkTerminal(clause: string);
begin
    if ArrayToken[indexToken]['token'] = clause then
        indexToken := indexToken + 1
    else
        ProgressElement.Lines.Add('Parsing failed');
end;

procedure ParserAnalyzerHelper.setProgressComponent(Element: TMemo);
begin
    ProgressElement:= Element;
end;

procedure ParserAnalyzerHelper.run(token: ArrayTokenMaps);
begin
    ArrayToken := token;
    ProgressElement.Lines.Add('Parsing start');
    indexToken := 0;
    gProgram();
    ProgressElement.Lines.Add('Parsing done');
end;

procedure ParserAnalyzerHelper.gVar();
begin
    ProgressElement.Lines.Add('>> <var> ' + ArrayToken[indexToken]['token']);
    indexToken := indexToken + 1;
    if ArrayToken[indexToken]['token'] = ',' then
    begin
        indexToken := indexToken + 1;
        gVar();
    end
    else if ArrayToken[indexToken]['token'] = '[' then
    begin
        checkTerminal('[');
        gVar();
        checkTerminal(']');
    end;
end;

procedure ParserAnalyzerHelper.gVarType();
begin
    ProgressElement.Lines.Add('>> <var_type>');
    case LeftStr(ArrayToken[indexToken]['token'], 1) of
        'i': checkTerminal('integer');
        'c': checkTerminal('char');
        'r': checkTerminal('real');
        's': checkTerminal('string');
        'b': checkTerminal('boolean');
        'a':
        begin
            checkTerminal('array');
            checkTerminal('of');
            gVarType();
        end;
    end;
end;

procedure ParserAnalyzerHelper.gVarList();
begin
    ProgressElement.Lines.Add('>> <var_list>');
    gVar();
    checkTerminal(':');
    gVarType();
    checkTerminal(';');
    if ArrayToken[indexToken]['token'] <> 'begin' then
        gVarList();
end;

procedure ParserAnalyzerHelper.gOperator();
begin
    ProgressElement.Lines.Add('>> <arithmetic_opr>');
    case ArrayToken[indexToken]['token'] of
        '+': checkTerminal('+');
        '-': checkTerminal('-');
        '*': checkTerminal('*');
        '/': checkTerminal('/');
        '>': checkTerminal('>');
        '<': checkTerminal('<');
        '=': checkTerminal('=');
        '>=': checkTerminal('>=');
        '<=': checkTerminal('<=');
        '<>': checkTerminal('<>');
    end;
end;

procedure ParserAnalyzerHelper.gExpression();
begin
    ProgressElement.Lines.Add('>> <expression>');
    gVar();
    if ArrayToken[indexToken]['token'] <> ';' then
    begin
        gOperator();
        gVar();
    end;
end;

procedure ParserAnalyzerHelper.gFunction();
begin
    ProgressElement.Lines.Add('>> <function>');
    checkTerminal('(');
    gVar();
    checkTerminal(')');
end;

procedure ParserAnalyzerHelper.gStmt();
begin
    ProgressElement.Lines.Add('>> <stmt>');
    case LeftStr(ArrayToken[indexToken]['token'], 2) of
        'if': gIf();
        'fo': gFor();
        'wh': gWhile();
        'wr': gWrite();
        're': gRepeat();
        else if ArrayToken[indexToken]['token'] <> 'end' then
            begin
                gVar();
                if ArrayToken[indexToken]['token'] = '(' then
                    gFunction()
                else
                begin
                    checkTerminal(':=');
                    gExpression();
                end;
            end;
    end;
end;

procedure ParserAnalyzerHelper.gStmtList();
begin
    ProgressElement.Lines.Add('>> <stmt_list>');
    gStmt();
    if ArrayToken[indexToken]['token'] = ';' then
    begin
        indexToken := indexToken + 1;
        gStmtList();
    end;
end;

procedure ParserAnalyzerHelper.gIf();
begin
    ProgressElement.Lines.Add('>> <if>');
    checkTerminal('if');
    gVar();
    gOperator();
    gVar();
    checkTerminal('then');
    gStmtList();
end;

procedure ParserAnalyzerHelper.gWrite();
begin
    ProgressElement.Lines.Add('>> <write>');
    checkTerminal('write');
    checkTerminal('(');
    gVar();
    checkTerminal(')');
end;

procedure ParserAnalyzerHelper.gFor();
begin
    ProgressElement.Lines.Add('>> <for>');
    checkTerminal('for');
end;

procedure ParserAnalyzerHelper.gWhile();
begin
    ProgressElement.Lines.Add('>> <while>');
    checkTerminal('while');
    gVar();
    gOperator();
    gVar();
    checkTerminal('do');
    gStmtList();
end;

procedure ParserAnalyzerHelper.gRepeat();
begin
    ProgressElement.Lines.Add('>> <repeat>');
    checkTerminal('repeat');
end;

procedure ParserAnalyzerHelper.gProgram();
begin
    ProgressElement.Lines.Add('>> <program>');
    checkTerminal('program');
    gVar();
    checkTerminal(';');
    checkTerminal('var');
    gVarList();
    checkTerminal('begin');
    gStmtList();
    checkTerminal('end');
end;

end.

