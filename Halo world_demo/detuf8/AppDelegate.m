//
//  AppDelegate.m
//  detuf8
//
//  Created by Seth on 2017/11/30.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "AppDelegate.h"
#import "F8MainViewController.h"
#import "F8BaseNavController.h"
@interface AppDelegate ()
{
    UIBackgroundTaskIdentifier bgTask;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    NSLog(@"%@", APP_NET_JSON_URL);
    DeveloperMode(
                  NSLog(@"写在这里的代码只有开发模式、测试模式会生效！")
    );
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[F8BaseNavController alloc] initWithRootViewController:[F8MainViewController new]];
                                      
    [[F8DeviceManager sharedInstance] config];
    [[F8ActiveMonitor sharedInstance] monitor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    id  applanguage = [defaults valueForKey:@"applanguage"];
    if (applanguage == nil) {
        if ([preferredLang isEqualToString:@"zh-Hans-CN"]){
            [defaults setValue:@"zh-Hans" forKey:@"applanguage"];
            [defaults synchronize];
        } else if ([preferredLang isEqualToString:@"zh-Hant-CN"]){
            [defaults setValue:@"zh-Hant" forKey:@"applanguage"];
            [defaults synchronize];
        } else if ([preferredLang isEqualToString:@"fr"]||[preferredLang isEqualToString:@"fr-CN"]){
            [defaults setValue:@"fr" forKey:@"applanguage"];
            [defaults synchronize];
        }else {
            [defaults setValue:@"en" forKey:@"applanguage"];
            [defaults synchronize];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // 10分钟后执行这里，应该进行一些清理工作，如断开和服务器的连接等
        // ...
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    if (bgTask == UIBackgroundTaskInvalid) {
        NSLog(@"failed to start background task!");
    }
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Do the work associated with the task, preferably in chunks.
        NSTimeInterval timeRemain = 0;
        do{
            [NSThread sleepForTimeInterval:5];
            if (bgTask != UIBackgroundTaskInvalid) {
                timeRemain = [application backgroundTimeRemaining];
                NSLog(@"Time remaining: %f",timeRemain);
            }
        }while(bgTask != UIBackgroundTaskInvalid && timeRemain > 1 * 60);
        // 如果改为timeRemain > 5*60,表示后台运行5分钟
        // done!
        // 如果没到10分钟，也可以主动关闭后台任务，但这需要在主线程中执行，否则会出错
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                // 和上面10分钟后执行的代码一样
                // ...
                // if you don't call endBackgroundTask, the OS will exit your app.
                
                [application endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // 如果没到10分钟又打开了app,结束后台任务
    if (bgTask != UIBackgroundTaskInvalid) {
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

- (void)SetScreenVertical{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarOrientation:)]){
        SEL selector = NSSelectorFromString(@"setStatusBarOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIApplication instanceMethodSignatureForSelector:selector]];
        UIDeviceOrientation orentation = UIDeviceOrientationPortrait;
        [invocation setSelector:selector];
        [invocation setTarget:[UIApplication sharedApplication]];
        [invocation setArgument:&orentation atIndex:2];
        [invocation invoke];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    if (![F8AutorotateTool autorotateTool].autorotate) {
//        if ([F8AutorotateTool autorotateTool].isAutorotate) {
//            return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//        }
//        return UIInterfaceOrientationMaskPortrait;
//    }
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
