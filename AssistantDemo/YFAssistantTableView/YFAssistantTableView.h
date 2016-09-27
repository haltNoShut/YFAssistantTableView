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
/**
 *  YFAssistantDelegate方法内调用系统原生方法时，需要YF_logicIndexPath2Actual还原成真实indexPath
 */
- (UITableViewCell *)YFAssistantTableView:(YFAssistantTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
/**
 *  YFAssistantDelegate方法内调用系统原生方法时，需要YF_logicIndexPath2Actual还原成真实indexPath
 */
- (BOOL)YFAssistantTableView:(YFAssistantTableView *)tableView shouldSpreadAssistantAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  YFAssistantDelegate方法内调用系统原生方法时，需要YF_logicIndexPath2Actual还原成真实indexPath
 */
- (CGFloat)YFAssistantTableView:(YFAssistantTableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  YFAssistantDelegate方法内调用系统原生方法时，需要YF_logicIndexPath2Actual还原成真实indexPath
 */
- (CGFloat)YFAssistantTableView:(YFAssistantTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  展开时动画效果
 */
- (UITableViewRowAnimation )YFAssistantTableViewSpreadAnimation:(YFAssistantTableView *)tableView;
/**
 *  缩回时动画效果
 */
- (UITableViewRowAnimation )YFAssistantTableViewRetractAnimation:(YFAssistantTableView *)tableView;
@end

@interface YFAssistantTableView : UITableView

@property(nonatomic,weak)id<YFAssistantDelegate> assistantDelegate;

/**
 *  如果已经展开当前indexpath，再次调用spreadAssistant时，是否缩回,默认NO
 */
@property(nonatomic)BOOL retractWhenSpread;

- (void)spreadAssistant:(NSIndexPath *)indexPath;

- (void)retractAssistant:(NSIndexPath *)indexPath;

/**
 *  @param indexPath 真正的indexpath,既考虑assistants影响的indexpath
 *
 *  @return 逻辑转换后的indexpath,既不考虑assistants影响的原始的indexpath
 */
- (LogicIndexPath *)actualIndexPath2Logic:(ActualIndexPath *)indexPath;

/**
 * 任何情况(除YFAssistantDelegate方法内)调用含有NSIndexPath参数的系统原生方法时，需要用- (ActualIndexPath *)logicIndexPath2Actual:(LogicIndexPath *)indexPath进行IndexPath还原
 * ①:UITableViewDelegate和UITableViewDataSource的方法内需要调用
 * - (void)tableView:(YFAssistantTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 * ActualIndexPath *actual = [tableView logicIndexPath2Actual:indexPath];
 * [tableView deselectRowAtIndexPath:actual animated:NO];
 * }
 * ②:其它地方调用
 * ActualIndexPath *actualIndexPath = [yfAssistantTableView logicIndexPath2Actual:logicIndexPath];
 * [self tableView:yfAssistantTableView didSelectRowAtIndexPath:actualIndexPath];
 *
 *  @param indexPath 逻辑转换后的indexPath,既不考虑assistants影响的原始的indexPath
 *
 *  @return 真正的indexPath,既考虑assistants影响的indexPath
 */
- (ActualIndexPath *)logicIndexPath2Actual:(LogicIndexPath *)indexPath;

/**
 * YFAssistantDelegate方法内调用系统原生方法时，需要YF_logicIndexPath2Actual还原成真实indexPath
 * - (UITableViewCell *)YFAssistantTableView:(YFAssistantTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 * ActualIndexPath *actual = [tableView YF_logicIndexPath2Actual:indexPath];
 * UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"assistant" forIndexPath:actual];
 * return cell;
 * }
 *
 *  @param indexPath 逻辑转换后的indexpath,既不考虑assistants影响的原始的indexpath
 *
 *  @return 真正的indexpath,既考虑assistants影响的indexpath
 */
- (ActualIndexPath *)YF_logicIndexPath2Actual:(LogicIndexPath *)indexPath;

@end
