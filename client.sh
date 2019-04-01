#!/bin/bash

id="$1"
trap ctrl_c INT
function ctrl_c() {
    rm $id.pipe
    exit 0
}

# ensure that the client have an ID
if [ $# -ne 1 ]; then
    echo "Error: client.sh accept 1 parameter you gave $#"
    exit 1
else
# create the client pipe
    clientpipe="$1.pipe"
    mkfifo "$1.pipe"

# enter an infinite loop that wait for user input.
    while true; do
        read input

# read the input and compare it to exit and shutdown
# I should have used case like in server.sh
        if [ "$input" = "exit" ]; then
            
            echo "the client is clossing"
            rm $id.pipe
            exit 0

        elif [ "$input" = "shutdown" ]; then
            echo "shutdown">server.pipe
            echo "The server is shuting down"

        else
        # The script count the number of space in the input.
            var_count=`echo $input | awk -F " " ' { print NF-1 } '`

            # if var_count = 0 that mean that the user entered a comand without argument.
            if [ $var_count -eq 0 ]; then
                echo "you should imput something like \"req args\""
            else
                # the input is spited into 2 variable req which should countain the name of a script (func in server.sh) and args that contain all the argumant the user want.
                req=`echo $input | cut -d ' ' -f 1`
                args=`echo $input | cut -d ' ' -f 2-9`

                # The client.sh echo the $req client id and $args into the server.pipe
                echo "$req $1 $args">server.pipe
            fi

            # client.sh store the response of the server into the variable output (cat what come from it's pipe)
            output=`cat $clientpipe`

            # and print the result on the client monitor (I use printf because it's more consistant than echo depending on which machine we use)
            printf "$output"

            # this 2 echo are here to insert 2 new lines.
            echo
            echo

        fi
    done
fi