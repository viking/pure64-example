all: build/disk.vdi

build/disk.vdi: build/disk.img
	VBoxManage convertdd $< $@ --format VDI

build/disk.img: vendor/pure64/build/system.img
	mkdir -p build
	cp $^ $@

vendor/pure64/build/system.img: vendor/baremetal-os/build/kernel64.sys vendor/pure64/Makefile
	$(MAKE) -C vendor/pure64 NASM="nasm -g" IMAGESIZE=32 KERNELPATH=../../$< img

vendor/baremetal-os/build/kernel64.sys: vendor/baremetal-os/Makefile
	$(MAKE) -C vendor/baremetal-os NASM="nasm -g" FS=BMFS

clean:
	$(MAKE) -C vendor/baremetal-os clean
	$(MAKE) -C vendor/pure64 clean
	rm -fr build

.PHONY: all clean
