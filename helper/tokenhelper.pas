unit TokenHelper;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils;

type
    TokenReaderHelper = class
        function IsNumeric(Value: string; const AllowFloat: boolean): boolean;
        function ExcludeSymbols(ch: char): boolean;
    end;

implementation

function TokenReaderHelper.IsNumeric(Value: string; const AllowFloat: boolean): boolean;
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

function TokenReaderHelper.ExcludeSymbols(ch: char): boolean;
begin
    ExcludeSymbols := (ch <> '+') and (ch <> '-') and (ch <> '*') and (ch <> '/') and
        (ch <> '=') and (ch <> ':') and (ch <> ',') and (ch <> ';') and
        (ch <> ' ') and (ch <> '(') and (ch <> ')') and (ch <> '[') and
        (ch <> ']') and (ch <> '<') and (ch <> '>') and (ch <> #13) and
        (ch <> #10) and (ch <> #9);
end;

end.

