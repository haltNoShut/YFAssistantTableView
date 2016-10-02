//
//  NewsModel.m
//  AssistantDemo
//
//  Created by 杨帆 on 2016/10/1.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "NewsModel.h"
#import "AFNetworking.h"

#define news_server @"http://c.m.163.com/nc/article/list/T1348648517839/0-20.html"

@implementation NewsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return nil;
}

+ (void )requestNewsModels:(void (^)(NSArray *models)) completion{
    
    [[AFHTTPSessionManager manager] GET:news_server parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *data = [responseObject valueForKey:@"T1348648517839"];
        if (data.count>2) {
            NSArray *newsModels = [MTLJSONAdapter modelsOfClass:[self class] fromJSONArray:[data mtl_arrayByRemovingFirstObject] error:nil];
            if (completion) {
                completion(newsModels);
            }
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
