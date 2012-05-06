@echo off
if exist source\OverbyteIcsWSocket.pas goto clean
echo.
echo.
echo Not an ICS repository
goto end
:clean

REM Clear samples
if exist samples\delphi\internet\OverbyteIcs*.rsm del samples\delphi\internet\OverbyteIcs*.rsm
if exist samples\delphi\internet\OverbyteIcs*_Icon.ico del samples\delphi\internet\OverbyteIcs*_Icon.ico
if exist samples\delphi\internet\OverbyteIcs*.exe del samples\delphi\internet\OverbyteIcs*.exe
if exist samples\delphi\internet\OverbyteIcs*.dll del samples\delphi\internet\OverbyteIcs*.dll
if exist samples\delphi\internet\OverbyteIcs*.ddp del samples\delphi\internet\OverbyteIcs*.ddp
if exist samples\delphi\internet\Dcu\*.dcu del samples\delphi\internet\Dcu\*.dcu
if exist samples\delphi\internet\OverbyteIcs*.dcu del samples\delphi\internet\OverbyteIcs*.dcu
if exist samples\delphi\internet\OverbyteIcs*.dproj del samples\delphi\internet\OverbyteIcs*.dproj
if exist samples\delphi\internet\OverbyteIcs*.dproj.2007 del samples\delphi\internet\OverbyteIcs*.dproj.2007
if exist samples\delphi\internet\OverbyteIcs*.bdsproj del samples\delphi\internet\OverbyteIcs*.bdsproj
if exist samples\delphi\internet\OverbyteIcs*.bdsgroup del samples\delphi\internet\OverbyteIcs*.bdsgroup
if exist samples\delphi\internet\OverbyteIcs*.groupproj del samples\delphi\internet\OverbyteIcs*.groupproj
if exist samples\delphi\internet\dcu\OverbyteIcs*.dcu del samples\delphi\internet\dcu\OverbyteIcs*.dcu
if exist samples\delphi\internet\OverbyteIcs*.cfg del samples\delphi\internet\OverbyteIcs*.cfg
if exist samples\delphi\internet\OverbyteIcs*.~*  del samples\delphi\internet\OverbyteIcs*.~*
if exist samples\delphi\internet\OverbyteIcs*.bak del samples\delphi\internet\OverbyteIcs*.bak
if exist samples\delphi\internet\OverbyteIcs*.dproj.local del samples\delphi\internet\OverbyteIcs*.dproj.local
if exist samples\delphi\internet\OverbyteIcs*.groupproj.local del samples\delphi\internet\OverbyteIcs*.groupproj.local
if exist samples\delphi\internet\OverbyteIcs*.bdsproj.local del samples\delphi\internet\OverbyteIcs*.bdsproj.local
if exist samples\delphi\internet\OverbyteIcs*.bdsgroup.local del samples\delphi\internet\OverbyteIcs*.bdsgroup.local
if exist samples\delphi\internet\OverbyteIcs*.identcache del samples\delphi\internet\OverbyteIcs*.identcache

if exist samples\delphi\sslinternet\OverbyteIcs*.rsm del samples\delphi\sslinternet\OverbyteIcs*.rsm
if exist samples\delphi\sslinternet\OverbyteIcs*_Icon.ico del samples\delphi\sslinternet\OverbyteIcs*_Icon.ico
if exist samples\delphi\sslinternet\OverbyteIcs*.exe del samples\delphi\sslinternet\OverbyteIcs*.exe
if exist samples\delphi\sslinternet\OverbyteIcs*.ddp del samples\delphi\sslinternet\OverbyteIcs*.ddp
if exist samples\delphi\sslinternet\Dcu\*.dcu del samples\delphi\sslinternet\Dcu\*.dcu
if exist samples\delphi\sslinternet\OverbyteIcs*.dcu del samples\delphi\sslinternet\OverbyteIcs*.dcu
if exist samples\delphi\sslinternet\OverbyteIcs*.dproj del samples\delphi\sslinternet\OverbyteIcs*.dproj
if exist samples\delphi\sslinternet\OverbyteIcs*.dproj.2007 del samples\delphi\sslinternet\OverbyteIcs*.dproj.2007
if exist samples\delphi\sslinternet\OverbyteIcs*.bdsproj del samples\delphi\sslinternet\OverbyteIcs*.bdsproj
if exist samples\delphi\sslinternet\OverbyteIcs*.bdsgroup del samples\delphi\sslinternet\OverbyteIcs*.bdsgroup
if exist samples\delphi\sslinternet\OverbyteIcs*.groupproj del samples\delphi\sslinternet\OverbyteIcs*.groupproj
if exist samples\delphi\sslinternet\OverbyteIcs*.cfg del samples\delphi\sslinternet\OverbyteIcs*.cfg
if exist samples\delphi\sslinternet\OverbyteIcs*.~*  del samples\delphi\sslinternet\OverbyteIcs*.~*
if exist samples\delphi\sslinternet\OverbyteIcs*.bak del samples\delphi\sslinternet\OverbyteIcs*.bak
if exist samples\delphi\sslinternet\OverbyteIcs*.dproj.local del samples\delphi\sslinternet\OverbyteIcs*.dproj.local
if exist samples\delphi\sslinternet\OverbyteIcs*.groupproj.local del samples\delphi\sslinternet\OverbyteIcs*.groupproj.local
if exist samples\delphi\sslinternet\OverbyteIcs*.bdsproj.local del samples\delphi\sslinternet\OverbyteIcs*.bdsproj.local
if exist samples\delphi\sslinternet\OverbyteIcs*.bdsgroup.local del samples\delphi\sslinternet\OverbyteIcs*.bdsgroup.local
if exist samples\delphi\sslinternet\OverbyteIcs*.identcache del samples\delphi\sslinternet\OverbyteIcs*.identcache

