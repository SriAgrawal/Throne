//
//  ISRecentActivityCell.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISRecentActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *recentActivityUserLbl;
@property (strong, nonatomic) IBOutlet UILabel *recentActivity;
@property (strong, nonatomic) IBOutlet UIImageView *recentActivityImageView;

@end
