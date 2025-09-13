#!/bin/sh

thisdir=`pwd`

# find . -name \*-rc-\* -a -type d | less

# set -x

for meta in `find . -name maven-metadata.xml` ; do
    dir=`dirname ${meta}`
    cd ${dir}

    cat maven-metadata.xml.sha1 > bbb
    echo -n " maven-metadata.xml" >> bbb
    OK=0 ; sha1sum -c bbb && OK=1
    if [ ${OK} -eq 0 ] ; then
        echo "${dir}: ${meta}: sha1 failed"
        cat bbb
        rm bbb
        exit 1 
    fi

    cat maven-metadata.xml.md5 > bbb
    echo -n " maven-metadata.xml" >> bbb
    OK=0 ; md5sum -c bbb && OK=1
    if [ ${OK} -eq 0 ] ; then
        echo "${dir}: ${meta}: md5 failed"
        cat bbb
        rm bbb
        exit 1 
    fi

    rm bbb
    cd ${thisdir}
done
