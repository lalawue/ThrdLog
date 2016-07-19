
# ThrdLog

Lightweight and improved log system for replacing NSLog.

Only support ARC.


# Usage

uncomment 2 lines in ThrdLog.h, and import to your .pch header before any source compiled.

```
#undef NSLog
#define NSLog(...)      ThrdLog(THRD_LOG_LEVEL_VERBOSE, __FILE__, __LINE__, __VA_ARGS__)
```

it will print out in Debug area like these:
```
7/20 01:16:02.250> [AppDelegate.m:98] (Main) log in main thread
7/20 01:16:02.254> [SomeViewController.m:170] (Thread 3) log in thread
```
