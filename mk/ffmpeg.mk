

# NOTE: This file is generated by m4! Make sure you're editing the .m4 version,
# not the generated version!

FFMPEG_VERSION=5.1.2

FFMPEG_CONFIG=--prefix=/opt/ffmpeg \
	--target-os=linux \
	--cc=emcc --ranlib=emranlib \
	--disable-doc \
	--disable-stripping \
	--disable-programs \
	--disable-ffplay --disable-ffprobe --disable-network --disable-iconv --disable-xlib \
	--disable-sdl2 \
	--disable-everything


build/ffmpeg-$(FFMPEG_VERSION)/build-%/libavformat/libavformat.a: \
	build/ffmpeg-$(FFMPEG_VERSION)/build-%/ffbuild/config.mak
	cd build/ffmpeg-$(FFMPEG_VERSION)/build-$* ; $(MAKE)

# General build rule for any target
# Use: buildrule(target name, configure flags, CFLAGS)


# Base (asm.js and wasm)

build/ffmpeg-$(FFMPEG_VERSION)/build-base-%/ffbuild/config.mak: build/inst/base/cflags.txt \
	build/ffmpeg-$(FFMPEG_VERSION)/PATCHED configs/%/ffmpeg-config.txt
	test ! -e configs/$(*)/deps.txt || $(MAKE) `sed 's/@TARGET/base/g' configs/$(*)/deps.txt`
	mkdir -p build/ffmpeg-$(FFMPEG_VERSION)/build-base-$(*) ; \
	cd build/ffmpeg-$(FFMPEG_VERSION)/build-base-$(*) ; \
	emconfigure env PKG_CONFIG_PATH="$(PWD)/build/inst/base/lib/pkgconfig" \
		../configure $(FFMPEG_CONFIG) \
		--disable-pthreads --arch=emscripten \
		--extra-cflags="-I$(PWD)/build/inst/base/include " \
		--extra-ldflags="-L$(PWD)/build/inst/base/lib " \
		`cat ../../../configs/$(*)/ffmpeg-config.txt`
	touch $(@)

# wasm + threads

build/ffmpeg-$(FFMPEG_VERSION)/build-thr-%/ffbuild/config.mak: build/inst/thr/cflags.txt \
	build/ffmpeg-$(FFMPEG_VERSION)/PATCHED configs/%/ffmpeg-config.txt
	test ! -e configs/$(*)/deps.txt || $(MAKE) `sed 's/@TARGET/thr/g' configs/$(*)/deps.txt`
	mkdir -p build/ffmpeg-$(FFMPEG_VERSION)/build-thr-$(*) ; \
	cd build/ffmpeg-$(FFMPEG_VERSION)/build-thr-$(*) ; \
	emconfigure env PKG_CONFIG_PATH="$(PWD)/build/inst/thr/lib/pkgconfig" \
		../configure $(FFMPEG_CONFIG) \
		--arch=emscripten --enable-cross-compile \
		--extra-cflags="-I$(PWD)/build/inst/thr/include -pthread" \
		--extra-ldflags="-L$(PWD)/build/inst/thr/lib -pthread" \
		`cat ../../../configs/$(*)/ffmpeg-config.txt`
	touch $(@)

# wasm + simd

build/ffmpeg-$(FFMPEG_VERSION)/build-simd-%/ffbuild/config.mak: build/inst/simd/cflags.txt \
	build/ffmpeg-$(FFMPEG_VERSION)/PATCHED configs/%/ffmpeg-config.txt
	test ! -e configs/$(*)/deps.txt || $(MAKE) `sed 's/@TARGET/simd/g' configs/$(*)/deps.txt`
	mkdir -p build/ffmpeg-$(FFMPEG_VERSION)/build-simd-$(*) ; \
	cd build/ffmpeg-$(FFMPEG_VERSION)/build-simd-$(*) ; \
	emconfigure env PKG_CONFIG_PATH="$(PWD)/build/inst/simd/lib/pkgconfig" \
		../configure $(FFMPEG_CONFIG) \
		--disable-pthreads --arch=x86 --disable-inline-asm --disable-x86asm \
		--extra-cflags="-I$(PWD)/build/inst/simd/include -msimd128" \
		--extra-ldflags="-L$(PWD)/build/inst/simd/lib -msimd128" \
		`cat ../../../configs/$(*)/ffmpeg-config.txt`
	touch $(@)

