//
//  ISSellerTableCell.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 13/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface ISSellerTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PATextField *sellerTextField;
@property (strong, nonatomic) IBOutlet UILabel *sellerTypeLbl;

@end
