//
//  ISLockerValueCell.h
//  Instasneaks
//
//  Created by Suresh patel on 22/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISLockerValueCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * label_serial_number;
@property (strong, nonatomic) IBOutlet UILabel * label_userName;
@property (strong, nonatomic) IBOutlet UILabel * label_userPlace;
@property (strong, nonatomic) IBOutlet UILabel * label_moeny;
@property (strong, nonatomic) IBOutlet UILabel * label_chechItems;
@property (strong, nonatomic) IBOutlet UILabel * label_seperator;
@property (strong, nonatomic) IBOutlet UIImageView * imageView_userImage;

@end
