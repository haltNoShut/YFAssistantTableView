//
//  YFAssistantTableView.m
//  ttt
//
//  Created by 杨帆 on 16/8/3.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "YFAssistantTableView.h"
#import <objc/runtime.h>

#define replaceDelegate(selector) replaceMethod(selector,delegate)

#define replaceDatasource(selector) replaceMethod(selector,dataSource)

#define replaceMethod(selector,className) do{\
if (![className respondsToSelector:selector]) {continue;}\
Method method1 = class_getInstanceMethod([className class], selector);\
const char *type = method_getTypeEncoding(method1);\
IMP imp = class_getMethodImplementation([self class], stitchingHookSelector(selector));\
class_addMethod([className class], stitchingHookSelector(selector), imp, type);\
Method method2 = class_getInstanceMethod([className class], stitchingHookSelector(selector));\
method_exchangeImplementations(method1, method2);\
}\
while (0);

@interface YFAssistantTableViewManager : NSObject

+ (instancetype)manager;

- (BOOL )registeDelegate:(id<UITableViewDelegate> ) delegate;

- (BOOL )registeDataSource:(id<UITableViewDataSource> ) dataSource;

@property (strong, nonatomic)NSMutableArray *delegates;

@property (strong, nonatomic)NSMutableArray *dataSources;

@end

@implementation YFAssistantTableViewManager

+ (instancetype )manager{
    
    static YFAssistantTableViewManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [YFAssistantTableViewManager new];
    });
    return manager;
}

- (BOOL )registeDelegate:(id<UITableViewDelegate> ) delegate {
    
    NSString *className = NSStringFromClass([delegate class]);
    if (!className || [self.delegates containsObject:className]) {
        
        return NO;
    }
    [self.delegates addObject:className];
    return YES;
    
}

- (BOOL )registeDataSource:(id<UITableViewDataSource> ) dataSource {
    
    NSString *className = NSStringFromClass([dataSource class]);
    if (!className || [self.dataSources containsObject:className]) {
        
        return NO;
    }
    [self.dataSources addObject:className];
    return YES;

}

- (NSMutableArray *)delegates {
    
    if (!_delegates) {
        
        _delegates = [NSMutableArray array];
    }
    
    return _delegates;
}

- (NSMutableArray *)dataSources {
    
    if (!_dataSources) {
        
        _dataSources = [NSMutableArray array];
    }
    
    return _dataSources;
    
}

@end

@interface YFAssistantTableView ()
/**
 *  点击的cell的逻辑indexPath
 */
@property(nonatomic,strong)NSMutableArray<LogicIndexPath *> *spreadAssistants;
/**
 *  存储assistant的实际indexPath
 */
@property(nonatomic,strong)NSMutableArray<ActualIndexPath *> *assistantsIndexPaths;

@end

SEL stitchingHookSelector(SEL selector){
    
    NSString *originName = NSStringFromSelector(selector);
    NSString *stitchingName;
    char headerChar = [originName characterAtIndex:0];
    if (headerChar <=122 && headerChar >=97) {
        
        headerChar -= 32;
        
    }
    stitchingName = [originName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[NSString alloc]initWithUTF8String:&headerChar]];
    stitchingName = [@"hook" stringByAppendingString:stitchingName];
    return NSSelectorFromString(stitchingName);
}

@implementation YFAssistantTableView

#pragma mark

- (void)spreadAssistant:(LogicIndexPath *)indexPath{
    
    if ([self.spreadAssistants containsObject:indexPath]) {
        
        if (self.retractWhenSpread) {
            
            [self retractAssistant:indexPath];
            
        }
        return;
        
    }
    if ([self.assistantDelegate respondsToSelector:@selector(YFAssistantTableView:shouldSpreadAssistantAtIndexPath:)] && [self.assistantDelegate YFAssistantTableView:self shouldSpreadAssistantAtIndexPath:indexPath]) {
        
        UITableViewRowAnimation animation = UITableViewRowAnimationMiddle;
        if ([self.assistantDelegate respondsToSelector:@selector(YFAssistantTableViewSpreadAnimation:)]) {
            
            animation = [self.assistantDelegate YFAssistantTableViewSpreadAnimation:self];
            
        }
        [self.spreadAssistants addObject:indexPath];
        ActualIndexPath *actualIndexPath = [self YF_logicIndexPath2Actual:indexPath];
        [self addAssistantIndexPath:actualIndexPath];
        [self insertRowsAtIndexPaths:@[actualIndexPath] withRowAnimation:animation];
        
    }
    
}

