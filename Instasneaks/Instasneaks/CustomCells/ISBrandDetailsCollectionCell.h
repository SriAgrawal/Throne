//
//  ISBrandDetailsCollectionCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISBrandDetailsCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView_Brand;
@property (strong, nonatomic) IBOutlet UIButton *btn_BrandPrice;
@property (strong, nonatomic) IBOutlet UILabel *label_BrandName;

@end
