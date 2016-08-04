//
//  YFAssistantTableView.h
//  ttt
//
//  Created by 杨帆 on 16/8/3.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  真正的indexpath,既考虑assistants影响的indexpath
 */
typedef NSIndexPath ActualIndexPath;
/**
 *  逻辑转换后的indexpath,既不考虑assistants影响的原始的indexpath
 */
typedef NSIndexPath LogicIndexPath;
@class YFAssistantTableView;
@protocol YFAssistantDelegate <NSObject>
@required
- (BOOL)YFAssistantTableView:(YFAssistantTableView *)tableView shouldSpreadAssistantAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)YFAssistantTableView:(YFAssistantTableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)YFAssistantTableView:(YFAssistantTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)YFAssistantTableView:(YFAssistantTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (UITableViewRowAnimation )YFAssistantTableViewSpreadAnimation:(YFAssistantTableView *)tableView;
- (UITableViewRowAnimation )YFAssistantTableViewRetractAnimation:(YFAssistantTableView *)tableView;
@end

@interface YFAssistantTableView : UITableView

@property(nonatomic,weak)id<YFAssistantDelegate> assistantDelegate;

- (void)spreadAssistant:(NSIndexPath *)indexPath;

- (void)retractAssistant:(NSIndexPath *)indexPath;

- (LogicIndexPath *)actualIndexPath2Logic:(ActualIndexPath *)indexPath;

- (ActualIndexPath *)logicIndexPath2Actual:(LogicIndexPath *)indexPath;

@end
