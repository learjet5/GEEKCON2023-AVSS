# AVSS 2023 Qualifier - VulnParcel (UV1)

`VulnParcel` is the first set of challenges in the AVSS application challenges. You need to exploit a parcel mismatch vulnerability in the `android.os.VulnParcelable` and retrieve the flag in `com.android.settings`.



## Vulnerability Info

**Vulnerabilities limitation**

> In this challenge, you are only allowed to exploit the following vulnerabilities.

In the `android.os.VulnParcelable` class, the `readFromParcel` and `writeToParcel` functions have a Parcel Mismatch issue, resulting in a mismatch between the data read from and written to the parcel.

```java
+    public void readFromParcel(@NonNull Parcel in) {
+        Log.d("VulnParcelable", "read from parcel");
+        opt = in.readInt();
+        if (opt == 0) {
+            o1 = in.readInt();
+            Log.d("VulnParcelable", "read o1: "+o1);
+        } else if (opt == 1) {
+            o2 = in.readInt();
+            Log.d("VulnParcelable", "read o2: "+o2);
+            int size = in.readInt();
+            Log.d("VulnParcelable", "read size: "+size);
+            if (o2 > 0) {
+                mPayload = new byte[size];
+                in.readByteArray(mPayload);
+                Log.d("VulnParcelable", "readByteArray");
+            }
+        }
+    }
+    @Override
+    public void writeToParcel(@NonNull Parcel dest, int flags) {
+        Log.d("VulnParcelable", "writeToParcel");
+        dest.writeInt(opt);
+        if (opt == 0) {
+            dest.writeInt(o1);
+            Log.d("VulnParcelable", "write o1: "+o1);
+        } else if (opt == 1) {
+            dest.writeInt(o2);
+            Log.d("VulnParcelable", "write o2: "+o2);
+            if (o2 > 0) {
+                dest.writeInt(mPayload.length);				// mismatch
+                dest.writeByteArray(mPayload);
+                Log.d("VulnParcelable", "write writeByteArray: "+mPayload.length);
+            }
+        }
+    }
```



## Source Code

### Android 12
```
# AOSP
repo init -u https://android.googlesource.com/platform/manifest -b android12-gsi
#repo init -u https://mirrors.tuna.tsinghua.edu.cn/git/AOSP/platform/manifest -b android12-gsi
```
### Android 13
```
# AOSP
repo init -u https://android.googlesource.com/platform/manifest -b android13-gsi
```



### Apply Patch

```
/bin/bash patcher.sh patch AOSPPROJ PATCHFILE
```

Next, you can follow the official website's [instructions](https://source.android.com/docs/setup/build/building) to proceed with the AOSP build process.



## Local Environment

Since the environment files are stored on cloud object storage service, you can obtain this series of challenges by running the following command.

```
# Android 12
python3 ./envfetcher.py UV1A12
# Android 13
python3 ./envfetcher.py UV1A13
```



## Remote Connection

In application challenge `VulnParcel`, you can provide a url of your exploit apk file. It will be downloaded and launched in remote emulator. And you will get the logcat of emulator.



## Notes

1. **Vulnerability Limitation**: Contestants must only exploit the vulnerabilities in `Vulnerability Info` Provided.
2. After starting the remote environment, it may take several minutes for the emulator to start.
3. If you do not have an arm64 debugging environment locally, you can apply for an arm64 debugging environment on the competition platform.
4. Downloading AOSP requires several tens to hundreds of gigabytes of disk space. You can also browse the AOSP source code online on the following websites.
   1. https://cs.android.com/android
   2. https://android.googlesource.com/?format=HTML
