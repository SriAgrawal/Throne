//
//  ISInviteFriendsCell.h
//  Instasneaks
//
//  Created by Suresh patel on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISInviteFriendsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet  UILabel     * label_friendName;
@property (strong, nonatomic) IBOutlet  UIButton    * button_checkBox;
@property (strong, nonatomic) IBOutlet UIImageView  * imageView_friendImage;

@end
