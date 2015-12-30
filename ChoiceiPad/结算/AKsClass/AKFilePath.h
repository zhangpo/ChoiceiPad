//路径
//  AKFilePath.h
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import <Foundation/Foundation.h>

@interface AKFilePath : NSObject
+(NSString *)getBundleFilePathWithFileName:(NSString *)name;
+(NSString *)getDocumentFilePathWithFileName:(NSString *)name;
+(NSString *)getPadID;
+(NSDictionary *)getDicCurrentPageConfig;
@end
