//
//  ISHomeCollectionCells.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 05/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ISHomeCollectionCells : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView           * viewHomeCollection;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_logo;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_background;
@property (strong, nonatomic) IBOutlet UILabel          * label_storeName;
@property (strong, nonatomic) IBOutlet UILabel          * label_productCount;

@property (strong, nonatomic) IBOutlet UIImageView      * imageView_productOne;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_productTwo;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_productThree;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_productFour;
@property (weak, nonatomic) IBOutlet UIButton *itemOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *itemTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *itemThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *itemFourBtn;
-(void)showProductImageWithData:(NSArray *)productList;

@end
