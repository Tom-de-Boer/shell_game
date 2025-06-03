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

    result=$(echo "$1" | sed -z s/./$replaceBy/$indx)
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
The field that is animated is the selected field.
Use space bar to write to selected field.
Use a s d w to move the selected field.

If the field
DELIMITER
)

cheesePlaysTurnText="X Cheese is playing"
eggsPlaysTurnText="O eggs is playing O"
cheeseWonText="X Cheese won! X \n Press space bar for new game"
eggsWonText="O Eggs won! O \n Press space bar for new game"  

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
    if [ "$inputKey" == "a" ]; then
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

main () {(
    f1=""
    f2=""
    f3=""
    f4=""
    f5=""
    f6=""
    f7=""
    f8=""
    f9=""

    keepPlaying=true
    turnIsFor="X"
    turnText=$(getTurnText "${turnIsFor}")
    newField=$(replaceInPlayfield "${playfield}" 9 "X")
    selectedField=1
    animationFrame=1 
    animatedField="${newField}"
    inputKey=" "
    while $keepPlaying; do
        animatedField="${newField}"
        # read inputKey
        read -t 0.5 -N 1 inputKey
        selectedField=$(getSelectedField "${selectedField}" "${inputKey}") 
        if [ ${animationFrame} == 1 ]; then 
            animatedField=$(replaceInPlayfield "${newField}" "${selectedField}" ".")
            animationFrame=2
        
        else 
            animatedField=$(replaceInPlayfield "${newField}" "${selectedField}" ",")
            animationFrame=1
        fi
        clear
        echo "$turnText"
        echo "$animatedField"
    done
)}

main



