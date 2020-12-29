//
//  LKStoreViewController.m
//  LKImageInfoViewer
//
//  Created by Selina on 14/12/2020.
//  Copyright © 2020 Luka Li. All rights reserved.
//

#import "LKStoreViewController.h"
#import <Masonry/Masonry.h>
#import "LKPaymentManager.h"
#import <LKPayment/LKPayment.h>
#import "LKStoreListView.h"
#import <LKKit/LKKit.h>

@interface LKStoreViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) LKStoreListView *listView;

@property (nonatomic, strong) UITextView *privacyLabel;

@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *restoreButton;

@property (nonatomic, strong) SKProduct *product;

@end

@implementation LKStoreViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefaultValues];
        [self initNaviItem];
    }
    return self;
}

- (void)initDefaultValues
{
    self.naviTitleText = @"Upgrade";
    self.closeButtonText = @"Done";
    self.mainThemeColor = UIColor.systemBlueColor;
    self.titleText = @"Upgrade";
    self.descText = @"Hope you enjoy the app. If you like it please support us, let us make it better :)\n\nUpgrade you can:";
    self.buyButtonTextFormat = @"%@ one-time purchase";
    self.restoreButtonText = @"Restore Purchase";
}

- (void)initNaviItem
{
    self.title = self.naviTitleText;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:self.closeButtonText style:UIBarButtonItemStyleDone target:self action:@selector(onDoneButtonClick)];
    self.navigationItem.leftBarButtonItem = doneButton;
}

- (BOOL)isModalInPresentation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([LKDeviceHelper isiPad]) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
    if (!self.isBuyed) {
        [self requestProductData];
    } else {
        [self refreshView];
    }
}

- (void)initView
{
    if (@available(iOS 13, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.blackColor;
    }
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.centerX.offset(0);
        make.width.height.equalTo(@80);
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.view addSubview:self.restoreButton];
    [self.restoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
    }];
    
    [self.view addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([LKDeviceHelper isiPad]) {
            make.width.equalTo(self.view).multipliedBy(0.8);
            make.centerX.offset(0);
        } else {
            make.left.offset(15);
            make.right.offset(-15);
        }
        
        make.height.equalTo(@50);
        make.bottom.equalTo(self.restoreButton.mas_top).offset(-10);
    }];
    
    [self.view addSubview:self.privacyLabel];
    [self.privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.buyButton.mas_top).offset(-10);
    }];
    
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.privacyLabel.mas_top).offset(-10);
        
        if ([LKDeviceHelper isiPad]) {
            make.centerX.offset(0);
            make.width.equalTo(self.view).multipliedBy(0.8);
        } else {
            make.left.offset(15);
            make.right.offset(-15);
        }
    }];
}

- (void)refreshView
{
    if (self.isBuyed) {
        self.buyButton.enabled = NO;
        self.restoreButton.enabled = NO;
        [self.buyButton setTitle:@"Thanks for your purchase" forState:UIControlStateNormal];
        return;
    }
    
    self.buyButton.enabled = YES;
    self.restoreButton.enabled = YES;
    NSString *str = [NSString stringWithFormat:self.buyButtonTextFormat, self.product.lk_regularPrice];
    [self.buyButton setTitle:str forState:UIControlStateNormal];
}

- (void)refreshBuyFlag:(BOOL)isBuyed
{
    self.isBuyed = isBuyed;
    [self refreshView];
}

#pragma mark - Request Product

- (void)requestProductData
{
    [LKAlertHelper showLoadingHUDAllowUserInterAction:YES];
    
    [[LKPaymentManager sharedManager] requestProductDataForIds:self.productIds completion:^(NSArray<SKProduct *> *products) {
        SKProduct *product = products.firstObject;
        if (!products) {
            // error
            [LKAlertHelper showErrorHUD:@"Request product data failed"];
            return;
        }
        
        [LKAlertHelper dismissHUD];
        self.product = product;
        [self onProductRequestSuccess];
    }];
}

- (void)onProductRequestSuccess
{
    [self refreshView];
}

#pragma mark - Buy

- (void)onBuyButtonClick
{
    [LKAlertHelper showLoadingHUD];
    [[LKPaymentManager sharedManager] buy:self.product
                               completion:
     ^(SKPaymentTransaction *transaction, NSError *error, BOOL isCancelled, LKPaymentManagerFinishTransactionBlock finishTransactionBlock) {
        if (isCancelled) {
            [LKAlertHelper dismissHUD];
            return;
        }
        
        if (error) {
            // error
            [LKAlertHelper showErrorHUD:error.localizedDescription];
            return;
        }
        
        [LKAlertHelper showSuccessHUD:@"Thanks for your purchase"];
        
        if ([self.delegate respondsToSelector:@selector(store:didBuyedSuccess:)]) {
            [self.delegate store:self didBuyedSuccess:transaction];
        }
    }];
}

