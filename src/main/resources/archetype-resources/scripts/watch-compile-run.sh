#! /usr/bin/env sh

DIR=$(pwd)
SRC=$(find src/main -print -maxdepth 10 -type f -regex ".*\.scm")
CLASSPATH=$(find $DIR -maxdepth 10 -type f -regex ".*\.jar" | paste -sd ":")

echo Running in $DIR
echo Watching $SRC
echo Classpath is $CLASSPATH

KAWA=$(find . -maxdepth 20 -type f -regex ".*kawa.*\.jar")

echo Found Kawa jar:  $KAWA

[ ! -f $KAWA ] && echo "Kawa jar can't be found" && exit 1;

fswatch --monitor=poll_monitor $SRC | (while read LINE; do cd $DIR/src/main/scheme && CLASSPATH=$CLASSPATH kawa main.scm; done)

