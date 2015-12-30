//
//  AKPrivateAdditionCell.m
//  BookSystem-iPhone
//
//  Created by chensen on 15/3/24.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import "AKPrivateAdditionCell.h"

@implementation AKPrivateAdditionCell
@synthesize dataDic=_dataDic,delegate=_delegate,indexPath=_indexPath;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *FNAME=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        FNAME.backgroundColor=[UIColor clearColor];
        FNAME.textAlignment=NSTextAlignmentLeft;
        FNAME.tag=100;
        [self.contentView addSubview:FNAME];
        UILabel *FCOUNT=[[UILabel alloc] initWithFrame:CGRectMake(280, 5, 50, 30)];
        FCOUNT.backgroundColor=[UIColor clearColor];
        FCOUNT.textAlignment=NSTextAlignmentCenter;
        FCOUNT.tag=101;
        FCOUNT.textColor=[UIColor blackColor];
        [self.contentView addSubview:FCOUNT];
        UILabel *FPRICE=[[UILabel alloc] initWithFrame:CGRectMake(210, 0, 70, 40)];
        FPRICE.backgroundColor=[UIColor clearColor];
        FPRICE.textAlignment=NSTextAlignmentLeft;
        FPRICE.tag=102;
        [self.contentView addSubview:FPRICE];
        for (int i=1; i>=0; i--) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.tag=200+i;
            if (i==1) {
                [button setBackgroundImage:[UIImage imageNamed:@"missPhone.png"] forState:UIControlStateNormal];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"addphone.png"] forState:UIControlStateNormal];
            }
            button.frame=CGRectMake(FCOUNT.frame.origin.x+40,0, 40, 40);
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
    }
    return self;
}
-(void)btnClick:(UIButton *)button
{
    if(button.tag==200){
        [UIView animateWithDuration:0.5 animations:^{
            UIView *view=[self.contentView viewWithTag:201];
            view.frame=CGRectMake(250, 0, 40, 40);
        } completion:^(BOOL finished) {
            
        }];
    }
    [_dataDic setValue:[NSString stringWithFormat:@"%d",button.tag] forKey:@"TYPE"];
    [_delegate AKPrivateAdditionBtnClick:self];
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic=dataDic;
    UILabel *lb=(UILabel *)[self.contentView viewWithTag:100];
    lb.text=[dataDic objectForKey:@"FNAME"];
    lb=(UILabel *)[self.contentView viewWithTag:101];
    UIView *view=[self.contentView viewWithTag:201];
    if ([[dataDic objectForKey:@"count"] intValue]>0) {
        lb.text=[dataDic objectForKey:@"count"];
        view.frame=CGRectMake(250, 0, 40, 40);
    }else
    {
        lb.text=@"";
        view.frame=CGRectMake(320, 0, 40, 40);
    }
    lb=(UILabel *)[self.contentView viewWithTag:102];
    lb.text=[dataDic objectForKey:@"FPRICE"];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
