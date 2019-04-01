#!/bin/bash

# check the number of parameter
if [ $# -ne 1 ];
    then
        echo "Error: no parameter"
        exit 1
else
# we enter the critical section
    ./p.sh $0

    # we check that the database does not exist already.
    if [ -d "$1" ];
        then
        echo "Error: DB already exists"
        exitcode="2"

        # Creation of the new directory
    else
        mkdir "$1"
        echo "OK: database created"
        exitcode="0"
    fi

    # We exit the critical section
    ./v.sh $0

# We properly exit the script
    exit $exitcode
    
    fi
fi