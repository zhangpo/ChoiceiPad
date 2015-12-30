//
//  AKLogTableViewCell.m
//  ChoiceiPad
//
//  Created by chensen on 15/6/30.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKLogTableViewCell.h"

@implementation AKLogTableViewCell
{
    ZCAdditionalView *ZCAddition;
    AKAdditionView *vAddition;
    BSChuckView    *chuckView;
}
@synthesize foodInfo=_foodInfo,indexPath=_indexPath,delegate=_delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //即起叫起
        self.foodCall=[UIButton buttonWithType:UIButtonTypeCustom];
        self.foodCall.frame=CGRectMake(26, 14, 24, 35);
        self.foodCall.tag=105;
        [self.foodCall addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.foodCall];
        
        //名称
        self.foodName=[[UILabel alloc] initWithFrame:CGRectMake(64, 5, 150, 45)];
        self.foodName.font=[UIFont systemFontOfSize:20];
        self.foodName.lineBreakMode=NSLineBreakByWordWrapping;
        self.foodName.numberOfLines=0;
        [self.contentView addSubview:self.foodName];
        
        //数量
        self.foodCount=[[UITextField alloc] initWithFrame:CGRectMake(252, 16, 65, 30)];
        self.foodCount.font=[UIFont systemFontOfSize:20];
        self.foodCount.backgroundColor=[UIColor lightGrayColor];
        self.foodCount.textAlignment=NSTextAlignmentCenter;
        self.foodCount.delegate=self;
        self.foodCount.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
        [self.contentView addSubview:self.foodCount];
        
        //加按钮
        self.foodAdd=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.foodAdd setImage:[UIImage imageNamed:@"Add.png"] forState:UIControlStateNormal];
        self.foodAdd.frame=CGRectMake(225, 10, 45, 45);
        [self.foodAdd addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.foodAdd.tag=100;
        [self.contentView addSubview:self.foodAdd];
        
        //减按钮
        self.foodSubtract=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.foodSubtract setImage:[UIImage imageNamed:@"Subtract.png"] forState:UIControlStateNormal];
        self.foodSubtract.tag=101;
        self.foodSubtract.frame=CGRectMake(300, 10, 45, 45);
        [self.foodSubtract addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.foodSubtract];
        
        //价格
        self.foodPrice=[[UILabel alloc] initWithFrame:CGRectMake(363, 10, 75 , 35)];
        self.foodPrice.font=[UIFont systemFontOfSize:20];
        self.foodPrice.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.foodPrice];
        
        //单位
        self.foodUnit=[[UILabel alloc] initWithFrame:CGRectMake(460,10, 60, 35)];
        self.foodUnit.font=[UIFont systemFontOfSize:20];
        self.foodUnit.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:self.foodUnit];
        
        //小计
        self.foodTalPrice=[[UILabel alloc] initWithFrame:CGRectMake(545, 10, 75, 35)];
        self.foodTalPrice.font=[UIFont systemFontOfSize:20];
        self.foodTalPrice.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.foodTalPrice];
        
        //附加项
        self.foodAddition=[[UILabel alloc] initWithFrame:CGRectMake(50, 45, 668, 45)];
        self.foodAddition.font=[UIFont systemFontOfSize:16];
        self.foodAddition.numberOfLines=0;
        self.foodAddition.lineBreakMode=NSLineBreakByWordWrapping;
        self.foodAddition.textAlignment=NSTextAlignmentLeft;
//        self.foodAddition.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:self.foodAddition];
        
        
        //赠按钮
        self.foodPresent=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.foodPresent setImage:[UIImage imageNamed:@"Present.png"] forState:UIControlStateNormal];
        self.foodPresent.frame=CGRectMake(616, 5, 45, 45);
        [self.foodPresent addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.foodPresent.tag=102;
        [self.contentView addSubview:self.foodPresent];
        
        //附加按钮
        self.foodAdditional=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.foodAdditional setImage:[UIImage imageNamed:@"Addition.png"] forState:UIControlStateNormal];
        self.foodAdditional.tag=103;
        self.foodAdditional.frame=CGRectMake(660, 5, 65, 45);
        [self.foodAdditional addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.foodAdditional];
        //删除按钮
        self.foodDelete=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.foodDelete setImage:[UIImage imageNamed:@"Delect.png"] forState:UIControlStateNormal];
        self.foodDelete.tag=104;
        self.foodDelete.frame=CGRectMake(720, 5, 45, 45);
        [self.foodDelete addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.foodDelete];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    self.foodName.numberOfLines=0;
    self.foodName.lineBreakMode=NSLineBreakByCharWrapping;
