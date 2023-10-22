# AVSS 2023 Qualifier - Allocator (UV4)

`Allocator` is the last set of challenges in the AVSS application challenges. You need to exploit several heap related vulnerabilities in the `com.avss.testallocator` APP and retrieve the flag in `com.avss.testallocator` private file directory.



## Vulnerability Info

**Vulnerabilities limitation**

> In this challenge, you are only allowed to exploit the following vulnerabilities.

The vulnerabilities including

- Heap uninitialization in `Java_com_avss_testallocator_MyJavaScriptInterface_native_1add`
- Heap overwrite 8 bytes in `Java_com_avss_testallocator_MyJavaScriptInterface_native_1edit`
- Heap out-of-bounds read 8 bytes in `Java_com_avss_testallocator_MyJavaScriptInterface_native_1show`
- Double free in `Java_com_avss_testallocator_MyJavaScriptInterface_native_1delete`

```cpp
extern "C" JNIEXPORT void JNICALL Java_com_avss_testallocator_MyJavaScriptInterface_native_1add(JNIEnv *env, jobject thiz, jint idx, jstring jkey, jint size)
{
    unsigned int realsize = size + KEYSIZE;
    const char *key = env->GetStringUTFChars(jkey, nullptr);
    if (idx >= 0 && idx < ARRAY_SIZE && (unsigned int)size > 0 && (unsigned int)realsize <= MAXSIZE) {
        struct mystruct *p = (struct mystruct *) new char[realsize];
//        memset(p, 0, sizeof(struct mystruct));  // initialize
        strncpy(p->key, (char *)key, KEYSIZE);

        chunklist[idx] = p;
        chunksize[idx] = realsize;
        LOGD("add %d %p(size: %d)\n", idx, p, realsize);

    }
}
extern "C" JNIEXPORT void JNICALL Java_com_avss_testallocator_MyJavaScriptInterface_native_1edit(JNIEnv *env, jobject thiz, jint idx, jbyteArray jdata)
{
    signed char *data = env->GetByteArrayElements(jdata, nullptr);
    unsigned int size = env->GetArrayLength(jdata);
    if (idx >= 0 && idx < ARRAY_SIZE && chunklist[idx] != 0 && chunksize[idx] != 0)
    {
        if (size > chunksize[idx])
            size = chunksize[idx];
        memcpy(((struct mystruct *)chunklist[idx])->value, data, size); // overflow 8 bytes
        LOGD("edit %d %p\n", idx, chunklist[idx]);
    }
}
extern "C" JNIEXPORT jbyteArray JNICALL Java_com_avss_testallocator_MyJavaScriptInterface_native_1show(JNIEnv *env, jobject thiz, jint idx, jint size)
{
    if (idx >= 0 && idx < ARRAY_SIZE && chunklist[idx] != 0 && chunksize[idx] != 0)
    {
        if (size > chunksize[idx])
            size = chunksize[idx];
        jbyteArray bytes = env->NewByteArray(size);
        env->SetByteArrayRegion(bytes, 0, size, (jbyte *)((struct mystruct *)chunklist[idx])->value); // overread 8 bytes
        LOGD("show %d %p\n", idx, chunklist[idx]);
        return bytes;
    }
    else
    {
        jbyteArray bytes = env->NewByteArray(0);
        return bytes;
    }
}

extern "C" JNIEXPORT void JNICALL Java_com_avss_testallocator_MyJavaScriptInterface_native_1delete(JNIEnv *env, jobject thiz, jint idx)
{
    if (idx >= 0 && idx < ARRAY_SIZE && chunklist[idx] != 0)
    {
        // double free
        free(chunklist[idx]);
        //        chunklist[idx] = 0;
        chunksize[idx] = 0;
        LOGD("delete %d %p\n", idx, chunklist[idx]);
    }
}
```



## Source Code

Source code is in `uv4_src.zip`.

You can build the app by Android Studio or command line.



## Local Environment

Since the environment files are stored on cloud object storage service, you can obtain this series of challenges by running the following command.

```
# Android 4
python3 ./envfetcher.py UV4A4
# Android 8
python3 ./envfetcher.py UV4A8
# Android 12
python3 ./envfetcher.py UV4A12
```



## Remote Connection

In application challenge `Allocator`,  you can provide a url and the APP will load the provided url.



## Notes

1. **Vulnerability Limitation**: Contestants must only exploit the vulnerabilities in `Vulnerability Info` Provided.
2. After starting the remote environment, it may take several minutes for the emulator to start.
   - Especially for the Android 4 version in this challenges, it may take 5 minutes to initialize.
3. If you do not have an arm64 debugging environment locally, you can apply for an arm64 debugging environment on the competition platform.
4. Downloading AOSP requires several tens to hundreds of gigabytes of disk space. You can also browse the AOSP source code online on the following websites.
   1. https://cs.android.com/android
   2. https://android.googlesource.com/?format=HTML
