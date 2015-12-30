//
//  BSBGSettingViewController.m
//  BookSystem
//
//  Created by Dream on 11-7-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSBGSettingViewController.h"


@implementation BSBGSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 540, 50)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont boldSystemFontOfSize:26];
    lbl.textAlignment = UITextAlignmentCenter;
    lbl.text = @"选择你喜欢的背景图片";
    [self.view addSubview:lbl];
    [lbl release];
    
    scvBGs = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 540, 944)];
    [self.view addSubview:scvBGs];
    [scvBGs release];
    BSDataProvider *dp = [BSDataProvider sharedInstance];
    
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    
    NSArray *aryBGs = [dp getAllBG];
    
    int count = [aryBGs count];
    if (count){
        int rows;
        if (count%3!=0)
            rows = count/3+1;
        else
            rows = count/3;
        [scvBGs setContentSize:CGSizeMake(540, 334*rows)];
        //768*1024    384*512   768-40/3  243   324
        for (int i=0;i<[aryBGs count];i++){
            int row = i/3;
            int column = i%3;
            //      UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(253*column, 334*row, 243, 324)];
            NSString *imgPath = [docPath stringByAppendingPathComponent:[[aryBGs objectAtIndex:i] objectForKey:@"name"]];
            UIImage *img = [[UIImage alloc] initWithContentsOfFile:imgPath];
            //        [imgv setImage:img];
            //        [img release];
            
            //        [scvBGs addSubview:imgv];
            //        [imgv release];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+253*column, 334*row, 243, 324);
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            [img release];
            //      btn.backgroundColor = [UIColor blackColor];
            [scvBGs addSubview:btn];
            [btn addTarget:self action:@selector(imageSelected:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有可供选择的背景图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void)imageSelected:(UIButton *)btn{
    BSDataProvider *dp = [BSDataProvider sharedInstance];
    
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:kBGFileName];
    
    NSArray *aryBGs = [dp getAllBG];
    
    [[aryBGs objectAtIndex:btn.tag] writeToFile:path atomically:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置成功" message:@"背景图片设置成功，将在下次运行时生效。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
