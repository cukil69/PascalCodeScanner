program CompilerPascal;

{$mode objfpc}{$H+}

uses
    {$IFDEF UNIX}{$IFDEF UseCThreads}
    cthreads,
    {$ENDIF}{$ENDIF}
    Interfaces, // this includes the LCL widgetset
    Forms,
    Form,
    LexicalAnalyzer,
    ParserAnalyzer,
    SemanticAnalyzer,
    FileHelper,
    TokenHelper
    { you can add units after this };

{$R *.res}

begin
    RequireDerivedFormResource:=True;
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
end.

