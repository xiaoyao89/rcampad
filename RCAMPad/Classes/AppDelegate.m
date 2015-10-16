//
//  AppDelegate.m
//  RCAMPad
//

#import "AppDelegate.h"
#import "VFCDocument.h"
#import "VFCDocumentViewController.h"
#import "ViewController.h"
#import "VFCTutorialViewController.h"

#pragma mark - AppDelegate

#pragma mark - Private Interface

@interface AppDelegate ()
@end

#pragma mark - Public Implementation

@implementation AppDelegate

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Appearance
    [[UINavigationBar appearance] setBarTintColor:[UIColor venturaFoodsBlueColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIToolbar appearance] setBarTintColor:[UIColor venturaFoodsBlueColor]];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    [[UIToolbar appearance] setTranslucent:NO];
    NSDictionary *titleDict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:titleDict];
    
    [[UISearchBar appearance] setTintColor:[UIColor venturaFoodsBlueColor]];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    ViewController *viewController = [[ViewController alloc] init];
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Tutorial" ofType:@"plist"];
    //NSArray *pageDicts = [NSArray arrayWithContentsOfFile:filePath];
    //VFCTutorialViewController *tutorialVC = [[VFCTutorialViewController alloc] initWithArray:pageDicts];
    //[viewController presentViewController:tutorialVC animated:YES completion:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
