//
//  BSAllCheakRight.m
//  BookSystem
//
//  Created by chensen on 14-1-18.
//
//

#import "BSAllCheakRight.h"
#import "BSDataProvider.h"
#import "BSAllCheakRightCell.h"
#import "CVLocalizationSetting.h"

@interface BSAllCheakRight ()

@end

@implementation BSAllCheakRight
{
    UITableView *_table;
    NSArray *_dataArray;
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
    self.view.backgroundColor=[UIColor whiteColor];
    [self updata];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    [image setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"LeftTitle.png"]];
    [self.view addSubview:image];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (updata) name:@"updata" object:nil];
    
}
-(void)updata
{
    if ([_dataArray count]>0) {
        _table=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 280, 1024-44) style:UITableViewStylePlain];
        _table.delegate=self;
        _table.dataSource=self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_table];
    }
   
    [_table reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellName";
    BSAllCheakRightCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[BSAllCheakRightCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    NSLog(@"%@",_dataArray);
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"ISTC"] intValue]==0) {
        cell.lblName.text=[dict objectForKey:@"PCname"];
        cell.lblOver.text=[dict objectForKey:@"sum(Over)"];
        cell.lblCount.text=[dict objectForKey:@"sum(pcount)"];
    }else
    {
    if ([[dict objectForKey:@"Pcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]) {
        cell.lblName.text=[dict objectForKey:@"PCname"];
        cell.lblOver.text=[dict objectForKey:@"Over"];
        cell.lblCount.text=[dict objectForKey:@"pcount"];
    }
        else
        {
            cell.lblName.text=[NSString stringWithFormat:@"--%@",[dict objectForKey:@"PCname"]];
            cell.lblOver.text=[dict objectForKey:@"Over"];
            cell.lblCount.text=[dict objectForKey:@"pcount"];
        }
    }
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
