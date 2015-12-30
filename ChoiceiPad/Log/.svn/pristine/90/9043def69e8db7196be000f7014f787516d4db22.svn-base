//
//  BSSearchViewController.m
//  BookSystem
//
//  Created by Dream on 11-6-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSSearchViewController.h"
#import "BSDataProvider.h"
#import "CVLocalizationSetting.h"
#import "BSSearchCell.h"

@implementation BSSearchViewController

@synthesize delegate,aryFoods,aryDisplayList;

- (NSString *)strInput{
    return strInput;
}

- (void)setStrInput:(NSString *)strInput_{
    NSLog(@"Old:%@,New:%@",strInput,strInput_);
    if (strInput_!=strInput){
        BSDataProvider *dp = [BSDataProvider sharedInstance];
        
        NSString *str = [strInput_ copy];
        [strInput release];
        strInput = str;
        
        [aryDisplayList removeAllObjects];
        
        
        
        if ([str length]>0){
            int count = strlen([strInput UTF8String]);
            int len = [strInput length];
            
            char a = [strInput characterAtIndex:0];
                
            if (a>='0' && a<='9'){
                NSArray *ary = [dp getFoodList:[NSString stringWithFormat:@"ITCODE like '%%%@%%'",strInput]];
                [aryDisplayList addObjectsFromArray:ary];
            }
            else if (count==len && ((a>='A' && a<='Z') || (a>='a' && a<='z'))){
                NSArray *ary = [dp getFoodList:[NSString stringWithFormat:@"(DESCE like '%%%@%%') or (INIT like '%%%@%%')",strInput,strInput]];
                [aryDisplayList addObjectsFromArray:ary];
            }
            else{
                NSArray *ary = [dp getFoodList:[NSString stringWithFormat:@"DES like '%%%@%%'",strInput]];
                [aryDisplayList addObjectsFromArray:ary];
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
    
    tvFoods = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 275, 360)];
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
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BSSearchCell *cell = (BSSearchCell *)[tableView cellForRowAtIndexPath:indexPath];
    [delegate didSelectItem:cell.dicInfo];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (!vHeader){
        vHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 40)];
        vHeader.backgroundColor = [UIColor grayColor];
        
        UILabel *lblCode = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 75, 40)];
        lblCode.tag = 700;
        lblCode.backgroundColor = [UIColor clearColor];
        lblCode.font = [UIFont systemFontOfSize:14];
        [vHeader addSubview:lblCode];
        [lblCode release];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 75, 40)];
        lblName.tag = 701;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont systemFontOfSize:14];
        [vHeader addSubview:lblName];
        [lblName release];
        
        UILabel *lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(165, 0, 50, 40)];
        lblUnit.tag = 702;
        lblUnit.backgroundColor = [UIColor clearColor];
        lblUnit.font = [UIFont systemFontOfSize:14];
        [vHeader addSubview:lblUnit];
        [lblUnit release];
        
        UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 50, 40)];
        lblPrice.tag = 703;
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.font = [UIFont systemFontOfSize:14];
        [vHeader addSubview:lblPrice];
        [lblPrice release];
        
        lblCode.text = @"菜品号码";
        lblName.text = @"菜品名称";
        lblPrice.text = @"价格";
        lblUnit.text = @"单位";
    }
    
    
    
    
    
    return vHeader;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    
    BSSearchCell *cell = (BSSearchCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[[BSSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    [cell showInfo:[aryDisplayList objectAtIndex:indexPath.row]];

    
    
    return cell;
}
@end
