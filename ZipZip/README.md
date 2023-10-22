# AVSS 2023 Qualifier - ZipZip (UV3)

`ZipZip` is the third set of challenges in the AVSS application challenges. You need to exploit the zip path traversal vulnerability in the `com.darknavy.avss_zipzip` APP and retrieve the flag in `com.darknavy.avss_zipzip` private file directory.



## Vulnerability Info

**Vulnerabilities limitation**

> In this challenge, you are only allowed to exploit the following vulnerabilities.

The vulnerability of this challenges is  zip path traversal in `app/src/main/java/com/darknavy/avss_zipzip/utils/ZipUtils.java`

```java
public static boolean unzipFile(final InputStream zipFileStream, final File destDir)
        throws IOException {
    ZipInputStream zipInputStream = new ZipInputStream(zipFileStream);
    ZipEntry zipEntry = zipInputStream.getNextEntry();
    List<File> files = new ArrayList<>();
    byte[] buffer = new byte[1024 * 1024];
    int count = 0;
    while (zipEntry != null) {
        if (!zipEntry.isDirectory()) {
            String fileName = zipEntry.getName();
            File file = new File(destDir, fileName);
            if(file.exists()){
                file.delete();
            }
            file.createNewFile();
            FileOutputStream fileOutputStream = new FileOutputStream(file);

            while ((count = zipInputStream.read(buffer)) > 0) {
                fileOutputStream.write(buffer, 0, count);
            }
            fileOutputStream.close();
        }
        zipEntry = zipInputStream.getNextEntry();
    }
    zipInputStream.close();
    return true;
}
```



## Source Code

Source code is in `app-11-14-1-src.zip` and `app-14-2-src.zip`.

You can build the app by Android Studio or command line.



## Local Environment

Since the environment files are stored on cloud object storage service, you can obtain this series of challenges by running the following command.

```
# Android 11
python3 ./envfetcher.py UV3A11
# Android 14 ver 1
python3 ./envfetcher.py UV3A14_1
# Android 14 ver 2
python3 ./envfetcher.py UV3A14_2
```



## Remote Connection

In application challenge `ZipZip`,  you can provide a url of your exploit apk file. It will be downloaded and launched in remote emulator. And you will get the logcat of emulator.



## Notes

1. **Vulnerability Limitation**: Contestants must only exploit the vulnerabilities in `Vulnerability Info` Provided.
2. After starting the remote environment, it may take several minutes for the emulator to start.
3. If you do not have an arm64 debugging environment locally, you can apply for an arm64 debugging environment on the competition platform.
4. Downloading AOSP requires several tens to hundreds of gigabytes of disk space. You can also browse the AOSP source code online on the following websites.
   1. https://cs.android.com/android
   2. https://android.googlesource.com/?format=HTML
