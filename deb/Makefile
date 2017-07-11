SHELL=/bin/bash

ifndef BUILD_NAME
$(error BUILD_NAME is not defined.)
endif

name=$(BUILD_NAME)

tag=develop

ifdef BUILD_TAG
tag=$(BUILD_TAG)
endif

ifndef BUILD_REPO
$(error BUILD_REPO is not defined.)
endif

git=$(BUILD_REPO)

source_dir=sources
debbuild_dir=$(shell pwd)/debbuild

pkg_dir=pkg

ifndef PKG_REPO
$(error PKG_REPO is not defined.)
endif

pkg_git=$(PKG_REPO)
pkg_tag=develop

ifdef PKG_TAG
pkg_tag=$(PKG_TAG)
endif

pkg_packages_dir=/packages/$(BUILD_PLATFORM)

ifdef PKG_PACKAGES_DIR
pkg_packages_dir=$(PKG_PACKAGES_DIR)
endif

stage_dir=/stage-area/$(BUILD_PLATFORM)

ifdef PKG_STAGE_DIR
stage_dir=$(PKG_STAGE_DIR)
endif

spec=$(pkg_dir)/$(name)/rpm/$(name).spec

ifdef PKG_SPEC_FILE
spec=$(pkg_dir)/$(PKG_SPEC_FILE)
endif

prebuild_script=$(pkg_dir)/$(name)/rpm/pre-build.sh

ifdef PKG_PREBUILD_SCRIPT
prebuild_script=$(pkg_dir)/$(PKG_PREBUILD_SCRIPT)
endif

tarball_name=$(name).tar
tarball_prefix=$(name)

ifdef TARBALL_VERSION_REQUIRED
ifndef TARBALL_VERSION
$(error TARBALL_VERSION is required for this build.)
endif
endif

ifdef TARBALL_VERSION
tarball_name=$(name)-$(TARBALL_VERSION).tar
tarball_prefix=$(name)-$(TARBALL_VERSION)
endif

ifdef BUILD_NUMBER
deb_revision=0~build$(BUILD_NUMBER)
endif

ifndef BUILD_NUMBER
deb_revision=1
endif

.PHONY: clean deb

all: deb

print-info:
	@echo "Packaging $(name) fetched from $(git) for tag $(tag)"

fetch-packaging:
	@mkdir -p $(pkg_dir)
	git clone $(pkg_git) $(pkg_dir)/$(name)
	cd $(pkg_dir)/$(name) && git checkout $(pkg_tag)

fetch-sources: print-info
	@mkdir -p $(source_dir)/$(name)
	git clone $(git) $(source_dir)/$(name)
	cd $(source_dir)/$(name) && git checkout $(tag)
	cd $(source_dir)/$(name) && git archive --format=tar --prefix=$(tarball_prefix)/ $(tag) > $(tarball_name)

prepare-sources: fetch-sources
	cd $(source_dir) && gzip $(name)/$(tarball_name)
	mv $(source_dir)/$(name)/$(tarball_name).gz $(source_dir)/$(tarball_name).gz

setup-stage-area:
	sudo -E bash -c '/bin/bash -ex setup-stage-area.sh'

prepare-spec: fetch-packaging prepare-sources

prepare-deb: prepare-spec
	mkdir -p  $(debbuild_dir)/DEBS \
		$(debbuild_dir)/SDEBS \
		$(debbuild_dir)/SOURCES
	cp $(source_dir)/$(tarball_name).gz $(debbuild_dir)/SOURCES/$(tarball_name).gz
	cp -r $(pkg_dir)/$(name)/deb/$(name)/debian $(debbuild_dir)/
	sed -e 's#@@DEB_REVISION@@#$(deb_revision)#g' $(debbuild_dir)/debian/changelog.in > $(debbuild_dir)/debian/changelog

build-deb: prepare-deb
	cd $(debbuild_dir) && \
	find | sort && \
	dpkg-buildpackage -us -uc

export-deb: build-deb
	mkdir -p $(pkg_packages_dir)
	cp -v $(HOME)/*.deb $(pkg_packages_dir)

stage-deb: export-deb
ifdef PKG_STAGE_DEBS
	mkdir -p $(stage_dir)
	find $(pkg_packages_dir)/ -name $(BUILD_NAME)_*.deb -exec cp -v {} $(stage_dir) \;
	dpkg-scanpackages -m $(stage_dir) | gzip --fast > $(stage_dir)/Packages.gz
else
	echo "PKG_STAGE_DEBS not defined, do nothing..."
endif

deb: stage-deb

clean:
	rm -rf $(source_dir) $(debbuild_dir) $(pkg_dir)
