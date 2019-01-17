//
//  ExpandTableViewDelegate.m
//  ExpandTableView
//
//  Created by QiM on 2019/1/16.
//  Copyright © 2019 ZhiZhangYi. All rights reserved.
//

#import "ExpandTableViewDelegate.h"
#import "ExpandTableView.h"

@implementation ExpandData



@end

@interface ExpandTableViewDelegate()

@property (nonatomic, strong) NSMutableDictionary<NSNumber*, NSArray *> *expandDatas;

@property(nonatomic, weak) id<ExpandTableViewProtocol>delegate;
@property(nonatomic, weak) ExpandTableView *expandTableView;

@end

@implementation ExpandTableViewDelegate

- (instancetype)initWithExpandDelegate:(id<ExpandTableViewProtocol>)delegate tableView:(nonnull ExpandTableView *)expandTableView {
    if (self = [super init]) {
        self.delegate = delegate;
        self.expandTableView = expandTableView;
    }
    
    return self;
}

#pragma mark - API

/**
 添加父cell

 @param indexPath 父原始IndexPath
 */
- (void)addCellAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *realIndexPath = [self realIndexPathFor:indexPath];
    // TODO: 更新已展开的列表
    [self.expandTableView insertRowsAtIndexPaths:@[realIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)addCellAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index {
    ExpandData *data = [self dataAtOriginalIndexPath:parentIndexPath];
    
    if (!data) {
        // 没有展开，不处理
        return;
    }
    
    NSIndexPath *realIndexPath = [self realIndexPathFor:parentIndexPath];
    NSIndexPath *childIndexPath = [NSIndexPath indexPathForRow:realIndexPath.row + index + 1
                                                     inSection:realIndexPath.section];
    NSMutableArray *children = [NSMutableArray arrayWithArray:data.children];
    [children insertObject:childIndexPath atIndex:index];
    
    NSMutableArray *toChange = [NSMutableArray array];
    for (NSInteger i = index + 1; i < children.count; i++) {
        NSIndexPath *oIndexPath = children[i];
        NSIndexPath *nIndexPath = [NSIndexPath indexPathForRow:oIndexPath.row + 1
                                                     inSection:oIndexPath.section];
        [toChange addObject:nIndexPath];
    }
    
    if (toChange.count > 0) {
        [children replaceObjectsInRange:NSMakeRange(index + 1, children.count - index - 1)
                   withObjectsFromArray:toChange];
    }
    
    // TODO: 更新已展开的列表
    [self.expandTableView insertRowsAtIndexPaths:@[childIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)collapseCellAtIndexPath:(NSIndexPath *)indexPath {
    ExpandData *data = [self dataAtOriginalIndexPath:indexPath];
    
    if (!data) {
        // 已经收起，什么都不做
        return;
    }
    
    NSArray *toDeleteIndexPaths = [self reloadDataForCollapseIndexPath:indexPath expandData:data];
    
    if (toDeleteIndexPaths) {
        [self.expandTableView deleteRowsAtIndexPaths:toDeleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *realIndexPath = [self realIndexPathFor:indexPath];
    ExpandData *data = [self dataAtOriginalIndexPath:indexPath];
    
    if (data) {
        // 不是展开的
    }
}

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath {
    ExpandData *data = [self dataAtOriginalIndexPath:indexPath];
    
    if (data) {
        // 已经展开，什么都不做
        return;
    }
    
    NSInteger count = [self.delegate expandTableView:self.expandTableView numberOfRowsAtParentIndexPath:indexPath];
    NSArray *toAddIndexPaths = [self reloadDataForExpandIndexPath:indexPath count:count];
    
    if (toAddIndexPaths) {
        [self.expandTableView insertRowsAtIndexPaths:toAddIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)loadExpandDelegate:(id<ExpandTableViewProtocol>)delegate {
    self.delegate = delegate;
}

#pragma mark - Private

/**
 查找对应的IndexPath的展开数据，可以判断indexPath是否已经展开

 @param indexPath 原始的Root IndexPath
 @return 如果没有对应的返回nil
 */
- (ExpandData *)dataAtOriginalIndexPath:(NSIndexPath *)indexPath {
    if (![self.expandDatas.allKeys containsObject:@(indexPath.section)]) {
        return nil;
    }
    
    ExpandData *relData = nil;
    NSArray *datas = self.expandDatas[@(indexPath.section)];
    
    for (ExpandData *data in datas) {
        if ([data.originalIndexPath isEqual:indexPath]) {
            relData = data;
            break;
        }
    }
    
    return relData;
}

/**
 当前indexPath对应的展开数据，如果indexPath是子cell的，也会返回子cell所在的展开数据

 @param indexPath 当前indexPath
 @return 如果没有对应的数据返回nil
 */
- (ExpandData *)dataAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.expandDatas.allKeys containsObject:@(indexPath.section)]) {
        return nil;
    }
    
    NSArray *datas = self.expandDatas[@(indexPath.section)];
    
    ExpandData *relData = nil;
    for (ExpandData *data in datas) {
        if ([data.indexPath isEqual:indexPath] || [data.children containsObject:indexPath]) {
            relData = data;
            break;
        }
    }
    
    return relData;
}

/**
 子节点的索引

 @param indexPath 真实的IndexPath
 @return >= 0
 */
- (NSInteger)indexOfChildFrom:(NSIndexPath *)indexPath expandData:(ExpandData *)data {
    if (!data || [data.indexPath isEqual:indexPath] || ![data.children containsObject:indexPath]) {
        return 0;
    }
    
    return [data.children indexOfObject:indexPath];
}

/**
 返回父节点的原始IndexPath

 @param indexPath 当前IndexPath
 @return 如果传入值不是父节点则返回nil
 */
- (NSIndexPath *)originalIndexPathFor:(NSIndexPath *)indexPath expandData:(ExpandData *)data {
    if (!data) {
        // 没有展开的Root IndexPath
        NSInteger totalBefore = 0;
        for (ExpandData *eData in self.expandDatas[@(indexPath.section)]) {
            if (eData.indexPath.row < indexPath.row) {
                totalBefore += eData.childrenCount;
            }
        }
        
        return [NSIndexPath indexPathForRow:indexPath.row - totalBefore inSection:indexPath.section];
    }
    
    return data.originalIndexPath;
}

/**
 返回父节点的真实IndexPath

 @param indexPath 当前的IndexPath
 @return 如果没有父节点返回nil
 */
- (NSIndexPath *)parentIndexPathFor:(NSIndexPath *)indexPath expandData:(ExpandData *)data {
    if (!data) {
        return nil;
    }
    
    if ([data.indexPath isEqual:indexPath] || ![data.children containsObject:indexPath]) {
        return nil;
    }
    
    return data.indexPath;
}

/**
 展开时，重载数据

 @param indexPath 原始的Root IndexPath
 @param count 该Root下的子元素数量
 @return 添加的IndexPaths
 */
- (NSArray *)reloadDataForExpandIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count {
    ExpandData *data = [[ExpandData alloc] init];
    data.originalIndexPath = indexPath;
    
    NSInteger totalBefore = 0;
    NSMutableArray *newExpandData = [NSMutableArray array];
    for (ExpandData *tData in self.expandDatas[@(indexPath.section)]) {
        if (tData.originalIndexPath.row < indexPath.row) {
            totalBefore += tData.childrenCount;
        }
        else {
            tData.indexPath = [NSIndexPath indexPathForRow:tData.indexPath.row + count
                                                 inSection:tData.indexPath.section];
            
            NSMutableArray *newChildren = [NSMutableArray arrayWithCapacity:tData.childrenCount];
            for (NSIndexPath *childIndexPath in tData.children) {
                NSIndexPath *child = [NSIndexPath indexPathForRow:childIndexPath.row + count
                                                        inSection:childIndexPath.section];
                [newChildren addObject:child];
            }
            
            tData.children = newChildren;
        }
        
        [newExpandData addObject:tData];
    }
    
    data.indexPath = [NSIndexPath indexPathForRow:indexPath.row + totalBefore inSection:indexPath.section];
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSIndexPath *child = [NSIndexPath indexPathForRow:data.indexPath.row + i + 1 inSection:data.indexPath.section];
        [children addObject:child];
    }
    
    data.children = children;
    data.childrenCount = count;
    [newExpandData addObject:data];
    self.expandDatas[@(indexPath.section)] = newExpandData;
    
    return children;
}

/**
 收起时，重载数据

 @param indexPath Root 原始的IndexPath
 @param data 对应的展开数据
 @return 准备删除的IndexPaths
 */
- (NSArray *)reloadDataForCollapseIndexPath:(NSIndexPath *)indexPath expandData:(ExpandData *)data {
    NSMutableArray *newExpandData = [NSMutableArray array];
    for (ExpandData *tData in self.expandDatas[@(indexPath.section)]) {
        if ([tData isEqual:data]) {
            continue;
        }
        
        if (tData.originalIndexPath.row > data.originalIndexPath.row) {
            tData.indexPath = [NSIndexPath indexPathForRow:tData.indexPath.row - data.childrenCount
                                                 inSection:tData.indexPath.section];
            NSMutableArray *newChildren = [NSMutableArray arrayWithCapacity:tData.childrenCount];
            for (NSIndexPath *childIndexPath in tData.children) {
                NSIndexPath *child = [NSIndexPath indexPathForRow:childIndexPath.row - data.childrenCount
                                                        inSection:childIndexPath.section];
                [newChildren addObject:child];
            }
            
            tData.children = newChildren;
        }
        
        [newExpandData addObject:tData];
    }
    
    self.expandDatas[@(indexPath.section)] = newExpandData;
    
    return data.children;
}

- (void)reloadExpandedDataForAdd:(NSIndexPath *)parentIndexPath childIndexPath:(NSIndexPath *)childIndexPath {
    
}

/**
 父节点的真实IndexPath

 @param originalIndexPath 父节点的原始IndexPath
 @return not nil
 */
- (NSIndexPath *)realIndexPathFor:(NSIndexPath *)originalIndexPath {
    NSInteger totalBefore = 0;
    for (ExpandData *tData in self.expandDatas[@(originalIndexPath.section)]) {
        if (tData.originalIndexPath.row < originalIndexPath.row) {
            totalBefore += tData.childrenCount;
        }
    }
    
    return [NSIndexPath indexPathForRow:originalIndexPath.row + totalBefore inSection:originalIndexPath.section];
}

- (NSInteger)totalCountOfExpandDataInSection:(NSInteger)section {
    NSInteger count = 0;
    
    if (![self.expandDatas.allKeys containsObject:@(section)]) {
        return count;
    }
    
    NSArray *datas = self.expandDatas[@(section)];
    for (ExpandData *eData in datas) {
        count += eData.childrenCount;
    }
    
    return count;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.delegate numberOfSectionInExpandTableView:self.expandTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger parentCount = [self.delegate expandTableView:self.expandTableView numberOfRowsInSection:section];
    NSInteger expandedCount = [self totalCountOfExpandDataInSection:section];
    
    return parentCount + expandedCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpandData *data = [self dataAtIndexPath:indexPath];
    NSIndexPath *parentIndexPath = [self parentIndexPathFor:indexPath expandData:data];
    if (!parentIndexPath) {
        // 父节点
        if ([self.delegate respondsToSelector:@selector(expandTableView:heightForRowAtIndexPath:)]) {
            return [self.delegate expandTableView:self.expandTableView
                          heightForRowAtIndexPath:[self originalIndexPathFor:indexPath expandData:data]];
        }
        else {
            return UITableViewAutomaticDimension;
        }
    }
    else {
        // 子节点
        if ([self.delegate respondsToSelector:@selector(expandTableView:heightForRowAtParentIndexPath:atIndex:)]) {
            return [self.delegate expandTableView:self.expandTableView
                    heightForRowAtParentIndexPath:[self originalIndexPathFor:indexPath expandData:data]
                                          atIndex:[self indexOfChildFrom:indexPath expandData:data]];
        }
        else {
            return UITableViewAutomaticDimension;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpandData *data = [self dataAtIndexPath:indexPath];
    NSIndexPath *parentIndexPath = [self parentIndexPathFor:indexPath expandData:data];
    if (!parentIndexPath) {
        // 父节点
        return [self.delegate expandTableView:self.expandTableView
                        cellForRowAtIndexPath:[self originalIndexPathFor:indexPath expandData:data]];
    }
    else {
        // 子节点
        return [self.delegate expandTableView:self.expandTableView
                  cellForRowAtParentIndexPath:[self originalIndexPathFor:indexPath expandData:data]
                                      atIndex:[self indexOfChildFrom:indexPath expandData:data]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpandData *data = [self dataAtIndexPath:indexPath];
    NSIndexPath *parentIndexPath = [self parentIndexPathFor:indexPath expandData:data];
    if (!parentIndexPath) {
        // 父节点
        [self.delegate expandTableView:self.expandTableView
               didSelectRowAtIndexPath:[self originalIndexPathFor:indexPath expandData:data]];
    }
    else {
        // 子节点
        [self.delegate expandTableView:self.expandTableView
         didSelectRowAtParentIndexPath:[self originalIndexPathFor:indexPath expandData:data]
                               atIndex:[self indexOfChildFrom:indexPath expandData:data]];
    }
}

#pragma mark - Property

- (NSMutableDictionary<NSNumber*, NSArray *> *)expandDatas {
    if (!_expandDatas) {
        _expandDatas = [NSMutableDictionary dictionary];
    }
    
    return _expandDatas;
}

@end
