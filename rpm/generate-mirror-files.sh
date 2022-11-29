#!/bin/bash

CENTOS7_RELEASE=7

## CENTOS 7
for i in os updates extras centosplus contrib fasttrack; do sed -e "s/##REL##/${CENTOS7_RELEASE}/" -e "s/##REPO##/$i/" centos-mirror.template > centos7/$i.local.mirror; done
sed -e "s/##REL##/7/" epel-mirror.template > centos7/epel.local.mirror