#pragma mark - Restore

- (void)onRestoreButtonClick
{
    if (self.isBuyed) {
        [LKAlertHelper showSuccessHUD:@"Thanks for your purchase"];
        return;
    }
    
    [LKAlertHelper showLoadingHUD];
    [[LKPaymentManager sharedManager] restoreWithProcess:^(SKPaymentTransaction *transaction) {
        if ([self.delegate respondsToSelector:@selector(store:didRestoreTransaction:)]) {
            [self.delegate store:self didRestoreTransaction:transaction];
        }
    } completion:^(NSError *error, BOOL isCancelled) {
        if (isCancelled) {
            [LKAlertHelper dismissHUD];
            return;
        }
        
        if (error) {
            // error
            [LKAlertHelper showErrorHUD:error.localizedDescription];
        } else {
            [LKAlertHelper showSuccessHUD:@"Order restored successfully"];
        }
        
        [self refreshView];
    }];
}

- (void)onDoneButtonClick
{
    [LKAlertHelper dismissHUD];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:self.icon];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 10;
    }
    
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = LKAvenirMediumFont(17);
        if (@available(iOS 13, *)) {
            _titleLabel.textColor = UIColor.labelColor;
        } else {
            _titleLabel.textColor = UIColor.whiteColor;
        }
        
        _titleLabel.text = self.titleText;
    }
    
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.font = LKAvenirLightFont(15);
        _descLabel.numberOfLines = 0;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        
        if (@available(iOS 13, *)) {
            _descLabel.textColor = UIColor.secondaryLabelColor;
        } else {
            _descLabel.textColor = UIColor.whiteColor;
        }
        
        _descLabel.text = self.descText;
    }
    
    return _descLabel;
}

- (UIButton *)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setBackgroundImage:[UIImage lk_imageWithColor:self.mainThemeColor] forState:UIControlStateNormal];
        [_buyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _buyButton.titleLabel.font = LKAvenirMediumFont(17);
        _buyButton.clipsToBounds = YES;
        _buyButton.layer.cornerRadius = 10;
        _buyButton.enabled = NO;
        [_buyButton setTitle:@"Loading" forState:UIControlStateNormal];
        
        [_buyButton addTarget:self action:@selector(onBuyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _buyButton;
}

- (UIButton *)restoreButton
{
    if (!_restoreButton) {
        _restoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_restoreButton setTitleColor:UIColor.systemGrayColor forState:UIControlStateNormal];
        [_restoreButton setTitle:self.restoreButtonText forState:UIControlStateNormal];
        _restoreButton.titleLabel.font = LKAvenirLightFont(15);
        _restoreButton.enabled = NO;
        
        [_restoreButton addTarget:self action:@selector(onRestoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _restoreButton;
}

- (LKStoreListView *)listView
{
    if (!_listView) {
        _listView = [[LKStoreListView alloc] initWithItems:self.featureItems];
    }
    
    return _listView;
}

- (UITextView *)privacyLabel
{
    if (!_privacyLabel) {
        _privacyLabel = [UITextView new];
        _privacyLabel.backgroundColor = UIColor.clearColor;
        UIFont *font = LKAvenirLightFont(15.f);
        NSDictionary *linkAttr = @{NSFontAttributeName: font, NSForegroundColorAttributeName: self.mainThemeColor};
        _privacyLabel.linkTextAttributes = linkAttr;
        _privacyLabel.editable = NO;
        _privacyLabel.scrollEnabled = NO;
        _privacyLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableDictionary *termsAttr = [linkAttr mutableCopy];
        termsAttr[NSLinkAttributeName] = [NSURL URLWithString:self.termsURL];
        NSMutableAttributedString *terms = [[NSMutableAttributedString alloc] initWithString:@"Terms" attributes:termsAttr];
        
        NSMutableDictionary *privacyAttr = [linkAttr mutableCopy];
        privacyAttr[NSLinkAttributeName] = [NSURL URLWithString:self.privacyURL];
        
        NSMutableAttributedString *privacy = [[NSMutableAttributedString alloc] initWithString:@"Privacy" attributes:privacyAttr];
        
        NSMutableDictionary *andAttr = [linkAttr mutableCopy];
        if (@available(iOS 13, *)) {
            andAttr[NSForegroundColorAttributeName] = UIColor.secondaryLabelColor;
        } else {
            andAttr[NSForegroundColorAttributeName] = UIColor.whiteColor;
        }
        NSMutableAttributedString *and = [[NSMutableAttributedString alloc] initWithString:@" & " attributes:andAttr];
        
        [terms appendAttributedString:and];
        [terms appendAttributedString:privacy];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        [terms addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, terms.length)];
        
        _privacyLabel.attributedText = terms;
    }
    
    return _privacyLabel;
}

@end
