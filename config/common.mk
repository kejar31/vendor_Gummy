PRODUCT_BRAND ?= gummy

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.gummy.superuser

-include vendor/cm-priv/keys.mk

# Allow alternative overlay package with additional/alternative defaults, apps, scripts, etc...host user name dependant
HOST_CHECK := $(shell hostname)
ifeq ($(HOST_CHECK), cphelps76-HP-Pavilion-dv7)
    PRODUCT_PACKAGE_OVERLAYS += vendor/Gummy/overlay/inverted
else
    PRODUCT_PACKAGE_OVERLAYS += vendor/Gummy/overlay/common
endif

# To deal with CM9 specifications
# TODO: remove once all devices have been switched
ifneq ($(TARGET_BOOTANIMATION_NAME),)
TARGET_SCREEN_DIMENSIONS := $(subst -, $(space), $(subst x, $(space), $(TARGET_BOOTANIMATION_NAME)))
ifeq ($(TARGET_SCREEN_WIDTH),)
TARGET_SCREEN_WIDTH := $(word 2, $(TARGET_SCREEN_DIMENSIONS))
endif
ifeq ($(TARGET_SCREEN_HEIGHT),)
TARGET_SCREEN_HEIGHT := $(word 3, $(TARGET_SCREEN_DIMENSIONS))
endif
endif

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# clear TARGET_BOOTANIMATION_NAME in case it was set for CM9 purposes
TARGET_BOOTANIMATION_NAME :=

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/Gummy/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_BOOTANIMATION := vendor/Gummy/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip
endif

ifdef TG_NIGHTLY
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmodnightly
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=cyanogenmod
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1 \
    dalvik.vm.dexopt-data-only=1

# Enable ADB authentication and root
ifneq ($(TARGET_BUILD_VARIANT),eng)
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.adb.secure=0 \
    ro.secure=0 \
    persist.sys.root_access=3 \
    persist.sys.usb.config=mtp
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/Gummy/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/Gummy/prebuilt/common/bin/50-tg.sh:system/addon.d/50-tg.sh \
    vendor/Gummy/prebuilt/common/bin/blacklist:system/addon.d/blacklist

# init.d support
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/Gummy/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Gummy-specific init file
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/etc/init.local.rc:root/init.tg.rc

# Compcache/Zram support
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/Gummy/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache

# Terminal Emulator
PRODUCT_COPY_FILES +=  \
    vendor/Gummy/prebuilt/gummy/app/Term.apk:system/app/Term.apk \
    vendor/Gummy/prebuilt/gummy/lib/libjackpal-androidterm4.so:system/lib/libjackpal-androidterm4.so

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/Gummy/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/Gummy/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is Gummy!
PRODUCT_COPY_FILES += \
    vendor/Gummy/config/permissions/com.cyanogenmod.android.xml:system/etc/permissions/com.cyanogenmod.android.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/etc/mkshrc:system/etc/mkshrc

# Required Gummy packages
PRODUCT_PACKAGES += \
    LatinIME \
    Superuser \
    su

# Optional Gummy packages
PRODUCT_PACKAGES += \
    SoundRecorder \
    Basic \
    Torch \
    Apollo \
    LockClock \
    Launcher3

# Custom Gummy packages
PRODUCT_PACKAGES += \
    MusicFX \
    Gummypapers    

PRODUCT_PACKAGES += \
    CellBroadcastReceiver

# Extra tools in Gummy
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    vim \
    nano \
    htop \
    powertop \
    lsof \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/Gummy/overlay/dictionaries

PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 1
PRODUCT_VERSION_MAINTENANCE = 0-RC0

# Set Gummy_BUILDTYPE
ifdef TG_NIGHTLY
    TG_BUILDTYPE := NIGHTLY
endif
ifdef TG_EXPERIMENTAL
    TG_BUILDTYPE := EXPERIMENTAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
endif
ifdef TG_RELEASE
    TG_BUILDTYPE := RELEASE
endif

ifdef TG_BUILDTYPE
    ifdef TG_EXTRAVERSION
        # Force build type to EXPERIMENTAL
        TG_BUILDTYPE := EXPERIMENTAL
    endif
else
    # If TG_BUILDTYPE is not defined, set to UNOFFICIAL
    TG_BUILDTYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
endif

TG_VERSION := "Gummy"-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +"%m-%d-%y")-$(TG_BUILDTYPE)

PRODUCT_PROPERTY_OVERRIDES += \
  ro.tg.version=$(TG_VERSION) \
  ro.modversion=$(TG_VERSION)

-include vendor/Gummy/sepolicy/sepolicy.mk
