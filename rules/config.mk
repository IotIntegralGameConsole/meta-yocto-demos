#! /usr/bin/make -f
# Author: Philippe Coval <philippe.coval@osg.samsung.com>
# ex: set tabstop=4 noexpandtab:

MACHINE?=qemux86
machine?=${MACHINE}

distro?=poky
distro_branch?=dizzy
branch?=distro/${distro}/${distro_branch}
repo_branch?=${branch}
init_name?=oe
image?=core-image-minimal
init_build_env?=${sources_dir}/${distro}/${init_name}-init-build-env

