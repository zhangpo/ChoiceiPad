//
//  BSLogCell.m
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AKLogCell.h"
#import "BSDataProvider.h"
#import "CVLocalizationSetting.h"


@implementation AKLogCell
{
    AKAdditionView *vAddition;
}
@synthesize delegate,dicInfo,lblAdditionPrice,tfPrice,lblUnit,indexPath,lblName,lblTotalPrice,lblAddition,tfCount,btnAdd,btnReduce,jia,jian,lb,lblLine,supTableView,btnEdit;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 160, 50)];
        lblName.font = [UIFont systemFontOfSize:16];
        lblName.numberOfLines =0;
        lblName.textColor=[UIColor blackColor];
        lblName.lineBreakMode = UILineBreakModeWordWrap;     //指定换行模式
        lblName.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:lblName];
        tfCount = [[UILabel alloc] initWithFrame:CGRectMake(109*2, 10,109, 30)];
        tfCount.backgroundColor=[UIColor lightGrayColor];
        tfCount.textColor=[UIColor redColor];
        tfCount.textAlignment=NSTextAlignmentCenter;
        tfCount.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:tfCount];
        jia=[UIButton buttonWithType:UIButtonTypeCustom];
        jia.frame=CGRectMake(109*2-20,5, 40, 40);
        [jia setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Add.png"] forState:UIControlStateNormal];
        [jia addTarget:self action:@selector(countchange:) forControlEvents:UIControlEventTouchUpInside];
        jia.tag=1;
        [self.contentView addSubview:jia];
        jian=[UIButton buttonWithType:UIButtonTypeCustom];
        jian.frame=CGRectMake(109*3-20, 5, 40, 40);
        [jian setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Subtract.png"] forState:UIControlStateNormal];
        jian.tag=2;
        [jian addTarget:self action:@selector(countchange:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:jian];
        tfPrice = [[UILabel alloc] initWithFrame:CGRectMake(109*3, 15, 109, 25)];
        tfPrice.backgroundColor = [UIColor clearColor];
        tfPrice.textAlignment=NSTextAlignmentRight;
        tfPrice.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:tfPrice];
        
        lblUnit = [[UILabel alloc] init];
        
        lblUnit.textAlignment=NSTextAlignmentCenter;
        lblUnit.font = [UIFont systemFontOfSize:16];
        lblUnit.frame=CGRectMake(109*4, 15, 109, 25);
        lblUnit.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblUnit];
        UIButton *btnUnit=[UIButton buttonWithType:UIButtonTypeCustom];
        btnUnit.backgroundColor=[UIColor clearColor];
        btnUnit.frame=CGRectMake(109*4, 15, 109, 25);
        [btnUnit addTarget:self action:@selector(changeUnit:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnUnit];
        
        lblTotalPrice = [[UILabel alloc] init ];
        
        lblTotalPrice.textAlignment=NSTextAlignmentRight;
        lblTotalPrice.backgroundColor = [UIColor clearColor];
        lblTotalPrice.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:lblTotalPrice];
        lb=[[UILabel alloc] initWithFrame:CGRectMake(75, 45, 100, 25)];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor grayColor];
        [self.contentView addSubview:lb];
        lblAddition = [[UILabel alloc] initWithFrame:CGRectMake(170, 45, 440, 25)];
        lblAddition.backgroundColor = [UIColor clearColor];
        lblAddition.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:lblAddition];
        //        lblAddition.text = [langSetting localizedString:@"Additions:"];//@"附加项:";
        
        btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btnAdd setImage:imgPlusNormal forState:UIControlStateNormal];
        //        [btnAdd setImage:imgPlusPressed forState:UIControlStateHighlighted];
        [btnAdd sizeToFit];
        [self.contentView addSubview:btnAdd];
        [btnAdd addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [btnAdd setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Present.png"] forState:UIControlStateNormal];
        btnReduce = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnReduce setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Delect.png"] forState:UIControlStateNormal];
        //        [btnReduce setImage:imgMinusNormal forState:UIControlStateNormal];
        //        [btnReduce setImage:imgMinusPressed forState:UIControlStateHighlighted];
        [btnReduce sizeToFit];
        //btnReduce.center = CGPointMake(109*6+90, 30);//620,30,675,30
        
        [self.contentView addSubview:btnReduce];
        [btnReduce addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
        btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnEdit.frame = CGRectMake(109*5.7+45, 10, 60, 40);
        [btnEdit setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Addition.png"] forState:UIControlStateNormal];
        [btnEdit sizeToFit];
        
        [self.contentView addSubview:btnEdit];
        [btnEdit addTarget:self action:@selector(setAddition) forControlEvents:UIControlEventTouchUpInside];
        
        lblTotalPrice.frame= CGRectMake(109*5-20, 15, 100, 25);
        
        btnAdd.frame=CGRectMake(109*5.7, 10, 40, 40);
        btnReduce.frame=CGRectMake(109*5.7+110, 10, 40, 40);
        lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 768, 2)];
        lblLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:lblLine];
    }
    return self;
}

-(void)countchange:(UIButton *)btn
{
    if (btn.tag==1) {
        [delegate cell:self count:1];
    }else if(btn.tag==2){
        if ([tfCount.text intValue]-1>0) {
            [delegate cell:self count:-1];
        }
        else
        {
            [self reduce];
        }
        
    }
}
/**
 *  换单位
 *
 *  @param btn
 */
-(void)changeUnit:(UIButton *)btn
{
    [delegate unitOfCellChanged:self];
       
}
#pragma mark Handle Button Events
/**
 *  数量加
 */
- (void)add{
    BOOL ZS;
    if ([self.lblTotalPrice.text floatValue]!=[[NSString stringWithFormat:@"%.2f",[self.tfPrice.text floatValue]*[self.tfCount.text floatValue]] floatValue]) {
        ZS=NO;
    }
    else
    {
        ZS=YES;
    }
    
    [delegate cell:self present:ZS];
}
/**
 *  删除
 */
- (void)reduce{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否确定要从列表中移除这个菜品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"移除", nil];
    [alert show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"移除"]){
        [delegate cell:self countChanged:0];
    }
}
/**
 *  设置附加项
 */
- (void)setAddition{
    self.supTableView.userInteractionEnabled=NO;
    if (!vAddition){
        vAddition = [[AKAdditionView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withSelectAddtions:[dicInfo objectForKey:@"addition"]];
        vAddition.delegate = self;
        [self.window addSubview:vAddition];
//        vAddition.arySelectedAddtions=[[NSMutableArray alloc] initWithArray:[dicInfo objectForKey:@"addition"]];
    }
    //    [vAddition presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark - AKAdditionViewDelegate
- (void)additionSelected:(NSArray *)ary{
    self.supTableView.userInteractionEnabled=YES;
    if (ary!=nil) {
        [delegate cell:self additionChanged:[NSMutableArray arrayWithArray:ary]];
    }
    [vAddition removeFromSuperview];
    vAddition=nil;
}

/**
 *  删除
 */
- (void)deleteSelf{
    [delegate cell:self countChanged:0];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        if ([textField.text length]>=2) {
            return NO;
        }
        NSString *validRegEx =@"^[0-9]$";
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        if (myStringMatchesRegEx)
            return YES;
        else
            return NO;
    }
}

@end
