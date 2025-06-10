#!/usr/bin/env bash


replaceInPlayfield () {(
    #index like this
    # 1 2 4
    # 4 5 6
    # 7 8 9
    playfield="$1"
    indx="$2"
    replaceBy="$3"

    arr=('17' '21' '25' '45' '49' '53' '73' '77' '81')
    indxFromZero=$((indx - 1))

    strIndx="${arr[$indxFromZero]}"

    result=$(replaceByInStringAtIndex "$playfield" "$strIndx" "$replaceBy")
    echo "$result"
)}

replaceByInStringAtIndex () {(
    str="$1"
    indx="$2"
    replaceBy="$3"

    result=$(echo "${str}" | sed -z s/./$replaceBy/$indx)
    echo "$result"
)}

getCharAtIndex () {(
    strng="$1"
    indx="$2"
    indxMinusOne=$(( indx - 1 ))
    result="${strng:indxMinusOne:1}"
    echo "$result"
)}


playfield=$(cat <<DELIMITER
+---+---+---+
|   |   |   |
+---+---+---+
|   |   |   |
+---+---+---+
|   |   |   |
+---+---+---+
DELIMITER
)

explainationText=$(cat <<DELIMITER
Butter cheese and eggs.
The field that is animated is the selected field.
Use space bar to write to selected field.
Use a s d w to move the selected field.
DELIMITER
)

cheesePlaysTurnText="X Cheese is playing"
eggsPlaysTurnText="O eggs is playing O"
cheeseWonText="X Cheese won! X"
eggsWonText="O Eggs won! O"  

getTurnText () {(
    XorO="$1"
    if [ "$XorO" == "O" ]; then
        echo "$eggsPlaysTurnText"
    else
        echo "$cheesePlaysTurnText"
    fi
)}

getSelectedField () {(
    oldSelectedField="$1"
    inputKey="$2"
    selectedField="$oldSelectedField"
    if [ "$inputKey" == "a" ] || [ "$inputKey" == "4" ]; then
            newSelectedField=$(( oldSelectedField - 1 ))
            if [ "$newSelectedField" -gt "0" ]; then
                selectedField="$newSelectedField"
            fi
        elif [ "$inputKey" == "d" ]; then
             newSelectedField=$(( oldSelectedField + 1 ))
            if [ "$newSelectedField" -lt "10" ]; then
                selectedField="$newSelectedField"
            fi
        elif [ "$inputKey" == "s" ]; then
            newSelectedField=$(( oldSelectedField + 3 ))
            if [ "$newSelectedField" -lt "10" ]; then
                selectedField="$newSelectedField"
            fi
        elif [ "$inputKey" == "w" ]; then
            newSelectedField=$(( oldSelectedField - 3 ))
            if [ "$newSelectedField" -gt "0" ]; then
                selectedField="$newSelectedField"
            fi
        fi
        echo "$selectedField"
)} 

didwin () {(
    fields="$1"
    player="$2"

    if 
        [ "$( getCharAtIndex "$fields" 1 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 2 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 3 )" == "${player}" ]; then
        echo true
    fi
    if 
        [ "$( getCharAtIndex "$fields" 4 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 5 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 6 )" == "${player}" ]; then
        echo true
    fi
    if 
        [ "$( getCharAtIndex "$fields" 7 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 8 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 9 )" == "${player}" ]; then
        echo true
    fi
    if 
        [ "$( getCharAtIndex "$fields" 1 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 4 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 7 )" == "${player}" ]; then
        echo true
    fi
    if 
        [ "$( getCharAtIndex "$fields" 2 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 5 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 8 )" == "${player}" ]; then
        echo true
    fi
    if 
        [ "$( getCharAtIndex "$fields" 3 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 6 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 9 )" == "${player}" ]; then
        echo true
    fi
    if 
        [ "$( getCharAtIndex "$fields" 1 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 5 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 9 )" == "${player}" ]; then
        echo true
    fi
    if 
        [ "$( getCharAtIndex "$fields" 3 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 5 )" == "${player}" ] &&
        [ "$( getCharAtIndex "$fields" 7 )" == "${player}" ]; then
        echo true
    fi
)}

main () {(
    valuesInField="         "
    keepPlaying=true
    turnIsFor="X"
    selectedField=1
    animationFrame=1 
    inputKey=" "
    while $keepPlaying; do
        
        animatedField="${playfield}"

        read -rt 1 -N 1 inputKey

        selectedFieldValue=$(getCharAtIndex "${valuesInField}" "${selectedField}")
        
        if [ "${inputKey}" == " " ] && [ "${selectedFieldValue}" == " " ]; then
            if [ "${turnIsFor}" == "X" ]; then
                valuesInField=$(replaceByInStringAtIndex "${valuesInField}" "${selectedField}" "X")
                turnIsFor="O"
            else
                valuesInField=$(replaceByInStringAtIndex "${valuesInField}" "${selectedField}" "O")
                turnIsFor="X"
            fi
        fi
        turnText=$(getTurnText "${turnIsFor}")

        selectedField=$(getSelectedField "${selectedField}" "${inputKey}") 

        j=0
        while [ $j -lt 9 ]; do
            valueAtIndex="${valuesInField:${j}:1}"
            if [ "${valueAtIndex}" != " " ]; then
                animatedField=$(replaceInPlayfield "${animatedField}" "$(( j + 1 ))" "${valueAtIndex}")
            fi
            j=$(( j + 1 ))
        done
        selectedFieldValue=$(getCharAtIndex "${valuesInField}" "${selectedField}")
        
        if [ "${selectedFieldValue}" == " " ]; then 
            if [ ${animationFrame} == 1 ]; then 
                animatedField=$(replaceInPlayfield "${animatedField}" "${selectedField}" ".")
                animationFrame=2
            
            else 
                animatedField=$(replaceInPlayfield "${animatedField}" "${selectedField}" ",")
                animationFrame=1
            fi
        elif [ "${selectedFieldValue}" == "X" ]; then
            if [ ${animationFrame} == 1 ]; then 
                animatedField=$(replaceInPlayfield "${animatedField}" "${selectedField}" "X")
                animationFrame=2
            
            else 
                animatedField=$(replaceInPlayfield "${animatedField}" "${selectedField}" "x")
                animationFrame=1
            fi
        elif [ "${selectedFieldValue}" == "O" ]; then
            if [ ${animationFrame} == 1 ]; then 
                animatedField=$(replaceInPlayfield "${animatedField}" "${selectedField}" "O")
                animationFrame=2
            
            else 
                animatedField=$(replaceInPlayfield "${animatedField}" "${selectedField}" "o")
                animationFrame=1
            fi
        fi

        clear
        echo "$explainationText"
        echo "$turnText"
        echo "$animatedField"
        
        if [ "$(didwin "$valuesInField" "X")" ]; then
            keepPlaying=false
            echo "${cheeseWonText}"
        fi
        if [ "$(didwin "$valuesInField" "O")" ]; then
            keepPlaying=false
            echo "${eggsWonText}"
        fi
        
    done
)}

main