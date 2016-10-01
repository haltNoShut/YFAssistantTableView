//
//  SynopsisCell.m
//  AssistantDemo
//
//  Created by 杨帆 on 2016/10/1.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "SynopsisCell.h"
#import "NewsModel.h"
#import "UIImageView+AFNetworking.h"

@implementation SynopsisCell
{
    __weak IBOutlet UIImageView *imgView;
    __weak IBOutlet UILabel *desLabel;
    __weak IBOutlet UILabel *titleLabel;
}

- (void)setModel:(NewsModel *)model{
    
    _model = model;
    titleLabel.text = _model.title;
    desLabel.text = _model.digest;
    [imgView setImageWithURL:[NSURL URLWithString:_model.imgsrc]];
}

@end
