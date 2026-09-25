APK_DIR := /apk/haraworks
PACKAGE := com.haravan.haraworks

.PHONY: install-haraworks wait-for-android

install-haraworks: wait-for-android
	@test -f "$(APK_DIR)/com.haravan.haraworks.apk" || { echo "Base APK not found in $(APK_DIR)"; exit 1; }
	@test -f "$(APK_DIR)/config.xxhdpi.apk" || { echo "Density split not found in $(APK_DIR)"; exit 1; }
	@test -f "$(APK_DIR)/config.vi.apk" || { echo "Vietnamese split not found in $(APK_DIR)"; exit 1; }
	@abi="$$(adb shell getprop ro.product.cpu.abi | tr -d '\r')"; \
	case "$$abi" in \
	  arm64-v8a) abi_split="config.arm64_v8a.apk" ;; \
	  *) echo "Unsupported emulator ABI: $$abi. This Haraworks bundle only contains config.arm64_v8a.apk."; exit 1 ;; \
	esac; \
	adb install-multiple -r -g \
	  "$(APK_DIR)/com.haravan.haraworks.apk" \
	  "$(APK_DIR)/$$abi_split" \
	  "$(APK_DIR)/config.xxhdpi.apk" \
	  "$(APK_DIR)/config.vi.apk"

wait-for-android:
	@adb wait-for-device
	@elapsed=0; \
	until [ "$$(adb shell getprop sys.boot_completed | tr -d '\r')" = "1" ]; do \
	  if [ "$$elapsed" -ge 180 ]; then echo "Android did not finish booting within 180 seconds"; exit 1; fi; \
	  echo "Waiting for Android to finish booting..."; \
	  sleep 2; \
	  elapsed=$$((elapsed + 2)); \
	done
