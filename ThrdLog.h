//
//  Created by lalawue@github.com on 15/4/18.

// uncomment NSLog below and import this file from pch header,
// before any source compiled.

#ifndef THRD_LOG_H
#define THRD_LOG_H

#import <Foundation/Foundation.h>

#define THRD_LOG_OPTION_LEVEL   1       // log level info
#define THRD_LOG_OPTION_TIME    2
#define THRD_LOG_OPTION_THREAD  4
#define THRD_LOG_OPTION_FILE    8

#define THRD_LOG_OPTION_DEFAULT 0xfe
#define THRD_LOG_OPTION_ALL     0xff

void ThrdLogSetOption(int option);
void ThrdLogSetLevel(int level);

FOUNDATION_EXPORT void ThrdLog(int level, char *fname, int line, NSString *fmt, ...) NS_FORMAT_FUNCTION(4,5);

#define THRD_LOG_LEVEL_ERROR   0
#define THRD_LOG_LEVEL_WARNING 1
#define THRD_LOG_LEVEL_INFO    2
#define THRD_LOG_LEVEL_VERBOSE 3    // default

#define ThrdLogError(...)       ThrdLog(THRD_LOG_LEVEL_ERROR, __FILE__, __LINE__, __VA_ARGS__)
#define ThrdLogWarning(...)     ThrdLog(THRD_LOG_LEVEL_WARNING, __FILE__, __LINE__, __VA_ARGS__)
#define ThrdLogInfo(...)        ThrdLog(THRD_LOG_LEVEL_INFO, __FILE__, __LINE__, __VA_ARGS__);
#define ThrdLogVerbose(...)     ThrdLog(THRD_LOG_LEVEL_VERBOSE, __FILE__, __LINE__, __VA_ARGS__)

//#undef NSLog
//#define NSLog(...)      ThrdLog(THRD_LOG_LEVEL_VERBOSE, __FILE__, __LINE__, __VA_ARGS__)

#endif
