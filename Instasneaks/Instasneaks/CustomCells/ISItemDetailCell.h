//
//  ISItemDetailCell.h
//  Instasneaks
//
//  Created by Suresh patel on 18/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISItemDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel    * label_itemDescription;
@property (weak, nonatomic) IBOutlet UILabel    * label_bottomSeperator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_newsImage;
@property (strong, nonatomic) IBOutlet UILabel          * label_newsTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView_NewsDescription;


@end
