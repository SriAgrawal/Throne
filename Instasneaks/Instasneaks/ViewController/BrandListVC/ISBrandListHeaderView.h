//
//  ISBrandListHeaderView.h
//  Instasneaks
//
//  Created by Suresh patel on 13/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISBrandListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton   * button_wallet;
@property (weak, nonatomic) IBOutlet UIButton   * button_search;
@property (weak, nonatomic) IBOutlet UIButton   * button_back;

@property (weak, nonatomic) IBOutlet UILabel    * label_title;

+ (instancetype)instantiateFromNib;

@end
