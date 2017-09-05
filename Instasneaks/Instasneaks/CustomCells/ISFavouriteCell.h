//
//  FavouriteCell.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 19/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface ISFavouriteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *priceBtn;
@property (strong, nonatomic) IBOutlet UILabel *productNameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@end
