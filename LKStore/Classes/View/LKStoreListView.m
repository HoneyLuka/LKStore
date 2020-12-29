//
//  LKStoreListView.m
//  LKImageInfoViewer
//
//  Created by Selina on 15/12/2020.
//  Copyright © 2020 Luka Li. All rights reserved.
//

#import "LKStoreListView.h"
#import <Masonry/Masonry.h>
#import "LKStoreListCell.h"

@interface LKStoreListView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *items;

@end

@implementation LKStoreListView

- (instancetype)initWithItems:(NSArray<LKStoreListItem *> *)items
{
    self = [super initWithFrame:CGRectZero];
    self.items = items;
    [self _setup];
    return self;
}

- (void)_setup
{
    self.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKStoreListItem *item = self.items[indexPath.row];
    return [LKStoreListCell heightForString:item.desc atWidth:CGRectGetWidth(tableView.bounds)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LKStoreListItem *item = self.items[indexPath.row];
    LKStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LKStoreListCell"];
    
    [cell configWithItem:item];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.alwaysBounceVertical = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:LKStoreListCell.class forCellReuseIdentifier:@"LKStoreListCell"];
    }
    
    return _tableView;
}

@end
