//
//  ISShippingCell.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ISShippingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PATextField *shippingTextField;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrowImage;

@end
