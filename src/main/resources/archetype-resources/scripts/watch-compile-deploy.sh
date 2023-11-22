#! /usr/bin/env sh

SRC=$(find src/main -maxdepth 10 -type f -regex ".*\.scm")

fswatch --monitor=poll_monitor $SRC | (while read LINE; do mvn kawa:compile; mvn compile: mvn tomcat9:redeploy; done)

