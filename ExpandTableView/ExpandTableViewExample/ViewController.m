//
//  ViewController.m
//  ExpandTableView
//
//  Created by QiM on 2019/1/16.
//  Copyright © 2019 ZhiZhangYi. All rights reserved.
//

#import "ViewController.h"
#import "ExpandTableView.h"

@interface ViewController ()<ExpandTableViewProtocol>

@property (weak, nonatomic) IBOutlet ExpandTableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSDictionary*> *dataSource;
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath*, NSNumber*> *expandState;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.expandDelegate = self;
}

#pragma mark - Actions

- (IBAction)clickAddRoot:(id)sender {
    NSArray *subData = @[@"Sub1", @"Sub2"];
    int r = arc4random_uniform(74);
    [self.dataSource insertObject:@{@"Root": [NSString stringWithFormat:@"Row%d", r], @"Child": subData} atIndex:0];
    [self.tableView addCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (IBAction)clickDeleteRoot:(id)sender {
    [self.dataSource removeObjectAtIndex:0];
    [self.tableView deleteCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (IBAction)clickAddSub:(id)sender {
}

- (IBAction)clickDeleteSub:(id)sender {
}

#pragma mark - ExpandTableViewProtocol

- (NSInteger)numberOfSectionInExpandTableView:(ExpandTableView *)tableView {
    return 1;
}

- (NSInteger)expandTableView:(ExpandTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)expandTableView:(ExpandTableView *)tableView numberOfRowsAtParentIndexPath:(NSIndexPath *)parentIndexPath {
    NSDictionary *info = self.dataSource[parentIndexPath.row];
    NSArray *array = info[@"Child"];
    return array.count;
}

- (UITableViewCell *)expandTableView:(ExpandTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *info = self.dataSource[indexPath.row];
    cell.textLabel.text = info[@"Root"];
    
    return cell;
}

- (UITableViewCell *)expandTableView:(ExpandTableView *)tableView cellForRowAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *info = self.dataSource[parentIndexPath.row];
    NSArray *array = info[@"Child"];
    
    cell.textLabel.text = array[index];
    
    return cell;
}

- (void)expandTableView:(ExpandTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.expandState[indexPath] || ![self.expandState[indexPath] boolValue]) {
        // 展开
        [tableView expandCellAtIndexPath:indexPath];
        self.expandState[indexPath] = @(YES);
    }
    else {
        [tableView collapseCellAtIndexPath:indexPath];
        self.expandState[indexPath] = @(NO);
    }
}

- (void)expandTableView:(ExpandTableView *)tableView didSelectRowAtParentIndexPath:(NSIndexPath *)parentIndexPath atIndex:(NSInteger)index {
    
}

#pragma mark - Property

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSArray *subData = @[@"Sub1", @"Sub2"];
        NSArray *source = @[@{@"Root": @"Row1", @"Child": subData},
                            @{@"Root": @"Row2", @"Child": subData}];
        _dataSource = [NSMutableArray arrayWithArray:source];
    }
    
    return _dataSource;
}

- (NSMutableDictionary<NSIndexPath*, NSNumber*> *)expandState {
    if (!_expandState) {
        _expandState = [NSMutableDictionary dictionary];
    }
    
    return _expandState;
}

@end
