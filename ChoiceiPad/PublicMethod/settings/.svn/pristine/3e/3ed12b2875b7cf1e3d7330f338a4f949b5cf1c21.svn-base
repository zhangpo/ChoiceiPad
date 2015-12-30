//
//  BSPageConfigViewController.m
//  BookSystem
//
//  Created by Stan Wu on 1/30/13.
//
//

#import "BSPageConfigViewController.h"
#import "BSDataProvider.h"

@interface BSPageConfigViewController ()

@end

@implementation BSPageConfigViewController

- (void)navBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"软件设置";
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(navBack)] autorelease];//[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(releaseSelf)] autorelease];
    
    //    [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(releaseSelf)];
    
    tvConfig = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 540, 620-44) style:UITableViewStyleGrouped];
    [self.view addSubview:tvConfig];
    [tvConfig release];
    tvConfig.delegate = self;
    tvConfig.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)indexOfSelectedConfig{
    int index = -1;
    NSDictionary *current = [[BSDataProvider sharedInstance] currentPageConfig];
    NSArray *ary = [[BSDataProvider sharedInstance] pageConfigList];
    
    for (int i=0;i<ary.count;i++){
        BOOL isSame = YES;
        NSDictionary *dict = [ary objectAtIndex:i];
        for (NSString *key in dict.allKeys){
            if (![[dict objectForKey:key] isEqualToString:[current objectForKey:key]]){
                isSame = NO;
                break;
            }
        }
        if (isSame){
            index = i;
            break;
        }
    }
        
    return index;
}

#pragma mark -
#pragma mark UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ConfigruationCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        cell.detailTextLabel.numberOfLines = 0;
//        cell.detailTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    }
    
    int row = indexPath.row;
    NSArray *ary = [[BSDataProvider sharedInstance] pageConfigList];
    NSDictionary *dict = [ary objectAtIndex:row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",[dict objectForKey:@"name"],[dict objectForKey:@"number"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",[dict objectForKey:@"layout"],[dict objectForKey:@"sqlite"]];
    
    int selectedIndex = [self indexOfSelectedConfig];
    
    cell.accessoryType = selectedIndex==row?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[BSDataProvider sharedInstance] pageConfigList] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"变更配置文件" message:@"是否确定要变更页面配置文件？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = indexPath.row;
    [alert show];
    [alert release]; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"选择页面配置文件";
            break;
        default:
            return nil;
            break;
    }
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]){
        int index = alertView.tag;
        [[NSUserDefaults standardUserDefaults] setObject:[[[BSDataProvider sharedInstance] pageConfigList] objectAtIndex:index] forKey:@"CurrentPageConfig"];
        
        [tvConfig reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageConfigChanged" object:nil];
    }
}

@end
