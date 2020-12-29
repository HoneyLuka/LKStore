//
//  LKStoreListView.h
//  LKImageInfoViewer
//
//  Created by Selina on 15/12/2020.
//  Copyright © 2020 Luka Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKStoreListItem.h"

@interface LKStoreListView : UIView

- (instancetype)initWithItems:(NSArray<LKStoreListItem *> *)items;

@end
