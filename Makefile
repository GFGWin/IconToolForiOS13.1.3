INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:latest:8.0
THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
ARCHS = arm64
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = icontool

icontool_FILES = Tweak.x 
icontool_FRAMEWORKS = UIKit
icontool_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "killall -9 SpringBoard"
