//
//  ISFeaturedCololectionCell.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISFeaturedCololectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageview_ProductImage;
@property (strong, nonatomic) IBOutlet UILabel *label_ProductName;
@property (strong, nonatomic) IBOutlet UILabel *label_PricelLabel;
@property (strong, nonatomic) IBOutlet UILabel *label_StoreName;
@property (strong, nonatomic) IBOutlet UIView *view_Subview;

@end
