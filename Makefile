export TARGET=iphone:clang

include theos/makefiles/common.mk

BUNDLE_NAME = FlappyFedora
FlappyFedora_FILES = FlappyFedora.m FindAppContainer.m
FlappyFedora_INSTALL_PATH = /Library/PreferenceBundles
FlappyFedora_FRAMEWORKS = UIKit
FlappyFedora_PRIVATE_FRAMEWORKS = Preferences

ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FlappyFedora.plist$(ECHO_END)
