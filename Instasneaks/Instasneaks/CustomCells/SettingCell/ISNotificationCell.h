//
//  ISNotificationCell.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISNotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *notificationLbl;
@property (strong, nonatomic) IBOutlet UILabel *notificationDiscriptionLbl;
@property (strong, nonatomic) IBOutlet UISwitch *notifySwitch;

@end
