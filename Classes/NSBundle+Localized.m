//
//  NSBundle+Localized.m
//  Pods
//
//  Created by Michael on 30/8/14.
//
//

#import "NSBundle+Localized.h"
@implementation NSBundle (Localized)
+ (NSBundle*) bundleWithName:(NSString*)name
{
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:frameworkBundlePath]){
        return [NSBundle bundleWithPath:frameworkBundlePath];
    }
    return nil;
}
@end
