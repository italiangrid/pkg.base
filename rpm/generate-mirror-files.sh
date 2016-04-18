#!/bin/bash

CENTOS5_RELEASE=5
CENTOS6_RELEASE=6
CENTOS7_RELEASE=7.2.1511

## CENTOS 5
for i in os updates extras centosplus contrib fasttrack; do sed -e "s/##REL##/${CENTOS5_RELEASE}/" -e "s/##REPO##/$i/" centos-mirror.template > centos5/$i.local.mirror; done
sed -e "s/##REL##/5/" epel-mirror.template > centos5/epel.local.mirror

## CENTOS 6
for i in os updates extras centosplus contrib fasttrack; do sed -e "s/##REL##/${CENTOS6_RELEASE}/" -e "s/##REPO##/$i/" centos-mirror.template > centos6/$i.local.mirror; done
sed -e "s/##REL##/6/" epel-mirror.template > centos6/epel.local.mirror

## CENTOS 7
for i in os updates extras centosplus contrib fasttrack; do sed -e "s/##REL##/${CENTOS7_RELEASE}/" -e "s/##REPO##/$i/" centos-mirror.template > centos7/$i.local.mirror; done
sed -e "s/##REL##/7/" epel-mirror.template > centos7/epel.local.mirror
