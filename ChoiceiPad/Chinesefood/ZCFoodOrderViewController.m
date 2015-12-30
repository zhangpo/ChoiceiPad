//
//  ZCFoodOrderViewController.m
//  ChoiceiPad
//
//  Created by chensen on 15/7/31.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZCFoodOrderViewController.h"
#import "SearchCoreManager.h"
#import "Singleton.h"
#import "SearchBage.h"
#import "ZCLogViewController.h"


@interface ZCFoodOrderViewController ()

@end

@implementation ZCFoodOrderViewController
{
    NSMutableArray              *_classArray;       //全部的类别
    NSMutableArray              *_allFoodArray;     //全部的菜品
    NSMutableArray              *_allFoodList;
    NSArray                     *_allComboArray;    //全部的套餐明细
    NSMutableArray              *_selectArray;      //全部的选择菜品
    NSMutableDictionary         *_searchDict;       //搜索
    NSArray                     *_foodArray;        //显示的菜品
    NSArray                     *_soldOutArray;     //估清的菜品
    NSArray                     *_quickFoodArray;   //急推菜品
    NSMutableArray              *_searchArray;
    
    int                         _total;
    UIScrollView                *_RecommendView;
    UIButton                    *_recommendButton;
    UIPanGestureRecognizer      *_pan;
    AKMySegmentAndView          *akmsav;
    AKFoodOrderCell             *_foodCell;
    NSMutableDictionary         *_foodDic;
    ZCPackageView               *_packageView;
    ZCAdditionalView            *_additionView;
    UISearchBar                 *_searchBar;
    UICollectionView            *_foodCV;
    AKOrderClassView            *_classView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    //类别界面
    _searchDict=[[NSMutableDictionary alloc] init];
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(120, 80);
    flowLayout.minimumInteritemSpacing =2;//列距
    flowLayout.minimumLineSpacing=10;
    
    _foodCV=[[UICollectionView alloc] initWithFrame:CGRectMake(100,170, 660, 740) collectionViewLayout:flowLayout];
    _foodCV.backgroundColor=[UIColor whiteColor];
    _foodCV.delegate=self;
    _foodCV.dataSource=self;
    [_foodCV registerClass:[AKFoodOrderCell class] forCellWithReuseIdentifier:@"colletionCell2"];
    [self.view addSubview:_foodCV];
    
    
    _classView=[[AKOrderClassView alloc] initWithFrame:CGRectMake(0, 170, 100, 1024-190)];
    _classView.delegate=self;
    [self.view addSubview:_classView];
    
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
        btn.tag=i;
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        btn.tintColor=[UIColor whiteColor];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    _total=1;
//    _RecommendView=[[UIScrollView alloc] initWithFrame:CGRectMake(90, 450, 678, 400)];
//    _RecommendView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:_RecommendView];
//    _recommendButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    _recommendButton.frame=CGRectMake(60, 800, 60, 60);
//    _RecommendView.frame=_recommendButton.frame;
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tuodongView:)];
    _pan.delaysTouchesBegan=YES;
//    [_recommendButton addGestureRecognizer:_pan];
//    [_recommendButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"sweep.png"] forState:UIControlStateNormal];
//    _recommendButton.hidden=YES;
//    [_recommendButton addTarget:self action:@selector(recommendShow) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_recommendButton];
//    _RecommendView.hidden=YES;
//    [_RecommendView sendSubviewToBack:self.view];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    akmsav= [AKMySegmentAndView shared];
    akmsav.delegate=self;
    [akmsav segmentShow:YES];
    [akmsav shoildCheckShow:NO];
    //    akmsav.frame=CGRectMake(0, 0, 768, 114);
    [self.view addSubview:akmsav];
    if (_classArray) {
        return;
    }
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"Load"] maskType:SVProgressHUDMaskTypeBlack];
    bs_dispatch_sync_on_main_thread(^{
        [self foodArray];
    });
