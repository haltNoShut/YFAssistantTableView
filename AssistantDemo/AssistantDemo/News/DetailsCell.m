//
//  DetailsCell.m
//  AssistantDemo
//
//  Created by 杨帆 on 2016/10/1.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "DetailsCell.h"
#import "DetailNewsModel.h"

@implementation DetailsCell
{
    
    __weak IBOutlet UIWebView *_webView;
}

-(void)prepareForReuse{
    
    [super prepareForReuse];
    [_webView loadHTMLString:@"" baseURL:nil];
}

- (void)setModel:(DetailNewsModel *)model{
    
    _model = model;
    [_webView loadHTMLString:model.content baseURL:nil];
    
}

@end
