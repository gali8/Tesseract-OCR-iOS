//
//  AppDelegate.m
//  TestsProjectmacOS
//
//  Created by Hamilton Chapman on 28/03/2018.
//  Copyright © 2018 Pilgrimage Software. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#ifdef DEBUG
+ (void)load {
    [[NSUserDefaults standardUserDefaults] setValue:@"XCTestLog"
                                             forKey:@"XCTestObserverClass"];
}
#endif

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window = [[NSWindow alloc] initWithContentRect: [[NSScreen mainScreen] frame] styleMask: NSWindowStyleMaskTitled backing: NSBackingStoreBuffered defer: NO screen: [NSScreen mainScreen]];
    self.window.backgroundColor = [NSColor whiteColor];
    self.window.windowController = [[ViewController alloc] init];

    NSLog(@"lol");

    [self.window makeKeyWindow];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
#ifdef DEBUG
//    extern void __gcov_flush(void);
//    __gcov_flush();
#endif
}


@end
