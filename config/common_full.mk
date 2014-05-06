# Inherit common Gummy stuff
$(call inherit-product, vendor/Gummy/config/common.mk)

# Bring in all video files
$(call inherit-product, frameworks/base/data/videos/VideoPackage2.mk)

# Include Gummy audio files
include vendor/Gummy/config/tg_audio.mk

# Include Gummy LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/Gummy/overlay/dictionaries

# Optional Gummy packages
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    SunBeam \
    WaterBeam \
    VisualizationWallpapers \
    PhotoTable \
    VoiceDialer \
    SoundRecorder

PRODUCT_PACKAGES += \
    VideoEditor \
    libvideoeditor_jni \
    libvideoeditor_core \
    libvideoeditor_osal \
    libvideoeditor_videofilters \
    libvideoeditorplayer

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libstagefright_soft_ffmpegadec.so \
    libstagefright_soft_ffmpegvdec.so \
    libFFmpegExtractor.so \
    libnamparser.so

# Extra tools in CM
PRODUCT_PACKAGES += \
    vim
