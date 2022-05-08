@ECHO OFF

set seconds=%1
set url=%2

:while
if 0 GTR 1 (
   set HEADERS=`curl -Is --connect-timeout 5 ${2}`
   set CURLSTATUS=%ERRORLEVEL%
    @REM Check for timeout
    if %CURLSTATUS% EQU 28 (
        echo "Request failed"
    )
    else (
        @REM Check HTTP status code
        set HTTPSTATUS=`echo $HEADERS | grep HTTP | cut -d' ' -f2`
        if %HTTPSTATUS% LSS 399 (
            echo "Request success"
        )
        else (
            echo "Request failed"
        )
    )
    sleep $1
   goto :while
)