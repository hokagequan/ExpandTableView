//
//  ExpandTableViewDelegate.h
//  ExpandTableView
//
//  Created by QiM on 2019/1/16.
//  Copyright © 2019 ZhiZhangYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ExpandTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpandData : NSObject

/**
 未展开前的父节点IndexPath
 */
@property (nonatomic, strong) NSIndexPath *originalIndexPath;

/**
 展开后的父节点IndexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 子节点的IndexPath
 */
@property (nonatomic, strong) NSArray<NSIndexPath *> *children;

/**
 子节点的数量
 */
@property (nonatomic, assign) NSInteger childrenCount;

@end

@interface ExpandTableViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithExpandDelegate:(id<ExpandTableViewProtocol>)delegate tableView:(ExpandTableView *)expandTableView;
- (void)loadExpandDelegate:(id<ExpandTableViewProtocol>)delegate;

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)collapseCellAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)originalIndexPathForCell:(UITableViewCell *)cell;

- (void)addCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)addCellAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index;
- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteCellAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
