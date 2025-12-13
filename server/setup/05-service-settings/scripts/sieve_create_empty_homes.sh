#!/bin/sh

cd /home

for i in * ; do
    if [ ! -e $i/sieve ] ; then
        echo "Creating $i/sieve"
        mkdir $i/sieve
        chown -R $i:$i $i/sieve
    fi
done
