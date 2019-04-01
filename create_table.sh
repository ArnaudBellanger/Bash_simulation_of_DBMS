#!/bin/bash

# check the number of parameter
if [ $# -ne 3 ];
    then
    echo "Error: parameters problem"
    exit 1

else

# Check the existance of the database/folder
    if [ ! -d "$1" ];
        then
        echo "Error: DB does not exist"
        exit 21

    else

    # we enter the critical section 
        ./p.sh $1

        # We check that the table does not exist
        if [ -f "./$1/$2" ];
            then
            echo "Error: table already exists"
            exitcode="3"

            # we create the table and we insert the table heading in it.
        else
            touch "./$1/$2"
            echo "$3" >> "./$1/$2"
            echo "OK: table created"
            exitcode="0"
        fi

        # we exit the critical section
        ./v.sh $1

        exit $exitcode

    fi
fi