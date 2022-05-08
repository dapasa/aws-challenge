#!/bin/dash

#Settings variables from parameters
echo "### Running Watchdog ###"
echo "Enter url to check"
read url
echo "Enter time to wait between check (in seconds)"
read seconds

until [ 0 -gt 1 ]
do
    # Executing curl check and store the response.
    HEADERS=`curl -Is --connect-timeout 5 ${url}`
    CURLSTATUS=$?
    if [ ! -z "$HEADERS" ]
    then
        if [ $CURLSTATUS -eq 28 ]
        then
                # Print message if the curl response back in time out
                echo "************************************************************************"
                echo "Status code: ${CURLSTATUS} - time out"
                echo "Request failed"
                echo "************************************************************************"
        else
            # Check HTTP status code and print message if the curl response back in succss
            HTTPSTATUS=`echo $HEADERS | grep HTTP | cut -d' ' -f2`
            echo "************************************************************************"
            echo "Status code: ${HTTPSTATUS}"
            echo "Request success"
            echo "************************************************************************"
        fi
    else
        # Print message if the curl response back in fail
        echo "************************************************************************"
        echo "Status code: 404" 
        echo "Request failed"
        echo "************************************************************************"
    fi
    # start wait time until next curl execution.
    sleep $seconds
done