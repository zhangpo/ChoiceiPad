//
//  BSAllCheakRightCell.m
//  BookSystem
//
//  Created by chensen on 14-1-18.
//
//

#import "BSAllCheakRightCell.h"

@implementation BSAllCheakRightCell
@synthesize lblName=_lblName,lblCount=_lblCount,lblOver=_lblOver;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _lblName=[[UILabel alloc] initWithFrame:CGRectMake(5, 0,150, 50)];
        _lblName.backgroundColor=[UIColor clearColor];
        _lblName.numberOfLines =0;
        _lblName.lineBreakMode =NSLineBreakByWordWrapping;
    
        [self.contentView addSubview:_lblName];
        _lblOver=[[UILabel alloc] initWithFrame:CGRectMake(180, 0,50, 50)];
        _lblOver.backgroundColor=[UIColor clearColor];
        _lblOver.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_lblOver];
        _lblCount=[[UILabel alloc] initWithFrame:CGRectMake(230, 0,50, 50)];
        _lblCount.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_lblCount];
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
