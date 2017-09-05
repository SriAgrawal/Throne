//
//  ISShopCollectionsVC.h
//  Instasneaks
//
//  Created by Suresh patel on 18/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@class ISBrandListHeaderView;

@interface ISShopCollectionsVC : UIViewController

@property (nonatomic, strong) NSString * itemId;
@property (nonatomic, strong) ISBrandListHeaderView     * navigationBarView;

@end
