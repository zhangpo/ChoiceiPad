//
//  AKOrderLeft.m
//  BookSystem
//
//  Created by chensen on 14-1-12.
//
//

#import "AKOrderLeft.h"
#import "AKOrderRepastViewController.h"
#import "Singleton.h"
#import "AKOredrCell.h"
#import "CVLocalizationSetting.h"

@interface AKOrderLeft ()

@end

@implementation AKOrderLeft
{
    NSMutableArray *_dataArray;
    UITableView *table;
    NSMutableArray *array;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    [image setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"RightTitle.jpg"]];
    [self.view addSubview:image];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (mydish:) name:@"postData" object:nil];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 280, 1024-50) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - 通知
-(void)mydish:(NSNotification *)center
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //异步操作代码块
        NSArray *array1=[[NSArray alloc] initWithArray:(NSArray *)center.object];
        _dataArray=[[NSMutableArray alloc] initWithArray:array1];
        int i=0;
        for (NSDictionary *dict in array1) {
            if ([[dict objectForKey:@"ISTC"] intValue]==1) {
                NSArray *array2=[dict objectForKey:@"combo"];
                NSRange range = NSMakeRange(i+1, [array2 count]);
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                [_dataArray insertObjects:array2 atIndexes:indexSet];
                i+=[array2 count];
            }
            i++;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
        
            //回到主线程操作代码块
            [table reloadData];
            
        });
    
    });
    
}
#pragma mark - tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    
    AKOredrCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[AKOredrCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.name.text=@"";
    cell.count.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"total"];
    if ([[_dataArray objectAtIndex:indexPath.row] objectForKey:@"CNT"]==nil) {
        cell.name.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"DES"];
    }else
    {
        cell.name.text=[NSString stringWithFormat:@"--%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PNAME"]==nil?[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"DES"]:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PNAME"]];
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
