//
//  DetailsCell.m
//  AssistantDemo
//
//  Created by 杨帆 on 2016/10/1.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "DetailsCell.h"

@implementation DetailsCell
{
    
    __weak IBOutlet UIWebView *_webView;
}

- (void)setURL:(NSString *)URL {
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:URL]];
    [_webView loadRequest:request];
    
}

@end
