#!/bin/bash
# Karabiner maps Shift+Caps to Ctrl+Space. macOS switches the input source on Ctrl+Space only
# when the "Select the previous input source" shortcut (symbolic hot key 60) is enabled.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 \
  '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>'
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
