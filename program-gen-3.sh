#!/usr/bin/bash

# Kernel Details
VER="-1.0 this is your version"

# Vars
BASE_AK_VER="your name"
AK_VER="$BASE_AK_VER$VER"
export LOCALVERSION=~`echo $AK_VER`
export ARCH=arm64
export SUBARCH=arm64
export CONFIG=sprd_sharkl5Pro_defconfig
export PATH=root/toolchains/clang-18/bin:$PATH

echo "#"
echo "# Menuconfig"
echo "#"

make O=out $CONFIG;
make O=out CC=clang AS=llvm-as NM=llvm-nm STRIP=llvm-strip OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump READELF=llvm-readelf HOSTAS=llvm-as CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi- menuconfig
cp -rf out/.config arch/arm64/configs/$CONFIG;

echo "#"
echo "# Compile Kernel"
echo "#"
make O=out CC=clang $CONFIG;
time make -j$(nproc --all) O=out CC=clang AS=llvm-as NM=llvm-nm STRIP=llvm-strip OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump READELF=llvm-readelf HOSTAS=llvm-as CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
echo -e "\033[1;36mPress enter to continue \e[0m"
read a1

# Make a dtb file
cd out/arch/arm64/boot/
find dts/vendor/qcom -name '*.dtb' -exec cat {} + > dtb
ls -a

echo "#"
echo "# Zipping into a flashable zip!"
echo "#"
cp out/arch/arm64/boot/Image.gz ~/AnyKernel3/
cp out/arch/arm64/boot/dtb ~/AnyKernel3/
cd ~/Anykernel3
zip -r9 your-kernel-name.zip *
cp your-kernel-name.zip ../$HOME
echo -e "\033[1;36mPress enter to continue \e[0m"
read a1

exit 0
