unit ScannerLexical_Unit;
{ Nama: SYAUQI ILHAM ALFARACI, Kelas: IF14K, NIM: 10116900 }
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
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    tableIdent: TStringGrid;
    tableToken: TStringGrid;
    tableKategori: TStringGrid;
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

procedure TForm1.btnOpenFileClick(Sender: TObject);   
function IsNumeric(Value: string; const AllowFloat: Boolean): Boolean;
var
  ValueInt: Integer;
  ValueFloat: Extended;
  ErrCode: Integer;
begin
Value := SysUtils.Trim(Value);
Val(Value, ValueInt, ErrCode);
Result := ErrCode = 0;
if not Result and AllowFloat then
    begin

    Val(Value, ValueFloat, ErrCode);
    Result := ErrCode = 0;
    end;
end;
procedure WriteData(token, kategoriToken, kategori: string);
var kategoriExist, identExist : boolean;
begin
     kategoriExist := false; 
     identExist := false;
     if (kategoriToken = 'identifier') then
     begin
        for i := Low(arrIdentifier) to High(arrIdentifier) do
          if arrIdentifier[i] = token then
          begin
            identExist := true;
            break;
          end;
        if (identExist = false) then
        begin
           setLength(arrIdentifier, length(arrIdentifier) + 1);
           arrIdentifier[high(arrIdentifier)] := token;
           tableIdent.InsertRowWithValues(ri, [token]);
           ri := ri + 1;
        end;
     end
     else
     begin
          setLength(arrToken, length(arrToken) + 1);
          arrToken[high(arrToken)] := token;
          setLength(arrTokenKategori, length(arrTokenKategori) + 1);
          arrTokenKategori[high(arrTokenKategori)] := kategoriToken;
     end;
     tableToken.InsertRowWithValues(r, [token, kategoriToken]);
      for i := Low(arrKategori) to High(arrKategori) do
        if arrKategori[i] = kategori then
        begin
          kategoriExist := true;
          break;
        end
        else
        begin
        end;
      r := r + 1;
      if (kategoriExist) then
      begin
          tableKategori.cells[1, i + 1] := inttostr(strtoint(tableKategori.cells[1, i + 1]) + 1);
      end
      else
      begin
          setLength(arrKategori, length(arrKategori) + 1);
          arrKategori[high(arrKategori)] := kategori;
          tableKategori.InsertRowWithValues(rk, [kategori, '1']);
          rk := rk + 1;
      end;
end;
procedure CheckKeywords(s: string);
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
procedure CheckSymbols();
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
              else begin
                 WriteData('<', 'lss', 'lss');
                 CheckKeywords(ch);
              end;
         end
         else if (ch = '>') then
         begin
              read(f, ch);
              if (ch = '=') then
                 WriteData('>=', 'geg', 'geg')
              else begin
                 WriteData('>', 'gtr', 'gtr');   
                 CheckKeywords(ch);
              end;
         end
         else if (ch = ':') then
         begin
              read(f, ch);
              if (ch = '=') then
                 WriteData(':=', 'operator :=', 'becomes')
              else begin
                 WriteData(':', 'colon', 'colon'); 
                 CheckKeywords(ch);
              end;
         end;
end;
procedure ResetApp();
begin
        tableToken.RowCount := 1; 
        tableKategori.RowCount := 1;
        tableIdent.RowCount := 1;
      setLength(arrToken, 0);  
      setLength(arrTokenKategori, 0);
      setLength(arrKategori, 0);   
      setLength(arrIdentifier, 0);
       r := 1;
       rk := 1;
       ri := 1;
       isComment := false;

end;

function ExcludeSymbols(ch: char) : Boolean;
begin
  ExcludeSymbols := (ch <> '+') and (ch <> '-') and (ch <> '*') and (ch <> '/')
                    and (ch <> '=') and (ch <> ':') and (ch <> ',') and (ch <> ';')
                    and (ch <> ' ') and (ch <> '(') and (ch <> ')') and (ch <> '[')
                    and (ch <> ']') and (ch <> '<') and (ch <> '>') and (ch <> #13)
                    and (ch <> #10) and (ch <> #9) and (ch <> '.')
end;

begin
  if OpenDialog1.Execute then
  begin
       inCode.Lines.LoadFromFile(OpenDialog1.Filename);
       system.assign(f,OpenDialog1.Filename);  
       ResetApp();
       reset(f);
       while not eof(f) do
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
       closefile(f);
  end;
end;

end.

