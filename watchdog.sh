#!/bin/dash

seconds=$1
url=$2

until [ 0 -gt 1 ]
do
    HEADERS=`curl -Is --connect-timeout 5 ${2}`
    CURLSTATUS=$?
    # Check for timeout
    if [ $CURLSTATUS -eq 28 ]
        then
            echo "Request failed"
    else
        # Check HTTP status code
        HTTPSTATUS=`echo $HEADERS | grep HTTP | cut -d' ' -f2`
        if [ $HTTPSTATUS -le 399 ]
            then
                echo "Request success"
        else
            echo "Request failed"
        fi
    fi
    sleep $1
done