//    self.foodName.l/
    self.foodAddition.numberOfLines=0;
    self.foodAddition.lineBreakMode=NSLineBreakByCharWrapping;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_foodInfo setValue:textField.text forKey:@"total"];
    [_delegate AKLogTableViewCellClick:self];
}
-(void)setFoodInfo:(NSDictionary *)foodInfo
{
    self.foodAdd.hidden=NO;
    self.foodSubtract.hidden=NO;
    self.foodPresent.hidden=NO;
    self.foodDelete.hidden=NO;

    //判断是否赠送
    if (([foodInfo objectForKey:@"CNT"]||[foodInfo objectForKey:@"Tpcode"])&&![foodInfo objectForKey:@"combo"]) { //判断套餐明细
        self.foodName.text=[NSString stringWithFormat:@"---%@",[foodInfo objectForKey:@"PNAME"]==nil?[foodInfo objectForKey:@"DES"]:[foodInfo objectForKey:@"PNAME"]];
    }else if ([foodInfo objectForKey:@"promonum"]&&[[foodInfo objectForKey:@"promonum"] intValue]>0) {
        self.foodName.text=[NSString stringWithFormat:@"%@-赠%@",[foodInfo objectForKey:@"DES"],[foodInfo objectForKey:@"promonum"]];
    }
    else
    {
        self.foodName.text=[foodInfo objectForKey:@"DES"];
    }
    self.foodCount.text=[foodInfo objectForKey:@"total"];
    float price=[[foodInfo objectForKey:[foodInfo objectForKey:@"priceKey"]==nil?@"PRICE":[foodInfo objectForKey:@"priceKey"]] floatValue];
    self.foodPrice.text=[NSString stringWithFormat:@"%.2f",price];
    self.foodUnit.text=[foodInfo objectForKey:@"unitKey"]==nil?[foodInfo objectForKey:@"UNIT"]:[foodInfo objectForKey:[foodInfo objectForKey:@"unitKey"]];
    [self.foodCall setTitle:[[foodInfo objectForKey:@"foodCall"] isEqualToString:@"Y"]?@"叫":@"即" forState:UIControlStateNormal];
    [self.foodCall setTitleColor:[[foodInfo objectForKey:@"foodCall"] isEqualToString:@"Y"]?[UIColor redColor]:[UIColor greenColor] forState:UIControlStateNormal];
//    [self.foodCall setTintColor:[[foodInfo objectForKey:@"foodCall"] isEqualToString:@"Y"]?[UIColor redColor]:[UIColor greenColor]] ;
    self.foodTalPrice.text=[[foodInfo objectForKey:@"UNITCNT"] intValue]==2?[NSString stringWithFormat:@"%.2f",price*[[foodInfo objectForKey:@"Weight"] floatValue]]:[NSString stringWithFormat:@"%.2f",price*([[foodInfo objectForKey:@"total"] floatValue]-([foodInfo objectForKey:@"promonum"]==nil?0:[[foodInfo objectForKey:@"promonum"] floatValue]))];
    //附加项判断
    if ([[foodInfo objectForKey:@"addition"] count]>0) {
        NSMutableString *additionStr=[[NSMutableString alloc] init];
        [additionStr appendString:@"附加项:"];
        for (NSDictionary *addition in [foodInfo objectForKey:@"addition"]){
            if ([addition objectForKey:@"FNAME"]) {
                NSString *str=[NSString stringWithFormat:@"%@X%@  ",[addition objectForKey:@"FNAME"],[addition objectForKey:@"count"]];
                [additionStr appendString:str];
            }else
            {
                NSString *str=[NSString stringWithFormat:@"%@X%@   ",[addition objectForKey:@"DES"],[addition objectForKey:@"count"]==nil?@"1":[addition objectForKey:@"count"]];
                [additionStr appendString:str];
            }
        }
        CGSize size = CGSizeMake(668,10000);  //设置宽高，其中高为允许的最大高度
        CGSize labelsize = [additionStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.foodAddition.frame =CGRectMake(self.foodAddition.frame.origin.x, self.foodAddition.frame.origin.y,668,labelsize.height);
        self.foodAddition.text=additionStr;
        
    }else
    {
        self.foodAddition.text=@"";
    }
    //判断是否套餐或第二单位
    if ([[foodInfo objectForKey:@"ISTC"] intValue]==1||[[foodInfo objectForKey:@"UNITCNT"] intValue]==2||[foodInfo objectForKey:@"CNT"]||[foodInfo objectForKey:@"Tpcode"]) {
        self.foodAdd.hidden=YES;
        self.foodSubtract.hidden=YES;
        self.foodCount.backgroundColor=[UIColor clearColor];
    }
    if ([foodInfo objectForKey:@"CNT"]||[foodInfo objectForKey:@"Tpcode"]) {
        self.foodPresent.hidden=YES;
        self.foodDelete.hidden=YES;
    }
    _foodInfo =foodInfo;
    
}
#pragma mark - 各种按钮事件
- (IBAction)buttonClick:(id)sender {
    UIButton *button=(UIButton *)sender;
    //加按钮事件
    if (button.tag==100) {
        int i=[[_foodInfo objectForKey:@"total"] intValue]+1;
        [_foodInfo setValue:[NSString stringWithFormat:@"%d",i] forKey:@"total"];
    }else if (button.tag==101){
        //减按钮事件
        int i=[[_foodInfo objectForKey:@"total"] intValue]-1;
        if (i==0) {
            [self deleteFood];
            return;
        }
        [_foodInfo setValue:[NSString stringWithFormat:@"%d",i] forKey:@"total"];
    }else if (button.tag==102){
        //赠送按钮事件
        if ([Mode isEqualToString:@"zc"]) {
            
            return;
        }else
        {
            if (!chuckView){
                chuckView=[[BSChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:0];
                chuckView.delegate = self;
                [self.window addSubview:chuckView];
            }
        }
        return;
    }else if (button.tag==103){
        //附加项
        [self setAddition];
        return;
    }else if (button.tag==104){
        //删除
        [self deleteFood];
        return;
    }else if (button.tag==105){
        //即起叫起
        if (![_foodInfo objectForKey:@"foodCall"]) {
            [_foodInfo setValue:@"Y" forKey:@"foodCall"];
        }else if ([[_foodInfo objectForKey:@"foodCall"] isEqualToString:@"Y"]){
            [_foodInfo setValue:@"N" forKey:@"foodCall"];
        }else{
            [_foodInfo setValue:@"Y" forKey:@"foodCall"];
        }
    }
    [_delegate AKLogTableViewCellClick:self];
}
#pragma mark - 删除
-(void)deleteFood
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"你确定要删除该菜品吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        _foodInfo=nil;
        [_delegate AKLogTableViewCellClick:self];
    }
}
- (void)setAddition{
    if ([Mode isEqualToString:@"zc"]) {
        [ZCAddition removeFromSuperview];
        ZCAddition=nil;
        if (!ZCAddition){
//            ZCAddition=[[BSAddtionView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) info:_foodInfo];
//            ZCAddition.delegate = self;
//            [self.superview addSubview:ZCAddition];
            ZCAddition = [[ZCAdditionalView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withSelectAddtions:[_foodInfo objectForKey:@"addition"]];
            ZCAddition.delegate = self;
            ZCAddition.center = CGPointMake(self.window.center.x,self.window.center.y);
            [self.superview.superview.superview addSubview:ZCAddition];
        }
        return;
    }
    if (!vAddition){
        vAddition=[[AKAdditionView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withSelectAddtions:[_foodInfo objectForKey:@"addition"]];
        vAddition.delegate = self;
        vAddition.center = CGPointMake(self.window.center.x,self.window.center.y);
        [self.superview.superview.superview addSubview:vAddition];
    }
    //    [vAddition presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - 附加项
-(void)additionSelected:(NSArray *)ary
{
    [vAddition==nil?ZCAddition:vAddition removeFromSuperview];
    vAddition=nil;
    ZCAddition=nil;
    if (ary) {
        [_foodInfo setValue:ary forKey:@"addition"];
    }
    [_delegate AKLogTableViewCellClick:self];
}
#pragma mark - 赠送
-(void)chuckOrderWithOptions:(NSDictionary *)info
{
    if (info) {
        if ([info objectForKey:@"count"]!=nil||[info objectForKey:@"recount"]!=nil) {
            if ([[info objectForKey:@"count"] intValue]>[[_foodInfo objectForKey:@"total"] intValue]-[[_foodInfo objectForKey:@"promonum"] intValue]||[[info objectForKey:@"recount"] intValue]>[[_foodInfo objectForKey:@"promonum"] intValue]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"The input number is wrong"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alert show];
                return;
            }
        }
        if ([chuckView.tfcount.text intValue]>0&&[chuckView.tffan.text intValue]>0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"The input number is wrong"] message:nil  delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        BSDataProvider *dp=[BSDataProvider sharedInstance];
        NSDictionary *dict=[dp checkAuth:info];
        if (dict) {
            NSString *result = [[[dict objectForKey:@"ns:checkAuthResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
            NSArray *ary1 = [result componentsSeparatedByString:@"@"];
            if ([ary1 count]==1) {
                UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alwet show];
            }
            else
            {
                NSString *str=[NSString stringWithFormat:@"%d",[[_foodInfo objectForKey:@"promonum"] intValue]+[[info objectForKey:@"count"] intValue]-[[info objectForKey:@"recount"] intValue] ];
                [_foodInfo setValue:str forKey:@"promonum"];
                [_foodInfo setValue:[info objectForKey:@"INIT"] forKey:@"promoReason"];
                if ([[_foodInfo objectForKey:@"ISTC"] intValue]==1) {
                    for (NSMutableDictionary *combo in [_foodInfo objectForKey:@"combo"]) {
                        [combo setObject:str forKey:@"promonum"];
                        [combo setObject:[info objectForKey:@"INIT"] forKey:@"promoReason"];
                    }
                }
            }
        }
    }
    [chuckView removeFromSuperview];
    chuckView=nil;
    [_delegate AKLogTableViewCellClick:self];

}
@end
