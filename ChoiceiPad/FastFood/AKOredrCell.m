//
//  AKOredrCell.m
//  BookSystem
//
//  Created by chensen on 14-1-13.
//
//

#import "AKOredrCell.h"

@implementation AKOredrCell
@synthesize name=_name,count=_count;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _name=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 50)];
//        _name.backgroundColor=[UIColor blackColor];
        _name.numberOfLines =0;
        _name.lineBreakMode = UILineBreakModeWordWrap;
        [self.contentView addSubview:_name];
        _count=[[UILabel alloc] initWithFrame:CGRectMake(240, 0, 30, 50)];
//        _count.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_count];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 49, 280, 2)];
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