//    [NSThread detachNewThreadSelector:@selector(foodArray) toTarget:self withObject:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _classArray =nil;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_foodArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell2";
    AKFoodOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    cell.dataDict=[_foodArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_searchBar.text length]>0){
        _searchBar.text=@"";
        [_searchBar endEditing:YES];
    }
    _foodCell=(AKFoodOrderCell *)[_foodCV cellForItemAtIndexPath:indexPath];
    _foodDic =[NSMutableDictionary dictionaryWithDictionary:_foodCell.dataDict];
    [self foodPkId];
    if (_total==0) {
    A:
        for (NSDictionary *dict in _selectArray) {
            if ([[dict objectForKey:@"ITEM"] isEqualToString:[_foodDic objectForKey:@"ITEM"]]||[[dict objectForKey:@"PACKID"] isEqualToString:[_foodDic objectForKey:@"PACKID"]]) {
                [_selectArray removeObject:dict];
                [_foodCell.dataDict setObject:[NSString stringWithFormat:@"%d",[[_foodDic objectForKey:@"total"] intValue]-[[dict objectForKey:@"total"] intValue]] forKey:@"total"];
                
                goto A;
                break;
            }
        }
        [_foodCell.dataDict setObject:@"0" forKey:@"total"];
        [_foodCell setDataDict:_foodCell.dataDict];
        [akmsav setTitle:@""];
        _total=1;
    }else
    {
        _classView.userInteractionEnabled=NO;
        _foodCV.userInteractionEnabled=NO;
        [self soldOut];
    }

}
#pragma mark - 估清
-(void)soldOut
{
    if ([[_foodDic objectForKey:@"SOLDOUT"] boolValue]==YES) {
        [SVProgressHUD showErrorWithStatus:@"菜品已估清"];
        [self cancelProduct];
        return;
    }
    if ([_foodDic objectForKey:@"SOLDOUTCNT"]&&[[_foodDic objectForKey:@"SOLDOUTCNT"] floatValue]-[[_foodDic objectForKey:@"total"] floatValue]<_total) {
            [SVProgressHUD showErrorWithStatus:@"厨房没有那么多菜品"];
            [self cancelProduct];
            return;
    }
    [self ISTC];
}
#pragma mark - 判断是否套餐
-(void)ISTC
{
    if ([[_foodDic objectForKey:@"ISTC"] intValue]==1) {
        _packageView=[[ZCPackageView alloc] initWithFrame:CGRectMake(90, 350, 678, 580) withPackId:[_foodDic objectForKey:@"PACKID"]];
        _packageView.delegate=self;
        
        [self.view addSubview:_packageView];
        [_packageView notChangeItem];
    }else
    {
        [self PRIORMTH];
    }
}
#pragma mark - ZCPackageViewDelegate
-(void)package:(NSArray *)array
{
    _classView.userInteractionEnabled=YES;
    _foodCV.userInteractionEnabled=YES;
    if (array) {
        [_foodDic setObject:[_foodDic objectForKey:@"PKID"] forKey:@"TPNUM"];
        for (NSDictionary *dict in array) {
            [dict setValue:[_foodDic objectForKey:@"PKID"] forKey:@"TPNUM"];
        }
        [_foodDic setObject:array forKey:@"combo"];
        [_foodDic setObject:@"1" forKey:@"total"];
        [_selectArray addObject:_foodDic];
        [_foodCell.dataDict setObject:[NSString stringWithFormat:@"%d",[[_foodCell.dataDict objectForKey:@"total"] intValue]+1] forKey:@"total"];
        [_foodCell setDataDict:_foodCell.dataDict];
        
        
        NSMutableDictionary *dic=[_classArray objectAtIndex:[[_foodDic objectForKey:@"CLASSINDEX"] intValue]];
        [dic setObject:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"count"] intValue]+[[_foodDic objectForKey:@"total"] intValue]] forKey:@"count"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"classData" object:_classArray];
    }
    [_packageView removeFromSuperview];
    _packageView=nil;
}
#pragma mark - 判断是否修改价格
-(void)PRIORMTH
{
    if ([[_foodDic objectForKey:@"PRIORMTH"] intValue]==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"临时菜" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
        alert.tag=5;
        UITextField *textField=[alert textFieldAtIndex:0];
        textField.delegate=self;
        textField.tag=1000;
        textField.placeholder=@"请输入菜品名称";
        UITextField *textField1=[alert textFieldAtIndex:1];
        textField1.placeholder=@"请输入菜品价格";
        textField1.secureTextEntry=NO;
        textField1.inputView=[[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
        [alert show];
    }else
    {
        [self changeUnit];
    }
}
#pragma mark - 多单位
- (void)changeUnit{
    NSMutableArray *mutmut = [[NSMutableArray alloc] init];;
    for (int i=0;i<5;i++){
        NSString *unit = [_foodDic objectForKey:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1]];
        NSString *price = [_foodDic objectForKey:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1]];
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
        [sheet showFromRect:_foodCell.frame inView:_foodCV animated:YES];
    }else
    {
        [_foodDic setObject:@"UNIT" forKey:@"unitKey"];
        [_foodDic setObject:@"PRICE" forKey:@"priceKey"];
        [self PLUSD];
    }
}
#pragma mark - 第二单位
-(void)PLUSD
{
    if ([[_foodDic objectForKey:@"PLUSD"] intValue]==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入数量" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *tf1=[alert textFieldAtIndex:0];
        tf1.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
        tf1.text=@"0.00";
        alert.tag=3;
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
        NSString *str=[_foodDic objectForKey:[NSString stringWithFormat:@"RE%d",i]];
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
        [_foodDic setObject:additions forKey:@"addition"];
        [self addFood];
    }else{
        _foodDic=nil;
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSDictionary *food = _foodDic;
    int j = 0;
    int mutIndex = buttonIndex;
    
    for (int i=0;i<5;i++){
        NSString *unit = [food objectForKey:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1]];
        if (unit && [unit length]>0){
            if (j==mutIndex){
//                [_foodDic setObject:unit forKey:@"UNIT"];
//                [_foodDic setObject:[_foodDic objectForKey:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1]] forKey:@"PRICE"];
                [_foodDic setObject:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1] forKey:@"unitKey"];
                [_foodDic setObject:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1] forKey:@"priceKey"];
                break;
            }
            j++;
        }
        
    }
    [self PLUSD];
}
#pragma mark - 添加菜品
-(void)addFood
{
//    for (NSDictionary *dict1 in _selectArray) {
//        if ([[dict1 objectForKey:@"ISTC"] intValue]==0&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[_foodDic objectForKey:@"ITCODE"]]&&[dict1 objectForKey:@"addition"]==nil&&[[dict1 objectForKey:@"unitKey"] isEqualToString:[_foodDic objectForKey:@"unitKey"]]) {
//            [_foodDic setValue:[NSString stringWithFormat:@"%d",_total+[[dict1 objectForKey:@"total"] intValue]] forKey:@"total"];
//            [_selectArray removeObject:dict1];
//            break;
//        }
//    }
    
//    [_selectArray addObject:_foodDic];
//    _total=1;
//    [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
//    //    [self PackageGroup];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [_foodDic setValue:[NSString stringWithFormat:@"%d",_total] forKey:@"total"];
    for (NSDictionary *dict1 in _selectArray) {
        if ([[dict1 objectForKey:@"ISTC"] intValue]==0&&[[dict1 objectForKey:@"ITEM"] isEqualToString:[_foodDic objectForKey:@"ITEM"]]&&[dict1 objectForKey:@"addition"]==nil&&[[dict1 objectForKey:@"UNITKAY"] isEqualToString:[_foodDic objectForKey:@"UNITKAY"]]) {
            [_foodDic setObject:[NSString stringWithFormat:@"%d",_total+[[dict1 objectForKey:@"total"] intValue]] forKey:@"total"];
            [_selectArray removeObject:dict1];
            break;
        }
    }
    NSLog(@"%@",[_foodCell.dataDict objectForKey:@"total"]);
    [_foodCell.dataDict setObject:[NSString stringWithFormat:@"%d",_total+[[_foodCell.dataDict objectForKey:@"total"] intValue]] forKey:@"total"];
    [_selectArray addObject:_foodDic];
    [_foodCell setDataDict:_foodCell.dataDict];
    NSMutableDictionary *dic=[_classArray objectAtIndex:[[_foodDic objectForKey:@"CLASSINDEX"] intValue]];
    [dic setObject:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"count"] intValue]+[[_foodDic objectForKey:@"total"] intValue]] forKey:@"count"];
    [self cancelProduct];
