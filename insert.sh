#!/bin/bash

# check the number of parameter
if [ $# -ne 3 ];
    then
    echo "Error: parameters problem"
    exit 1

else

# We check the existance of the table
    if [ ! -d "$1" ];
        then
        echo "Error: DB does not exist"
        exit 21
    else

    # We check that the table exist
        if [ ! -f "./$1/$2" ];
            then
            echo "Error: table does not exist"
            exit 31
        else

# we count the number of column in the table $head_count and the number of colum that we insert $var_count
            head_count=`head -n 1 ./$1/$2 | awk -F "," ' { print NF-1 } '`
            var_count=`echo $3 | awk -F "," ' { print NF-1 } '`

            # if we insert as much colunm that there is in the table we can proceed
            if [ $head_count -eq $var_count ];
                then         
                ./p.sh "$1/$2"       
                echo "$3" >> "./$1/$2"
                echo "OK: tuple inserted"
                ./v.sh "$1/$2"
                exit 0

                # there is not the same number of column in the table and in the insert so error
            else
                echo "Error: number of columns in tuple does not match schema of tabe \"$2\""
                exit 4
            fi
        fi
    fi
fi