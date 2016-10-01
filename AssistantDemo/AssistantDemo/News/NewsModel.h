//
//  NewsModel.h
//  AssistantDemo
//
//  Created by 杨帆 on 2016/10/1.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import <Mantle.h>
@interface NewsModel : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *digest;
@property (copy, nonatomic) NSString *imgsrc;
@property (copy, nonatomic) NSString *detailURL;

+ (void )requestNewsModels:(void (^)(NSArray *models)) completion;

@end
