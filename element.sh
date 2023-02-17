#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then 
  ELEMENT_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number::varchar = '$1' OR symbol = '$1' OR name = '$1'")
  if [[ -z $ELEMENT_NUMBER ]]
  then
      echo "I could not find that element in the database."
  else
    # Get all properties
    ELEMENT_QUERY=$($PSQL "SELECT * FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number WHERE elements.atomic_number = $ELEMENT_NUMBER")
    echo "$ELEMENT_QUERY" | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do
      ELEMENT_TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
      ELEMENT_TYPE_FORMATTED=$(echo $ELEMENT_TYPE | sed -r 's/^ *| *$//g')
      ATOMIC_NUMBER_FORMATTED=$(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g')
      ATOMIC_MASS_FORMATTED=$(echo $ATOMIC_MASS | sed -r 's/^ *| *$//g')
      MELTING_POINT_FORMATTED=$(echo $MELTING_POINT | sed -r 's/^ *| *$//g')
      BOILING_POINT_FORMATTED=$(echo $BOILING_POINT | sed -r 's/^ *| *$//g')
      SYMBOL_FORMATTED=$(echo $SYMBOL | sed -r 's/^ *| *$//g')
      NAME_FORMATTED=$(echo $NAME | sed -r 's/^ *| *$//g')
      # Print formatted data
      echo "The element with atomic number $ATOMIC_NUMBER_FORMATTED is $NAME_FORMATTED ($SYMBOL_FORMATTED). It's a $ELEMENT_TYPE_FORMATTED, with a mass of $ATOMIC_MASS_FORMATTED amu. $NAME_FORMATTED has a melting point of $MELTING_POINT_FORMATTED celsius and a boiling point of $BOILING_POINT_FORMATTED celsius."
    done
  fi
else
  echo -e "Please provide an element as an argument."
fi
