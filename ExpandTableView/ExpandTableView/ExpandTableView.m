//
//  ExpandTableView.m
//  ExpandTableView
//
//  Created by QiM on 2019/1/16.
//  Copyright © 2019 ZhiZhangYi. All rights reserved.
//

#import "ExpandTableView.h"
#import "ExpandTableViewDelegate.h"

@interface ExpandTableView()

@property (nonatomic, strong) ExpandTableViewDelegate *etvDelegate;

@end

@implementation ExpandTableView

- (instancetype)init {
    if (self = [super init]) {
        self.delegate = self.etvDelegate;
        self.dataSource = self.etvDelegate;
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.delegate = self.etvDelegate;
    self.dataSource = self.etvDelegate;
}

- (void)addCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.etvDelegate addCellAtIndexPath:indexPath];
}

- (void)addCellAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index {
    [self.etvDelegate addCellAtParentIndexPath:parentIndexPath atIndex:index];
}

- (void)deleteCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.etvDelegate deleteCellAtIndexPath:indexPath];
}

- (void)deleteCellAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index {
    [self.etvDelegate deleteCellAtParentIndexPath:parentIndexPath atIndex:index];
}

- (void)expandCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.etvDelegate expandCellAtIndexPath:indexPath];
}

- (void)collapseCellAtIndexPath:(NSIndexPath *)indexPath {
    [self.etvDelegate collapseCellAtIndexPath:indexPath];
}

#pragma mark - Property

- (ExpandTableViewDelegate *)etvDelegate {
    if (!_etvDelegate) {
        _etvDelegate = [[ExpandTableViewDelegate alloc] initWithExpandDelegate:self.expandDelegate tableView:self];
    }
    
    return _etvDelegate;
}

- (void)setExpandDelegate:(id<ExpandTableViewProtocol>)expandDelegate {
    [self.etvDelegate loadExpandDelegate:expandDelegate];
    _expandDelegate = expandDelegate;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