# wasm + threads + simd

build/ffmpeg-$(FFMPEG_VERSION)/build-thrsimd-%/ffbuild/config.mak: build/inst/thrsimd/cflags.txt \
	build/ffmpeg-$(FFMPEG_VERSION)/PATCHED configs/%/ffmpeg-config.txt
	test ! -e configs/$(*)/deps.txt || $(MAKE) `sed 's/@TARGET/thrsimd/g' configs/$(*)/deps.txt`
	mkdir -p build/ffmpeg-$(FFMPEG_VERSION)/build-thrsimd-$(*) ; \
	cd build/ffmpeg-$(FFMPEG_VERSION)/build-thrsimd-$(*) ; \
	emconfigure env PKG_CONFIG_PATH="$(PWD)/build/inst/thrsimd/lib/pkgconfig" \
		../configure $(FFMPEG_CONFIG) \
		--arch=x86 --disable-inline-asm --disable-x86asm --enable-cross-compile \
		--extra-cflags="-I$(PWD)/build/inst/thrsimd/include -pthread -msimd128" \
		--extra-ldflags="-L$(PWD)/build/inst/thrsimd/lib -pthread -msimd128" \
		`cat ../../../configs/$(*)/ffmpeg-config.txt`
	touch $(@)


extract: build/ffmpeg-$(FFMPEG_VERSION)/PATCHED

build/ffmpeg-$(FFMPEG_VERSION)/PATCHED: build/ffmpeg-$(FFMPEG_VERSION)/configure
	cd build/ffmpeg-$(FFMPEG_VERSION) ; ( test -e PATCHED || patch -p1 -i ../../patches/ffmpeg.diff )
	touch $@

build/ffmpeg-$(FFMPEG_VERSION)/configure: build/ffmpeg-$(FFMPEG_VERSION).tar.xz
	cd build ; tar Jxf ffmpeg-$(FFMPEG_VERSION).tar.xz
	touch $@

build/ffmpeg-$(FFMPEG_VERSION).tar.xz:
	mkdir -p build
	curl https://ffmpeg.org/releases/ffmpeg-$(FFMPEG_VERSION).tar.xz -o $@

ffmpeg-release:
	cp build/ffmpeg-$(FFMPEG_VERSION).tar.xz libav.js-$(LIBAVJS_VERSION)/sources/

.PRECIOUS: \
	build/ffmpeg-$(FFMPEG_VERSION)/build-base-%/libavformat/libavformat.a \
	build/ffmpeg-$(FFMPEG_VERSION)/build-base-%/ffbuild/config.mak \
	build/ffmpeg-$(FFMPEG_VERSION)/build-thr-%/libavformat/libavformat.a \
	build/ffmpeg-$(FFMPEG_VERSION)/build-thr-%/ffbuild/config.mak \
	build/ffmpeg-$(FFMPEG_VERSION)/build-simd-%/libavformat/libavformat.a \
	build/ffmpeg-$(FFMPEG_VERSION)/build-simd-%/ffbuild/config.mak \
	build/ffmpeg-$(FFMPEG_VERSION)/build-thrsimd-%/libavformat/libavformat.a \
	build/ffmpeg-$(FFMPEG_VERSION)/build-thrsimd-%/ffbuild/config.mak \
	build/ffmpeg-$(FFMPEG_VERSION)/PATCHED \
	build/ffmpeg-$(FFMPEG_VERSION)/configure
