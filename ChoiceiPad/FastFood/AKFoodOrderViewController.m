//
//  AKFoodOrderViewController.m
//  ChoiceiPad
//
//  Created by chensen on 15/7/17.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKFoodOrderViewController.h"
#import "AKFoodOrderCell.h"
#import "SearchBage.h"
#import "SearchCoreManager.h"
#import "BSLogViewController.h"
#import "Singleton.h"


@interface AKFoodOrderViewController ()

@end

@implementation AKFoodOrderViewController
{
    NSArray             *_classArray;       //菜品类别
    NSArray             *_allFoodArray;     //全部菜品
    NSArray             *_foodArray;        //菜品
    NSMutableArray      *_selectArray;      //选择的菜品
    NSArray             *_allComboArray;
    AKMySegmentAndView  *akmsav;
    UICollectionView    *_foodCV;           //菜品列表
    NSMutableDictionary *_foodDic;          //选择的菜品
    AKFoodOrderCell     *_foodCell;         //选择的cell
    UISearchBar         *_searchBar;        //搜索框
    NSMutableDictionary *_searchDict;
    AKPrivateAdditionView *privateAddition; //固定附加项
    int                 _total;             //选择的数量
    AKComboView         *_comboView;        //套餐界面
    AKAdditionView      *_additionView;     //附加项界面
    AKOrderClassView    *_classView;        //类别界面
    NSMutableArray      *_comboFinish;      //套餐推荐完成
    NSMutableArray      *_onlyOne;          //套餐推荐选择菜品
    UIScrollView        *_RecommendView;    //套餐推荐界面
    UIButton            *_recommendButton;  //套餐推荐的button
    UIPanGestureRecognizer *_pan;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _classArray =nil;
    _allFoodArray =nil;
    _foodArray=nil;
    _selectArray=nil;
    _allComboArray=nil;
}
#pragma mark - 生命周期函数
-(void)viewWillAppear:(BOOL)animated
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
        [NSThread detachNewThreadSelector:@selector(foodArray) toTarget:self withObject:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    _RecommendView=[[UIScrollView alloc] initWithFrame:CGRectMake(90, 450, 678, 400)];
    _RecommendView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_RecommendView];
    _recommendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _recommendButton.frame=CGRectMake(60, 800, 60, 60);
    _RecommendView.frame=_recommendButton.frame;
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tuodongView:)];
    _pan.delaysTouchesBegan=YES;
    [_recommendButton addGestureRecognizer:_pan];
    [_recommendButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"sweep.png"] forState:UIControlStateNormal];
    _recommendButton.hidden=YES;
    [_recommendButton addTarget:self action:@selector(recommendShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recommendButton];
    _RecommendView.hidden=YES;
    [_RecommendView sendSubviewToBack:self.view];
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
#pragma mark - 下面的按钮事件
-(void)buttonClick:(UIButton *)button
{
    if (button.tag==0) {
        if (!_additionView){
            _additionView = [[AKAdditionView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withSelectAddtions:[_foodDic objectForKey:@"addition"]];
            _additionView.delegate = self;
            _additionView.center = CGPointMake(self.view.center.x,self.view.center.y);
            //            vAddition.backgroundColor=[UIColor redColor];
            [self.view addSubview:_additionView];
        }
    }else if (button.tag==1){
        bs_dispatch_sync_on_main_thread(^{
            [Singleton sharedSingleton].dishArray=_selectArray;
            BSLogViewController *log=[[BSLogViewController alloc] init];
            [self.navigationController pushViewController:log animated:YES];
        });
        
    }else
    {
        if (_comboView) {
            [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Combo No Over"]];
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
        bs_dispatch_sync_on_main_thread(^{
            if (1==buttonIndex){
                NSMutableArray *array=[[NSMutableArray alloc] initWithArray:_selectArray];
                
                
                [SVProgressHUD showSuccessWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Save Success"]];
                
                BSDataProvider *dp=[BSDataProvider sharedInstance];
                [dp cache:array];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else if (2==buttonIndex){
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    }
    else  if (alertView.tag==10001)
    {
        [akmsav setTitle:@"1"];
        _total=1;
    }else if (alertView.tag==3) {//第二单位
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        
        if (1==buttonIndex) {
            [_foodDic setValue:@"1" forKey:@"total"];
            [_foodDic setValue:@"2" forKey:@"UNITCUR"];
            [_foodDic setValue:tf1.text forKey:@"Weight"];
            //            [_selectArray addObject:_dataDic];
            //继续判断别的
            [self privateAdditionView];
        }
    }else if (alertView.tag==4)//修改价格
    {
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        if (buttonIndex==1) {
            [_foodDic setObject:tf1.text forKey:@"PRICE"];
            [self WeightFlg];
        }
    }else if (alertView.tag==5){
        if (buttonIndex==1) {
            UITextField *textField=[alertView textFieldAtIndex:0];
            UITextField *textField1=[alertView textFieldAtIndex:1];
            [_foodDic setObject:textField.text forKey:@"DES"];
            [_foodDic setObject:textField1.text forKey:@"PRICE"];
            [self ChangeUnit];
        }
        
    }
}
#pragma mark - 附加项事件
-(void)additionSelected:(NSArray *)ary
{
    if (ary) {
        [_foodDic setObject:ary forKey:@"addition"];
    }
    [_additionView removeFromSuperview];
    _additionView=nil;
    
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
    _foodCell=(AKFoodOrderCell *)[_foodCV cellForItemAtIndexPath:indexPath];
    _foodDic =[NSMutableDictionary dictionaryWithDictionary:_foodCell.dataDict];
    if (_total==0) {
    A:
        for (NSDictionary *dict in _selectArray) {
            if ([[dict objectForKey:@"ITEM"] isEqualToString:[_foodDic objectForKey:@"ITEM"]]) {
                [_selectArray removeObject:dict];
                [_foodCell.dataDict setObject:[NSString stringWithFormat:@"%d",[[_foodDic objectForKey:@"total"] intValue]-[[dict objectForKey:@"total"] intValue]] forKey:@"total"];
            
                goto A;
                break;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
        [_foodCell.dataDict setObject:@"0" forKey:@"total"];
        [_foodCell setDataDict:_foodCell.dataDict];
        [akmsav setTitle:@""];
        _total=1;
    }else
    {
        _classView.userInteractionEnabled=NO;
        _foodCV.userInteractionEnabled=NO;
        
        [self ISTC];
    }
}
#pragma mark - 判断是否套餐
-(void)ISTC
{
    if ([[_foodDic objectForKey:@"ISTC"] intValue]==1) {
        _comboView=[[AKComboView alloc] initWithFrame:CGRectMake(90, 350, 678, 580) withPcode:_foodDic];
        [self.view addSubview:_comboView];
        _comboView.delegate=self;
    }else
    {
        [self productslimitcnt];
    }
}
#pragma mark - 套餐事件
-(void)AKComboViewClick:(NSMutableDictionary *)comboDic
{
    if (comboDic) {
        [comboDic setObject:@"1" forKey:@"total"];
        //计算TPNUM
        int i=1;
        for (NSDictionary *dict in _selectArray) {
            if ([[dict objectForKey:@"ISTC"] intValue]==1) {
                i++;
            }
        }
        [comboDic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"TPNUM"];
        for (NSDictionary *dict in [comboDic objectForKey:@"combo"]) {
            [dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"TPNUM"];
        }
        
        
        [_selectArray addObject:comboDic];
        [_foodCell.dataDict setObject:[NSString stringWithFormat:@"%d",[[_foodCell.dataDict objectForKey:@"total"] intValue]+1] forKey:@"total"];
        [_foodCell setDataDict:_foodCell.dataDict];
        NSMutableDictionary *dic=[_classArray objectAtIndex:[[_foodDic objectForKey:@"CLASSINDEX"] intValue]];
        [dic setObject:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"count"] intValue]+[[_foodDic objectForKey:@"total"] intValue]] forKey:@"count"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"classData" object:_classArray];
        
    }
    _classView.userInteractionEnabled=YES;
    _foodCV.userInteractionEnabled=YES;
    [_comboView removeFromSuperview];
    _comboView  = nil;
}
#pragma mark - 菜品是否估清判断
-(void)productslimitcnt
{
    if ([[_foodCell.dataDict objectForKey:@"SOLDOUT"] boolValue]) {
        [SVProgressHUD showErrorWithStatus:@"菜品已估清"];
        _foodCell=nil;
        return;
    }else
    {
        [self ISTEMP];
    }
}
#pragma mark - 临时菜
-(void)ISTEMP
{
    if ([[_foodCell.dataDict objectForKey:@"ISTEMP"] intValue]==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"临时菜" message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
        alert.tag=5;
        UITextField *textField=[alert textFieldAtIndex:0];
        textField.delegate=self;
        textField.tag=1000;
        textField.placeholder=@"请输入菜品名称";
        UITextField *textField1=[alert textFieldAtIndex:1];
        textField1.placeholder=@"请输入菜品价格";
        textField1.secureTextEntry=NO;
        textField1.delegate=self;
        [alert show];
    }else
    {
        [self ChangeUnit];
    }
}
#pragma mark - 多单位
/**
 *  @author ZhangPo, 15-04-13 15:04:01
 *
 *  @brief  判断单位
 *
 *  @since
 */
-(void)ChangeUnit
{
    if ([[_foodCell.dataDict objectForKey:@"ISUNITS"] intValue]==1) {
        NSDictionary *food=_foodCell.dataDict;
        NSMutableArray *mutmut = [NSMutableArray array];
        for (int i=0;i<6;i++){
            NSString *unit = [food objectForKey:[NSString stringWithFormat:@"UNITS%d",i+1]];
            NSString *price = [food objectForKey:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+4]];
            if (unit && [unit length]>0)
                [mutmut addObject:[NSDictionary dictionaryWithObjectsAndKeys:price,@"price",unit,@"unit", nil]];
        }
        
        if ([mutmut count]>1){
            NSMutableArray *mut = [NSMutableArray array];
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
        }
        
    }else{
        [_foodDic setObject:@"UNIT1" forKey:@"UNITKAY"];
        [self ChangePrice];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex>=0) {
        int j = 0;
        for (int i=0;i<6;i++){
            NSString *unit = [_foodCell.dataDict objectForKey:[NSString stringWithFormat:@"UNITS%d",i+1]];
            if (unit && [unit length]>0){
                if (j==buttonIndex) {
                    [_foodDic setObject:unit forKey:@"UNIT"];
                    [_foodDic setObject:[NSString stringWithFormat:@"UNIT%d",i+1] forKey:@"UNITKAY"];
                    [_foodDic setValue:[_foodDic objectForKey:j==0?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+4]] forKey:@"PRICE"];
                    break;
                }
                j++;
            }
            
        }
        [self ChangePrice];
    }else
    {
        [self cancelProduct];
    }
    
}
#pragma mark - 判断是否改变价格
-(void)ChangePrice
{
    /**
     * 判断是否修改价格
     */
    if ([[_foodCell.dataDict objectForKey:@"STATE"] intValue]==1) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"修改价格" message:@"请输入修改价格" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:@"确定",nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        tf1.delegate=self;
        alertView.tag=4;
        [alertView show];
    }else
    {
        [self WeightFlg];
    }
}
#pragma  mark - 判断是否第二单位
-(void)WeightFlg
{
    if ([[_foodCell.dataDict objectForKey:@"UNITCUR"] intValue]==2)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"重量" message:@"请输入重量" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:@"确定",nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        tf1.delegate=self;
        alertView.tag=3;
        [alertView show];
    }else
    {
        [_foodDic setObject:@"0" forKey:@"Weight"];
        [_foodDic setObject:@"1" forKey:@"UNITCUR"];
        [_foodDic setObject:@"0" forKey:@"TPNUM"];
        [self privateAdditionView];
    }
}
#pragma mark - 判断是否必选附加项
-(void)privateAdditionView
{
    /**
     *  @author ZhangPo, 15-04-13 14:04:49
     *
     *  @brief  附加产品标识错误   ISTEMP临时菜  ISADDPROD附加产品
     *
     *  @since
     */
    if ([[_foodCell.dataDict objectForKey:@"FUJIAMODE"] intValue]==1||[[_foodCell.dataDict objectForKey:@"ISADDPRO"] intValue]==1) {
        //        aScrollView.userInteractionEnabled=NO;
        if (!privateAddition){
            privateAddition = [[AKPrivateAdditionView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withFoodDict:_foodCell.dataDict];
            privateAddition.delegate = self;
        }
        if (!privateAddition.superview){
            privateAddition.center = CGPointMake(self.view.center.x,self.view.center.y);
            [self.view addSubview:privateAddition];
        }
        else{
            //            aScrollView.userInteractionEnabled=YES;
            [privateAddition removeFromSuperview];
            privateAddition = nil;
        }
        
    }else
    {
        [self addFoodForArray];
        
    }
}
#pragma mark - AKMySegmentAndViewDelegate
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
#pragma mark - privateAdditionDelegate
-(void)privateAdditionSelected:(NSArray *)ary
{
    if (ary) {
        [_foodDic setObject:ary forKey:@"addition"];
        [self addFoodForArray];
    }else
    {
        [self cancelProduct];
    }
    [privateAddition removeFromSuperview];
    privateAddition = nil;
}
#pragma mark - 添加菜品
-(void)addFoodForArray
{
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
    [self PackageGroup];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"classData" object:_classArray];
}

#pragma mark - AKOrderClassViewClickDelegate  类别按钮
-(void)AKOrderClassViewClick:(int)classGrp
{
    bs_dispatch_sync_on_main_thread(^{
        _foodArray=[_allFoodArray objectAtIndex:classGrp];
        [_foodCV reloadData];
    });
}
#pragma mark - 菜品搜索
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *_searchByName=[[NSMutableArray alloc] init];
    NSMutableArray *_searchByPhone=[[NSMutableArray alloc] init];
    NSMutableArray *foodAry=[[NSMutableArray alloc] init];
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:_searchByPhone];

    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (NSNumber *localID in _searchByName) {
        [array addObject:localID];
        for (NSArray *array in _allFoodArray) {
            for (NSDictionary *dict in array) {
                if ([[dict objectForKey:@"localID"] intValue]==[localID intValue]) {
                    [foodAry addObject:dict];
                }
            }
        }
        if ([searchBar.text length]) {
            [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
        }
    }
    for (NSNumber *localID in _searchByPhone) {
        [array addObject:localID];
         BOOL SET=NO;
        for (NSArray *array in _allFoodArray) {
            for (NSDictionary *dict in array) {
                if ([[dict objectForKey:@"localID"] intValue]==[localID intValue]) {
                    [foodAry addObject:dict];
                }
            }
        }
        if ([searchBar.text length]) {
            NSMutableArray *matchPhones = [NSMutableArray array];
            [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
            [matchString appendString:[matchPhones objectAtIndex:0]];
        }
    }

    _foodArray=[NSArray arrayWithArray:foodAry];
    bs_dispatch_sync_on_main_thread(^{
        [_foodCV reloadData];
    });

    
}


#pragma mark - 菜品数据处理
-(void)foodArray
{
    BSDataProvider *bs=[BSDataProvider sharedInstance];
    _classArray=[bs getClassById];                          //查询菜品类别
    _allFoodArray=[bs getAllFoodList:_classArray];          //查询全部菜品
    //选择的菜品
    NSArray        *measdocArray=[bs measdocArray];         //查询菜品单位
    NSArray        *_soldOutArray=[bs soldOut];             //估清的菜品
//    _allComboArray=[bs allCombo];
    //判断是否有菜品，如果没有可能有保存的菜品读取保存的菜品
    if ([[Singleton sharedSingleton].dishArray count]>0) {
        _selectArray=[Singleton sharedSingleton].dishArray;
  
    }else
    {
        _selectArray=[[NSMutableArray alloc] init];
    }
    if ([_selectArray count]==0) {
        [_selectArray addObjectsFromArray:[bs selectCache]];
    }
B:
    for (int i=0;i<[_selectArray count];i++) {
        NSDictionary *dict=[_selectArray objectAtIndex:i];
        if ([dict objectForKey:@"isShow"]&&[[dict objectForKey:@"ISTC"] intValue]==1&&[[dict objectForKey:@"isShow"] boolValue]==YES) {
            NSRange range = NSMakeRange(i+1,[[dict objectForKey:@"combo"] count]);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_selectArray removeObjectsAtIndexes:indexSet];
            [dict setValue:@"NO" forKey:@"isShow"];
            goto B;
        }
    }
    for (NSDictionary *selectDic in _selectArray) {
        //菜品类别的数量计算
        NSMutableDictionary *classDic=[_classArray objectAtIndex:[[selectDic objectForKey:@"CLASSINDEX"] intValue]];
        [classDic setObject:[NSString stringWithFormat:@"%d",[[classDic objectForKey:@"count"] intValue]+[[selectDic objectForKey:@"total"] intValue]] forKey:@"count"];
        //选择的菜在菜品里加标示
        for (NSDictionary *foodDic in [_allFoodArray objectAtIndex:[[selectDic objectForKey:@"CLASSINDEX"] intValue]]) {
            if ([[foodDic objectForKey:@"ITCODE"] isEqualToString:[selectDic objectForKey:@"ITCODE"]]) {
                [foodDic setValue:[NSString stringWithFormat:@"%d",[[foodDic objectForKey:@"total"] intValue]+[[selectDic objectForKey:@"total"] intValue]] forKey:@"total"];
            }
            
        }
    }
    
    //类别循环
    int k=0;
    for (int i=0;i<[_allFoodArray count];i++) {
        //类别里的菜品
        for (NSDictionary *foodDic in [_allFoodArray objectAtIndex:i]) {
            //类别标示
            [foodDic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"CLASSINDEX"];
            for (NSString *code in _soldOutArray) {
                if ([code isEqualToString:[foodDic objectForKey:@"ITCODE"]]) {
                    [foodDic setValue:[NSNumber numberWithBool:YES] forKey:@"SOLDOUT"];
                }
            }
            for (int j=0; j<6; j++) {
                if ([[foodDic objectForKey:[NSString stringWithFormat:@"UNIT%d",j+1]] length]>0&&![[foodDic objectForKey:[NSString stringWithFormat:@"UNIT%d",j+1]] isEqualToString:[NSString stringWithFormat:@"~_UNIT%d_~",j+1]]) {
                    //查找单位
                    for (NSDictionary *unit in measdocArray) {
                        if ([[foodDic objectForKey:[NSString stringWithFormat:@"UNIT%d",j+1]] isEqualToString:[unit objectForKey:@"code"]]) {
                            [foodDic setValue:[unit objectForKey:@"name"] forKey:[NSString stringWithFormat:@"UNITS%d",j+1]];
                            if (j>=1) {
                                //多规格加标识
                                [foodDic setValue:@"1" forKey:@"ISUNITS"];
                            }
                            break;
                        }
                    }
                    
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
    }
    _foodArray =[_allFoodArray objectAtIndex:0];
    [SVProgressHUD dismiss];
    bs_dispatch_sync_on_main_thread(^{
        //刷新界面
        [_foodCV reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"classData" object:_classArray];
    });
    
}
#pragma mark - 取消点菜
-(void)cancelProduct
{
    _classView.userInteractionEnabled=YES;
    _foodCV.userInteractionEnabled=YES;
    _foodCell=nil;
    [akmsav setTitle:@""];
    _total=1;
}

#pragma mark - 套餐推荐
-(void)PackageGroup
{
    NSMutableArray *comboArray=[NSMutableArray array];
    for (NSArray *array in _allComboArray) {//取出所有套餐
        for (NSArray *ary in array) {//取出所有组
            [comboArray addObjectsFromArray:ary];//取出所有的菜
        }
    }
    //    int x=0;
    /**
     *  遍历所有的明细菜品
     */
    for (NSDictionary *dictAll in comboArray) {
        for (NSDictionary *dictSelect in _selectArray) {
            if ([[dictSelect objectForKey:@"ISTC"] intValue]!=1) {
                if ([[dictSelect objectForKey:@"ITCODE"] isEqualToString:[dictAll objectForKey:@"PCODE1"]]) {
                    [dictAll setValue:@"0" forKey:@"count"];
                    [dictAll setValue:[dictSelect objectForKey:@"total"] forKey:@"count"];
                }
            }
        }
    }
    _comboFinish=[NSMutableArray array];//可选择套餐
    _onlyOne=[NSMutableArray array];//推荐套餐
    for (int i=0;i<[_allComboArray count];i++) {//所有的套餐
        NSMutableArray *array=[_allComboArray objectAtIndex:i];//单个套餐
        NSMutableArray *ary2=[NSMutableArray array];
        for (int k=0;k<[array count];k++) {//套餐里的层
            NSMutableArray *ary=[array objectAtIndex:k];
            int j=0;
            
            NSMutableArray *ary1=[NSMutableArray array];
            for (NSDictionary *dict in ary) {//该层里的菜
                NSMutableDictionary *dicFood=[NSMutableDictionary dictionary];
                if ([[dict objectForKey:@"MINCNT"] intValue]<=[[dict objectForKey:@"count"] intValue]&&[[dict objectForKey:@"count"] intValue]!=0&&[[dict objectForKey:@"TYPMAXCNT"] intValue]>=j+1) {//判断数量是不是在该菜的范围
                    if ([[dict objectForKey:@"MINCNT"] intValue]==0) {
                        j+=1;
                    }else
                        j+=[[dict objectForKey:@"MINCNT"] intValue];
                    [ary1 addObject:dict];
                }
                if (dict==[ary lastObject]) {//判断最后一个菜
                    if (j>=[[dict objectForKey:@"TYPMAXCNT"] intValue]&&j!=0) {//判断是否在套餐的范围内
                        [dicFood setObject:ary1 forKey:@"food"];
                        [dicFood setObject:[NSString stringWithFormat:@"%d",k] forKey:@"num"];
                        [ary2 addObject:dicFood];//选择的菜
                    }
                }
            }
            if (k==[array count]-1) {//判断套餐的最后一个菜
                //                for (NSArray *ary in array) {
                //                    if ([[[ary lastObject] objectForKey:@"tpmin"] intValue]!=0) {
                //
                //                    }
                //                }
                if ([ary2 count]==[array count]) {//判断是否符合套餐
                    [_comboFinish addObject:ary2];
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
                    [dict10 setObject:ary2 forKey:@"food"];
                    [dict10 setObject:[array objectAtIndex:z] forKey:@"combo"];
                    int b=0;
                    for (int a=0; a<[[array objectAtIndex:z] count];a++) {
                        b+=[[[[array objectAtIndex:z] objectAtIndex:a] objectForKey:@"count"] intValue];
                    }
                    if ((b+1==[[[[array objectAtIndex:z] lastObject] objectForKey:@"TYPMINCNT"] intValue]&&[[[[array objectAtIndex:z] lastObject] objectForKey:@"TYPMINCNT"] intValue]!=0)||[[[[array objectAtIndex:z] lastObject] objectForKey:@"TYPMINCNT"] intValue]==0) {
                        [_onlyOne addObject:dict10];
                    }
                    if ([[[[array objectAtIndex:z] lastObject] objectForKey:@"TYPMINCNT"] intValue]==0) {
                        [_comboFinish addObject:ary2];
                    }
                    
                }
            }
        }
    }
    for(UIView *view in [_RecommendView subviews])
    {
        [view removeFromSuperview];
    }
    if ([_comboFinish count]!=0||[_onlyOne count]!=0) {
        
        UIImageView *image1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 660, 400)];
        [image1 setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"recommendBG.png"]];
        [_RecommendView addSubview:image1];
        int h=0;
        if ([_comboFinish count]>0) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 660,30)];
            lb.text=@"可组成套餐";
            lb.font=[UIFont fontWithName:@"Noteworthy-Bold" size:25];
            lb.textColor=[UIColor redColor];
            lb.textAlignment=NSTextAlignmentCenter;
            [_RecommendView addSubview:lb];
            int y=0;
            for (NSArray *ary11 in _comboFinish) {
                
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.frame=CGRectMake(y%5*135,y/5*90+50,120,80);
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonEmpty.png"] forState:UIControlStateNormal];
                [button setTitle:[[[[ary11 lastObject] objectForKey:@"food"] lastObject] objectForKey:@"DES"] forState:UIControlStateNormal];
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
        if ([_onlyOne count]>0) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(30, h+20, 660,30)];
            lb.text=@"推荐套餐";
            lb.textColor=[UIColor redColor];
            lb.font=[UIFont fontWithName:@"Noteworthy-Bold" size:25];
            lb.textAlignment=NSTextAlignmentCenter;
            [_RecommendView addSubview:lb];
            int j=0;
            for (NSDictionary *dict in _onlyOne) {
                int i=0;
                NSArray *array=[dict objectForKey:@"combo"];
                UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(30, h+50, 476, 30)];
                lb.text=[NSString stringWithFormat:@"选择可构成%@",[[array lastObject] objectForKey:@"DES"]];
                lb.textColor=[UIColor redColor];
                [_RecommendView addSubview:lb];
                for (NSDictionary *dict in array) {
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame=CGRectMake(i%5*135,h+i/5*90+80,120,80);
                    [button setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"TableButtonEmpty.png"] forState:UIControlStateNormal];
                    [button setTitle:[dict objectForKey:@"PNAME"] forState:UIControlStateNormal];
                    button.titleLabel.numberOfLines=0;
                    button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                    button.tag=10000*(j+1)+i;
                    [button addTarget:self action:@selector(makePackage:) forControlEvents:UIControlEventTouchUpInside];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_RecommendView addSubview:button];
                    i++;
                    if ([dict isEqual:[array lastObject]]) {
                        h=button.frame.origin.y+40;
                    }
                }
                j++;
                
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
-(void)makePackage:(UIButton *)btn
{
    /**
     *  array代表已经选择的菜品
     */
    NSMutableArray *array=[NSMutableArray array];
    /**
     *  当tag>=10000时，说明是推荐套餐，反之是组合成的套餐
     */
    if (btn.tag>=10000) {
        /**
         *  获得可注册套餐的菜品
         */
        for (NSDictionary *dict in [[_onlyOne objectAtIndex:btn.tag/10000-1] objectForKey:@"food"]) {
            /**
             *  将已经选择的菜品放入数组中
             */
            for (NSDictionary *dict1 in [dict objectForKey:@"food"]) {
                [array addObject:[NSMutableDictionary dictionaryWithDictionary:dict1]];
            }
            //            [array addObjectsFromArray:[NSMutableArray arrayWithArray:]];
        }
        /**
         *  获取选择的菜品
         */
        [[[[_onlyOne objectAtIndex:btn.tag/10000-1] objectForKey:@"combo"] objectAtIndex:btn.tag%10000] setObject:@"1" forKey:@"total"];
        //        [array addObject:[NSMutableDictionary dictionaryWithDictionary:[[[_onlyOne objectAtIndex:btn.tag/10000-1] objectForKey:@"combo"] objectAtIndex:btn.tag%10000]]];
        [array addObject:[NSMutableDictionary dictionaryWithDictionary:[[[_onlyOne objectAtIndex:btn.tag/10000-1] objectForKey:@"combo"] objectAtIndex:btn.tag%10000]]];
    }else
    {
        /**
         *  组合成套餐的菜品
         */
        for (NSDictionary *fooddic in [_comboFinish objectAtIndex:btn.tag-1]) {
            [array addObjectsFromArray:[[NSArray alloc] initWithArray:[fooddic objectForKey:@"food"]]];
        }
    }
    //ary已经点的菜品
    NSMutableArray *ary=[[NSMutableArray alloc] initWithArray:_selectArray];
    int i=0;
    int k=0;
    /**
     *  将组合成套餐的菜品从数组里删除
     */
    for (NSDictionary *dict in array) {
        int j=0;
        for (NSDictionary *food in ary) {
            if ([[dict objectForKey:@"PCODE1"] isEqualToString:[food objectForKey:@"ITCODE"]]) {
                if ([[dict objectForKey:@"count"] intValue]>=[[food objectForKey:@"total"] intValue]) {
                    [_selectArray removeObject:food];
                    [dict setValue:[dict objectForKey:@"count"] forKey:@"total"];
                    
                    //                    j已点菜数组第几个
                    //                    k去掉几个菜
                    //
                    k++;
                }else
                {
                    [[_selectArray objectAtIndex:j-k] setObject:[NSString stringWithFormat:@"%d",[[food objectForKey:@"total"] intValue]-[[dict objectForKey:@"count"] intValue] ] forKey:@"total"];
                    
                }
            }
            j++;
        }
        i++;
    }
    int j=0;
    /**
     *  计算套餐标示TPNUM
     */
    for (NSDictionary *dic in _selectArray) {
        if ([[dic objectForKey:@"ITCODE"]isEqualToString:[[array lastObject] objectForKey:@"ITCODE"]]) {
            j++;
        }
    }
    for (NSDictionary *dict1 in array) {
        [dict1 setValue:[NSString stringWithFormat:@"%d",j] forKey:@"TPNUM"];
    }
    /**
     *  拼接组合成套餐的数据
     */
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",j] forKey:@"TPNUM"];
    [dict setObject:[[array lastObject] objectForKey:@"PCODE"] forKey:@"Tpcode"];
    [dict setObject:[[array lastObject] objectForKey:@"DES"] forKey:@"DES"];
    [dict setObject:[[array lastObject] objectForKey:@"PCODE"] forKey:@"ITCODE"];
    [dict setObject:[[array lastObject] objectForKey:@"PRICE"] forKey:@"PRICE"];
    [dict setObject:[[array lastObject] objectForKey:@"FCLASS"] forKey:@"CLASS"];
    
    [dict setObject:@"1" forKey:@"total"];
    [dict setObject:@"1" forKey:@"ISTC"];
    //    NSArray *ary1=[[NSArray alloc] initWithArray:array];
    [dict setObject:array forKey:@"combo"];
//    _selectCombo=array;
    _onlyOne=nil;
    _comboFinish=nil;
    
    [_selectArray addObject:dict];
    _RecommendView.hidden=YES;
    _recommendButton.hidden=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"classData" object:_classArray];
    [self comboend:array];
    [Singleton sharedSingleton].dishArray=_selectArray;
    [self foodArray];
    
}
-(void)comboend:(NSArray *)_selectCombo
{
    /**
     *  判断套餐是否选择完毕
     */
    float mrMoney = 0.0;
    //套餐价格
    float tcMoney=[[[_selectArray lastObject] objectForKey:@"PRICE"] floatValue];
    //套餐加价
    for (NSDictionary *dict in _selectCombo) {
        if ([[dict objectForKey:@"NADJUSTPRICE"] floatValue]>0) {
            tcMoney+=[[dict objectForKey:@"NADJUSTPRICE"] floatValue]*[[dict objectForKey:@"total"] floatValue];
        }
    }
    [[_selectArray lastObject] setObject:[NSNumber numberWithFloat:tcMoney] forKey:@"PRICE"];
    
    for (int i=0; i<[_selectCombo count]; i++) {
        
        NSDictionary *dict=[_selectCombo objectAtIndex:i];
        if ([[dict objectForKey:@"TCMONEYMODE"] intValue]!=2) {
            if ([[dict objectForKey:@"UNITCUR"] intValue]==2) {
                mrMoney+=[[dict objectForKey:@"UNITCUR"] floatValue]*[[dict objectForKey:@"PRICE1"] floatValue];
            }
            if ([dict objectForKey:@"total"]==nil) {
                [dict setValue:@"1" forKey:@"total"];
            }
            [dict setValue:[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"PRICE1"] floatValue]*[[dict objectForKey:@"total"] floatValue]] forKey:@"PRICE"];
            mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
        }else
        {
            [dict setValue:[dict objectForKey:@"FPRICE"] forKey:@"PRICE1"];
            if ([[dict objectForKey:@"UNITCUR"] intValue]==2) {
                mrMoney+=[[dict objectForKey:@"UNITCUR"] floatValue]*[[dict objectForKey:@"PRICE1"] floatValue];
            }
            if ([dict objectForKey:@"total"]==nil) {
                [dict setValue:@"1" forKey:@"total"];
            }
            [dict setValue:[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"PRICE1"]!=nil?[dict objectForKey:@"PRICE1"]:[dict objectForKey:@"PRICE"] floatValue]*[[dict objectForKey:@"total"] floatValue]] forKey:@"PRICE"];
            mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
        }
        
    }
    
    for (int i=0; i<[_selectCombo count]; i++) {
        NSDictionary *dict=[_selectCombo objectAtIndex:i];
        float m_price1=[[dict objectForKey:@"PRICE1"] floatValue];
        int TC_m_State=[[dict objectForKey:@"TCMONEYMODE"] floatValue];
        if(TC_m_State == 1)   //计价方式一
        {
            
            //                float youhuijia =mrMoney-tcMoney;     //优惠的价钱    合计 - 套餐价额
            float tempMoney1=m_price1*tcMoney/mrMoney;
            //                    float tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
            [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
        }
        else if(TC_m_State==2)
        {
            NSDictionary *dict1=[_selectArray lastObject];
            [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
        }else if (TC_m_State==3) {
            if (mrMoney<tcMoney) {
                //                    float youhuijia =mrMoney-tcMoney;     //优惠的价钱    合计 - 套餐价额
                float tempMoney1=m_price1*tcMoney/mrMoney;
                //                        float tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
                [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
            }
            else
            {
                NSDictionary *dict1=[_selectArray lastObject];
                [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
            }
        }
        if (i==[_selectCombo count]-1) {
            float mrMoney1 = 0.0;
            tcMoney=[[[_selectArray lastObject] objectForKey:@"PRICE"] floatValue];
            for (int i=0; i<[_selectCombo count]; i++) {
                
                NSDictionary *dict=[_selectCombo objectAtIndex:i];
                if ([[dict objectForKey:@"UNITCUR"] intValue]==2) {
                    mrMoney1+=[[dict objectForKey:@"UNITCUR"] floatValue]*[[dict objectForKey:@"PRICE"] floatValue];
                }else{
                    mrMoney1+=[[dict objectForKey:@"PRICE"] floatValue];
                }
            }
            
            if (mrMoney1!=tcMoney) {
                for (int i=0; i<[_selectCombo count]; i++) {
                    NSDictionary *dict=[_selectCombo objectAtIndex:i];
                    
                    if ([[dict objectForKey:@"PRICE"] floatValue]>0) {
                        if ([[dict objectForKey:@"UNITCUR"] intValue]!=2) {
                            float x=[[dict objectForKey:@"PRICE"] floatValue]+tcMoney-mrMoney1;
                            [dict setValue:[NSString stringWithFormat:@"%.2f",x] forKey:@"PRICE"];
                            break;
                        }
                        
                    }
                }
            }
            
        }
        
    }
    [[_selectArray lastObject] setObject:[NSArray arrayWithArray:_selectCombo] forKey:@"combo"];
    
}

@end
