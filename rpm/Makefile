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
rpmbuild_dir=$(shell pwd)/rpmbuild

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


.PHONY: clean rpm print-info

all: rpm

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

prepare-sources.local:

prepare-sources: fetch-sources prepare-sources.local
	cd $(source_dir) && gzip $(name)/$(tarball_name)
	mv $(source_dir)/$(name)/$(tarball_name).gz $(source_dir)/$(tarball_name).gz

prepare-spec.local:

prepare-spec: fetch-packaging prepare-sources prepare-spec.local

prepare-rpm: prepare-spec
	mkdir -p  $(rpmbuild_dir)/BUILD \
		$(rpmbuild_dir)/RPMS \
		$(rpmbuild_dir)/SOURCES \
		$(rpmbuild_dir)/SPECS \
		$(rpmbuild_dir)/SRPMS
	cp $(source_dir)/$(tarball_name).gz $(rpmbuild_dir)/SOURCES/$(tarball_name).gz

build-rpm: prepare-rpm
	if [ -r "$(prebuild_script)" ]; then echo "Running prebuild script" && sh $(prebuild_script); fi
ifndef BUILD_NUMBER
	rpmbuild --nodeps -v -ba $(spec) --define "_topdir $(rpmbuild_dir)"
else
	rpmbuild --nodeps -v -ba $(spec) --define "_topdir $(rpmbuild_dir)" --define "build_number $(BUILD_NUMBER)"
endif

export-rpm: build-rpm
	mkdir -p $(pkg_packages_dir)
	cp -r $(rpmbuild_dir)/RPMS $(pkg_packages_dir)
	cp -r $(rpmbuild_dir)/SRPMS $(pkg_packages_dir)

stage-rpm: export-rpm
ifdef PKG_STAGE_RPMS
	mkdir -p $(stage_dir)
	find $(pkg_packages_dir)/RPMS -name $(BUILD_NAME)-*.rpm -exec cp {} $(stage_dir) \;
	createrepo ${stage_dir}
else
	echo "PKG_STAGE_RPMS not defined, do nothing..."
endif

rpm: stage-rpm

clean:
	rm -rf $(source_dir) $(rpmbuild_dir) $(pkg_dir)
