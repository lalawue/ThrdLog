//
//  Created by lalawue@github.com on 15/4/18.

#import "ThrdLog.h"
#import <sys/time.h>

static int _thrd_option = THRD_LOG_OPTION_DEFAULT;
static int _thrd_level = THRD_LOG_LEVEL_VERBOSE;

static inline void _thrd_name(char *tbuf, int tlen) {
    if ( [NSThread isMainThread] ) {
        sprintf(tbuf, "Main");
    }
    else if ( [NSThread isMultiThreaded] ) {
        NSThread *thread = [NSThread currentThread];
        NSString *name = [thread name];
        
        if ([name length] > 0) {
            strncpy(tbuf, [name UTF8String], tlen);
            return;
        }
        
        // optimize CPU use by computing the thread name once and storing it back
        // in the thread dictionary
        name = [thread description];
        NSArray *threadNumberPrefixes = @[ @"num = ", @"number = "];
        NSRange range = NSMakeRange(NSNotFound, 0);
        
        for (NSString *threadNumberPrefix in threadNumberPrefixes) {
            range = [name rangeOfString:threadNumberPrefix];
            if (range.location != NSNotFound) {
                NSUInteger nlen = [threadNumberPrefix length];
                range = NSMakeRange(range.location + nlen, range.length - nlen);
                break;
            }
        }
        
        if (range.location != NSNotFound) {
            snprintf(tbuf, tlen, "Thread %d", atoi([[name substringFromIndex:range.location] UTF8String]));
        }
    }
}

static inline void _ttime(char *tbuf, int tlen) {
    struct tm stm; time_t tloc; struct timeval tv;
    tloc = time(NULL);
    localtime_r(&tloc, &stm);
    gettimeofday(&tv, NULL);
    snprintf(tbuf, tlen, "%d/%d %02d:%02d:%02d.%03d", stm.tm_mon+1, stm.tm_mday, stm.tm_hour, stm.tm_min, stm.tm_sec, tv.tv_usec>>10);
}

static inline const char* _tlevel(int level) {
    static char *tlev[] = { "Err", "Warn", "Info", "Verbose"};
    
    if (level>=THRD_LOG_LEVEL_ERROR && level<=THRD_LOG_LEVEL_VERBOSE) {
        return tlev[level];
    }
    return "???";
}


void ThrdLogSetOption(int option) {
    _thrd_option = option;
    printf("#### Thrd Log option %x ####\n", option);
}

void ThrdLogSetLevel(int level) {
    _thrd_level = level;
    printf("#### Thrd Log level (%s) ####\n", _tlevel(level));
}

void ThrdLog(int level, char *fname, int line, NSString *fmt, ...) {
    if (level > _thrd_level) {
        return;
    }
    
    if (_thrd_option & THRD_LOG_OPTION_LEVEL) {
        printf("(%s) ", _tlevel(level));
    }
    
    if (_thrd_option & THRD_LOG_OPTION_TIME) {
        char ttime[32] = {0};
        _ttime(ttime, 32);
        printf("%s> ", ttime);
    }
    
    if (_thrd_option & THRD_LOG_OPTION_FILE) {
        NSString *fpath = [NSString stringWithUTF8String:fname];
        printf("[%s:%d] ", [[fpath lastPathComponent] UTF8String], line);
    }
    
    if (_thrd_option & THRD_LOG_OPTION_THREAD) {
        char tname[32] = {0};
        _thrd_name(tname, 32);
        printf("(%s) ", tname);
    }
    
    va_list ap;
    va_start(ap, fmt);
    
    NSString *strOutput = [[NSString alloc] initWithFormat:fmt arguments:ap];
    printf("%s\n", [strOutput UTF8String]);
    
    va_end(ap);
}