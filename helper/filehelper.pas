unit FileHelper;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Dialogs;

type
    { ReadFileHeper }
    FileStringType = file of char;

    ReadFileHeper = class
        ObjDialog: TOpenDialog;
        FileString: FileStringType;
        function setFileString(DIALOG: TOpenDialog): boolean;
        procedure setCloseFile();
    end;

implementation

function ReadFileHeper.setFileString(DIALOG: TOpenDialog): boolean;
begin
    ObjDialog := DIALOG;

    if DIALOG.Execute then
    begin
        system.Assign(FileString, DIALOG.Filename);
        reset(FileString);
        setFileString := true;
    end
    else
    begin
        setFileString := false;
    end;
end;

procedure ReadFileHeper.setCloseFile();
begin
    close(FileString);
end;

end.


