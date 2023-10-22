# AVSS 2023 Qualifier - expReceiver (UV2)

`expReceiver` is the second set of challenges in the AVSS application challenges. You need to exploit a exposed broadcast receiver in the `com.avss.testreceiver` APP and retrieve the flag in `com.avss.testreceiver` private file directory.



## Vulnerability Info

**Vulnerabilities limitation**

> In this challenge, you are only allowed to exploit the following vulnerabilities.

The vulnerability in this challenge is that the `com.avss.testreceiver` application has an exposed broadcast receiver that can be accessed by other applications.

```xml
<receiver
    android:name="com.avss.testreceiver.MyBroadcastReceiver">
    <intent-filter>
        <action android:name="com.avss.testreceiver.GET_FLAG" />
    </intent-filter>
</receiver>
```



## Source Code

Source code is in `uv2_src.tar.gz`.

You can build the app by Android Studio or command line.



## Local Environment

Since the environment files are stored on cloud object storage service, you can obtain this series of challenges by running the following command.

```
# Android 7
python3 ./envfetcher.py UV2A7
# Android 8
python3 ./envfetcher.py UV2A8
```



## Remote Connection

In application challenge `expReceiver`,  you can connect to the adb shell in emulator and exploit in the adb shell.



## Notes

1. **Vulnerability Limitation**: Contestants must only exploit the vulnerabilities in `Vulnerability Info` Provided.
2. After starting the remote environment, it may take several minutes for the emulator to start.
3. If you do not have an arm64 debugging environment locally, you can apply for an arm64 debugging environment on the competition platform.
4. Downloading AOSP requires several tens to hundreds of gigabytes of disk space. You can also browse the AOSP source code online on the following websites.
   1. https://cs.android.com/android
   2. https://android.googlesource.com/?format=HTML
