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
pgk_tag=$(PKG_TAG)
endif

pkg_stage_dir=/packages/$(BUILD_PLATFORM)

ifdef PKG_STAGE_DIR
pkg_stage_dir=$(PKG_STAGE_DIR)
endif

spec=$(pkg_dir)/$(name)/rpm/$(name).spec

ifdef PKG_SPEC_FILE
spec=$(PKG_SPEC_FILE)
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
	cd $(source_dir)/$(name) && git archive --format=tar --prefix=$(name)/ $(tag) > $(name).tar

prepare-sources.local:

prepare-sources: fetch-sources prepare-sources.local
	cd $(source_dir) && gzip $(name)/$(name).tar
	mv $(source_dir)/$(name)/$(name).tar.gz $(source_dir)/$(name).tar.gz

prepare-spec.local:

prepare-spec: fetch-packaging prepare-sources prepare-spec.local

prepare-rpm: prepare-spec
	mkdir -p  $(rpmbuild_dir)/BUILD \
		$(rpmbuild_dir)/RPMS \
		$(rpmbuild_dir)/SOURCES \
		$(rpmbuild_dir)/SPECS \
		$(rpmbuild_dir)/SRPMS
	cp $(source_dir)/$(name).tar.gz $(rpmbuild_dir)/SOURCES/$(name).tar.gz

build-rpm: prepare-rpm
ifndef BUILD_NUMBER
	rpmbuild --nodeps -v -ba $(spec) --define "_topdir $(rpmbuild_dir)"
else
	rpmbuild --nodeps -v -ba $(spec) --define "_topdir $(rpmbuild_dir)" --define "build_number $(BUILD_NUMBER)"
endif

stage-rpm: build-rpm
	mkdir -p $(pkg_stage_dir)
	cp -r $(rpmbuild_dir)/RPMS $(pkg_stage_dir)
	cp -r $(rpmbuild_dir)/SRPMS $(pkg_stage_dir)

rpm: stage-rpm

clean:
	rm -rf $(source_dir) $(rpmbuild_dir) $(pkg_dir)
