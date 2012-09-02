unit Ics.Fmx.DemoUtils;

interface

{$I OverbyteIcsDefs.inc}

uses
    FMX.Platform;

function ScreenHeight : Integer;
function ScreenWidth : Integer;

implementation

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ScreenHeight : Integer;
begin
    Result := Trunc(Platform.GetScreenSize.Y);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function ScreenWidth : Integer;
begin
    Result := Trunc(Platform.GetScreenSize.X);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

end.
