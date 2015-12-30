//
//  BSSearchViewController.m
//  BookSystem
//
//  Created by Dream on 11-6-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSResvSearchViewController.h"
#import "BSDataProvider.h"
#import "CVLocalizationSetting.h"

@implementation BSResvSearchViewController

@synthesize delegate,aryFoods,aryDisplayList;

- (NSString *)strInput{
    return strInput;
}

- (void)setStrInput:(NSString *)strInput_{
    if (strInput_!=strInput){
//        BSDataProvider *dp = [BSDataProvider sharedInstance];
        
        NSString *str = [strInput_ copy];
        [strInput release];
        strInput = str;
        
        [aryDisplayList removeAllObjects];
        
        
        
        if ([str length]>0){
            for (int i=0;i<[aryFoods count];i++){
                NSDictionary *testdict = [aryFoods objectAtIndex:i];
                
                NSString *address = [testdict objectForKey:@"address"];
                NSString *name = [testdict objectForKey:@"name"];
                NSString *mobile = [testdict objectForKey:@"mobile"];
                NSString *time = [testdict objectForKey:@"time"];
                
                if ([time rangeOfString:str].location!=NSNotFound ||
                    [name rangeOfString:str].location!=NSNotFound ||
                    [mobile rangeOfString:str].location!=NSNotFound ||
                    [address rangeOfString:str].location!=NSNotFound){
                    [aryDisplayList addObject:testdict];
                }

            }
        }
        [tvFoods reloadData];
    }
}

- (void)dealloc
{
    [vHeader release];
    self.delegate = nil;
    self.aryFoods = nil;
    self.aryDisplayList = nil;
    self.strInput = nil;
    
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
    BSDataProvider *dp = [BSDataProvider sharedInstance];
    
    self.aryFoods = [dp getAllFoods];
    self.aryDisplayList = [NSMutableArray array];
    
    tvFoods = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 360)];
    tvFoods.delegate = self;
    tvFoods.dataSource = self;
    [self.view addSubview:tvFoods];
    [tvFoods release];
    
}

/*
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark TableView Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.aryDisplayList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [aryDisplayList objectAtIndex:indexPath.row];
    
    NSMutableArray *aryKeysValues = [NSMutableArray arrayWithObjects:@"acct",@"帐单号",@"name",@"客户姓名",@"business",@"地址",@"mobile",@"手机号码",@"number",@"人数",
                                     @"remark",@"预订人备注信息",@"time",@"客到时间",@"interest",@"喜好的菜品",@"business",@"维护人",@"num",@"已预定菜数量",@"price",@"已预订菜总价",nil];
    for (int i=0;i<10;i++){
        [aryKeysValues addObject:[NSString stringWithFormat:@"f%d",i+1]];
        [aryKeysValues addObject:[NSString stringWithFormat:@"附加项%d",i+1]];
    }
    NSMutableString *str = [NSMutableString string];
    for (int i=0;i<[aryKeysValues count]/2;i++){
        if ([dict objectForKey:[aryKeysValues objectAtIndex:i*2]])
            [str appendFormat:@"%@:%@\n",[aryKeysValues objectAtIndex:i*2+1],[dict objectForKey:[aryKeysValues objectAtIndex:i*2]]];
    }
    //        for (NSString *key in [dict allKeys]){
    //            [str appendFormat:@"%@:%@\n",key,[dict objectForKey:key]];
    //        }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"预订信息" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (!vHeader){
        vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 40)];
        vHeader.backgroundColor = [UIColor grayColor];
        
        UILabel *lblCode = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 165, 40)];
        lblCode.tag = 700;
        lblCode.backgroundColor = [UIColor clearColor];
        lblCode.font = [UIFont systemFontOfSize:14];
        [vHeader addSubview:lblCode];
        [lblCode release];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(175, 0, 60, 40)];
        lblName.tag = 701;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont systemFontOfSize:14];
        [vHeader addSubview:lblName];
        [lblName release];
        
        UILabel *lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(265, 0, 50, 40)];
        lblUnit.tag = 702;
        lblUnit.backgroundColor = [UIColor clearColor];
        lblUnit.font = [UIFont systemFontOfSize:14];
        [vHeader addSubview:lblUnit];
        [lblUnit release];
        
        UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 50, 40)];
        lblPrice.tag = 703;
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.font = [UIFont systemFontOfSize:14];
        [vHeader addSubview:lblPrice];
        [lblPrice release];
        
        lblCode.text = @"姓名";
        lblName.text = @"手机号码";
        lblPrice.text = @"地址";
        lblUnit.text = @"客到时间";
    }
    
    
    
    
    
    return vHeader;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        UILabel *lblCode = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 155, 40)];
        lblCode.tag = 700;
        lblCode.backgroundColor = [UIColor clearColor];
        lblCode.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lblCode];
        [lblCode release];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(165, 0, 100, 40)];
        lblName.tag = 701;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lblName];
        [lblName release];
        
        UILabel *lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(265, 0, 50, 40)];
        lblUnit.tag = 702;
        lblUnit.backgroundColor = [UIColor clearColor];
        lblUnit.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lblUnit];
        [lblUnit release];
        
        UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 50, 40)];
        lblPrice.tag = 703;
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lblPrice];
        [lblPrice release];
    }
    
    UILabel *lblCode = (UILabel *)[cell.contentView viewWithTag:700];
    UILabel *lblName = (UILabel *)[cell.contentView viewWithTag:701];
    UILabel *lblUnit = (UILabel *)[cell.contentView viewWithTag:702];
    UILabel *lblPrice = (UILabel *)[cell.contentView viewWithTag:703];
    
    NSDictionary *dic = [aryDisplayList objectAtIndex:indexPath.row];
    lblCode.text = [dic objectForKey:@"name"];
    lblName.text = [dic objectForKey:@"mobile"];
    lblUnit.text = [dic objectForKey:@"time"];
    lblPrice.text = [dic objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"address"]];
    
    
    return cell;
}
@end
