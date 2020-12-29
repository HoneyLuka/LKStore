//
//  LKStoreListCell.m
//  LKImageInfoViewer
//
//  Created by Selina on 15/12/2020.
//  Copyright © 2020 Luka Li. All rights reserved.
//

#import "LKStoreListCell.h"
#import <Masonry/Masonry.h>
#import <LKKit/LKKit.h>

#define LR_INSET 15.f
#define ICON_WIDTH 23.f
#define TB_INSET 9.f
#define TEXT_FONT [UIFont fontWithName:@"Avenir-Medium" size:15]

@implementation LKStoreListCell

+ (CGFloat)heightForString:(NSString *)str atWidth:(CGFloat)width
{
    CGFloat textMaxWidth = width - LR_INSET * 2 - ICON_WIDTH - LR_INSET;
    if (textMaxWidth <= 0 || !str.length) {
        return 0;
    }
    
    NSDictionary *attr = @{NSFontAttributeName: TEXT_FONT};
    CGFloat height = [str lk_heightForWidth:textMaxWidth attributes:attr];
    return height + TB_INSET * 2;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self _setup];
    return self;
}

- (void)_setup
{
    self.backgroundColor = UIColor.clearColor;
    self.contentView.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LR_INSET);
        make.centerY.offset(0);
        make.width.height.equalTo(@(ICON_WIDTH));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LR_INSET + ICON_WIDTH + LR_INSET);
        make.centerY.offset(0);
        make.right.offset(-LR_INSET);
    }];
}

- (void)configWithItem:(LKStoreListItem *)item
{
    self.iconImageView.image = item.icon;
    self.titleLabel.text = item.desc;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = TEXT_FONT;
        if (@available(iOS 13, *)) {
            _titleLabel.textColor = UIColor.labelColor;
        } else {
            _titleLabel.textColor = UIColor.whiteColor;
        }
    }
    
    return _titleLabel;
}

@end
