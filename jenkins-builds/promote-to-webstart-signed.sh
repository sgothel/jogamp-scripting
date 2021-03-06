#! /bin/bash

##
#
# Will promote an aggregated/archived folder to a webstart folder.
#   - copy adir -> wsdir
#   - filters jnlp files (url and version)
#   - repack
#   - sign
#   - pack200
#
# promote-to-webstart-signed.sh <version> <adir> <wsdir> <url> <pkcs12-keystore> <storepass> <key_alias>
# eg.
#   promote-to-webstart-signed.sh v2.0-rc2 \
#                          /srv/www/deployment/b3 \
#                          /srv/www/deployment/webstart-b3 \
#                          http://lala.lu/webstart-b3 \
#                          secret.p12 \
#                          PassWord \
#                          key_alias
#
##

version=$1
shift

abuild=$1
shift

wsdir=$1
shift

url=$1
shift

keystore=$1
shift

storepass=$1
shift

signarg="$*"

if [ -z "$version" -o -z "$abuild" -o -z "$wsdir" -o -z "$url" -o -z "$keystore" -o -z "$storepass" ] ; then
    echo "usage $0 version abuilddir webstartdir url pkcs12-keystore storepass [signarg]"
    exit 1
fi

if [ ! -e $abuild ] ; then
    echo $abuild does not exist
    exit 1
fi

if [ -e $wsdir ] ; then
    echo $wsdir already exist
    exit 1
fi

if [ ! -e $keystore ] ; then
    echo $keystore does not exist
    exit 1
fi

sdir=`dirname $0`

thisdir=`pwd`

logfile=$thisdir/`basename $0 .sh`.log

. $sdir/../deployment/funcs_jnlp_relocate.sh
. $sdir/../deployment/funcs_jars_pack_sign.sh

function echo_info() {
    echo
    echo "Promotion webstart jars"
    echo
    echo "  $abuild -> $wsdir"
    echo "  $url"
    echo
    echo `date`
    echo
}

function promote-webstart-jars() {

#
# repack it .. so the signed jars can be pack200'ed
#
wsdir_jars_repack  $wsdir
wsdir_jars_repack  $wsdir/joal-demos
wsdir_jars_repack  $wsdir/jogl-demos
wsdir_jars_repack  $wsdir/jocl-demos


#
# sign it
#
wsdir_jars_sign    $wsdir $keystore $storepass $signarg
wsdir_jars_sign    $wsdir/joal-demos $keystore $storepass $signarg
wsdir_jars_sign    $wsdir/jogl-demos $keystore $storepass $signarg
wsdir_jars_sign    $wsdir/jocl-demos $keystore $storepass $signarg

#
# pack200
#
wsdir_jars_pack200 $wsdir
wsdir_jars_pack200 $wsdir/joal-demos
wsdir_jars_pack200 $wsdir/jogl-demos
wsdir_jars_pack200 $wsdir/jocl-demos

cp -av $logfile $wsdir

}

echo_info 2>&1 | tee $logfile

cp -a $abuild $wsdir 2>&1 | tee $logfile

copy_relocate_jnlps_base  $version $url $wsdir            2>&1 | tee $logfile
copy_relocate_jnlps_demos $version $url $wsdir joal-demos 2>&1 | tee $logfile
copy_relocate_jnlps_demos $version $url $wsdir jogl-demos 2>&1 | tee $logfile
copy_relocate_jnlps_demos $version $url $wsdir jocl-demos 2>&1 | tee $logfile

promote-webstart-jars 2>&1 | tee $logfile

