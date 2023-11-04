###
# FILE:  
#   pckgz.sh (14-Jul-2008)
#
# USE:
#   Manage debian repository structure
#
# COMMENTS:
#   - Need "apache2" of "ftpd" to publish the repository.
#
#   - To use the repo include this lines in "/etc/apt/sources.list":
#       # For binaries i386
#       deb http://server/debian etch main contrib non-free
#
#       # For sources
#       deb-src http://server/debian etch main contrib-free
#
#   - Remember to make an "apt-get update".
#
#   - Files in the pool/ directory are not corrupted.
#
#   - You downloaded packages of the main, contrib, non-free component 
#     from debian.org (or other site) with apt-mirror or copy them to 
#     the hard disk with "cp -R $CDROM/pool $MIRROR/pool" and repeated
#     the operation for each CD (or DVD).
#   
#   - If is is not true, the last item, then you use apt-mirror o debmirror
#     to populate the pool/ directory directly from a debian mirror on Internet.
# 
#   - You are not interested in special directories such as: docs/, tools/
#     projects/, debian-installer/, ..., If yes, then use anonftpsync script
#     available in http://www.debian.org/mirror/ in the section focused to
#     explain how to create a debian mirror.
#
#
# AUTHOR: 
#   Olaf Reitmaier <olafrv@gmail.com>
#
# SOURCE:
#   http://olafrv.googlepages.com/packgz.sh
#
# LICENSE: 
#   GNU/GPL v2 or later (www.fsf.org)
##

# Redirect output and error streams
rm packgz.log
exec 2>packgz.log

# Global script vars
MIRROR=/var/www/debian
CDROM=/media/cdrom
NAME=debian
CODENAME=etch
VERSION=4.0
ARCHIVE=stable

###
# Package list file creation function
##
function create_dir
{
	echo "create_dir $1 $2"

	ARCHITECTURE=$1
	COMPONENT=$2

	cd $MIRROR	

	if [ "$ARCHITECTURE" == "source" ]
	then
		DIR="${MIRROR}/dists/${CODENAME}/${COMPONENT}/source"
	else
		DIR="${MIRROR}/dists/${CODENAME}/${COMPONENT}/binary-${ARCHITECTURE}"
	fi

	mkdir -p $DIR
	mkdir -p $MIRROR/pool/$COMPONENT
}

create_dir i386 main
create_dir i386 contrib
create_dir i386 non-free

# Mirror's links for all archives types
ln -s $CODENAME $MIRROR/dists/stable
ln -s $CODENAME $MIRROR/dists/unstable
ln -s $CODENAME $MIRROR/dists/frozen
ln -s $CODENAME $MIRROR/dists/testing

###
# Package list file creation function
##
function create_package_list
{
	echo "create_package_list $1 $2"

	ARCHITECTURE=$1
	COMPONENT=$2

	cd $MIRROR	

	if [ "$ARCHITECTURE" == "source" ]
	then
		FILE="${MIRROR}/dists/etch/${COMPONENT}/source/Sources"
		dpkg-scansources pool/$COMPONENT /dev/null > $FILE
	else
		FILE="${MIRROR}/dists/etch/${COMPONENT}/binary-${ARCHITECTURE}/Packages"
		dpkg-scanpackages -m pool/$COMPONENT /dev/null > $FILE
	fi
	cat $FILE | gzip -9c > "${FILE}.gz"
	cat $FILE | bzip2 -9c > "${FILE}.bz2" 
}

# Packages.gz files creation

create_package_list i386 main
create_package_list i386 contrib
create_package_list i386 non-free

# Sources.gz files 

create_package_list source main
create_package_list source contrib
create_package_list source non-free

###
# Release file creation function
##
function create_release
{
	echo "create_release $1 $2 $3"

	TYPE=$1
	if [ "$TYPE" == "root" ]
	then
		ARCHITECTURES=$2
		COMPONENTS=$3
		RELEASE="${MIRROR}/dists/${CODENAME}/Release"
		echo "Origin: DEM/TSJ" > $RELEASE
		echo "Label: $NAME" >> $RELEASE
		echo "Archive: $ARCHIVE" >> $RELEASE
		echo "Architectures: $ARCHITECTURES" >> $RELEASE
		echo "Codename: $CODENAME" >> $RELEASE
		echo "Version: $VERSION" >> $RELEASE
		echo "Components: $COMPONENTS" >> $RELEASE
		echo "MD5Sum:" >> $RELEASE

		cd $MIRROR
		find dists/etch -name *.gz | xargs md5sum | awk '{print $1}' > md5.list
		find dists/etch -name *.gz | xargs du -b | awk '{print $1}' > du.list
		find dists/etch -name *.gz | xargs ls | awk '{print $1}' > ls.list
		paste --delimiter="\ " md5.list du.list ls.list >> $RELEASE
		rm md5.list du.list ls.list
	else
		ARCHITECTURE=$2
		COMPONENT=$3
		if [ "$ARCHITECTURE" -eq "source" ]
		then
			RELEASE="${MIRROR}/dists/${CODENAME}/${COMPONENT}/source/Release"
		else
			RELEASE="${MIRROR}/dists/${CODENAME}/${COMPONENT}/binary-${ARCHITECTURE}/Release"
		fi
		echo "Origin: DEM/TSJ" > $RELEASE
		echo "Label: $NAME" >> $RELEASE
		echo "Archive: $ARCHIVE" >> $RELEASE
		echo "Architecture: $ARCHITECTURE" >> $RELEASE
		echo "Codename: $CODENAME" >> $RELEASE
		echo "Version: $VERSION" >> $RELEASE
		echo "Component: $COMPONENT" >> $RELEASE

	fi
}

# Release files creation
create_release root "i386 source" "main contrib non-free"
create_release root i386 main
create_release root i386 contrib
create_release root i386 non-free
create_release root source main
create_release root source contrib
create_release root source non-free

