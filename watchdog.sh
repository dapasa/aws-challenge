#!/bin/dash

seconds=$1
url=$2

until [ 0 -gt 1 ]
do
    HEADERS=`curl -Is --connect-timeout 5 ${2}`
    CURLSTATUS=$?
    # Check for timeout
    if [ ! -z "$HEADERS" ]
    then
        if [ $CURLSTATUS -eq 28 ]
        then
                echo "************************************************************************"
                echo "Status code: time out"
                echo "Request failed"
                echo "************************************************************************"
        else
            # Check HTTP status code
            HTTPSTATUS=`echo $HEADERS | grep HTTP | cut -d' ' -f2`
            echo "************************************************************************"
            echo "Status code: ${HTTPSTATUS}"
            echo "Request success"
            echo "************************************************************************"
        fi
    else
        echo "************************************************************************"
        echo "Status code: 404" 
        echo "Request failed"
        echo "************************************************************************"
    fi
    sleep $1
done