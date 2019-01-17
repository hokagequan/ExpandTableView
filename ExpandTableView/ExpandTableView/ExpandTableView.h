//
//  ExpandTableView.h
//  ExpandTableView
//
//  Created by QiM on 2019/1/16.
//  Copyright © 2019 ZhiZhangYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpandTableView : UITableView

@property (nonatomic, weak) id<ExpandTableViewProtocol> expandDelegate;


/**
 只按照父Cell排列的IndexPath, 这个indexPath不能用于原生tableview的操作，如果想用
 原生tableview操作，使用indexPathForCell方法

 @param cell cell
 @return 只按照父Cell排列的IndexPath
 */
- (NSIndexPath *)originalIndexPathForCell:(UITableViewCell *)cell;


/**
 展开Root Cell

 @param indexPath 使用originalIndexPathForCell方法获取的IndexPath
 */
- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 收起Root Cell

 @param indexPath 使用originalIndexPathForCell方法获取的IndexPath
 */
- (void)collapseCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 添加父cell

 @param indexPath 只按照父Cell排列的IndexPath, 这个indexPath不能用于原生tableview的操作，如果想用
 原生tableview操作，使用indexPathForCell方法
 */
- (void)addCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 添加子cell

 @param parentIndexPath 父节点IndexPath
 @param index 子节点索引
 */
- (void)addCellAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index;

/**
 删除父cell

 @param indexPath 只按照父Cell排列的IndexPath, 这个indexPath不能用于原生tableview的操作，如果想用
 原生tableview操作，使用indexPathForCell方法
 */
- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath;

/**
 删除子cell

 @param parentIndexPath 父节点IndexPath
 @param index 子节点索引
 */
- (void)deleteCellAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
