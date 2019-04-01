#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT
function ctrl_c() {
    rm server.pipe
    exit 0
}

echo "server running"
mkfifo server.pipe

# start of the infinite loop
while true; do

# the script store wat come from the server.pipe into the variable input
input=`cat server.pipe`

# The input is cut between the spaces and stored in smaller variable for futur use
func=`echo $input | cut -d ' ' -f 1`
cid=`echo $input | cut -d ' ' -f 2`
client="$cid.pipe"
database=`echo $input | cut -d ' ' -f 3`
table=`echo $input | cut -d ' ' -f 4`
row=`echo $input | cut -d ' ' -f 5`

# depending of the value of the first part of the input ($func) we execute the coresponding script. and we pass the variable that are needed for the script to run. The script is executed in the background (&). the result of the script is passed in the coresponding client pipe.
    case "$func" in
        create_database)
            ./create_database.sh $database > "$client" &
            ;;
        create_table)
            ./create_table.sh $database $table $row > "$client" &
            ;;
        insert)
            ./insert.sh $database $table $row > "$client" &
            ;;
        select)
        # during my firs try my select returned me the table as a single line, each row separeted by spaces. I changed the spaces by new line with sed.
            ./select.sh $database $table $row | sed 's/ /\n/' > "$client" &
            ;;
        shutdown)
            rm server.pipe
            echo "Server shuting down"
            exit 0
        ;;
        *)
            echo "Error: bad request"> "$client" &
    esac  
done