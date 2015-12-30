//
//  AKMySegmentAndView.h
//  BookSystem
//
//  Created by sundaoran on 13-11-21.
//
//

#import <UIKit/UIKit.h>
#import "AKShouldCheckView.h"


@protocol AKMySegmentAndViewDelegate <NSObject>


@optional
-(void)selectSegmentIndex:(NSString *)segmentIndex andSegment:(UISegmentedControl *)segment;
-(void)shouldCheckViewClick:(NSDictionary *)checkDic;
@end

@interface AKMySegmentAndView : UIView<AKShouldCheckViewDelegate>
{
    __weak id<AKMySegmentAndViewDelegate>_delegate;
}
@property(nonatomic,strong)UILabel *table,*CheckNum,*man,*woman;
@property(nonatomic,weak)__weak id<AKMySegmentAndViewDelegate>delegate;

//-(void)setsegmentIndex:(NSString *)index;
-(void)setTitle:(NSString *)title;
-(void)segmentShow:(BOOL)SHOW;
-(void)shoildCheckShow:(BOOL)SHOW;
-(void)peopelNumOrManandWoman;
+(AKMySegmentAndView *)shared;

@property(nonatomic,strong)AKShouldCheckView  *shoildCheck;


@end
