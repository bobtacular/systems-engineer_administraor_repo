#!/bin/bash

#REPLACE * * WITH REQUESTED FILED

title="*NAME_OF_PROJECT"
heading=""
description=""
icon="*ICON_PATH*"
jamfhelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Find existing password in keychain
/usr/bin/security find-generic-password -s com.apple.network.eap.user.item.wlan.ssid.*PLIST_SSID_NAME* > /dev/null 2>&1
keychainfound=$?

if [[ $keychainfound != 0 ]]; then
  description="No previous password found. Please try connecting to *WIFI_NAME* again or contact *EMAIL* for support."
  "$jamfhelper" -windowType hud \
                -title "$title" \
                -heading "$heading" \
                -description "$description" \
                -icon "$icon" \
                -button1 "OK" \
                -defaultButton 1 \
                -alignHeading center \
                -alignDescription left \
                > /dev/null 2>&1
  exit 0
else
  description="Saved password for *WIFI_NAME* detected. Do you want to delete the saved password?"
  "$jamfhelper" -windowType hud \
                -title "$title" \
                -heading "$heading" \
                -description "$description" \
                -icon "$icon" \
                -button1 "Cancel" \
                -button2 "Delete" \
                -defaultButton 1 \
                -alignHeading center \
                -alignDescription left \
                > /dev/null 2>&1
  if [[ $? != 2 ]]; then
    # User canceled
    exit 0
  fi
fi


# Delete *WIFI_NAME* keychain item
/usr/bin/security delete-generic-password -s com.apple.network.eap.user.item.wlan.ssid.*PLIST_SSID_NAME* > /dev/null 2>&1
error=$?

if [[ $error != 0 ]]; then
  description="No previous password found. Please try connecting to *WIFI_NAME* again."
else
  description="Saved *WIFI_NAME* password has been deleted. Please try connecting to *WIFI_NAME* again."
fi

"$jamfhelper" -windowType hud \
              -title "$title" \
              -heading "$heading" \
              -description "$description" \
              -icon "$icon" \
              -button1 "OK" \
              -defaultButton 1 \
              -alignHeading center \
              -alignDescription left \
              > /dev/null 2>&1

exit 0
