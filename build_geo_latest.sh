#!/bin/bash

# usage: build_apptainer_image.sh [full file path]
# where full file path ends with .sif, with full directory path to save the image
# after the image is built, group write/execution privileges are given
apptainer build --fakeroot beethoven_001.sif rocker_beethoven.def
