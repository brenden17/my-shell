#!/bin/bash

now=`date +%Y-%m-%d-%H:%M:%S`
tarName="backups/$now.tar"
#
tar -cvf $tarName src/*.java static/img static/style static/js
gzip $tarName
#
# delete backups 14 days old or older
#
find backups -mtime +14 -name '*.tar.gz' -exec rm {} \;
