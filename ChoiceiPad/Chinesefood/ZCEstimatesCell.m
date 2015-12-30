//
//  ZCEstimatesCell.m
//  ChoiceiPad
//
//  Created by chensen on 15/8/14.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZCEstimatesCell.h"

@implementation ZCEstimatesCell
{
    UILabel *foodName;
    UILabel *foodCnt;
    UIButton *doEstimatesBtn;
    UIButton *dontEstimatesBtn;
    
}
@synthesize estimatesDic=_estimatesDic,delegate=_delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        foodName=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
        foodName.numberOfLines=0;
//        foodName.backgroundColor=[UIColor lightGrayColor];
        foodName.lineBreakMode=NSLineBreakByWordWrapping;
        [self.contentView addSubview:foodName];
        foodCnt=[[UILabel alloc] initWithFrame:CGRectMake(370, 10, 100, 50)];
        foodCnt.textAlignment=NSTextAlignmentRight;
//        foodCnt.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:foodCnt];
        doEstimatesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        doEstimatesBtn.frame=CGRectMake(510, 10, 100, 50);
        [doEstimatesBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [doEstimatesBtn setTitle:@"估清设置" forState:UIControlStateNormal];

        doEstimatesBtn.tag=100;
        doEstimatesBtn.backgroundColor=[UIColor redColor];
        [self addSubview:doEstimatesBtn];
        dontEstimatesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        dontEstimatesBtn.frame=CGRectMake(630, 10, 100, 50);
        [dontEstimatesBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [dontEstimatesBtn setTitle:@"取消估清" forState:UIControlStateNormal];
        dontEstimatesBtn.backgroundColor=[UIColor lightGrayColor];
        dontEstimatesBtn.tag=101;
        [self addSubview:dontEstimatesBtn];
        
    }
    return self;
}
-(void)setEstimatesDic:(NSDictionary *)estimatesDic
{
    _estimatesDic=estimatesDic;
    dontEstimatesBtn.hidden=YES;
    foodCnt.text=@"";
    foodName.textColor=[UIColor blackColor];
    foodName.text=[estimatesDic objectForKey:@"DES"];
    if ([[estimatesDic objectForKey:@"SOLDOUT"]boolValue]) {
        foodName.textColor=[UIColor redColor];
        foodCnt.text=[estimatesDic objectForKey:@"SOLDOUTCNT"];
        dontEstimatesBtn.hidden=NO;
    }
    
}
-(void)buttonClick:(UIButton *)btn
{
    [_estimatesDic setValue:[NSString stringWithFormat:@"%d",btn.tag] forKey:@"TAG"];
    [_delegate ZCEstimatesCellClick:_estimatesDic];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
