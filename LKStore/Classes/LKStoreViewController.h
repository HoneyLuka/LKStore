//
//  LKStoreViewController.h
//  LKImageInfoViewer
//
//  Created by Selina on 14/12/2020.
//  Copyright © 2020 Luka Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKStoreListItem.h"
#import <StoreKit/StoreKit.h>

@class LKStoreViewController;
@protocol LKStoreViewControllerDelegate <NSObject>

@optional

/// Called on product buyed successfully.
- (void)store:(LKStoreViewController *)storeVC didBuyedSuccess:(SKPaymentTransaction *)transaction;

/// Called on restore processing. May call multiple times if has more than one transaction.
- (void)store:(LKStoreViewController *)storeVC didRestoreTransaction:(SKPaymentTransaction *)transaction;

@end

@interface LKStoreViewController : UIViewController

@property (nonatomic, weak) id<LKStoreViewControllerDelegate> delegate;

@property (nonatomic, strong) UIColor *mainThemeColor;
@property (nonatomic, copy) NSString *naviTitleText;
@property (nonatomic, copy) NSString *closeButtonText;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *descText;
@property (nonatomic, strong) NSArray<LKStoreListItem *> *featureItems;
@property (nonatomic, copy) NSString *termsURL;
@property (nonatomic, copy) NSString *privacyURL;
@property (nonatomic, copy) NSString *buyButtonTextFormat;
@property (nonatomic, copy) NSString *restoreButtonText;
@property (nonatomic, assign) BOOL isBuyed;
@property (nonatomic, strong) NSArray<NSString *> *productIds;

/// set buy flag and refresh view.
- (void)refreshBuyFlag:(BOOL)isBuyed;

@end
