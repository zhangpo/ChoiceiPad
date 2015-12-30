//
//  BSSettingViewController.m
//  BookSystem
//
//  Created by Dream on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSSettingViewController.h"
#import "BSDataProvider.h"
#import "Singleton.h"
//#import "PaymentSelect.h"
//#import "AKURLString.h"
#import "CVLocalizationSetting.h"

@implementation BSSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */
- (id)initWithType:(BSSettingType)type{
    self = [super init];
    if (self){
        settingType = type;
    }
    
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    UILabel *lblCap = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 540, 30)];
    //    lblCap.textAlignment = UITextAlignmentCenter;
    //    lblCap.backgroundColor = [UIColor clearColor];
    //    lblCap.font = [UIFont boldSystemFontOfSize:22];
    //    lblCap.textColor = [UIColor darkGrayColor];
    //    lblCap.text = @"cMenu 配置";
    //    [self.view addSubview:lblCap];
    //    [lblCap release];
    
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(270, 340);
    [self.view addSubview:indicator];
    
    NSString *navTitle = nil;
    
    if (settingType==BSSettingTypeFtp){
        navTitle = @"设置FTP地址";
        btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnConfirm.frame = CGRectMake(0, 0, 100, 30);
        [btnConfirm setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(0, 0, 100, 30);
        [btnCancel setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        tfUser = [[UITextField alloc] initWithFrame:CGRectMake(70, 150, 180, 30)];
        tfUser.autocorrectionType = UITextAutocorrectionTypeNo;
        tfUser.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tfUser];
        
        tfPass = [[UITextField alloc] initWithFrame:CGRectMake(340, 150, 180, 30)];
        tfPass.autocorrectionType = UITextAutocorrectionTypeNo;
        tfPass.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tfPass];
        
        tfSetting = [[UITextField alloc] initWithFrame:CGRectMake(70, 200, 450, 30)];
        tfSetting.autocorrectionType = UITextAutocorrectionTypeNo;
        tfSetting.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tfSetting];
        
        btnConfirm.center = CGPointMake(180, 536);
        btnCancel.center = CGPointMake(360, 536);
        
        
        [self.view addSubview:btnConfirm];
        [self.view addSubview:btnCancel];
        
        
        lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 500, 40)];
        lblTips.numberOfLines = 3;
        lblTips.backgroundColor = [UIColor clearColor];
        lblTips.textColor = [UIColor grayColor];
        lblTips.text = [[CVLocalizationSetting sharedInstance] localizedString:@"Please enter the folder in which the database files will live FTP address and account password (anonymously blank), note that the configuration files and other resources must be in the same directory"];
        [self.view addSubview:lblTips];
        
        lblUser = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 80, 30)];
        lblUser.backgroundColor = [UIColor clearColor];
        lblUser.textColor = [UIColor grayColor];
        lblUser.text = [[CVLocalizationSetting sharedInstance] localizedString:@"Account:"];
        [self.view addSubview:lblUser];
        
        lblPass = [[UILabel alloc] initWithFrame:CGRectMake(290, 150, 80, 30)];
        lblPass.backgroundColor = [UIColor clearColor];
        lblPass.textColor = [UIColor grayColor];
        lblPass.text = [[CVLocalizationSetting sharedInstance] localizedString:@"Password:"];
        [self.view addSubview:lblPass];
        
        lblSetting = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 80, 30)];
        lblSetting.backgroundColor = [UIColor clearColor];
        lblSetting.textColor = [UIColor grayColor];
        lblSetting.text = @"IP:";
        [self.view addSubview:lblSetting];
        
        
        
        
        NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [docPaths objectAtIndex:0];
        NSString *settingPath = [docPath stringByAppendingPathComponent:@"setting.plist"];
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:settingPath];
        NSString *str = [dict objectForKey:@"url"];
        if (!str)
            str = kPathHeader;
        //        str = [str stringByAppendingPathComponent:@"BookSystem.sqlite"];
        
        lblPath = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 540, 30)];
        lblPath.textAlignment = UITextAlignmentCenter;
        lblPath.backgroundColor = [UIColor clearColor];
        lblPath.textColor = [UIColor grayColor];
        lblPath.text = [NSString stringWithFormat:@"当前地址:%@",str];
        [self.view addSubview:lblPath];
        
        lblChecking = [[UILabel alloc] initWithFrame:CGRectZero];
        lblChecking.textColor = [UIColor darkGrayColor];
        lblChecking.backgroundColor = [UIColor clearColor];
        lblChecking.text = @"正在检查地址是否正确";
        [lblChecking sizeToFit];
        lblChecking.center = CGPointMake(270, 260);
        [self.view addSubview:lblChecking];
        lblChecking.hidden = YES;
        indicator.hidden = YES;
        
    }
    else if (settingType==BSSettingTypeUpdate){
        navTitle = @"更新资料";
        self.view.backgroundColor=[UIColor whiteColor];
        lblDownloading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        lblDownloading.backgroundColor = [UIColor clearColor];
        lblDownloading.textColor = [UIColor darkGrayColor];
        lblDownloading.text = @"正在下载最新数据";
        lblDownloading.textAlignment = UITextAlignmentCenter;
        //        [lblDownloading sizeToFit];
        lblDownloading.center = CGPointMake(270, 260);
        [self.view addSubview:lblDownloading];
        indicator.hidden = NO;
        [indicator startAnimating];
        
        [NSThread detachNewThreadSelector:@selector(download) toTarget:self withObject:nil];
    }
    else if (settingType==BSSettingTypeSocket){
        navTitle = @"设置IP地址";
        btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnConfirm.frame = CGRectMake(0, 0, 100, 30);
        [btnConfirm setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(setIP) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(0, 0, 100, 30);
        [btnCancel setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        btnConfirm.center = CGPointMake(180, 536);
        btnCancel.center = CGPointMake(360, 536);
        
        
        [self.view addSubview:btnConfirm];
        [self.view addSubview:btnCancel];
        
        
        lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 500, 40)];
        lblTips.numberOfLines = 3;
        lblTips.backgroundColor = [UIColor clearColor];
        lblTips.textColor = [UIColor grayColor];
        lblTips.text = @"请输入Web Service的地址";
        [self.view addSubview:lblTips];
        
        
        tfSetting = [[UITextField alloc] initWithFrame:CGRectMake(50, 200, 200, 30)];
        tfSetting.autocorrectionType = UITextAutocorrectionTypeNo;
        tfSetting.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tfSetting];
        
        tfUser = [[UITextField alloc] initWithFrame:CGRectMake(370, 200, 120, 30)];
        tfUser.autocorrectionType = UITextAutocorrectionTypeNo;
        tfUser.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tfUser];
        
        
        lblSetting = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 80, 30)];
        lblSetting.backgroundColor = [UIColor clearColor];
        lblSetting.textColor = [UIColor grayColor];
        lblSetting.text = @"IP";
        [self.view addSubview:lblSetting];
        
        lblUser = [[UILabel alloc] initWithFrame:CGRectMake(320, 200, 80, 30)];
        lblUser.backgroundColor = [UIColor clearColor];
        lblUser.textColor = [UIColor grayColor];
        lblUser.text = @"端口";
        [self.view addSubview:lblUser];
        
        
        
        
        NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [docPaths objectAtIndex:0];
        NSString *settingPath = [docPath stringByAppendingPathComponent:@"ip.plist"];
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:settingPath];
        NSString *str = [dict objectForKey:@"ip"];
        if (!str)
            str = kSocketServer;
        
        lblPath = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 540, 30)];
        lblPath.textAlignment = UITextAlignmentCenter;
        lblPath.backgroundColor = [UIColor clearColor];
        lblPath.textColor = [UIColor grayColor];
        lblPath.text = [NSString stringWithFormat:@"当前地址:http://%@/cmenu/CmenuServices.asmx",str];
        [self.view addSubview:lblPath];
        
        
        lblChecking.hidden = YES;
        indicator.hidden = YES;
    }
    else if (settingType==BSSettingTypePDAID){
        navTitle = @"设置iPad编号";
        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnConfirm.frame = CGRectMake(0, 0, 100, 30);
        [btnConfirm setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(setPDAID) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(0, 0, 100, 30);
        [btnCancel setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        
        tfSetting = [[UITextField alloc] initWithFrame:CGRectMake(70, 200, 450, 30)];
        tfSetting.autocorrectionType = UITextAutocorrectionTypeNo;
        tfSetting.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tfSetting];
        
        btnConfirm.center = CGPointMake(180, 536);
        btnCancel.center = CGPointMake(360, 536);
        
        
        [self.view addSubview:btnConfirm];
        [self.view addSubview:btnCancel];
        
        
        lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 500, 40)];
        lblTips.numberOfLines = 3;
        lblTips.backgroundColor = [UIColor clearColor];
        lblTips.textColor = [UIColor grayColor];
        lblTips.text = @"请输入iPad编号";
        [self.view addSubview:lblTips];
        
        
        lblSetting = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 80, 30)];
        lblSetting.backgroundColor = [UIColor clearColor];
        lblSetting.textColor = [UIColor grayColor];
        lblSetting.text = @"编号:";
        [self.view addSubview:lblSetting];
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"PDAID"];
        if (!str){
            str = kPDAID;
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"PDAID"];
        }
        
        lblPath = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 540, 30)];
        lblPath.textAlignment = UITextAlignmentCenter;
        lblPath.backgroundColor = [UIColor clearColor];
        lblPath.textColor = [UIColor grayColor];
        lblPath.text = [NSString stringWithFormat:@"当前编号:%@",str];
        [self.view addSubview:lblPath];
        
        
        lblChecking.hidden = YES;
        indicator.hidden = YES;
    }
    else if(settingType==BSSettingTypeDianPuId)
    {
        navTitle = @"设置店铺编号";
        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnConfirm.frame = CGRectMake(0, 0, 100, 30);
        [btnConfirm setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(setDianPuID) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(0, 0, 100, 30);
        [btnCancel setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        
        tfSetting = [[UITextField alloc] initWithFrame:CGRectMake(70, 200, 450, 30)];
        tfSetting.autocorrectionType = UITextAutocorrectionTypeNo;
        tfSetting.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tfSetting];
        
        btnConfirm.center = CGPointMake(180, 536);
        btnCancel.center = CGPointMake(360, 536);
        
        
        [self.view addSubview:btnConfirm];
        [self.view addSubview:btnCancel];
        
        
        lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 500, 40)];
        lblTips.numberOfLines = 3;
        lblTips.backgroundColor = [UIColor clearColor];
        lblTips.textColor = [UIColor grayColor];
        lblTips.text = @"请输入店铺编号";
        [self.view addSubview:lblTips];
        
        
        lblSetting = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 80, 30)];
        lblSetting.backgroundColor = [UIColor clearColor];
        lblSetting.textColor = [UIColor grayColor];
        lblSetting.text = @"编号:";
        [self.view addSubview:lblSetting];
        
        
        
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
        if (!str){
            str = kDianPuId;
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"DianPuId"];
        }
        
        lblPath = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 540, 30)];
        lblPath.textAlignment = UITextAlignmentCenter;
        lblPath.backgroundColor = [UIColor clearColor];
        lblPath.textColor = [UIColor grayColor];
        lblPath.text = [NSString stringWithFormat:@"当前编号:%@",str];
        [self.view addSubview:lblPath];
        
        
        lblChecking.hidden = YES;
        indicator.hidden = YES;
        
        
    }else if(settingType==BSSettingTypeZeng)
    {
        navTitle = @"设置赠菜授权金额";
        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnConfirm.frame = CGRectMake(0, 0, 100, 30);
        [btnConfirm setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(setZeng) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(0, 0, 100, 30);
        [btnCancel setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        
        tfSetting = [[UITextField alloc] initWithFrame:CGRectMake(70, 200, 450, 30)];
        tfSetting.autocorrectionType = UITextAutocorrectionTypeNo;
        tfSetting.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:tfSetting];
        
        btnConfirm.center = CGPointMake(180, 536);
        btnCancel.center = CGPointMake(360, 536);
        
        
        [self.view addSubview:btnConfirm];
        [self.view addSubview:btnCancel];
        
        
        lblTips = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 500, 40)];
        lblTips.numberOfLines = 3;
        lblTips.backgroundColor = [UIColor clearColor];
        lblTips.textColor = [UIColor grayColor];
        lblTips.text = @"请输入最小赠菜授权金额";
        [self.view addSubview:lblTips];
        
        
        lblSetting = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 80, 30)];
        lblSetting.backgroundColor = [UIColor clearColor];
        lblSetting.textColor = [UIColor grayColor];
        lblSetting.text = @"金额:";
        [self.view addSubview:lblSetting];
        
        
        
        
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"Zeng"];
        if (!str){
            str = @"49";
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"Zeng"];
        }
        
        lblPath = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 540, 30)];
        lblPath.textAlignment = UITextAlignmentCenter;
        lblPath.backgroundColor = [UIColor clearColor];
        lblPath.textColor = [UIColor grayColor];
        lblPath.text = [NSString stringWithFormat:@"当前金额:%@",str];
        [self.view addSubview:lblPath];
        
        
        lblChecking.hidden = YES;
        indicator.hidden = YES;
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (UIInterfaceOrientationPortrait==interfaceOrientation || UIInterfaceOrientationPortraitUpsideDown==interfaceOrientation);
}

