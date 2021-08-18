@echo off
if [%1]==[] goto usage
REM if [%3]==[] goto usage
Rem Logon/off Activity
@echo Logon/off Activity
REM LogParser.exe -stats:OFF -i:EVT -o CSV file:"C:\Program Files (x86)\Log Parser 2.2\Logon_activity.sql"?src=%1+dst=%2+host=%3 -filemode:0
LogParser.exe -stats:OFF -i:EVT -o CSV file:"C:\Program Files (x86)\Log Parser 2.2\Logon_activity.sql"?host=%1 -filemode:0
goto :eof
:usage
@echo Generate RDP Usage and Logon/off activities CSV
REM @echo Usage: %0 ^<EVTX-dir^> ^<OUTPUT-File^> ^<HOSTNAME^>
@echo Usage: %0 ^<HOSTNAME^>
exit /B 1