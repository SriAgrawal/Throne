//
//  ISBuyersCell.h
//  Instasneaks
//
//  Created by Suresh patel on 27/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISBuyersCell : UITableViewCell

@property (strong, nonatomic) IBOutlet  UILabel     * label_buyerName;
@property (strong, nonatomic) IBOutlet  UILabel     * label_offeredPrice;
@property (strong, nonatomic) IBOutlet UIImageView  * imageView_buyerImage;

@end
