//
//  ISHomecollectionCell.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 05/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSeachTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *homeCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *labelCellHeader;

@property (strong, nonatomic) IBOutlet UIButton *button_SeaAll;
@property (strong, nonatomic) IBOutlet UIView *viewSubView;
@end
