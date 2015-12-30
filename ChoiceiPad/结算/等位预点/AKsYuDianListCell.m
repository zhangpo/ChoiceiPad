//
//  AKsYuDianListCell.m
//  BookSystem
//
//  Created by sundaoran on 13-12-29.
//
//

#import "AKsYuDianListCell.h"

@implementation AKsYuDianListCell
@synthesize infoDic=_infoDic;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *CaiCount=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 80, 55)];
        CaiCount.textAlignment=NSTextAlignmentCenter;
        CaiCount.tag=100;
        CaiCount.backgroundColor=[UIColor clearColor];
        CaiCount.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [self.contentView addSubview:CaiCount];
        
        UILabel *CaiName=[[UILabel alloc]initWithFrame:CGRectMake(80,0, 220, 55)];
        CaiName.textAlignment=NSTextAlignmentLeft;
        CaiName.tag=101;
        //        if((![caidan.pcode isEqualToString:caidan.tpcode]) && (![caidan.tpcode isEqualToString:@""]))
        //        {
        //            if([caidan.weightflag isEqualToString:@"1"])
        //            {
        //                CaiName.text=[NSString stringWithFormat:@"   %@",caidan.pcname];
        //            }
        //            else
        //            {
        //                CaiName.text=[NSString stringWithFormat:@"   %@(赠送:%@)",caidan.pcname,caidan.weight];
        //            }
        //            CaiName.textColor=[UIColor grayColor];
        //
        //        }
        //        else
        //        {
        //            if([caidan.weightflag isEqualToString:@"1"])
        //            {
        //                CaiName.text=[NSString stringWithFormat:@"%@",caidan.pcname];
        //
        //            }
        //            else
        //            {
        //                CaiName.text=[NSString stringWithFormat:@"%@(赠送:%@)",caidan.pcname,caidan.weight];
        //
        //            }
        //
        //        }
        
        CaiName.backgroundColor=[UIColor clearColor];
        CaiName.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [self.contentView addSubview:CaiName];
        
        UILabel *CaiPrice=[[UILabel alloc]initWithFrame:CGRectMake(300,0, 100, 45)];
        CaiPrice.textAlignment=NSTextAlignmentCenter;
        //        CaiPrice.text=[NSString stringWithFormat:@"%.2f",[caidan.price floatValue]];
        CaiPrice.backgroundColor=[UIColor clearColor];
        CaiPrice.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        CaiPrice.tag=102;
        [self.contentView addSubview:CaiPrice];
        UILabel *line=[[UILabel alloc]init];
        line.backgroundColor=[UIColor blackColor];
        line.tag=103;
        line.alpha=0.7;
        [self.contentView addSubview:line ];
        //        if(![caidan.fujianame isEqualToString:@""])
        //        {
        //            NSArray *fujiaArray=[caidan.fujianame componentsSeparatedByString:@"!"];
        //            NSString *str=[fujiaArray objectAtIndex:0];
        line.frame=CGRectMake(0, 89, 768-370, 2);
        //        for (int i=1; i<[fujiaArray count]; i++)
        //            {
        //                str=[str stringByAppendingString:[NSString stringWithFormat:@",%@",[fujiaArray objectAtIndex:i]]];
        //            }
        //
        UILabel *FujiaName=[[UILabel alloc]initWithFrame:CGRectMake(30,45, 290, 45)];
        FujiaName.textAlignment=NSTextAlignmentLeft;
        FujiaName.tag=104;
        //            FujiaName.text=[NSString stringWithFormat:@"附加项：%@",str];
        //
        FujiaName.backgroundColor=[UIColor clearColor];
        FujiaName.font=[UIFont systemFontOfSize:20];
        [self.contentView addSubview:FujiaName];
        
        UILabel *FujiaPrice=[[UILabel alloc]initWithFrame:CGRectMake(320,45,60, 45)];
        FujiaPrice.tag=105;
        FujiaPrice.textAlignment=NSTextAlignmentCenter;
        //            FujiaPrice.text=[NSString stringWithFormat:@"%.2f元",[caidan.fujiaprice floatValue]];
        FujiaPrice.backgroundColor=[UIColor clearColor];
        FujiaPrice.font=[UIFont systemFontOfSize:20];
        [self.contentView addSubview:FujiaPrice ];
        //        }
        //        else
        //        {
        line.frame=CGRectMake(0, 43, 768-370, 2);
        //        }
    }
    return self;
}

-(void)setInfoDic:(NSDictionary *)infoDic
{
    UILabel *lb=(UILabel *)[self.contentView viewWithTag:101];
    lb.text=[infoDic objectForKey:@"PCname"];
    lb=(UILabel *)[self.contentView viewWithTag:100];
    lb.text=[infoDic objectForKey:@"pcount"];
    lb=(UILabel *)[self.contentView viewWithTag:102];
    lb.text=[infoDic objectForKey:@"talPreice"];
    lb=(UILabel *)[self.contentView viewWithTag:103];
    if ([[infoDic objectForKey:@"fujianame"] length]>0) {
        lb.frame=CGRectMake(0, 89, 768-370, 2);
        lb=(UILabel *)[self.contentView viewWithTag:104];
        lb.hidden=NO;
        lb.text=[NSString stringWithFormat:@"附加项:%@",[infoDic objectForKey:@"fujianame"]];
        lb=(UILabel *)[self.contentView viewWithTag:105];
        lb.hidden=NO;
        lb.text=[NSString stringWithFormat:@"%.2f元",[[infoDic objectForKey:@"fujiaPrice"] floatValue]];
        
    }else
    {
        lb.frame=CGRectMake(0, 43, 768-370, 2);
        lb=(UILabel *)[self.contentView viewWithTag:104];
        lb.hidden=YES;
        lb=(UILabel *)[self.contentView viewWithTag:105];
        lb.hidden=YES;
    }
    //    lb.text=[infoDic objectForKey:@"pcount"];
    
    
}
-(void)setCellForArray:(AKsCanDanListClass *)caidan
{
    [self greatView:caidan];
}

-(void)greatView:(AKsCanDanListClass *)caidan
{
    
    
}


-(void)setCellForAKsYouHuiList:(AKsYouHuiListClass *)list
{
    [self creatView:list];
}

-(void)creatView:(AKsYouHuiListClass*)list
{
    UILabel *YouName=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 155, 50)];
    YouName.textAlignment=NSTextAlignmentCenter;
    YouName.text=[NSString stringWithFormat:@"%@",list.youName];
    YouName.backgroundColor=[UIColor clearColor];
    YouName.font=[UIFont systemFontOfSize:17];
    [self.contentView addSubview:YouName];
    
    
    
    UILabel *YouMoney=[[UILabel alloc]initWithFrame:CGRectMake(155,0, 155, 50)];
    YouMoney.textAlignment=NSTextAlignmentCenter;
    YouMoney.text=[NSString stringWithFormat:@"-%.2f",[list.youMoney floatValue]];
    YouMoney.backgroundColor=[UIColor clearColor];
    YouMoney.font=[UIFont systemFontOfSize:17];
    [self.contentView addSubview:YouMoney];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0,0,768-370, 1)];
    line.backgroundColor=[UIColor blackColor];
    line.alpha=0.7;
    [self.contentView addSubview:line ];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
