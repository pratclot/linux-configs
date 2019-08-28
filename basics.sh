#!/bin/sh

PACKAGE_MANAGER='brew'
PACKAGES='python ansible'

for PACKAGE in ${PACKAGES}; do
    ${PACKAGE_MANAGER} install ${PACKAGE}
done
