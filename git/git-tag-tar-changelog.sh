#! /bin/bash

artifacts=$1
shift

if [ -z "$artifacts" ] ; then
    echo Usage $0 artifacts file
    exit 1
fi

branch=rc
tag_old=v2.0-rc4
tag=v2.0-rc5

sdir=`dirname $0`
thisdir=`pwd`

. $sdir/funcs_git.sh

for i in gluegen joal joal-demos jogl jogl-demos jocl jocl-demos ; do
    sha=`grep $i.build.commit $artifacts | awk --field-separator "=" ' { print $2 } ' `
    echo $i sha $sha
    cd $i
    git checkout $branch
    git pull jogamp $branch
    git tag -s -u 0x8ED60127 -m "$tag" $tag $sha
    git-new-milestone $i $tag_old $tag
    cd $thisdir
    echo done $i
    echo
done