//    [self PackageGroup];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"classData" object:_classArray];
}
#pragma mark - 取消点菜
-(void)cancelProduct
{
    _classView.userInteractionEnabled=YES;
    _foodCV.userInteractionEnabled=YES;
//    _foodDic=nil;
    _foodCell=nil;
    [akmsav setTitle:@""];
    _total=1;
}
-(void)foodPkId
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*60*24*3;
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HmssSS"];
    //用[NSDate date]可以获取系统当前时间
    NSString *yy = [dateFormatter stringFromDate:localeDate];
    NSString *pkid=[NSString stringWithFormat:@"%@%@",yy,[Singleton sharedSingleton].CheckNum];
    [_foodDic setObject:[NSString stringWithFormat:@"%u",arc4random() % 10000000] forKey:@"PKID"];
}
-(void)selectSegmentIndex:(NSString *)segmentIndex andSegment:(UISegmentedControl *)segment
{
    if(![segmentIndex isEqualToString:@"X"])
    {
        if ([[segment titleForSegmentAtIndex:11] length]==0) {
            _total=0;
        }
        
        if (_total<10) {
            int index=[segmentIndex intValue];
            _total=_total*10+index;
        }
        [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
    }
    else
    {
        _total=1;
        [akmsav setTitle:@""];
    }
}
#pragma mark - 下面的按钮事件
-(void)buttonClick:(UIButton *)button
{
    if (button.tag==0) {
        if (!_additionView){
            _additionView=[[ZCAdditionalView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withSelectAddtions:[_foodDic objectForKey:@"addition"]];
//            _additionView = [[ZCAdditionalView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withSelectAddtions:[_foodDic objectForKey:@"addition"]];
            _additionView.delegate = self;
            _additionView.center = CGPointMake(self.view.center.x,self.view.center.y);
            //            vAddition.backgroundColor=[UIColor redColor];
            [self.view addSubview:_additionView];
            _classView.userInteractionEnabled=NO;
            _foodCV.userInteractionEnabled=NO;
        }
    }else if (button.tag==1){
        if (_packageView) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"当前套餐没有选择完毕" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        bs_dispatch_sync_on_main_thread(^{
            [Singleton sharedSingleton].dishArray=_selectArray;
            ZCLogViewController *log=[[ZCLogViewController alloc] init];
            [self.navigationController pushViewController:log animated:YES];
        });
        
    }else
    {
        if (_packageView) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"当前套餐没有选择完毕" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        bs_dispatch_sync_on_main_thread(^{
            if ([_selectArray count]>0) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Save the dishes"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],[[CVLocalizationSetting sharedInstance] localizedString:@"NO"], nil];
                alert.tag=1;
                alert.delegate=self;
                [alert show];
                return;
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
}
#pragma mark - UIAlertViewDelegate

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
            
            [SVProgressHUD showSuccessWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Save Success"]];
            bs_dispatch_sync_on_main_thread(^{
                BSDataProvider *dp=[BSDataProvider sharedInstance];
                [dp cache:array];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else if (2==buttonIndex){
            bs_dispatch_sync_on_main_thread(^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    }
    else  if (alertView.tag==10001)
    {
        [akmsav setTitle:@"1"];
        _total=1;
    }
    else if (alertView.tag==3) {//第二单位
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        [tf1 endEditing:YES];
        if (1==buttonIndex) {
            [_foodDic setValue:[NSString stringWithFormat:@"%d",_total] forKey:@"total"];
            [_foodDic setValue:@"2" forKey:@"UNITCNT"];
            [_foodDic setValue:tf1.text forKey:@"Weight"];
            //            [_selectArray addObject:_dataDic];
            //继续判断别的
            [self necessaryAdditional];
        }
    }else if (alertView.tag==5){
        if (buttonIndex==1) {
            UITextField *textField=[alertView textFieldAtIndex:0];
            UITextField *textField1=[alertView textFieldAtIndex:1];
            [_foodDic setObject:textField.text forKey:@"DES"];
            [_foodDic setObject:textField1.text forKey:@"PRICE"];
            [self changeUnit];
        }
    }
}
#pragma mark - 附加项
- (void)additionSelected:(NSArray *)ary{
    if (ary) {
        [_foodDic setValue:ary forKey:@"addition"];
    }
    [_additionView removeFromSuperview];
    _additionView=nil;
    _classView.userInteractionEnabled=YES;
    _foodCV.userInteractionEnabled=YES;
    
}
#pragma mark - 类别代理事件
-(void)AKOrderClassViewClick:(int)classGrp
{
    _foodArray=[_allFoodArray objectAtIndex:classGrp];
    [_foodCV reloadData];
}
#pragma mark - 菜品搜索
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_searchArray removeAllObjects];
    for (NSDictionary *dict in _allFoodList) {
        if ([[dict objectForKey:@"ITCODE"] rangeOfString:searchBar.text].location !=NSNotFound||[[dict objectForKey:@"DES"] rangeOfString:searchBar.text].location !=NSNotFound||[[[dict objectForKey:@"INIT"] uppercaseString] rangeOfString:[searchBar.text uppercaseString]].location !=NSNotFound) {
            [_searchArray addObject:dict];
        }
    }
    _foodArray=[NSArray arrayWithArray:_searchArray];
    [_foodCV reloadData];
}
#pragma mark - 菜品数据处理
-(void)foodArray
{
    BSDataProvider *bs=[BSDataProvider sharedInstance];
    _searchArray =[[NSMutableArray alloc] init];
    _classArray=[NSMutableArray arrayWithArray:[bs getClassById]];//查询菜品类别
    [_classArray insertObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"套餐",@"DES",[NSString stringWithFormat:@"%d",[[[_classArray objectAtIndex:0] objectForKey:@"GRP"] intValue]-1],@"GRP", nil] atIndex:0];
    _allFoodArray=[NSMutableArray arrayWithArray:[BSDataProvider ZCgetAllFoodList:_classArray]];          //查询全部菜品
    _allFoodList=[[NSMutableArray alloc] init];
//    NSLog(@"查菜品");
    _soldOutArray=[bs ZCEstimatesFoodList];             //估清的菜品
    _quickFoodArray=[bs ZCquickFood];                  //急推菜
//     NSLog(@"查估清");
//    _allComboArray=[bs ZCallCombo];                                     //查询全部的套餐
//    判断是否有菜品，如果没有可能有保存的菜品读取保存的菜品
    
    if ([[Singleton sharedSingleton].dishArray count]>0) {
        _selectArray=[Singleton sharedSingleton].dishArray;
    }else
    {
        _selectArray=[[NSMutableArray alloc] init];
    }
    if ([_selectArray count]==0) {
        [_selectArray addObjectsFromArray:[bs selectCache]];
    }
    //类别数量
    for (NSDictionary *selectDic in _selectArray) {
        //菜品类别的数量计算
        NSMutableDictionary *classDic=[_classArray objectAtIndex:[[selectDic objectForKey:@"CLASSINDEX"] intValue]];
        [classDic setObject:[NSString stringWithFormat:@"%.1f",[[classDic objectForKey:@"count"] floatValue]+[[selectDic objectForKey:@"total"] floatValue]] forKey:@"count"];
        //选择的菜在菜品里加标示
        for (NSDictionary *foodDic in [_allFoodArray objectAtIndex:[[selectDic objectForKey:@"CLASSINDEX"] intValue]]) {
            if ([[foodDic objectForKey:@"ITCODE"] isEqualToString:[selectDic objectForKey:@"ITCODE"]]) {
                [foodDic setValue:[NSString stringWithFormat:@"%.1f",[[foodDic objectForKey:@"total"] floatValue]+[[selectDic objectForKey:@"total"] floatValue]] forKey:@"total"];
            }
            
        }
    }
    NSMutableArray *quickArray=[[NSMutableArray alloc] init];
    //类别循环
    int k=0;
    for (int i=0;i<[_allFoodArray count];i++) {
        //类别里的菜品
        for (NSDictionary *foodDic in [_allFoodArray objectAtIndex:i]) {
            //急推菜
            for (NSDictionary *dict in _quickFoodArray) {
                if ([[foodDic objectForKey:@"ITCODE"] isEqualToString:[dict objectForKey:@"ITCODE"]]) {
                    [foodDic setValue:@"1" forKey:@"QUICK"];
                    [quickArray addObject:foodDic];
                    break;
                }
            }
            
            //类别标示
            [foodDic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"CLASSINDEX"];
            for (NSDictionary *code in _soldOutArray) {
            
                if ([[code objectForKey:@"ITCODE"] isEqualToString:[foodDic objectForKey:@"ITCODE"]]) {
                    if ([[code objectForKey:@"CNT"] floatValue]==0) {
                        [foodDic setValue:[NSNumber numberWithBool:YES] forKey:@"SOLDOUT"];
                    }else
                    {
                        [foodDic setValue:[code objectForKey:@"CNT"] forKey:@"SOLDOUTCNT"];
                    }
                    break;
                }
            }
            //多单位
            for (int j=0; j<6; j++) {
                if ([[foodDic objectForKey:[NSString stringWithFormat:@"UNIT%d",j+1]] length]>0&&![[foodDic objectForKey:[NSString stringWithFormat:@"UNIT%d",j+1]] isEqualToString:[NSString stringWithFormat:@"~_UNIT%d_~",j+1]]) {
                    [foodDic setValue:@"1" forKey:@"ISUNITS"];
                }
            }
            [foodDic setValue:[NSString stringWithFormat:@"%d",k] forKey:@"localID"];
            SearchBage *search=[[SearchBage alloc] init];
            search.localID = [NSNumber numberWithInt:k];
            search.name=[foodDic objectForKey:@"DES"];
            NSMutableArray *ary=[[NSMutableArray alloc] init];
            [ary addObject:[foodDic objectForKey:@"ITCODE"]];
            search.phoneArray=ary;
            [_searchDict setObject:search forKey:search.localID];
            [[SearchCoreManager share] AddContact:search.localID name:search.name phone:search.phoneArray];
            k++;
        }
        [_allFoodList addObjectsFromArray:[_allFoodArray objectAtIndex:i]];
    }
    if ([quickArray count]>0) {
        [_allFoodArray addObject:quickArray];
        [_classArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"重点推介",@"DES",[NSString stringWithFormat:@"%d",[[[_classArray lastObject] objectForKey:@"GRP"] intValue]-1],@"GRP", nil]];
        
    }
    _foodArray =[_allFoodArray objectAtIndex:0];
    [SVProgressHUD dismiss];
    bs_dispatch_sync_on_main_thread(^{
        [_foodCV reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"classData" object:_classArray];
    });
    
}

@end
