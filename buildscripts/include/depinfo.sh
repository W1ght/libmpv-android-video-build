#!/bin/bash -e

## Dependency versions

v_sdk=9123335_latest
v_ndk=25.2.9519653
v_sdk_build_tools=33.0.2

v_libass=0.17.1
v_harfbuzz=7.2.0
v_fribidi=1.0.12
v_freetype=2-13-0
v_mbedtls=3.4.0
v_dav1d=1.2.0
v_libxml2=2.10.3
# HIBIKI FORK: 6.0 (2023-02) is off the maintenance branches and receives no
# security backports. 6.1.6 is the tip of the 6.1 LTS branch and carries the
# fixes Hibiki needs: magicyuv slice_height/median (the OOB-write RCE that a
# crafted mkv/mov/avi can reach), vp9 dimension rollback/realloc, mov CENC
# 64-bit subsample bounds, mpegts descriptor accounting, plus a large batch of
# matroskadec bounds checks. Staying inside 6.x keeps the FFmpeg API stable, so
# mpv is untouched; both ffmpeg patches below still apply cleanly (verified with
# patch --dry-run against the n6.1.6 tree).
v_ffmpeg=6.1.6
v_mpv=78d43740f52db817d98bcf24fb30a76ab6fa13ff
v_libogg=1.3.5
v_libvorbis=1.3.7
v_libvpx=1.13


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_dav1d=()
dep_libvorbis=(libogg)
if [ -n "${ENCODERS_GPL+x}" ]; then
	dep_ffmpeg=(mbedtls dav1d libxml2 libvorbis libvpx libx264)
else
	dep_ffmpeg=(mbedtls dav1d libxml2)
fi
dep_freetype2=()
dep_fribidi=()
dep_harfbuzz=()
dep_libass=(freetype fribidi harfbuzz)
dep_lua=()
dep_shaderc=()
if [ -n "${ENCODERS_GPL+x}" ]; then
	dep_mpv=(ffmpeg libass fftools_ffi)
else
	dep_mpv=(ffmpeg libass)
fi
