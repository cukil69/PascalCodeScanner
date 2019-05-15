unit ScannerLexical_Unit;

{ 
   @author  SYAUQI ILHAM ALFARACI
   @class   IF14K 
   @id      10116900 
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnOpenFile: TButton;
    inCode: TMemo;
    inProses: TMemo;
    Label1: TLabel;
    PROSES: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    tableToken: TStringGrid;
    function IsNumeric(Value: string; const AllowFloat: boolean): boolean;
    procedure WriteData(token, kategoriToken, kategori: string);
    procedure CheckKeywords(s: string);
    procedure CheckSymbols();
    procedure ResetApp();
    function ExcludeSymbols(ch: char): boolean;
    procedure cekTerminal(s: string);
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
    procedure btnOpenFileClick(Sender: TObject);

  private

  public
  end;

var
  Form1: TForm1;
  s: string;
  ch: char;
  f: file of char;
  i, r, rk, ri: integer;
  isComment, isString, isNumber: boolean;
  arrIdentifier: array of string;
  arrToken: array of string;
  arrTokenKategori: array of string;
  arrKategori: array of string;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.IsNumeric(Value: string; const AllowFloat: boolean): boolean;
var
  ValueInt: integer;
  ValueFloat: extended;
  ErrCode: integer;
begin
  Value := SysUtils.Trim(Value);
  Val(Value, ValueInt, ErrCode);
  result := ErrCode = 0;
  if not result and AllowFloat then
  begin

    Val(Value, ValueFloat, ErrCode);
    result := ErrCode = 0;
  end;
end;

procedure TForm1.WriteData(token, kategoriToken, kategori: string);
var
  kategoriExist, identExist: boolean;
begin
  kategoriExist := false;
  identExist := false;

  setLength(arrToken, length(arrToken) + 1);
  arrToken[high(arrToken)] := token;
  setLength(arrTokenKategori, length(arrTokenKategori) + 1);
  arrTokenKategori[high(arrTokenKategori)] := kategoriToken;

  tableToken.InsertRowWithValues(r, [IntToStr(length(arrToken) - 1), token]);

  r := r + 1;

end;

procedure TForm1.CheckKeywords(s: string);
begin
  if (s = 'integer') then
    WriteData(s, 'intcon', 'intcon')
  else if (s = 'real') then
    WriteData(s, 'realcon', 'realcon')
  else if (s = 'char') then
    WriteData(s, 'charcon', 'charcon')
  else if (s = 'string') then
    WriteData(s, 'stringt', 'stringt')
  else if (s = 'not') then
    WriteData(s, 'notsy', 'notsy')
  else if (s = 'div') then
    WriteData(s, 'div', 'div')
  else if (s = 'mod') then
    WriteData(s, 'mod', 'mod')
  else if (s = 'and') then
    WriteData(s, 'and', 'andsy')
  else if (s = 'or') then
    WriteData(s, 'or', 'orsy')
  else if (s = 'program') then
    WriteData(s, 'program', 'programsy')
  else if (s = 'var') then
    WriteData(s, 'var', 'varsy')
  else if (s = 'begin') then
    WriteData(s, 'begin', 'beginsy')
  else if (s = 'end') then
    WriteData(s, 'end', 'endsy')
  else if (s = 'if') then
    WriteData(s, 'if', 'ifsy')
  else if (s = 'else') then
    WriteData(s, 'else', 'elsesy')
  else if (s = 'then') then
    WriteData(s, 'then', 'thensy')
  else if (s = 'for') then
    WriteData(s, 'for', 'forsy')
  else if (s = 'to') then
    WriteData(s, 'to', 'tosy')
  else if (s = 'downto') then
    WriteData(s, 'downto', 'downtosy')
  else if (s = 'while') then
    WriteData(s, 'while', 'whilesy')
  else if (s = 'do') then
    WriteData(s, 'do', 'dosy')
  else if (s = 'until') then
    WriteData(s, 'until', 'untilsy')
  else if (s = 'repeat') then
    WriteData(s, 'repeat', 'repeatsy')
  else if (s = 'of') then
    WriteData(s, 'of', 'ofsy')
  else if (s = 'case') then
    WriteData(s, 'case', 'casesy')
  else if (s = 'array') then
    WriteData(s, 'array', 'arraysy')
  else if (s = 'procedure') then
    WriteData(s, 'procedure', 'proceduresy')
  else if (s = 'function') then
    WriteData(s, 'function', 'functionsy')
  else if (s = 'const') then
    WriteData(s, 'const', 'constsy')
  else if (s = 'type') then
    WriteData(s, 'type', 'typesy')
  else if (LeftStr(s, 1) = '{') and (RightStr(s, 1) = '}') then
    WriteData(s, 'operator {}', 'comment')
  else if (LeftStr(s, 1) = #39) and (RightStr(s, 1) = #39) and (length(s) = 3) then
    WriteData(s, 'typechar', 'typechar')
  else if (LeftStr(s, 1) = #39) and (RightStr(s, 1) = #39) then
    WriteData(s, 'typestring', 'typestring')
  else if (IsNumeric(s, true)) then
  begin
    if (pos('.', s) = 0) then
      WriteData(s, 'typeinteger', 'typeinteger')
    else
      WriteData(s, 'typereal', 'typereal');
  end
  else if (Length(Trim(s)) > 0) then
    WriteData(Trim(s), 'identifier', 'ident');
end;

procedure TForm1.CheckSymbols();
begin
  if (ch = ',') then
    WriteData(ch, 'comma', 'comma')
  else if (ch = '.') then
    WriteData(ch, 'period', 'period')
  else if (ch = ';') then
    WriteData(ch, 'semicolon', 'semicolon')
  else if (ch = '+') then
    WriteData(ch, 'operator +', 'plus')
  else if (ch = '-') then
    WriteData(ch, 'operator -', 'minus')
  else if (ch = '*') then
    WriteData(ch, 'operator *', 'times')
  else if (ch = '/') then
    WriteData(ch, 'operator /', 'idiv')
  else if (ch = '=') then
    WriteData(ch, 'operator =', '=')
  else if (ch = '(') then
    WriteData(ch, 'lparent', 'lparent')
  else if (ch = ')') then
    WriteData(ch, 'rparent', 'rparent')
  else if (ch = '[') then
    WriteData(ch, 'lbrack', 'lbrack')
  else if (ch = ']') then
    WriteData(ch, 'rbrack', 'rbrack')
  else if (ch = ']') then
    WriteData(ch, 'rbrack', 'rbrack')
  else if (ch = '<') then
  begin
    read(f, ch);
    if (ch = '=') then
      WriteData('<=', 'leg', 'leg')
    else
    begin
      WriteData('<', 'lss', 'lss');
      CheckKeywords(ch);
    end;
  end
  else if (ch = '>') then
  begin
    read(f, ch);
    if (ch = '=') then
      WriteData('>=', 'geg', 'geg')
    else
    begin
      WriteData('>', 'gtr', 'gtr');
      CheckKeywords(ch);
    end;
  end
  else if (ch = ':') then
  begin
    read(f, ch);
    if (ch = '=') then
      WriteData(':=', 'operator :=', 'becomes')
    else
    begin
      WriteData(':', 'colon', 'colon');
      CheckKeywords(ch);
    end;
  end;
end;

procedure TForm1.ResetApp();
begin
  tableToken.RowCount := 1;
  setLength(arrToken, 0);
  setLength(arrTokenKategori, 0);
  setLength(arrKategori, 0);
  setLength(arrIdentifier, 0);
  inProses.Lines.Clear();
  i := 0;
  r := 1;
  rk := 1;
  ri := 1;
  isComment := false;

end;

function TForm1.ExcludeSymbols(ch: char): boolean;
begin
  ExcludeSymbols := (ch <> '+') and (ch <> '-') and (ch <> '*') and (ch <> '/') and
    (ch <> '=') and (ch <> ':') and (ch <> ',') and (ch <> ';') and
    (ch <> ' ') and (ch <> '(') and (ch <> ')') and (ch <> '[') and
    (ch <> ']') and (ch <> '<') and (ch <> '>') and (ch <> #13) and
    (ch <> #10) and (ch <> #9) and (ch <> '.');
end;

procedure TForm1.cekTerminal(s: string);
begin
  if arrToken[i] = s then
    i := i + 1
  else
    inProses.Lines.Add('Parsing failed');
end;

procedure TForm1.gVar();
begin
  inProses.Lines.Add('>> <var> ' + arrToken[i]);
  i := i + 1;
  if arrToken[i] = ',' then
  begin
    i := i + 1;
    gVar();
  end
  else if arrToken[i] = '[' then
  begin
    cekTerminal('[');
    gVar();
    cekTerminal(']');
  end;
end;

procedure TForm1.gVarType();
begin
  inProses.Lines.Add('>> <var_type>');
  case LeftStr(arrToken[i], 1) of
    'i': cekTerminal('integer');
    'c': cekTerminal('char');
    'r': cekTerminal('real');
    's': cekTerminal('string');
    'b': cekTerminal('boolean');
    'a':
    begin
      cekTerminal('array');
      cekTerminal('of');
      gVarType();
    end;
  end;
end;

procedure TForm1.gVarList();
begin
  inProses.Lines.Add('>> <var_list>');
  gVar();
  cekTerminal(':');
  gVarType();
  cekTerminal(';');
  if arrToken[i] <> 'begin' then
    gVarList();
end;

procedure TForm1.gOperator();
begin
  inProses.Lines.Add('>> <arithmetic_opr>');
  case arrToken[i] of
    '+': cekTerminal('+');
    '-': cekTerminal('-');
    '*': cekTerminal('*');
    '/': cekTerminal('/');
    '>': cekTerminal('>');
    '<': cekTerminal('<');
    '=': cekTerminal('=');
    '>=': cekTerminal('>=');
    '<=': cekTerminal('<=');
    '<>': cekTerminal('<>');
  end;
end;

procedure TForm1.gExpression();
begin
  inProses.Lines.Add('>> <expression>');
  gVar();
  if arrToken[i] <> ';' then
  begin
    gOperator();
    gVar();
  end;
end;

procedure TForm1.gFunction();
begin
  inProses.Lines.Add('>> <function>');
  cekTerminal('(');
  gVar();
  cekTerminal(')');
end;

procedure TForm1.gStmt();
begin
  inProses.Lines.Add('>> <stmt>');
  case LeftStr(arrToken[i], 2) of
    'if': gIf();
    'fo': gFor();
    'wh': gWhile();
    'wr': gWrite();
    're': gRepeat();
    else if arrToken[i] <> 'end' then
      begin
        gVar();
        if arrToken[i] = '(' then
          gFunction()
        else
        begin
          cekTerminal(':=');
          gExpression();
        end;
      end;
  end;
end;

procedure TForm1.gStmtList();
begin
  inProses.Lines.Add('>> <stmt_list>');
  gStmt();
  if arrToken[i] = ';' then
  begin
    i := i + 1;
    gStmtList();
  end;
end;

procedure TForm1.gIf();
begin
  inProses.Lines.Add('>> <if>');
  cekTerminal('if');
  gVar();
  gOperator();
  gVar();
  cekTerminal('then');
  gStmtList();
end;

procedure TForm1.gWrite();
begin
  inProses.Lines.Add('>> <write>');
  cekTerminal('write');
  cekTerminal('(');
  gVar();
  cekTerminal(')');
end;

procedure TForm1.gFor();
begin
  inProses.Lines.Add('>> <for>');
  cekTerminal('for');
end;

procedure TForm1.gWhile();
begin
  inProses.Lines.Add('>> <while>');
  cekTerminal('while');
  gVar();
  gOperator();
  gVar();
  cekTerminal('do');
  gStmtList();
end;

procedure TForm1.gRepeat();
begin
  inProses.Lines.Add('>> <repeat>');
  cekTerminal('repeat');
end;

procedure TForm1.gProgram();
begin
  inProses.Lines.Add('>> <program>');
  cekTerminal('program');
  gVar();
  cekTerminal(';');
  cekTerminal('var');
  gVarList();
  cekTerminal('begin');
  gStmtList();
  cekTerminal('end');
end;

procedure TForm1.btnOpenFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    inCode.Lines.LoadFromFile(OpenDialog1.Filename);
    system.Assign(f, OpenDialog1.Filename);
    ResetApp();
    reset(f);
    inProses.Lines.Add('Tokenizing start');
    while not EOF(f) do
    begin
      read(f, ch);
      if (ch = '{') then
        isComment := true
      else if (ch = #39) then
        isString := true
      else if (IsNumeric(ch, true)) then
        isNumber := true;
      while ExcludeSymbols(ch) or isComment or isString or isNumber do
      begin
        s += ch;
        read(f, ch);
        if (ch = '}') then
          isComment := false
        else if (ch = #39) then
          isString := false
        else if (not IsNumeric(ch, true)) then
          isNumber := false;
      end;
      CheckKeywords(s);
      s := '';
      CheckSymbols();
    end;
    inProses.Lines.Add('Total: ' + IntToStr(length(arrToken)) + ' tokens');
    inProses.Lines.Add('Tokenizing done');
    inProses.Lines.Add('****************');
    inProses.Lines.Add('Parsing start');
    i := 0;
    gProgram();
    inProses.Lines.Add('Parsing done');
    closefile(f);
  end;
end;

end.