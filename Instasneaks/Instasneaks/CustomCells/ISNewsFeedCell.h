//
//  ISNewsFeedCell.h
//  Instasneaks
//
//  Created by Suresh patel on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface ISNewsFeedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView       * view_newsFeed;
@property (strong, nonatomic) IBOutlet YTPlayerView       * youTubeVideoView;
@property (strong, nonatomic) IBOutlet UIImageView  * imageView_newsFeed;
@property (strong, nonatomic) IBOutlet UILabel      * label_newsTitle;
@property (strong, nonatomic) IBOutlet UILabel      * label_newsDetail;
@property (strong, nonatomic) IBOutlet UILabel      * label_brandName;
@property (strong, nonatomic) IBOutlet UILabel      * label_videoTime;
@property (strong, nonatomic) IBOutlet UIButton     * button_share;


@end