- (void)retractAssistant:(LogicIndexPath *)indexPath{
    
    if ([self.spreadAssistants containsObject:indexPath]) {
        
        UITableViewRowAnimation animation = UITableViewRowAnimationMiddle;
        if ([self.assistantDelegate respondsToSelector:@selector(YFAssistantTableViewRetractAnimation:)]) {
            
            animation = [self.assistantDelegate YFAssistantTableViewRetractAnimation:self];
            
        }
        ActualIndexPath *actualIndexPath = [self YF_logicIndexPath2Actual:indexPath];
        [self.spreadAssistants removeObject:indexPath];
        [self removeAssistantIndexPath:actualIndexPath];
        [self deleteRowsAtIndexPaths:@[actualIndexPath] withRowAnimation:animation];
    }
    
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate{
    
    [super setDelegate:delegate];
    
    if (![[YFAssistantTableViewManager manager] registeDelegate:delegate]) {
        
        return ;
    }
    
    Protocol *delegateProtocol = objc_getProtocol("UITableViewDelegate");
    unsigned int count;
    struct objc_method_description *method_des = protocol_copyMethodDescriptionList(delegateProtocol, NO, YES, &count);
    for (int i=0; i<count; i++) {
        
        if ([NSStringFromSelector(method_des->name) hasSuffix:@"AtIndexPath:"]) {
            
            replaceDelegate(method_des->name);
            
        }
        method_des++;
        
    }    
    
    method_des = protocol_copyMethodDescriptionList(delegateProtocol, YES, YES, &count);
    for (int i=0; i<count; i++) {
        
        if ([NSStringFromSelector(method_des->name) hasSuffix:@"AtIndexPath:"]) {
            
            replaceDelegate(method_des->name);
            
        }
        method_des++;
        
    }
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource{
    
    [super setDataSource:dataSource];
    
    if (![[YFAssistantTableViewManager manager] registeDataSource:dataSource]) {
        
        return ;
    }
    
    Protocol *delegateProtocol = objc_getProtocol("UITableViewDataSource");
    unsigned int count;
    struct objc_method_description * method_des = protocol_copyMethodDescriptionList(delegateProtocol, NO, YES, &count);
    for (int i=0; i<count; i++) {
        
        if ([NSStringFromSelector(method_des->name) hasSuffix:@"AtIndexPath:"]) {
            
            replaceDatasource(method_des->name);
            
        }
        method_des++;
    }
    method_des = protocol_copyMethodDescriptionList(delegateProtocol, YES, YES, &count);
    for (int i=0; i<count; i++) {
        if ([NSStringFromSelector(method_des->name) hasSuffix:@"AtIndexPath:"]) {
            
            replaceDatasource(method_des->name);
            
        }
        method_des++;
        
    }
    replaceDatasource(@selector(tableView:numberOfRowsInSection:));
}

- (NSMutableArray<LogicIndexPath *> *)spreadAssistants{
    
    if (!_spreadAssistants) {
        
        _spreadAssistants = [NSMutableArray array];
        
    }
    return _spreadAssistants;
    
}

- (NSMutableArray<ActualIndexPath *> *)assistantsIndexPaths{
    
    if (!_assistantsIndexPaths) {
        
        _assistantsIndexPaths = [NSMutableArray array];
        
    }
    return _assistantsIndexPaths;
    
}

#pragma mark transformer

- (LogicIndexPath *)actualIndexPath2Logic:(ActualIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    __block NSInteger row = indexPath.row;
    [self.assistantsIndexPaths enumerateObjectsUsingBlock:^(ActualIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.section == section && obj.row<=indexPath.row) {
            
            row--;
            
        }
    }];
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (ActualIndexPath *)logicIndexPath2Actual:(LogicIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    __block NSInteger row = indexPath.row;
    [self.spreadAssistants enumerateObjectsUsingBlock:^(LogicIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.section == indexPath.section && obj.row<indexPath.row) {
            
            row++;
            
        }
    }];
    return [NSIndexPath indexPathForRow:row inSection:section];
    
}

- (ActualIndexPath *)YF_logicIndexPath2Actual:(LogicIndexPath *)indexPath{
    
    ActualIndexPath *actualBuf = [self logicIndexPath2Actual:indexPath];
    return [NSIndexPath indexPathForRow:actualBuf.row+1 inSection:actualBuf.section];
}

- (void)addAssistantIndexPath:(ActualIndexPath *)indexPath{
    
    NSArray *indexPathBuf = [self.assistantsIndexPaths copy];
    [indexPathBuf enumerateObjectsUsingBlock:^(ActualIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.section == indexPath.section && obj.row > indexPath.row) {
            
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:obj.row+1 inSection:obj.section];
            [self.assistantsIndexPaths replaceObjectAtIndex:idx withObject:newIndexPath];
            
        }
    }];
    [self.assistantsIndexPaths addObject:indexPath];
    
}

- (void)removeAssistantIndexPath:(ActualIndexPath *)indexPath{
    
    NSArray *indexPathBuf = [self.assistantsIndexPaths copy];
    [indexPathBuf enumerateObjectsUsingBlock:^(ActualIndexPath *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.section == indexPath.section && obj.row > indexPath.row) {
            
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:obj.row-1 inSection:obj.section];
            [self.assistantsIndexPaths replaceObjectAtIndex:idx withObject:newIndexPath];
            
        }
    }];
    [self.assistantsIndexPaths removeObject:indexPath];
    
}