- (void)setIP{
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSString *settingPath = [docPath stringByAppendingPathComponent:@"ip.plist"];
    
    if ([tfSetting.text length]>0){
        NSString *portcode = [tfUser.text length]>0?[NSString stringWithFormat:@"%d",[tfUser.text intValue]]:nil;
        NSString *ipport = tfSetting.text;
        if (portcode)
            ipport = [NSString stringWithFormat:@"%@:%@",ipport,portcode];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:ipport forKey:@"ip"];
        [dic writeToFile:settingPath atomically:NO];
        
        [self performSelector:@selector(cancel)];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入IP地址" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}

- (void)setPDAID{
    if ([tfSetting.text length]>0){
        BSDataProvider * bp=[BSDataProvider sharedInstance];
        if ([Mode isEqualToString:@"zc"])
        {
        NSDictionary * dict =[bp ZCequipmentCoding:tfSetting.text];
        if ([[dict objectForKey:@"state"] intValue]==1) {
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"msg"] forKey:@"PDAID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSelector:@selector(cancel)];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"msg"] delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        }
        }else
        {
            [[NSUserDefaults standardUserDefaults] setObject:tfSetting.text forKey:@"PDAID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSelector:@selector(cancel)];
        }
        
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshID" object:nil];
        
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入编号" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}

-(void)setDianPuID
{
    if ([tfSetting.text length]>0){
        [[NSUserDefaults standardUserDefaults] setObject:tfSetting.text forKey:@"DianPuId"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDianPuID" object:nil];
        
        [self performSelector:@selector(cancel)];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输店铺编号" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}


- (void)download{
    
    BOOL valid = NO;
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSString *settingPath = [docPath stringByAppendingPathComponent:@"setting.plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:settingPath];
    
    NSString *str = [dict objectForKey:@"url"];
    if ([str length]==0)
        str = kPathHeader;
    
    str = [str stringByAppendingPathComponent:@"BookSystem.sqlite"];
    NSURLRequest *request;
    NSURL *url = [NSURL URLWithString:str];
    request = [[NSURLRequest alloc] initWithURL:url
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:5.0];
    
    
    // retreive the data using timeout
    NSURLResponse* response;
    NSError *error;
    
    
    error = nil;
    response = nil;
    NSData *serviceData = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:&response
                                                            error:&error];
    // 1001 is the error code for a connection timeout
    if (!serviceData) {
        valid = NO;
    }
    else{
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        if (data==nil){
            valid = NO;
        }
        else{
            valid = YES;
        }
    }
    
    if (valid) {
        
        //Refresh Files
        
        
//        NSString *settingPath = [@"setting.plist" documentPath];
        NSDictionary *didict= [NSDictionary dictionaryWithContentsOfFile:settingPath];
        NSString *ftpurl = nil;
        if (didict!=nil)
            ftpurl = [didict objectForKey:@"url"];
        
        if (!ftpurl)
            ftpurl = kPathHeader;
        ftpurl = [ftpurl stringByAppendingPathComponent:@"BookSystem.sqlite"];
        
        
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:ftpurl]];
        [imgData writeToFile:[docPath stringByAppendingPathComponent:@"BookSystem.sqlite"] atomically:NO];
        NSDictionary *infoDict = [[BSDataProvider sharedInstance] dictFromSQL];
        NSArray *fileNames = [infoDict objectForKey:@"FileList"];
        int count = [fileNames count];
        for (int i=0;i<count;i++){
        NSString *fileName = [fileNames objectAtIndex:i];
         NSString *path = [docPath stringByAppendingPathComponent:fileName];
         NSString *strURL = [[ftpurl stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
        imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
        [imgData writeToFile:path atomically:NO];
         bs_dispatch_sync_on_main_thread(^{
        lblDownloading.text = [NSString stringWithFormat:@"正在更新              %d/%d",i+1,count];
         });
        }
    }
    
        
        
        //Refresh Files Ended
    [self performSelectorOnMainThread:@selector(finishedDownloading:) withObject:[NSNumber numberWithBool:valid] waitUntilDone:NO];
    
}

- (void)confirm{
    lblTips.hidden = YES;
    tfSetting.hidden = YES;
    tfUser.hidden = YES;
    tfPass.hidden = YES;
    lblUser.hidden = YES;
    lblPath.hidden = YES;
    lblPass.hidden = YES;
    lblSetting.hidden = YES;
    lblChecking.hidden = NO;
    indicator.hidden = NO;
    [indicator startAnimating];
    
    [NSThread detachNewThreadSelector:@selector(checkFTPSetting) toTarget:self withObject:nil];
}

- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkFTPSetting{
    
    BOOL valid = NO;
    NSURLRequest *request;
    NSURL *url = nil;
    NSString *str=nil;
    NSURLResponse* response = nil;
    NSError *error = nil;
    NSData *serviceData;
    for (int i=0; i<2; i++) {
        
        str = [tfSetting.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if ([tfUser.text length]==0 || [tfPass.text length]==0){
            if ([str length]==0)
                str = @"null";
            else
            {
                if (i==0) {
                    str = [NSString stringWithFormat:@"ftp://%@/BookSystem/BookSystem.sqlite",str];
                }else
                {
                    str = [NSString stringWithFormat:@"ftp://%@/BookSystem.sqlite",str];
                }
                
            }
        }
        else{
            if ([str length]==0)
                str = @"null";
            else
            {
                if (i==0) {
                    str = [NSString stringWithFormat:@"ftp://%@:%@@%@/BookSystem/BookSystem.sqlite",tfUser.text,tfPass.text,str];
                }else
                {
                    str = [NSString stringWithFormat:@"ftp://%@:%@@%@/BookSystem.sqlite",tfUser.text,tfPass.text,str];
                }
                
            }
        }
        url = [NSURL URLWithString:str];
        request = [[NSURLRequest alloc] initWithURL:url
                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:5.0];
        serviceData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response
                                                        error:&error];
        NSLog(@"Error Info:%@",error);
        if (serviceData) {
            break;
        }
    }
    
    
    
    // retreive the data using timeout
    
    
    
    
    
    // 1001 is the error code for a connection timeout
    if (!serviceData) {
        valid = NO;
    }
    else{
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        if (data==nil){
            valid = NO;
        }
        
        else{
            valid = YES;
            NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docPath = [docPaths objectAtIndex:0];
            NSString *settingPath = [docPath stringByAppendingPathComponent:@"setting.plist"];
            [[NSDictionary dictionaryWithObject:[str stringByReplacingOccurrencesOfString:@"BookSystem.sqlite" withString:@""] forKey:@"url"] writeToFile:settingPath atomically:NO];
            
        }
    }
    
    
    [self performSelectorOnMainThread:@selector(finishedChecking:) withObject:[NSNumber numberWithBool:valid] waitUntilDone:NO];

}

- (void)finishedChecking:(NSNumber *)pass{
    BOOL valid = [pass boolValue];
    if (valid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"FTP地址设置成功，请重新运行程序以使设置生效" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"FTP地址设置失败，请检查地址或网络连接状况" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        lblTips.hidden = NO;
        tfSetting.hidden = NO;
        tfUser.hidden = NO;
        tfPass.hidden = NO;
        lblUser.hidden = NO;
        lblPath.hidden = NO;
        lblPass.hidden = NO;
        lblSetting.hidden = NO;
        lblChecking.hidden = YES;
        indicator.hidden = YES;
        [indicator stopAnimating];
    }
}

- (void)finishedDownloading:(NSNumber *)pass{
    BOOL valid = [pass boolValue];
    
    if (valid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"下载完成，请重新运行程序以使设置生效" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag=1001;
        [alert show];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentPageConfig"];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"下载失败，请检查FTP配置或网络连接状况" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)updataHHT
{

    NSDictionary *dict=[[BSDataProvider sharedInstance] updateDataVersion:[Singleton sharedSingleton].dataVersion];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
    bs_dispatch_sync_on_main_thread(^{
        [self.navigationController popViewControllerAnimated:YES];
    });
//    AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
//    netAccess.delegate=self;
//    //    [self.view addSubview:HUD];
//    
//    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",netAccess.dataVersion,@"dataVersion", nil];
//    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"updateDataVersion"]] andPost:dict andTag:updateDataVersion];
}

-(void)HHTupdateDataVersionSuccessFormWebService:(NSDictionary *)dict
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showAlert:(int )alertTag andTitle:(NSString *)message
{
    if(alertTag==0)
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                            message:@"\n"
                                                           delegate:nil
                                                  cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"NO"]
                                                  otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],nil];
            alert.tag=alertTag;
            [alert show];
            
        });
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                            message:@"\n"
                                                           delegate:self
                                                  cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"NO"]
                                                  otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],nil];
            alert.tag=alertTag;
            [alert show];
            
        });
    }
    
}

//解析请求数据
-(NSArray *)getArrayWithDict:(NSDictionary *)dict andFunction:(NSString *)functionName
{
    NSString *str=[[[dict objectForKey:[NSString stringWithFormat:@"ns:%@Response",functionName]]objectForKey:@"ns:return"]objectForKey:@"text"];
    NSArray *array=[str componentsSeparatedByString:@"@"];
    return array;
}

-(void)failedFromWebServie
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                  message:@"网络连接失败，请检查网络！"
                                                 delegate:nil
                                        cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                        otherButtonTitles:nil];
    [alert show];
}

- (void)setType:(BSSettingType)type{
    settingType = type;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==1001)
    {
        [NSThread detachNewThreadSelector:@selector(updataHHT) toTarget:self withObject:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
