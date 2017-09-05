//
//  ISUploadListCell.h
//  Instasneaks
//
//  Created by Suresh patel on 26/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISUploadListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel      * label_brandName;
@property (strong, nonatomic) IBOutlet UILabel      * label_color;
@property (strong, nonatomic) IBOutlet UIImageView  * imageView_item;
@property (strong, nonatomic) IBOutlet UIImageView  *checkImageView;

@end