#pragma mark delegate

- (NSInteger)hookTableView:(YFAssistantTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    __block NSInteger count = 0;
    [tableView.spreadAssistants enumerateObjectsUsingBlock:^(LogicIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.section == section) {
            count++;
        }
    }];
    return [self hookTableView:tableView numberOfRowsInSection:section] + count;
}

- (UITableViewCell *)hookTableView:(YFAssistantTableView *)tableView cellForRowAtIndexPath:(ActualIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if ([tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [tableView.assistantDelegate YFAssistantTableView:tableView cellForRowAtIndexPath:logicIndexPath];
    }
    return [self hookTableView:tableView cellForRowAtIndexPath:logicIndexPath];
}

//=========================

- (BOOL)hookTableView:(YFAssistantTableView *)tableView canEditRowAtIndexPath:(ActualIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView canEditRowAtIndexPath:logicIndexPath];
    }
    return NO;
}

- (BOOL)hookTableView:(YFAssistantTableView *)tableView canMoveRowAtIndexPath:(ActualIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView canMoveRowAtIndexPath:logicIndexPath];
    }
    return NO;
}

- (void)hookTableView:(YFAssistantTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(ActualIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:logicIndexPath];
    }
}


#pragma mark dataSource

- (CGFloat)hookTableView:(YFAssistantTableView *)tableView estimatedHeightForRowAtIndexPath:(ActualIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if ([tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [tableView.assistantDelegate YFAssistantTableView:tableView estimatedHeightForRowAtIndexPath:logicIndexPath];
    }
    return [self hookTableView:tableView estimatedHeightForRowAtIndexPath:logicIndexPath];
}

- (CGFloat)hookTableView:(YFAssistantTableView *)tableView heightForRowAtIndexPath:(ActualIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if ([tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [tableView.assistantDelegate YFAssistantTableView:tableView heightForRowAtIndexPath:logicIndexPath];
    }
    return [self hookTableView:tableView heightForRowAtIndexPath:logicIndexPath];
}

//=================

- (void)hookTableView:(YFAssistantTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView willDisplayCell:cell forRowAtIndexPath:logicIndexPath];
    }
}

- (void)hookTableView:(YFAssistantTableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:logicIndexPath];
    }
}

-(BOOL)hookTableView:(YFAssistantTableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView shouldHighlightRowAtIndexPath:logicIndexPath];
    }
    return NO;
}

-(void)hookTableView:(YFAssistantTableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView didHighlightRowAtIndexPath:logicIndexPath];
    }
}

- (void)hookTableView:(YFAssistantTableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView didUnhighlightRowAtIndexPath:logicIndexPath];
    }
}

- (NSIndexPath *)hookTableView:(YFAssistantTableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView willSelectRowAtIndexPath:logicIndexPath];
    }
    return logicIndexPath;
}

- (NSIndexPath *)hookTableView:(YFAssistantTableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView willDeselectRowAtIndexPath:logicIndexPath];
    }
    return logicIndexPath;
}

-(void)hookTableView:(YFAssistantTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView didSelectRowAtIndexPath:logicIndexPath];
    }
}

-(void)hookTableView:(YFAssistantTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView didDeselectRowAtIndexPath:logicIndexPath];
    }
}

- (UITableViewCellEditingStyle)hookTableView:(YFAssistantTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView editingStyleForRowAtIndexPath:logicIndexPath];
    }
    return UITableViewCellEditingStyleNone;
}

-(NSString *)hookTableView:(YFAssistantTableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:logicIndexPath];
    }
    return @"";
}

-(NSArray<UITableViewRowAction *> *)hookTableView:(YFAssistantTableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView editActionsForRowAtIndexPath:logicIndexPath];
    }
    return nil;
}

-(BOOL)hookTableView:(YFAssistantTableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView shouldIndentWhileEditingRowAtIndexPath:logicIndexPath];
    }
    return NO;
}

-(void)hookTableView:(YFAssistantTableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView willBeginEditingRowAtIndexPath:logicIndexPath];
    }
}

-(void)hookTableView:(YFAssistantTableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        [self hookTableView:tableView didEndEditingRowAtIndexPath:logicIndexPath];
    }
}

-(NSInteger)hookTableView:(YFAssistantTableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView indentationLevelForRowAtIndexPath:logicIndexPath];
    }
    return 0;
}

-(BOOL)hookTableView:(YFAssistantTableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView shouldShowMenuForRowAtIndexPath:logicIndexPath];
    }
    return NO;
}

-(BOOL)hookTableView:(YFAssistantTableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath{
    LogicIndexPath *logicIndexPath = [tableView actualIndexPath2Logic:indexPath];
    if (![tableView.assistantsIndexPaths containsObject:indexPath]) {
        return [self hookTableView:tableView canFocusRowAtIndexPath:logicIndexPath];
    }
    return NO;
}


@end
