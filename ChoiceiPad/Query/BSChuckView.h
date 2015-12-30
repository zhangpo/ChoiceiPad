//
//  BSChunkView.h
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

@protocol  ChuckViewDelegate

- (void)chuckOrderWithOptions:(NSDictionary *)info;

@end

@interface BSChuckView : BSRotateView <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    UIButton *btnChunk,*btnCancel;
    UILabel *lblAcct,*lblPwd,*_lblcount,*lblReason, *_lblfan;
    UITextField *tfAcct,*tfPwd,*_tfcount,*_tffan;
    UIPickerView *pickerReason;
    __weak id<ChuckViewDelegate> delegate;
    int dSelected;
}
@property(nonatomic,strong)UILabel *lblcount;
@property(nonatomic,strong)UILabel *lblfan;
@property(nonatomic,strong)UITextField *tffan;
@property(nonatomic,strong)UITextField *tfcount;
@property (nonatomic,weak)__weak id<ChuckViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withTag:(int)tag;

@end
