//
//  DetailNewsModel.m
//  AssistantDemo
//
//  Created by 杨帆 on 2016/10/2.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "DetailNewsModel.h"
#import "AFNetworking.h"

#define detail_news_server @"http://c.m.163.com/nc/article/%@/full.html"

@implementation DetailNewsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{@"content":@"body"};
}

+ (void)requestDetailNews:(NSString *)postid completion:(void (^)(DetailNewsModel *model))completion{
    
    NSString *url = [NSString stringWithFormat:detail_news_server,postid];
    [[AFHTTPSessionManager manager] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *data = [responseObject valueForKey:postid];
        DetailNewsModel *model = [MTLJSONAdapter modelOfClass:[DetailNewsModel class] fromJSONDictionary:data error:nil];
        if (completion) {
            completion(model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
