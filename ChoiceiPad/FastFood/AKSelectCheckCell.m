//
//  AKSelectCheckCell.m
//  BookSystem
//
//  Created by chensen on 13-12-26.
//
//

#import "AKSelectCheckCell.h"

@implementation AKSelectCheckCell
@synthesize name=_name,count1=_count1,price=_price,unit=_unit,addition=_addition,lb=_lb;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization cod
        _name=[[UILabel alloc] initWithFrame:CGRectMake(0, 0,100, 60)];
        _name.lineBreakMode = UILineBreakModeWordWrap;     //指定换行模式
        _name.numberOfLines = 3;    // 指定label的行数
        _name.textColor=[UIColor blackColor];
        [self.contentView addSubview:_name];
        _count1=[[UILabel alloc] initWithFrame:CGRectMake(100, 0,59, 60)];
        _count1.textColor=[UIColor blackColor];
        _count1.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_count1];
        _price=[[UILabel alloc] initWithFrame:CGRectMake(159, 0, 59, 60)];
        _price.textColor=[UIColor blackColor];
        _price.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:_price];
        _unit=[[UILabel alloc] initWithFrame:CGRectMake(100+59*2, 0, 59, 60)];
        _unit.textColor=[UIColor blackColor];
        _unit.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_unit];
//        _lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 60, 59, 30)];
//        _lb.text=@"附加项";
//        _lb.textColor=[UIColor redColor];
        [self.contentView addSubview:_lb];
        _addition=[[UILabel alloc] initWithFrame:CGRectMake(100+59*3, 0, 300, 60)];
        _addition.lineBreakMode = UILineBreakModeWordWrap;     //指定换行模式
        _addition.numberOfLines = 3;    // 指定label的行数
        _addition.textColor=[UIColor blackColor];
        [self.contentView addSubview:_addition];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 59,768, 2)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
