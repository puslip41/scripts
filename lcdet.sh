#!/bin/bash

TEMP_FILE=lc.list

print_help() {
  echo "$0 [OPTIONS] FILE"
  echo "Find File Decoding Language Set."
  echo ""
  echo "      -h     help"
  echo "      -k     find word"
  exit 0
}

set_args() {
  while getopts "k:h" opt
  do
    case $opt in
      k) keyword=$OPTARG;;
      h) print_help ;;
      ?) print_help ;;
    esac
  done

  shift $(( $OPTIND - 1))

  file=$1
}

set_args $@

if [ "$file" == "" ]
then
  echo "no file is specfied"
  print_help

else

  echo "File: $file"

  iconv -l | sed -e 's/ /\
/g' | sort | uniq > $TEMP_FILE

  if [[ -z $keyword ]];
  then
    while read f
    do
      while read t
      do
        echo ""
        echo "Lang Set: $f --> $t"
        iconv -f $f -t $t $file 2>/dev/null
        echo ""
      done < $TEMP_FILE
    done < $TEMP_FILE
  else
    echo "Find Word: $keyword"

    while read f
    do
      while read t
      do
        r=`iconv -f $f -t $t $file 2>/dev/null | grep "$keyword"`
        if [[ ! -z $r ]]
        then
          echo ""
          echo "Lang Set: $f --> $t"
          echo "Convert Text: $r"
        fi
      done < $TEMP_FILE
    done < $TEMP_FILE
  fi

  rm -rf $TEMP_FILE

fi
