//
//  AKTableCell.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/7/13.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKTableCell.h"

@implementation AKTableCell

@synthesize dataInfo=_dataInfo,delegate=_delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        image.tag=100;
        [self.contentView addSubview:image];
        UILabel *manLabel=[[UILabel alloc] initWithFrame:CGRectMake(102,1.5, 30, 20)];
        manLabel.textAlignment=NSTextAlignmentRight;
        manLabel.textColor=[UIColor whiteColor];
        manLabel.backgroundColor=[UIColor clearColor];
        manLabel.tag=101;
        manLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:manLabel];
        
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:image.frame];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.backgroundColor=[UIColor clearColor];
        nameLabel.font=[UIFont boldSystemFontOfSize:25];
        nameLabel.tag=102;
        nameLabel.numberOfLines=0;
        nameLabel.lineBreakMode=NSLineBreakByCharWrapping;
        [self.contentView addSubview:nameLabel];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        button.backgroundColor=[UIColor clearColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 0.8;
        [self.contentView addGestureRecognizer:longPressGr];
    }
    return self;
}
#pragma mark - 点击事件
-(void)buttonClick:(UIButton *)button
{
    NSLog(@"%@",_dataInfo);
    [_delegate AKTableCellClick:_dataInfo];
}
#pragma mark - 长按事件
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if ([Mode isEqualToString:@"zc"])
        {
            [_delegate AKTableCellLongClick:_dataInfo];
        }else
        {
        int state=[[_dataInfo objectForKey:@"status"] integerValue];
        if (state!=1&&state!=4&&state!=6)
            [_delegate AKTableCellLongClick:_dataInfo];
        }
        
    }
}
-(void)setDataInfo:(NSDictionary *)dataInfo
{
    _dataInfo=dataInfo;
    if ([Mode isEqualToString:@"zc"]) {
        UILabel *lb=(UILabel *)[self.contentView viewWithTag:101];
        lb.text=[dataInfo objectForKey:@"man"];
        lb=(UILabel *)[self.contentView viewWithTag:102];
        lb.text=[dataInfo objectForKey:@"name"];
    }else
    {
    UILabel *lb=(UILabel *)[self.contentView viewWithTag:101];
    lb.text=[dataInfo objectForKey:@"man"];
    lb=(UILabel *)[self.contentView viewWithTag:102];
    lb.text=[dataInfo objectForKey:@"num"];
    }
}
@end
