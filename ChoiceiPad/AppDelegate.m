//
//  AppDelegate.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-4-21.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "AppDelegate.h"
#import "AKLogInViewController.h"
#import "CVLocalizationSetting.h"

@implementation AppDelegate
{
    NSString *_strLanguage;
    UINavigationController *nav;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    // Override point for customization after application launch.
    [self copyFiles];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
    }
    NSString *language = [[NSUserDefaults standardUserDefaults]
						  stringForKey:@"language"];
    if(!language) {
        [self performSelector:@selector(registerDefaultsFromSettingsBundle)];
    }
    if (![[NSUserDefaults standardUserDefaults]
         stringForKey:@"switch"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"kc" forKey:@"switch"];
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"version"];  //版本號
    [[NSUserDefaults standardUserDefaults] synchronize];
	_strLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
//    NSString *str=@"";
//    NSArray *array=[[NSArray alloc] initWithObjects:@"\n          查询单\n",@"用户名:11111\n",@"订单号:1111\n",@"菜品名称     价格 单位 数量\n",@"==============================\n", nil];
//    for (int i = 0; i < [array count]; i++) {
//        NSString *string=[array objectAtIndex:i];
//        str = [str stringByAppendingString:string];
//    }
//    for (int i=0;i<5;i++) {
//        NSString *name=@"鱼香肉丝";
//        name=[self stringWithLeng:8 WithString:name WhitAfter:YES];
//        NSString *price=@"1.00";
//        price=[self stringWithLeng:6 WithString:price WhitAfter:NO];
//        NSString *cnt=@"1.00";
//        cnt=[self stringWithLeng:4 WithString:cnt WhitAfter:NO];
//        NSString *unit=@"份";
//        unit=[self stringWithLeng:3 WithString:unit WhitAfter:YES];
//        
//        str = [str stringByAppendingFormat:@"%@ %@ %@ %@\n",name,price,unit,cnt];
//    }
//    NSLog(@"%@",str);
//    str = [str stringByAppendingString:@"==============================\n"];
    AKLogInViewController *logInVC = [[AKLogInViewController alloc]init];
    nav = [[UINavigationController alloc]initWithRootViewController:logInVC];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
//根据字符串的长度拼接字符串，长的截取，短的空格填充，可再前后拼接
-(NSString *)stringWithLeng:(int)lengt WithString:(NSString *)string WhitAfter:(BOOL)after
{
    if (string.length>=lengt) {
        string=[string substringWithRange:NSMakeRange(0, lengt)];
    }else
    {
        if (after) {
            for (int j=lengt; j>[string length]; j--) {
                string=[string stringByAppendingString:@"  "];
            }
        }else
        {
            NSString *str=@"";
            for (int j=lengt; j>[string length]; j--) {
                str=[str stringByAppendingString:@" "];
            }
            string=[str stringByAppendingString:string];
        }
        
    }
    return string;
}
- (void)registerDefaultsFromSettingsBundle {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            //			NSLog(@"Default %@ value:%@",key,[prefSpecification objectForKey:@"DefaultValue"]);
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}


-(void)checkLanguage{
	CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
	NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
	if (![_strLanguage isEqualToString:currentLanguage])
	{
		//	[check invalidate];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"LanguageChangedTitle"]
														message:[langSetting localizedString:@"LanguageChangedMessage"]
													   delegate:nil
											  cancelButtonTitle:[langSetting localizedString:@"OK"]
											  otherButtonTitles:nil];
		[alert show];
	}
	//	else
	//		[check invalidate];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[BSDataProvider sharedInstance] logout];
    [nav popToRootViewControllerAnimated:YES];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)copyFiles{
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
    
    NSString *sqlpath = [docPath stringByAppendingPathComponent:@"BookSystem.plist"];
    
    NSLog(@"%@",docPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:sqlpath]){
        NSArray *ary = [NSBundle pathsForResourcesOfType:@"jpg" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"JPG" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"png" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"PNG" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"plist" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
        
        ary = [NSBundle pathsForResourcesOfType:@"sqlite" inDirectory:[[NSBundle mainBundle] bundlePath]];
        for (NSString *path in ary){
            [fileManager copyItemAtPath:path toPath:[docPath stringByAppendingPathComponent:[path lastPathComponent]] error:nil];
        }
    }
}
@end
