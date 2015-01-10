//
//  AppDelegate.m
//  TestsProject
//
//  Created by Nikolay Volosatov on 15.12.14.
//  Copyright (c) 2014 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

#ifdef DEBUG
+ (void)load {
    [[NSUserDefaults standardUserDefaults] setValue:@"XCTestLog"
                                             forKey:@"XCTestObserverClass"];
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.window.rootViewController = [[ViewController alloc] init];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
#ifdef DEBUG
    extern void __gcov_flush(void);
    __gcov_flush();
#endif
}

@end
