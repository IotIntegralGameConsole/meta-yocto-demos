
rule/overide/clean-packages: \
 rule/bitbake/cleanall/bluetooth-tools \
 rule/bitbake/cleanall/config-image \
 rule/bitbake/cleanall/desktop-skin \
 rule/bitbake/cleanall/gumd \
 rule/bitbake/cleanall/initramfs-live-boot \
 rule/bitbake/cleanall/initramfs-live-install \
 rule/bitbake/cleanall/initramfs-live-install-efi \
 rule/bitbake/cleanall/pam \
 rule/bitbake/cleanall/rpcbind \
 rule/bitbake/cleanall/rpm \
 rule/bitbake/cleanall/samba \
 rule/bitbake/cleanall/systemd-serialgetty \
 rule/bitbake/cleanall/tizen-platform-config \
 rule/bitbake/cleanall/tizen-platform-wrapper \
 rule/bitbake/cleanall/tlm \
 rule/bitbake/cleanall/udev-extraconf \
 rule/bitbake/cleanall/weston \
 rule/bitbake/cleanall/weston-init \
 rule/bitbake/cleanall/wpa-supplicant \
 #eol

rule/wip/rebuild: rule/wip/cleanall \
 rule/bitbake/tlm

rule/wip: \
 rule/bitbake/cleanall/cairo rule/bitbake/build/cairo \
 rule/bitbake/cleanall/harfbuzz rule/bitbake/build/harfbuzz \
 rule/bitbake/cleanall/config-image rule/bitbake/build/config-image

rule/wip/help:
	make rule/bitbake/args ARGS="-e" | grep BBPATH

rule/reset:
	make GNUmakefile

rules/include/machine/%.mk:
	$(error please create $@)

rules/config/bsp/${bsp}/default.xml:
	$(error please create $@)


rule/setup-bsp: rules/config/bsp/${bsp}/default.xml
	cp -av $< ${<F}

rule/setup-machine/%: rules/config/machine/%/config.mk
	echo "MACHINE?=${@F}" > rules/09-local-config.mk
	echo 'include $<' >> rules/09-local-config.mk
	${MAKE} rule/cleanall rule/setup-bsp rule/reset

local/todo:
	cd  sources/meta-raspberrypi/ && \
	git cherry-pick 54c5451a04a2b6601ca729038780d4e4eb69437e

	cd  sources/meta-raspberrypi/ && \
	git cherry-pick	1949a0d5ba134036a590a41fd414f3bdd7ecee9e

rule/wip/patch: rule/overide/patch/meta-raspberrypi
	mv sources/tizen-distro/meta-tizen sources/tizen-distro/meta-tizen.orig
	ln -fs \
 /home/philippe/var/cache/url/git/ssh/review.tizen.org/scm/bb/meta-tizen/src/meta-tizen \
 sources/tizen-distro/meta-tizen

machines_list?=$(shell ls rules/config/machine/ | sed -e 's|.mk||g' | grep -v '~' | sort) 

rule/overide/help: rule/help
	@echo "# Machines: ${machines_list}"
	@echo ""

rule/machines:
	for MACHINE in ${machines_list} ; do make rule/setup-machine/$${MACHINE} ; make rule/image ; make rule/images ; done

