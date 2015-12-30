//
//  AKOrderRepastViewController.m
//  BookSystem
//
//  Created by chensen on 13-11-13.
//
//
#import "AKOrederClassButton.h"
#import "ZCOrderRepastViewController.h"
#import "Singleton.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"
#import "BSDataProvider.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "ZCLogViewController.h"
#import "AKsIsVipShowView.h"
#import "AKComboButton.h"
#import "SVProgressHUD.h"
#import "CVLocalizationSetting.h"
#import "AKsNetAccessClass.h"
#import "ZCPackageView.h"




@interface ZCOrderRepastViewController ()

@end

@implementation ZCOrderRepastViewController
{
    NSArray *_array;
    NSMutableArray *_buttonArray;
    NSMutableArray *_dataArray;
    NSMutableDictionary *_dict;
    NSMutableArray *_searchByName;
    NSMutableArray *_searchByPhone;
    UISearchBar *_searchBar;
    UIScrollView *_scroll;
    NSMutableArray *_Combo;
    NSMutableArray *_ComButton;
    NSMutableArray *_selectArray;
    NSArray *_array1;
    UIImageView *_view;
    UIScrollView *scrollview;
    UIButton *_button;
    NSMutableArray *_allComboArray;
    UIButton *_recommendButton;
    NSArray *arry;
    NSMutableArray *comboFinish;
    NSMutableArray *onlyOne;
    NSMutableArray *_selectCombo;
    //    NSMutableArray *_tableArray;
    AKMySegmentAndView *akmsav;
    UILabel *label;
    NSMutableArray *classButton;
    ZCAdditionalView *vAddition;
    NSMutableDictionary *_dataDic;
    NSMutableDictionary *_Weight;
    UIPanGestureRecognizer *_pan;
    UITableView *_comboTableView;
    UIScrollView *aScrollView;
    int _com;
    int _count;
    int _total;
    int _sele;
    int _btn;
    int _x;
    int _z;
    int cishu;
    int _y;
    ZCPackageView       *_packageView;
    AKsIsVipShowView    *showVip;
    BSDataProvider      *_dp;
    UIScrollView *_RecommendView;
    NSMutableArray *classArray;
    NSArray *_soldOut;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        classArray=[[NSMutableArray alloc] init];;
        classArray =[NSMutableArray arrayWithArray:[dp getClassById]];
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:@"套餐" forKey:@"DES"];
        [dict setObject:@"88" forKey:@"GRP"];
        [classArray insertObject:dict atIndex:0];
    }
    return self;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_dp)
    {
        _dp=nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor=[UIColor whiteColor];
    akmsav= [AKMySegmentAndView shared];
    [akmsav segmentShow:YES];
    [akmsav shoildCheckShow:NO];
    akmsav.frame=CGRectMake(0, 0, 768, 114);
    akmsav.delegate=self;
    
    [self.view addSubview:akmsav];
    if(!_dp)
    {
        _dp=[BSDataProvider sharedInstance];
        _soldOut=[_dp ZCEstimatesFoodList];
        [self upload];
        
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _y=0;
    aScrollView=[[UIScrollView alloc] init];
    aScrollView.frame=CGRectMake(80,175, 688, 740);
    aScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:aScrollView];
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tuodongView:)];
    _pan.delaysTouchesBegan=YES;
    _allComboArray=[[[BSDataProvider alloc] init] ZCallCombo];
    _dataDic=[NSMutableDictionary dictionary];
    classButton=[[NSMutableArray alloc] init];
    _selectCombo=[[NSMutableArray alloc] init];
    [self searchBarInit];
    
    int i=[classArray count];
    // Do any additional setup after loading the view from its nib.
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 170, 100, 1024-190)];
    //scrollview.backgroundColor=[UIColor redColor];
    //    scrollview.contentOffset=CGPointMake(768/9*i, 40);
    [scrollview setContentSize:CGSizeMake(100,60*i)];
    [self.view addSubview:scrollview];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 60*i)];
    [image setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"ClassBG.png"]];
    [scrollview addSubview:image];
    int j=0;
    for (NSDictionary *dict in classArray) {
        AKOrederClassButton *btn=[[AKOrederClassButton alloc] initWithFrame:CGRectMake(0,60*j,90, 59)];
        [btn.button setTitle:[dict objectForKey:@"DES"] forState:UIControlStateNormal];
        btn.button.tag=j;
        [btn.button addTarget:self action:@selector(segmentClick1:) forControlEvents:UIControlEventTouchUpInside];
        [scrollview addSubview:btn];
        [classButton addObject:btn];
        j++;
    }
    _count=0;
    _total=1;
    _ComButton=[[NSMutableArray alloc] init];
    _Combo=[[NSMutableArray alloc] init];
    _array=[[NSArray alloc] init];
    //_array=[BSDataProvider selectFood:1];
    
    _dataArray=[[NSMutableArray alloc] init];
    _searchByName=[[NSMutableArray alloc] init];
    _searchByPhone=[[NSMutableArray alloc] init];
    _dict=[[NSMutableDictionary alloc] init];
    _scroll=[[UIScrollView alloc] init];
    _scroll.bounces=NO;
    _view=[[UIImageView alloc] init];
    _view.frame=CGRectMake(90, 350, 678, 580);
    [_view setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Packagebg.png"]];
    _view.userInteractionEnabled=YES;
    _scroll.frame=CGRectMake(0, 60,678, 500);
    [_view addSubview:_scroll];
    [self.view addSubview:_view];
    [self.view sendSubviewToBack:_view];
    _RecommendView=[[UIScrollView alloc] initWithFrame:CGRectMake(90, 450, 678, 400)];
    _RecommendView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:_RecommendView];
    
    NSArray *array=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"Additions"],[[CVLocalizationSetting sharedInstance] localizedString:@"OrderedFood"],[[CVLocalizationSetting sharedInstance] localizedString:@"Back"], nil];
    for (int i=0; i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(270+125*i, 1024-70, 140, 60);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 125, 30)];
        lb.text=[array objectAtIndex:i];
        if ([[[NSUserDefaults standardUserDefaults]
              stringForKey:@"language"] isEqualToString:@"en"])
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:17];
        else
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        //        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonRed"] forState:UIControlStateNormal];
        //        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.tintColor=[UIColor whiteColor];
        if (i==0) {
            [btn addTarget:self action:@selector(Beizhu:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1)
        {
            [btn addTarget:self action:@selector(alreadyBuyGreens:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(i==2){
            [btn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:btn];
    }
    _recommendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _recommendButton.frame=CGRectMake(60, 800, 60, 60);
    _RecommendView.frame=_recommendButton.frame;
    [_recommendButton addGestureRecognizer:_pan];
    [_recommendButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"sweep.png"] forState:UIControlStateNormal];
    _recommendButton.hidden=YES;
    
    [_recommendButton addTarget:self action:@selector(recommendShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recommendButton];
    _RecommendView.hidden=YES;
    [_RecommendView sendSubviewToBack:_view];
    //    [_RecommendView ]
    
    
    
    //    _tableArray=[[NSMutableArray alloc] init];
    
}
-(void)recommendShow
{
    if (_RecommendView.hidden==NO) {
        [UIView animateWithDuration:0.3f animations:^{
            _RecommendView.frame = _recommendButton.frame;
        }completion:^(BOOL finished) {
            _RecommendView.hidden=YES;
        }];
    }else
    {
        _RecommendView.hidden=NO;
        [UIView animateWithDuration:0.3f animations:^{
            _RecommendView.frame = CGRectMake(90, 450, 678, 450);
        }completion:^(BOOL finished) {
            
            [_RecommendView bringSubviewToFront:self.view];
        }];
    }
    
}
//界面可拖动
-(void)tuodongView:(UIPanGestureRecognizer *)pan
{
    UIView *piece = [pan view];
    _RecommendView.frame=_recommendButton.frame;
    if ([pan state] == UIGestureRecognizerStateBegan || [pan state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [pan translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y+ translation.y)];
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
}

//类别按钮事件
- (void)segmentClick1:(UIButton *)sender
{
    if ([_Combo count]>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前的套餐没有选择完毕" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    for (AKOrederClassButton *btn in [aScrollView subviews]) {
        [btn removeFromSuperview];
    }
    //    _count=sender.selectedSegmentIndex;
    [self button:sender.tag];
}
-(void)upload
{
    _selectArray=[[NSMutableArray alloc] init];;
    _buttonArray=[[NSMutableArray alloc] init];
    self.navigationController.navigationBarHidden = YES;
    NSMutableArray *ary =[Singleton sharedSingleton].dishArray;
    NSMutableArray *deleteArray=[[NSMutableArray alloc] init];
    int i=0;
    for (NSDictionary *dict in ary) {
        if ([[dict objectForKey:@"ISTC"] intValue]==1&&[[dict objectForKey:@"isShow"] boolValue]) {
            [dict setValue:@"NO" forKey:@"isShow"];
            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
            [dict1 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
            [dict1 setObject:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"combo"] count]] forKey:@"count"];
            [deleteArray addObject:dict1];
        }
        i++;
    }
    i=0;
    for (NSDictionary *dict in deleteArray) {
        NSRange range = NSMakeRange(i+[[dict objectForKey:@"index"] intValue]+1,[[dict objectForKey:@"count"] intValue]);
        i+=[[dict objectForKey:@"count"] intValue];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [ary removeObjectsAtIndexes:indexSet];
    }
    for (UIButton *btn in [aScrollView subviews])
    {
        [btn removeFromSuperview];
    }
    [_dataArray removeAllObjects];
    [self button:0];
    [_selectArray removeAllObjects];
    [_ComButton removeAllObjects];
    
    NSArray *array=[_dp selectCache];
    
    if (![ary count])
    {
        NSMutableArray *array1=[NSMutableArray arrayWithArray:array];
        [_selectArray addObjectsFromArray:array1];
    }
    [_selectArray addObjectsFromArray:ary];
    [self changeButtonColor];
    [ary removeAllObjects];
    [_RecommendView sendSubviewToBack:self.view];
}
-(void)changeButtonColor
{
    for (int i=0; i<[classArray count]; i++) {
        for (int j=0;j<[[_buttonArray objectAtIndex:i] count];j++) {
            int x=0;
            AKComboButton *btn=[[_buttonArray objectAtIndex:i] objectAtIndex:j];
            for (NSDictionary *str in _soldOut) {
                if ([[[[_dataArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"ITCODE"] isEqualToString:[str objectForKey:@"ITCODE"]]) {
                    x++;
                }
            }
            if (x>0) {
                [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"assess.png"] forState:UIControlStateNormal];
            }else
            {
                [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (btn.selected==NO) {
                [[[btn subviews] lastObject] removeFromSuperview];
                btn.selected=YES;
            }
            for (NSDictionary *dict in _selectArray) {
                int k=0;
                int x=0;
                NSString *str=[dict objectForKey:@"DES"];
                if ([btn.titleLabel.text isEqualToString:str]) {
                    if (btn.selected==NO) {
                        btn.lblCount.text=@"";
                        btn.selected=YES;
                    }
                    for (NSDictionary *dict1 in _selectArray) {
                        if ([[dict1 objectForKey:@"DES"] isEqualToString:str]) {
                            k=k+[[dict1 objectForKey:@"total"] intValue];
                        }
                    }
                    if ([dict objectForKey:@"Tpcode"]==nil||[[dict objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[dict objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"ITCODE"]]||[[dict objectForKey:@"Tpcode"] isEqualToString:@""]) {
                        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"] forState:UIControlStateNormal];
                        btn.selected=NO;
                        btn.lblCount.text=[NSString stringWithFormat:@"%d",k];
                    }
                }
                
                x++;
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [self updataTitle];
}
- (void)searchBarInit {
    _searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 120, 768, 50)];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
	_searchBar.placeholder=@"搜索";
	_searchBar.delegate = self;
	_searchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:_searchBar];
}
- (void)additionSelected:(NSArray *)ary{
    if (ary) {
        [_dataDic setValue:ary forKey:@"addition"];
    }
    [vAddition removeFromSuperview];
}
-(void)updataTitle
{
    for (int i=0; i<[classArray count]; i++) {
        int j=0;
        AKOrederClassButton *button=[classButton objectAtIndex:i];
        for (AKComboButton *btn in [_buttonArray objectAtIndex:i]) {
            if (btn.selected==NO) {
                j+=[btn.lblCount.text intValue];
            }
        }
        if (j==0) {
            button.label.text=@"";
            button.frame=CGRectMake(0,60*i,90, 59);
            button.button.frame=CGRectMake(0,0,90,59);
            [button.button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"ClassShort.png"] forState:UIControlStateNormal];
        }
        else
        {
            button.frame=CGRectMake(0,60*i,100, 59);
            button.button.frame=CGRectMake(0,0,100,59);
            [button.button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"ClassLong.png"] forState:UIControlStateNormal];
            button.label.text=[NSString stringWithFormat:@"%d",j];
        }
    }
    
}
-(void)button:(int)tag
{
    if ([_buttonArray count]==0) {
        int k=0;
        for (int j=0; j<[classArray count]; j++) {
            NSArray *array1=[BSDataProvider ZCgetFoodList:[NSString stringWithFormat:@"%@",[[classArray objectAtIndex:j] objectForKey:@"GRP"]]];
            NSMutableArray *array2=[[NSMutableArray alloc] init];
            for (int i=0; i<[array1 count]; i++)
            {
                AKComboButton *btn=[AKComboButton buttonWithType:UIButtonTypeCustom];
                btn.selected=YES;
                
                if ([[[array1 objectAtIndex:i] objectForKey:@"ISTC"] intValue]==1) {
                    btn.tag=i+10000;
                }
                else
                {
                    btn.tag=i;
                }
                btn.dataInfo=[array1 objectAtIndex:i];
                btn.lblCount.frame=CGRectMake(70,50, 50, 30);
                btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
                btn.tintColor=[UIColor whiteColor];
                btn.titleLabel.numberOfLines=2;
                [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
                btn.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                [btn setTitle:[[array1 objectAtIndex:i] objectForKey:@"DES"] forState:UIControlStateNormal];
                [array2 addObject:btn];
                SearchBage *search=[[SearchBage alloc] init];
                search.localID = [NSNumber numberWithInt:k];
                search.name=[[array1 objectAtIndex:i] objectForKey:@"DES"];
                NSMutableArray *ary=[[NSMutableArray alloc] init];
                if ([[[array1 objectAtIndex:i] objectForKey:@"ISTC"] intValue]==1)
                    [ary addObject:[[array1 objectAtIndex:i] objectForKey:@"PACKID"]];
                else
                    [ary addObject:[[array1 objectAtIndex:i] objectForKey:@"ITCODE"]];
                search.phoneArray=ary;
                [_dict setObject:search forKey:search.localID];
                [[SearchCoreManager share] AddContact:search.localID name:search.name phone:search.phoneArray];
                k++;
            }
            [_buttonArray addObject:array2];
            //_buttonArray存的是所有的button
            [_dataArray addObject:array1];
            //_dataArray存的是所有的菜的数据
        }
    }
    _array=[_buttonArray objectAtIndex:tag];
    for (int i=0; i<[classArray count]; i++) {
        int k=0;
        for (AKComboButton *btn in [_buttonArray objectAtIndex:i]) {
            btn.frame=CGRectMake(k%5*135+15,k/5*90+15,120,80);
            k++;
        }
    }
    //    aScrollView.backgroundColor=[UIColor redColor];
    for (AKComboButton *btn in _array) {
        [aScrollView addSubview:btn];
    }
    [aScrollView setContentSize:CGSizeMake(688, [_array count]/5*90+114)];
}
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    for (UIButton *btn in [aScrollView subviews]) {
        [btn removeFromSuperview];
    }
    //    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:nil];
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:_searchByPhone];
    
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [[NSMutableArray alloc] init];;
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (int i=0; i<[_searchByName count]; i++) {//搜索到的
        localID = [_searchByName objectAtIndex:i];
        //姓名匹配 获取对应匹配的拼音串 及高亮位置
        int k=0;
        for (int i=0; i<[classArray count]; i++) {//每一个类
            for (UIButton *btn in [_buttonArray objectAtIndex:i]) {//
                if (k==[localID intValue]) {
                    [_dict objectForKey:localID];
                    [array addObject:btn];
                    if ([_searchBar.text length]) {
                        [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
                    }
                }
                k++;
            }
        }
    }
    //    NSNumber *localID = nil;
    //    NSMutableString *matchString = [NSMutableString string];
    //    NSMutableArray *matchPos = [[NSMutableArray alloc] init];;
    NSMutableArray *matchPhones = [[NSMutableArray alloc] init];;
    for (int i=0; i<[_searchByPhone count]; i++) {//搜索到的
        localID = [_searchByPhone objectAtIndex:i];
        int k=0;
        for (int i=0; i<[classArray count]; i++) {//每一个类
            for (UIButton *btn in [_buttonArray objectAtIndex:i]) {//
                if (k==[localID intValue]) {
                    [array addObject:btn];
                    //号码匹配 获取对应匹配的号码串 及高亮位置
                    if ([_searchBar.text length]) {
                        [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
                        [matchString appendString:[matchPhones objectAtIndex:0]];
                    }
                }
                k++;
            }
        }
    }
    //
    //    //姓名匹配 获取对应匹配的拼音串 及高亮位置
    //    if ([self.searchBar.text length]) {
    //        [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
    //    }
    //
    //    //号码匹配 获取对应匹配的号码串 及高亮位置
    //    if ([self.searchBar.text length]) {
    //        [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
    //        [matchString appendString:[matchPhones objectAtIndex:0]];
    //    }
    int a=0;
    _array=array;
    for (AKComboButton *btn in _array) {
        
        btn.frame=CGRectMake(a%5*135+15,a/5*90+15,120,80);
        [aScrollView addSubview:btn];
        a++;
    }
    [aScrollView setContentSize:CGSizeMake(688, [_array count]/5*90+114)];
}
-(void)buttonClick:(AKComboButton *)btn
{
    if(_total==0)
    {
        if (btn.selected==NO){
            if (btn.tag>=10000) {
                int k=0;
                NSMutableArray *array=[[NSMutableArray alloc] init];;
                for (NSDictionary *dict in _selectArray) {
                    NSString *str=[dict objectForKey:@"DES"];
                    if ([str isEqualToString:btn.titleLabel.text]||[[dict objectForKey:@"TPNANE"]isEqualToString:btn.titleLabel.text]) {
                        [array addObject:[NSString stringWithFormat:@"%d",k]];
                    }
                    k++;
                }
                int i=0;
                for (NSString *str in array) {
                    [_selectArray removeObjectAtIndex:[str intValue]-i];
                    i++;
                }
                [_selectCombo removeAllObjects];
                [_ComButton removeAllObjects];
                [_Combo removeAllObjects];
                for (UIButton *btn in [_scroll subviews]) {
                    [btn removeFromSuperview];
                }
                [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
                aScrollView.frame=CGRectMake(80,175, 688, 740);
                [self.view sendSubviewToBack:_view];
            }else{
                int k=0;
                NSMutableArray *array=[[NSMutableArray alloc] init];;
                for (NSDictionary *dict in _selectArray) {
                    NSString *str=[dict objectForKey:@"DES"];
                    if ([str isEqualToString:btn.titleLabel.text]) {
                        [array addObject:[NSString stringWithFormat:@"%d",k]];
                    }
                    k++;
                }
                int i=0;
                for (NSString *str in array) {
                    [_selectArray removeObjectAtIndex:[str intValue]-i];
                    i++;
                }
                
            }
            [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
            btn.lblCount.text=@"";
            btn.selected=YES;
            [self updataTitle];
        }
        
        _total=1;
        [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
        cishu=0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }else
    {
        
        if (_packageView) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前的套餐没有选择完毕，请选择完毕或者取消套餐以后再选择" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
            return;
        }
            if (btn.tag>=10000) {
                _total=1;
            }
            [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"] forState:UIControlStateNormal];
            int i=0;
            if (btn.selected==NO) {
                //                UILabel *lb=[[btn subviews] lastObject];
                i=[btn.lblCount.text intValue]+_total;
                btn.lblCount.text=[NSString stringWithFormat:@"%d",i];
            }else
            {
                btn.lblCount.text=[NSString stringWithFormat:@"%d",_total];
                btn.selected=NO;
            }
            
            if (btn.tag>=10000) {
                _dataDic=btn.dataInfo;
                _packageView=[[ZCPackageView alloc] initWithFrame:CGRectMake(90, 350, 678, 580) withPackId:[btn.dataInfo objectForKey:@"PACKID"]];
                _packageView.delegate=self;
                [self.view addSubview:_packageView];
                _button=btn;
                [_packageView notChangeItem];
            }
            else
            {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:btn.dataInfo];
                _dataDic=dict;
                [_dataDic setValue:[NSString stringWithFormat:@"%d",_total] forKey:@"total"];
                _button=btn;
                [self changeUnit:btn];
            }
        }
}
#pragma mark - ZCPackageViewDelegate
-(void)package:(NSArray *)array
{
    if (array) {
        [_dataDic setObject:array forKey:@"combo"];
        [_dataDic setObject:@"1" forKey:@"total"];
        [self foodPkId];
        [_selectArray addObject:_dataDic];
    }
    [_packageView removeFromSuperview];
    _packageView=nil;
    [self updataTitle];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
}

#pragma mark - 多单位
- (void)changeUnit:(AKComboButton *)btn{
    NSDictionary *food = btn.dataInfo;
    NSMutableArray *mutmut = [[NSMutableArray alloc] init];;
    for (int i=0;i<5;i++){
        NSString *unit = [food objectForKey:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1]];
        NSString *price = [food objectForKey:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1]];
        if (unit && [unit length]>0)
            [mutmut addObject:[NSDictionary dictionaryWithObjectsAndKeys:price,@"price",unit,@"unit", nil]];
    }
    
    if ([mutmut count]>1){
        NSMutableArray *mut = [[NSMutableArray alloc] init];;
        for (int j=0;j<[mutmut count];j++){
            NSString *title = [NSString stringWithFormat:@"%d元/%@",[[[mutmut objectAtIndex:j] objectForKey:@"price"] intValue],[[mutmut objectAtIndex:j] objectForKey:@"unit"]];
            [mut addObject:title];
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择单位"   delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
        // 逐个添加按钮（比如可以是数组循环）
        for (NSString *str in mut) {
            [sheet addButtonWithTitle:str];
        }
        sheet.delegate=self;
        [sheet showFromRect:btn.frame inView:aScrollView animated:YES];
    }else
    {
        [_dataDic setObject:@"UNIT" forKey:@"unitKey"];
        [_dataDic setObject:@"PRICE" forKey:@"priceKey"];
        [self PLUSD];
    }
}
#pragma mark - 第二单位
-(void)PLUSD
{
    if ([[_dataDic objectForKey:@"PLUSD"] intValue]==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入数量" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        alert.tag=10002;
        [alert show];
    }else
    {
        [self necessaryAdditional];
    }
}
#pragma mark - 必选附加项
-(void)necessaryAdditional
{
    NSMutableArray *array=[[NSMutableArray alloc] init];;
    for (int i=1;i<=10;i++) {
        NSString *str=[_dataDic objectForKey:[NSString stringWithFormat:@"RE%d",i]];
        if ([str length]>0) {
            [array addObject:str];
        }
    }
    if ([array count]>0) {
        ZCPrivateAdditionView *v = [[ZCPrivateAdditionView alloc] initWithFrame:CGRectMake(0, 0,320,350) withFcodeArray:array];
        v.delegate=self;
        [self.view addSubview:v];
    }else
    {
        [self addFood];
    }
}
- (void)additionsSelected:(NSArray *)additions
{
    if (additions.count>0)
    {
        [_dataDic setObject:additions forKey:@"addition"];
        [self addFood];
    }else{
        _dataDic=nil;
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSDictionary *food = _dataDic;
    int j = 0;
    int mutIndex = buttonIndex;
    
    for (int i=0;i<5;i++){
        NSString *unit = [food objectForKey:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1]];
        if (unit && [unit length]>0){
            if (j==mutIndex){
                [_dataDic setObject:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1] forKey:@"unitKey"];
                [_dataDic setObject:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1] forKey:@"priceKey"];
            }
            j++;
        }
        
    }
    [self PLUSD];
}
#pragma mark - 添加菜品
-(void)addFood
{
    for (NSDictionary *dict1 in _selectArray) {
        if ([[dict1 objectForKey:@"ISTC"] intValue]==0&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[_dataDic objectForKey:@"ITCODE"]]&&[dict1 objectForKey:@"addition"]==nil&&[[dict1 objectForKey:@"unitKey"] isEqualToString:[_dataDic objectForKey:@"unitKey"]]) {
            [_dataDic setValue:[NSString stringWithFormat:@"%d",_total+[[dict1 objectForKey:@"total"] intValue]] forKey:@"total"];
            [_selectArray removeObject:dict1];
            break;
        }
    }
    [self foodPkId];
    [_selectArray addObject:_dataDic];
    _total=1;
    [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
    cishu=0;
    [self updataTitle];
//    [self PackageGroup];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
}
-(void)foodPkId
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*60*24*3;
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HmmssSS"];
    //用[NSDate date]可以获取系统当前时间
    NSString *yy = [dateFormatter stringFromDate:localeDate];
    NSString *pkid=[NSString stringWithFormat:@"%@%@",yy,[Singleton sharedSingleton].CheckNum];
    [_dataDic setObject:[NSString stringWithFormat:@"%lld",[pkid intValue]-2147483648] forKey:@"PKID"];
}
-(void)selectSegmentIndex:(NSString *)segmentIndex andSegment:(UISegmentedControl *)segment
{
    if(![segmentIndex isEqualToString:@"X"])
    {
        if([[NSString stringWithFormat:@"%d",_total]length]>1)
        {
            _total=1;
            cishu=0;
            [segment setSelectedSegmentIndex:11];
            [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
        }
        else
        {
            int index=[segmentIndex intValue];
            cishu=cishu*10+index;
            _total=cishu;
            [segment setSelectedSegmentIndex:11];
            [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
        }
    }
    else
    {
        _total=1;
        cishu=0;
        [segment setSelectedSegmentIndex:11];
        [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
    }
}



- (IBAction)alreadyBuyGreens:(id)sender//已点菜品
{
    if (_packageView) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的套餐还没有选择完毕" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSArray *foods =[[NSArray alloc] initWithArray:_selectArray];
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    for (int i=0; i<[foods count]; i++) {
        //        for (int j=0; j<[[[foods objectAtIndex:i] objectForKey:@"total"] intValue]; j++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict1=[[NSMutableDictionary alloc] initWithDictionary:[_selectArray objectAtIndex:i]];
        [dict1 setObject:@"UNIT" forKey:@"unitKey"];
        [array1 addObject:dict1];
    }
    [Singleton sharedSingleton].dishArray=array1;
    ZCLogViewController *vbsvc=[[ZCLogViewController alloc] init];
    [self.navigationController pushViewController:vbsvc animated:YES];
}
- (IBAction)Beizhu:(UIButton *)sender {
    if ([_dataDic count]>0) {
        vAddition = [[ZCAdditionalView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withSelectAddtions:[_dataDic objectForKey:@"addition"]];
        vAddition.delegate = self;
        vAddition.center = CGPointMake(self.view.center.x,self.view.center.y);
        //            vAddition.backgroundColor=[UIColor redColor];
        [self.view addSubview:vAddition];
        
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择菜" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)goBack:(id)sender//返回
{
    
    if ([_Combo count]>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"当前套餐没有选择完毕，请将该套餐选择完毕或取消之后再返回" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        [alert show];
        return;
    }
    if ([_selectArray count]>0&&![Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Save the dishes"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],[[CVLocalizationSetting sharedInstance] localizedString:@"NO"], nil];
        alert.tag=1;
        alert.delegate=self;
        [alert show];
    }
    else if (![AKsNetAccessClass sharedNetAccess].isVipShow)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (1==buttonIndex){
            NSMutableArray *array=[[NSMutableArray alloc] initWithArray:_selectArray];
            int i=0,j=0;
            for (NSDictionary *dict in _selectArray) {
                if (![dict objectForKey:@"isShow"]&&[[dict objectForKey:@"ISTC"] intValue]==1) {
                    NSRange range = NSMakeRange(i+1+j,[[dict  objectForKey:@"combo"] count]);
                    j=[[dict objectForKey:@"combo"] count];
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                    [array insertObjects:[dict objectForKey:@"combo"] atIndexes:indexSet];
                }
                i++;
            }
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            [dp cache:array];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Save Success"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
            if(![AKsNetAccessClass sharedNetAccess].isVipShow)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
            }
            
        }else if (2==buttonIndex){
            if(![AKsNetAccessClass sharedNetAccess].isVipShow)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
            }
        }
        
    }
    else  if (alertView.tag==10001)
    {
        [akmsav setTitle:@"1"];
        _total=1;
    }else if (alertView.tag==10002){
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [_dataDic setObject:tf1.text forKey:@"PluseNum"];
        [self necessaryAdditional];
    }
}
-(void)PackageGroup
{
    NSMutableArray *comboAll=[[NSMutableArray alloc] init];;
    for (NSDictionary *dict in _allComboArray) {
        for (NSArray *array in [dict objectForKey:@"combo"]) {
            [comboAll addObjectsFromArray:array];
        }
        
    }
    int x=0;
    //数量置0
    for (NSDictionary *dictAll in comboAll) {
        for (NSDictionary *dictSelect in _selectArray) {
            if ([[dictSelect objectForKey:@"ISTC"] intValue]!=1) {
                [dictAll setValue:@"0" forKey:@"count"];
            }
        }
    }
    for (NSDictionary *dictAll in comboAll) {
        for (NSDictionary *dictSelect in _selectArray) {
            if ([[dictSelect objectForKey:@"ISTC"] intValue]!=1) {
                if ([[dictSelect objectForKey:@"ITCODE"] isEqualToString:[dictAll objectForKey:@"ITCODE"]]) {
                    [dictAll setValue:[dictSelect objectForKey:@"total"] forKey:@"count"];
                    x++;
                }
            }
        }
    }
    
    comboFinish=[[NSMutableArray alloc] init];;//可选择套餐
    onlyOne=[[NSMutableArray alloc] init];;//推荐套餐
    for (int i=0;i<[_allComboArray count];i++) {//所有的套餐
        NSMutableArray *array=[[_allComboArray objectAtIndex:i] objectForKey:@"combo"];//单个套餐
        NSMutableArray *ary2=[[NSMutableArray alloc] init];;
        for (int k=0;k<[array count];k++) {//套餐里的层
            NSMutableArray *ary=[array objectAtIndex:k];
            int j=0;
            
            NSMutableArray *ary1=[[NSMutableArray alloc] init];;
            for (NSDictionary *dict in ary) {//该层里的菜
                NSMutableDictionary *dicFood=[NSMutableDictionary dictionary];
                if ([[dict objectForKey:@"CNT"] intValue]<=[[dict objectForKey:@"count"] intValue]&&j<1) {
                    j+=1;
                    [ary1 addObject:dict];
                }
                if (dict==[ary lastObject]) {//判断最后一个菜
                    if (j>=[ary count]&&j!=0) {//判断是否在套餐的范围内
                        [dicFood setObject:ary1 forKey:@"food"];
                        [dicFood setObject:[NSString stringWithFormat:@"%d",k] forKey:@"num"];
                        [ary2 addObject:dicFood];//选择的菜
                    }
                }
            }
            if (k==[array count]-1) {//判断套餐的最后一个菜
                if ([ary2 count]==[array count]) {//判断是否符合套餐
                    [comboFinish addObject:[NSArray arrayWithArray:ary2]];
                }
                if ([ary2 count]==[array count]-1) {//判断是否符合推荐套餐
                    int z=0;
                    BOOL isy=NO;
                    
                    
                    for (int y=0;y<[ary2 count];y++) {
                        if ([[[ary2 objectAtIndex:y] objectForKey:@"num"] intValue]!=y) {
                            z=y;
                            isy=YES;
                            break;
                        }
                    }
                    if (!isy) {
                        z=[ary2 count];
                    }
                    NSMutableDictionary *dict10=[[NSMutableDictionary alloc] init];
                    [dict10 setObject:[NSArray arrayWithArray:ary2] forKey:@"food"];
                    [dict10 setObject:[array objectAtIndex:z] forKey:@"combo"];
                    int b=0;
                    for (int a=0; a<[[array objectAtIndex:z] count];a++) {
                        b+=[[[[array objectAtIndex:z] objectAtIndex:a] objectForKey:@"count"] intValue];
                    }
                    if ((b+1==[[[[array objectAtIndex:z] lastObject] objectForKey:@"tpmin"] intValue]&&[[[[array objectAtIndex:z] lastObject] objectForKey:@"tpmin"] intValue]!=0)||[[[[array objectAtIndex:z] lastObject] objectForKey:@"tpmin"] intValue]==0) {
                        [onlyOne addObject:dict10];
                    }
                    if ([[[[array objectAtIndex:z] lastObject] objectForKey:@"tpmin"] intValue]==0) {
                        [comboFinish addObject:ary2];
                    }
                    
                }
            }
        }
    }
    for(UIView *view in [_RecommendView subviews])
    {
        [view removeFromSuperview];
    }
    if ([comboFinish count]!=0||[onlyOne count]!=0) {
        
        UIImageView *image1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 660, 400)];
        [image1 setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"recommendBG.png"]];
        [_RecommendView addSubview:image1];
        int h=0;
        if ([comboFinish count]>0) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 660,30)];
            lb.text=@"可组成套餐";
            lb.font=[UIFont fontWithName:@"Noteworthy-Bold" size:25];
            lb.textColor=[UIColor redColor];
            lb.textAlignment=NSTextAlignmentCenter;
            [_RecommendView addSubview:lb];
            int y=0;
            for (NSArray *ary11 in comboFinish) {
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(y%5*135,y/5*90+50,120,80);
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonEmpty.png"] forState:UIControlStateNormal];
                [button setTitle:[[[[ary11 lastObject] objectForKey:@"food"] lastObject] objectForKey:@"tpname"] forState:UIControlStateNormal];
                //                button.titleLabel.text=[[[[ary11 lastObject] objectForKey:@"food"] lastObject] objectForKey:@"tpname"];
                //                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.tag=y+1;
                button.titleLabel.numberOfLines=0;
                button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                [button addTarget:self action:@selector(makePackage:) forControlEvents:UIControlEventTouchUpInside];
                y++;
                [_RecommendView addSubview:button];
                h=button.frame.origin.y+button.frame.size.height;
            }
            _recommendButton.hidden=NO;
        }
        //        _RecommendView.backgroundColor=[UIColor lightGrayColor];
        if ([onlyOne count]>0) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(30, h+20, 660,30)];
            lb.text=@"推荐套餐";
            lb.textColor=[UIColor redColor];
            lb.font=[UIFont fontWithName:@"Noteworthy-Bold" size:25];
            lb.textAlignment=NSTextAlignmentCenter;
            [_RecommendView addSubview:lb];
            int j=0;
            for (NSDictionary *dict in onlyOne) {
                int i=0;
                NSArray *array=[dict objectForKey:@"combo"];
                UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(30, h+50, 476, 30)];
                lb.text=[NSString stringWithFormat:@"选择可构成%@",[[array lastObject] objectForKey:@"tpname"]];
                lb.textColor=[UIColor redColor];
                [_RecommendView addSubview:lb];
                for (NSDictionary *dict in array) {
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame=CGRectMake(i%5*135,h+i/5*90+80,120,80);
                    [button setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"TableButtonEmpty.png"] forState:UIControlStateNormal];
                    [button setTitle:[dict objectForKey:@"DES"] forState:UIControlStateNormal];
                    button.titleLabel.numberOfLines=0;
                    button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                    button.tag=10000*(j+1)+i;
                    [button addTarget:self action:@selector(makePackage:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_RecommendView addSubview:button];
                    i++;
                }
                j++;
                h+=120;
                [_RecommendView setContentSize:CGSizeMake(650,h+50)];
                
                
            }
            
            [_RecommendView sendSubviewToBack:self.view];
            _RecommendView.hidden=YES;
            _recommendButton.hidden=NO;
        }
        image1.frame=CGRectMake(0, 0, 660, h+50);
    }else
    {
        _recommendButton.hidden=YES;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        NSString *validRegEx =@"^[0-9]+(.[0-9]{2})?$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}
@end
