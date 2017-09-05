//
//  ISWalletCell.h
//  Instasneaks
//
//  Created by Suresh patel on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISWalletCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * label_promoCode;
@property (weak, nonatomic) IBOutlet UILabel * label_description;
@property (weak, nonatomic) IBOutlet UILabel * label_seprator;
@property (weak, nonatomic) IBOutlet UILabel * label_uperSeprator;
@property (weak, nonatomic) IBOutlet UIImageView * imageView_arrow;

@end
