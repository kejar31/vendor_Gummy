# Inherit common Gummy stuff
$(call inherit-product, vendor/Gummy/config/common.mk)

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Include Gummy audio files
include vendor/Gummy/config/tg_audio.mk

# Optional Gummy packages
PRODUCT_PACKAGES += \
    HoloSpiralWallpaper \
    MagicSmokeWallpapers \
    NoiseField \
    Galaxy4 \
    LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    PhaseBeam \
    SunBeam \
    WaterBeam \
    VideoEditor
