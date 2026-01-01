#import <Foundation/Foundation.h>
#import "rty_wrapper.h"
#import "rty.h"

NSString * ios_getAllUrl(void) {
    const char *json = getAllUrl();
    if (json == NULL) {
        return @"{}";
    }
    return [NSString stringWithUTF8String:json];
}

