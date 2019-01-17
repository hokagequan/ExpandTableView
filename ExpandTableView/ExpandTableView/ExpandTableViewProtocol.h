//
//  ExpandTableViewProtocol.h
//  ExpandTableView
//
//  Created by QiM on 2019/1/16.
//  Copyright © 2019 ZhiZhangYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExpandTableView;

NS_ASSUME_NONNULL_BEGIN

@protocol ExpandTableViewProtocol <NSObject>

@required
/**
 Root节点Section的数量

 @param tableView ExpandTableView
 @return 大于等于0
 */
- (NSInteger)numberOfSectionInExpandTableView:(ExpandTableView *)tableView;

/**
 Root节点每个Section对应的Rows的数量

 @param tableView ExpandTableView
 @param section 当前的Section
 @return 大于等于0
 */
- (NSInteger)expandTableView:(ExpandTableView *)tableView numberOfRowsInSection:(NSInteger)section;

/**
 对应父节点的子节点的数量

 @param tableView ExpandTableView
 @param parentIndexPath Root节点的IndexPath
 @return 大于等于0
 */
- (NSInteger)expandTableView:(ExpandTableView *)tableView numberOfRowsAtParentIndexPath:(NSIndexPath *)parentIndexPath;

/**
 Root节点cell渲染

 @param tableView ExpandTableView
 @param indexPath Root节点的IndexPath
 @return Cell
 */
- (UITableViewCell *)expandTableView:(ExpandTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 子节点Cell渲染

 @param tableView ExpandTableView
 @param parentIndexPath 父节点的IndexPath
 @param index 子节点的索引
 @return Cell
 */
- (UITableViewCell *)expandTableView:(ExpandTableView *)tableView cellForRowAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index;

/**
 Root节点的点击事件

 @param tableView ExpandTableView
 @param indexPath Root节点的IndexPath
 */
- (void)expandTableView:(ExpandTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 子节点的点击事件

 @param tableView ExpandTableView
 @param parentIndexPath 父节点的IndexPath
 @param index 子节点的索引
 */
- (void)expandTableView:(ExpandTableView *)tableView didSelectRowAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index;


@optional
/**
 父节点Cell高度
 
 @param tableView ExpandTableView
 @param indexPath Root节点的IndexPath
 @return >= 0.0
 */
- (CGFloat)expandTableView:(ExpandTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 子节点Cell高度
 
 @param tableView ExpandTableView
 @param parentIndexPath 父节点的IndexPath
 @param index 子节点的索引
 @return >= 0.0
 */
- (CGFloat)expandTableView:(ExpandTableView *)tableView heightForRowAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
