#!/bin/sh

thisdir=`pwd`

# find . -name \*-rc-\* -a -type d | less

timestamp=`date +%Y%m%d%H%M%S`

for meta in `find . -name maven-metadata.xml` ; do
    dir=`dirname ${meta}`
    echo "${dir}: ${meta}"

    cp -a ${dir}/maven-metadata.xml ${dir}/maven-metadata.xml.old

    sed -i \
        -e "/<version>.*-rc-.*<\/version>/d" \
        -e "s/<lastUpdated>.*<\/lastUpdated>/<lastUpdated>${timestamp}<\/lastUpdated>/g" \
        ${dir}/maven-metadata.xml

    sha1=`sha1sum ${dir}/maven-metadata.xml | awk '{ print $1 }'`
    echo -n "${sha1}" > ${dir}/maven-metadata.xml.sha1
    md5=`md5sum ${dir}/maven-metadata.xml | awk '{ print $1 }'`
    echo -n "${md5}" > ${dir}/maven-metadata.xml.md5

    diff -Nur ${dir}/maven-metadata.xml.old ${dir}/maven-metadata.xml
done
