#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

DISPLAY_INFO() {
  echo $1 | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

if [[ -z $1 ]]
  then echo "Please provide an element as an argument."
  elif [[ $1 =~ ^[0-9]+$ ]]
    then ELEMENT_SEARCH_RESULT=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$1")
    if [[ -z $ELEMENT_SEARCH_RESULT ]]
      then echo "I could not find that element in the database."
      else DISPLAY_INFO "$ELEMENT_SEARCH_RESULT"
    fi
  else
    ELEMENT_SEARCH_RESULT=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol='$1' or name='$1'")
    if [[ -z $ELEMENT_SEARCH_RESULT ]]
      then echo "I could not find that element in the database."
      else DISPLAY_INFO "$ELEMENT_SEARCH_RESULT"
    fi
fi