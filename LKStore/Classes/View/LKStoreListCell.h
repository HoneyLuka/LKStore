//
//  LKStoreListCell.h
//  LKImageInfoViewer
//
//  Created by Selina on 15/12/2020.
//  Copyright © 2020 Luka Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKStoreListItem.h"

@interface LKStoreListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)configWithItem:(LKStoreListItem *)item;

+ (CGFloat)heightForString:(NSString *)str atWidth:(CGFloat)width;

@end
