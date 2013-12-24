# Inherit common CM stuff
$(call inherit-product, vendor/Gummy/config/common.mk)

# Include CM audio files
include vendor/Gummy/config/tg_audio.mk

# Default ringtone
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Orion.ogg \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/Gummy/prebuilt/common/bootanimation/320.zip:system/media/bootanimation.zip
endif
# World APN list
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# World SPN overrides list
PRODUCT_COPY_FILES += \
    vendor/Gummy/prebuilt/common/etc/spn-conf.xml:system/etc/spn-conf.xml

# SIM Toolkit
PRODUCT_PACKAGES += \
    Stk

