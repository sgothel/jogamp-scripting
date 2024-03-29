#! /bin/bash

plain_version=2.4.0
version=v${plain_version}
rootdir=/srv/www/jogamp.org/deployment
adir=archive/master/gluegen_952-joal_670-jogl_1519-jocl_1159
sdir=archive/rc
urlb=https://jogamp.org/deployment

logfile=`basename $0 .sh`.${version}.log

function deploy_it() {

ssh jogamp@jogamp.org "\
    cd /home/jogamp/builds ; \
    rm -rf jogamp-scripting ; \
    git clone file:///srv/scm/jogamp-scripting.git jogamp-scripting ; \
    cd jogamp-scripting ; \
    git status ; \
    ./jenkins-builds/promote-to-release.sh \
        $version \
        $rootdir \
        $adir $sdir $urlb ; \
"

scp jogamp@jogamp.org:$rootdir/$sdir/$version/sha512sum.txt .
gpg --output sha512sum.txt.sig --detach-sig sha512sum.txt
gpg --verify sha512sum.txt.sig sha512sum.txt && \
scp sha512sum.txt.sig jogamp@jogamp.org:$rootdir/$sdir/$version/

ssh jogamp@jogamp.org "\
    cd /home/jogamp/builds/jogamp-scripting/maven ; \
    ./make-all-jogamp.sh $rootdir/$sdir/$version/archive/jogamp-all-platforms.7z ${plain_version} ; \
"

}

deploy_it 2>&1 | tee ${logfile}
