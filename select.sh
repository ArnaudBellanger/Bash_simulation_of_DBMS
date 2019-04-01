#!/bin/bash

# Check if the number of parameter respect what we want to do later. (2 to display all the colunm 3 to display just the number specified)
if [ "$#" -ne 2 ] && [ "$#" -ne 3 ];
    then
    echo $#
    echo "Error: parameters problem"
    exit 1

else

# check that the database exist
    if [ ! -d "$1" ];
        then
        echo "Error: DB does not exist"
        exit 2
    else

    # check that the table exist
        if [ ! -f "./$1/$2" ];
            then
            echo "Error: table does not exist"
            exit 31
        else

        # count the number of column in the table (we count the coma and add one)
            number_col=$((`head -n 1 ./$1/$2 | awk -F "," ' { print NF-1 } '` + 1))

            # If we input 2 parameter that mean that the user want to display all the table so we display everything
            if [ $# -eq 2 ]; then
                    echo "start_result"
                    cat ./$1/$2
                    echo "end_result"

            # else the number of parameter is equal to 3 the user want to display just certain row
            else

            # we create an array $array that contain all the value of $3.
                IFS=', ' read -r -a array <<< "$3"
                # IFS Internal Field Separator set the coma as separator 
                # the <<< will introduce $3 as a stdin to read function
                # this create an array containing the value in $3

# we look for the minimun and maximun value of the $3 input
    # we set the max min to the first number of the array then...
                max="${array[0]}"
                min="${array[0]}"
        # ... we compare the value of min and max to the value array[i]...
                for i in "${array[@]}"; do
            # ... if the value is superrior or inferior to min we assign this value to min or max acordingly.
                (( i > max )) && max=$i
                (( i < min )) && min=$i
                done

# We compare the min to 0 (we will never have 0 coluln or less) and the max value to the number of colunm. If the user want to display column that don't exist the script will return an error.
                if [ $min -le 0 ] || [ $max -gt $number_col ];
                    then
                    echo "Error: column does not exist"
                    exit 4

            # The script return the colunm the user want 
                else
                    echo "start_result"
                    cut -d \, -f $3 < ./$1/$2
                    echo "end_result"
                    exit 0
            
                fi
            fi
        fi
    fi
fi