if exist samples\delphi\miscdemos\OverbyteIcs*.rsm del samples\delphi\miscdemos\OverbyteIcs*.rsm
if exist samples\delphi\miscdemos\OverbyteIcs*_Icon.icon del samples\delphi\miscdemos\OverbyteIcs*_Icon.icon
if exist samples\delphi\miscdemos\OverbyteIcs*.exe del samples\delphi\miscdemos\OverbyteIcs*.exe
if exist samples\delphi\miscdemos\OverbyteIcs*.ddp del samples\delphi\miscdemos\OverbyteIcs*.ddp
if exist samples\delphi\miscdemos\Dcu\*.dcu del samples\delphi\miscdemos\Dcu\*.dcu
if exist samples\delphi\miscdemos\OverbyteIcs*.dcu del samples\delphi\miscdemos\OverbyteIcs*.dcu
if exist samples\delphi\miscdemos\OverbyteIcs*.dproj del samples\delphi\miscdemos\OverbyteIcs*.dproj
if exist samples\delphi\miscdemos\OverbyteIcs*.dproj.2007 del samples\delphi\miscdemos\OverbyteIcs*.dproj.2007
if exist samples\delphi\miscdemos\OverbyteIcs*.bdsproj del samples\delphi\miscdemos\OverbyteIcs*.bdsproj
if exist samples\delphi\miscdemos\OverbyteIcs*.bdsgroup del samples\delphi\miscdemos\OverbyteIcs*.bdsgroup
if exist samples\delphi\miscdemos\OverbyteIcs*.groupproj del samples\delphi\miscdemos\OverbyteIcs*.groupproj
if exist samples\delphi\miscdemos\OverbyteIcs*.cfg del samples\delphi\miscdemos\OverbyteIcs*.cfg
if exist samples\delphi\miscdemos\OverbyteIcs*.~*  del samples\delphi\miscdemos\OverbyteIcs*.~*
if exist samples\delphi\miscdemos\OverbyteIcs*.bak del samples\delphi\miscdemos\OverbyteIcs*.bak
if exist samples\delphi\miscdemos\OverbyteIcs*.dproj.local del samples\delphi\miscdemos\OverbyteIcs*.dproj.local
if exist samples\delphi\miscdemos\OverbyteIcs*.groupproj.local del samples\delphi\miscdemos\OverbyteIcs*.groupproj.local
if exist samples\delphi\miscdemos\OverbyteIcs*.bdsproj.local del samples\delphi\miscdemos\OverbyteIcs*.bdsproj.local
if exist samples\delphi\miscdemos\OverbyteIcs*.bdsgroup.local del samples\delphi\miscdemos\OverbyteIcs*.bdsgroup.local
if exist samples\delphi\miscdemos\OverbyteIcs*.identcache del samples\delphi\miscdemos\OverbyteIcs*.identcache


if exist samples\delphi\platformdemos\*.identcache del samples\delphi\platformdemos\*.identcache
if exist samples\delphi\platformdemos\*.dproj.local del samples\delphi\platformdemos\*.dproj.local
if exist samples\delphi\platformdemos\win32\debug\*.* del samples\delphi\platformdemos\win32\debug\*.*
if exist samples\delphi\platformdemos\win32\release\*.* del samples\delphi\platformdemos\win32\release\*.*
if exist samples\delphi\platformdemos\win64\debug\*.* del samples\delphi\platformdemos\win64\debug\*.*
if exist samples\delphi\platformdemos\win64\release\*.* del samples\delphi\platformdemos\win64\release\*.*
if exist samples\delphi\platformdemos\osx32\debug\*.* del samples\delphi\platformdemos\osx32\debug\*.*
if exist samples\delphi\platformdemos\osx32\release\*.* del samples\delphi\platformdemos\osx32\release\*.*


if exist samples\cpp\internet\OverbyteIcs*.dcu del samples\cpp\internet\OverbyteIcs*.dcu
if exist samples\cpp\internet\OverbyteIcs*.~*  del samples\cpp\internet\OverbyteIcs*.~*
if exist samples\cpp\internet\OverbyteIcs*.ba  del samples\cpp\internet\OverbyteIcs*.bak
if exist samples\cpp\internet\OverbyteIcs*.obj del samples\cpp\internet\OverbyteIcs*.obj

if exist samples\cpp\internet\bcb6\OverbyteIcs*.dcu del samples\cpp\internet\bcb6\OverbyteIcs*.dcu
if exist samples\cpp\internet\bcb6\OverbyteIcs*.~*  del samples\cpp\internet\bcb6\OverbyteIcs*.~*
if exist samples\cpp\internet\bcb6\OverbyteIcs*.bak del samples\cpp\internet\bcb6\OverbyteIcs*.bak
if exist samples\cpp\internet\bcb6\OverbyteIcs*.obj del samples\cpp\internet\bcb6\OverbyteIcs*.obj

echo Done !
:end
pause