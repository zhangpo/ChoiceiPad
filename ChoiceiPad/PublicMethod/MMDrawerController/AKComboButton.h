//
//  AKComboButton.h
//  BookSystem
//
//  Created by chensen on 14-2-28.
//
//

#import <UIKit/UIKit.h>

@interface AKComboButton : UIButton
@property(nonatomic,assign)int btnTag;
@property(nonatomic,strong)UILabel *titleLabel1;
@property(nonatomic,strong)UILabel *lblCount;
@property(nonatomic,strong)NSString *PCODE;
@property(nonatomic,strong)NSDictionary *dataInfo;
@end
