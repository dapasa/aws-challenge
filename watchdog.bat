@ECHO OFF

REM Settings variables from parameters
echo "### Running Watchdog ###"
echo "Enter url to check"
set /p url="URL: "
echo "Enter time to wait between check (in seconds)"
set /p seconds="Seconds: "
REM set seconds=%1
REM set url=%2

REM Setting variables
:start
set count=0
set headers=0
set curlstatus=0
set httpstatus=0

:getUrl 
REM Checking url
IF "%count%" == "1" GOTO :next
curl -Is --connect-timeout 5 %url% > NUL
IF %ERRORLEVEL% EQU 0 GOTO :getCode
IF %ERRORLEVEL% NEQ 0 set curlstatus=%ERRORLEVEL%
IF %curlstatus% EQU 1 GOTO :fail
GOTO :next

:getCode
FOR /F "tokens=*" %%a in ('curl -Is --connect-timeout 5 %url%') do SET headers=%%a && GOTO :plusCount

REM To get the first line to curl response the counter is set to 1 to make a bypass in the url check
:plusCount
set count=1
GOTO :getUrl

:next
REM Check for timeout
IF "%curlstatus%" EQU "28" GOTO :failtimeout 

REM Check HTTP status code
FOR /F "tokens=2" %%a in ('echo %headers%') do set httpstatus=%%a
IF "%httpstatus%" EQU "200" GOTO :success
IF "%httpstatus%" EQU "301" GOTO :success
GOTO :fail

:failtimeout
REM Print message if the curl response back in time out
echo "************************************************************************"
echo "Status code: %curlstatus% - time out"
echo "Request failed"
echo "************************************************************************"
GOTO :waittime

:success
REM Print message if the curl response back in succss 
echo "************************************************************************"
echo "Status code: %httpstatus%"
echo "Request success"
echo "************************************************************************"
GOTO :waittime

:fail
REM Print message if the curl response back in fail
echo "************************************************************************"
echo "Status code: 404" 
echo "Request failed"
echo "************************************************************************"

:waittime
REM start wait time until next curl execution.
timeout /t %seconds% /nobreak > NUL
GOTO :start
