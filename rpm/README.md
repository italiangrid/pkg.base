# Base packaging tools

This repo provides a set of docker images used to create RPM packages for the
middleware components developed at INFN CNAF.

The tools are composed by a set of base docker images and a Makefile that 
drives the packaging process.

## Docker images

There's a docker image for each supported build and packaging platform.
The docker images build upon the following base docker images:

- centos:centos5
- centos:centos6
- centos:centos7
- quay.io/centos/centos:stream9
- fedora:rawhide

### Building the images

Images are built and tagged with the `build-images.sh` script:

```bash
sh build-images.sh
```

To build only a single tag, use the `tags` bash variable:

```bash
tags=centos7 sh build-images.sh
```

The command above will build only the centos7 image.

The build process produces the following images:

- italiangrid/pkg.base:centos5
- italiangrid/pkg.base:centos6
- italiangrid/pkg.base:centos7
- italiangrid/pkg.base:centos9
- italiangrid/pkg.base:rawhide

### Pushing the images to a local registry

Images can be pushed to a local registry with the `push-images.sh` script,
which requires that the `DOCKER_REGISTRY_HOST` environment variable is set to
the endpoint of a local docker registry.

## How the packaging works

The Makefile drives the packaging process.

It fetches code from two repositories:
- the repository holding the code that will be packaged (i.e. the actual
  service or library)
- the repository holding the packaging code (i.e., the spec file & other
  packaging configuration)

and then runs rpmbuild over the downloaded spec file.

The Makefile behaviour is configured by the following environment variables:

### `BUILD_NAME`

The name of the component being packaged.

### `BUILD_TAG`

The tag or branch of the component being packaged.

### `BUILD_REPO`

The repo which holds the code for the component being packaged.

### `PKG_REPO`

The repo which holds the packaging code for the component being packaged.

### `PKG_TAG`

The tag or branch of the packaging code to be used for the packaging.

### `PKG_SPEC_FILE`

The path to the spec file for the component being packaged.

### `PKG_STAGE_RPMS`

This flag tells the packager to install the built packages in the stage area.

## Generated packages

The container puts the generated packages in the /packages directory, inside
the container. This path is configured as a volume, so it can be linked to a
local directory or imported from a data container.

## The stage area

The container can also access a stage area, where packages generated during the
build are made available to other builds.
The stage area is in the /stage-area, which is also configured as a volume.
In order to stage the packages produced during a build, set the `PKG_STAGE_RPMS`
environment variable.

## Prebuild steps

To perform local build pre configuration (e.g., to install packages built in a
previous related build and staged in the stage area), a build configuration can
provide a pre-build script, that is run before the build by the Makefile before
running the build.

By default the Makefile looks for a script name `pre-build.sh` in the same
directory where the spec file lives. A custom path for the pre-build script can be
set with the `PKG_PREBUILD_SCRIPT`.

## Examples

- [Argus integrated packaging](https://github.com/argus-authz/pkg.argus)
