PRODUCT_BRAND ?= gummy

SUPERUSER_EMBEDDED := true
SUPERUSER_PACKAGE_PREFIX := com.android.settings.gummy.superuser

# Allow alternative overlay package with additional/alternative defaults, apps, scripts, etc...host user name dependant
HOST_CHECK := $(shell hostname)
ifeq ($(HOST_CHECK), cphelps76-HP-Pavilion-dv7)
    PRODUCT_PACKAGE_OVERLAYS += vendor/Gummy/overlay/inverted
    PRODUCT_PACKAGES += DSPManager
else
    PRODUCT_PACKAGE_OVERLAYS += vendor/Gummy/overlay/common
endif

ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
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
    ro.rommanager.developerid=gummynightly
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=gummy
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1 \
    dalvik.vm.dexopt-data-only=1

# Enable gesture typing
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so 

 # init.d support
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/Gummy/prebuilt/common/etc/init.d/01check:system/etc/init.d/01check \
    vendor/Gummy/prebuilt/common/etc/init.d/02zipalign:system/etc/init.d/02zipalign \
    vendor/Gummy/prebuilt/common/etc/init.d/03sysctl:system/etc/init.d/03sysctl \
    vendor/Gummy/prebuilt/common/etc/init.d/04firstboot:system/etc/init.d/04firstboot \
    vendor/Gummy/prebuilt/common/etc/init.d/05freemem:system/etc/init.d/05freemem \
    vendor/Gummy/prebuilt/common/etc/init.d/06removecache:system/etc/init.d/06removecache \
    vendor/Gummy/prebuilt/common/etc/init.d/07fixperms:system/etc/init.d/07fixperms \
    vendor/Gummy/prebuilt/common/etc/init.d/09cron:system/etc/init.d/09cron \
    vendor/Gummy/prebuilt/common/etc/init.d/10sdboost:system/etc/init.d/10sdboost \
    vendor/Gummy/prebuilt/common/etc/init.d/98tweaks:system/etc/init.d/98tweaks \
    vendor/Gummy/prebuilt/common/etc/helpers.sh:system/etc/helpers.sh \
    vendor/Gummy/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/Gummy/prebuilt/common/etc/init.d.cfg:system/etc/init.d.cfg

# Added xbin files
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/xbin/zip:system/xbin/zip \
    vendor/Gummy/prebuilt/common/xbin/zipalign:system/xbin/zipalign

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

# Gummy-specific init file
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/etc/init.local.rc:root/init.tg.rc

# Terminal Emulator
PRODUCT_COPY_FILES +=  \
    vendor/Gummy/prebuilt/gummy/app/Term.apk:data/app/Term.apk \
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

# T-Mobile theme engine
include vendor/Gummy/config/themes_common.mk

# Required Gummy packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    GummyUpdater \
    LatinIME \
    Superuser \
    su

# Optional Gummy packages
PRODUCT_PACKAGES += \
    Basic \
    libemoji \
    Apollo \
    LockClock \
    Trebuchet \
    GummyFileManager \
    MusicFX \
    Gummypapers \
    GummyStartupService

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools in Gummy
PRODUCT_PACKAGES += \
    libsepol \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
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

PRODUCT_VERSION_MAJOR = M2
PRODUCT_VERSION_MINOR = 2
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

TG_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +"%m-%d-%y")-$(TG_BUILDTYPE)-$(TG_BUILD)

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

PRODUCT_PROPERTY_OVERRIDES += \
  ro.tg.version=$(TG_VERSION) \
  ro.modversion=$(TG_VERSION) \
  ro.tg.release=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)
