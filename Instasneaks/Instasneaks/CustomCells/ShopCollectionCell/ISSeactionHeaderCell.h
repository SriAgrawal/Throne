//
//  ISSeactionHeaderCell.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 14/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ISSeactionHeaderCell : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UILabel *seactionLbl;
@property (strong, nonatomic) IBOutlet UIButton *seeAllBtn;
@property (strong, nonatomic) IBOutlet UIView *sepreatorView;

@end
