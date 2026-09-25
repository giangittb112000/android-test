APK_DIR := /apk/haraworks
PACKAGE := com.haravan.haraworks

.PHONY: install-haraworks wait-for-android android-info

install-haraworks: wait-for-android
	@test -f "$(APK_DIR)/com.haravan.haraworks.apk" || { echo "Base APK not found in $(APK_DIR)"; exit 1; }
	@test -f "$(APK_DIR)/config.arm64_v8a.apk" || { echo "ARM64 split not found in $(APK_DIR)"; exit 1; }
	@abi_list="$$(adb shell getprop ro.product.cpu.abilist | tr -d '\r')"; \
	case ",$$abi_list," in \
	  *,arm64-v8a,*) ;; \
	  *) echo "Android system image does not provide ARM64 translation. Supported ABIs: $$abi_list"; exit 1 ;; \
	esac; \
	echo "Installing Haraworks with supported ABIs: $$abi_list"; \
	adb install-multiple -r -g "$(APK_DIR)"/*.apk

wait-for-android:
	@adb wait-for-device
	@elapsed=0; \
	until [ "$$(adb shell getprop sys.boot_completed | tr -d '\r')" = "1" ]; do \
	  if [ "$$elapsed" -ge 300 ]; then echo "Android did not finish booting within 300 seconds"; exit 1; fi; \
	  echo "Waiting for Android to finish booting..."; \
	  sleep 2; \
	  elapsed=$$((elapsed + 2)); \
	done

android-info: wait-for-android
	@echo "Android: $$(adb shell getprop ro.build.version.release | tr -d '\r') (API $$(adb shell getprop ro.build.version.sdk | tr -d '\r'))"
	@echo "Primary ABI: $$(adb shell getprop ro.product.cpu.abi | tr -d '\r')"
	@echo "Supported ABIs: $$(adb shell getprop ro.product.cpu.abilist | tr -d '\r')"
	@echo "Native bridge: $$(adb shell getprop ro.dalvik.vm.native.bridge | tr -d '\r')"
