//
//  AKQueryTableViewCell.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/14.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKQueryTableViewCell.h"

@implementation AKQueryTableViewCell
@synthesize foodDic=_foodDic,couponDic=_couponDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *CaiCount=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 60, 45)];
        CaiCount.textAlignment=NSTextAlignmentCenter;
        CaiCount.tag=1000;
        CaiCount.backgroundColor=[UIColor clearColor];
        CaiCount.font=[UIFont systemFontOfSize:17];
        [self.contentView addSubview:CaiCount];
        
        UILabel *CaiName=[[UILabel alloc]initWithFrame:CGRectMake(60,0, 190, 45)];
        CaiName.textAlignment=NSTextAlignmentLeft;
        CaiName.tag=1001;
        CaiName.backgroundColor=[UIColor clearColor];
        CaiName.font=[UIFont systemFontOfSize:17];
        [self.contentView addSubview:CaiName];
        
        UILabel *CaiPrice=[[UILabel alloc]initWithFrame:CGRectMake(240,0, 70, 45)];
        CaiPrice.textAlignment=NSTextAlignmentRight;
        CaiPrice.tag=1002;
        CaiPrice.backgroundColor=[UIColor clearColor];
        CaiPrice.font=[UIFont systemFontOfSize:17];
        [self.contentView addSubview:CaiPrice];
        
        UILabel *YouName=[[UILabel alloc]initWithFrame:CGRectMake(0+20,0, 155-20, 50)];
        YouName.textAlignment=NSTextAlignmentLeft;
//        YouName.text=[NSString stringWithFormat:@"%@",list.youName];
        YouName.backgroundColor=[UIColor clearColor];
        YouName.tag=1003;
        YouName.font=[UIFont systemFontOfSize:17];
        [self.contentView addSubview:YouName];
        
        
        
        UILabel *YouMoney=[[UILabel alloc]initWithFrame:CGRectMake(155-8,0, 155, 50)];
        YouMoney.textAlignment=NSTextAlignmentRight;
//        YouMoney.text=[NSString stringWithFormat:@"-%.2f",[list.youMoney floatValue]];
        YouMoney.tag=1004;
        YouMoney.backgroundColor=[UIColor clearColor];
        YouMoney.font=[UIFont systemFontOfSize:17];
        [self.contentView addSubview:YouMoney];
        
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 310, 1)];
        line.backgroundColor=[UIColor blackColor];
        line.alpha=0.7;
        [self.contentView addSubview:line ];

    }
    return self;
}
-(void)setFoodDic:(NSDictionary *)foodDic
{
    
    UILabel *lb=(UILabel *)[self.contentView viewWithTag:1000];
    lb.text=[foodDic objectForKey:@"pcount"];
    lb=(UILabel *)[self.contentView viewWithTag:1001];
    lb.text=[foodDic objectForKey:@"PCname"];
    lb=(UILabel *)[self.contentView viewWithTag:1002];
    lb.text=[foodDic objectForKey:@"price"];
    lb=(UILabel *)[self.contentView viewWithTag:1003];
    lb.text=@"";
    lb=(UILabel *)[self.contentView viewWithTag:1004];
    lb.text=@"";
    
}
-(void)setCouponDic:(NSDictionary *)couponDic
{
    UILabel *lb=(UILabel *)[self.contentView viewWithTag:1001];
    lb.text=@"";
    lb=(UILabel *)[self.contentView viewWithTag:1002];
    lb.text=@"";
    lb=(UILabel *)[self.contentView viewWithTag:1003];
    lb.text=[couponDic objectForKey:@"paymentName"];
    lb=(UILabel *)[self.contentView viewWithTag:1004];
    lb.text=[couponDic objectForKey:@"paymentShowPrice"];

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
