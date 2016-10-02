//
//  DetailNewsModel.h
//  AssistantDemo
//
//  Created by 杨帆 on 2016/10/2.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface DetailNewsModel : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *content;

+ (void)requestDetailNews:(NSString *)postid completion:(void (^)(DetailNewsModel *model))completion;

@end
