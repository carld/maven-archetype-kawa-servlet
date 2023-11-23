#! /usr/bin/env sh

SRC=$(find src/main -maxdepth 10 -type f -regex ".*\.scm")

fswatch --monitor=poll_monitor $SRC | (while read LINE; do mvn --fail-fast --batch-mode kawa:compile && mvn --fail-fast --batch-mode tomcat9:redeploy; done)

