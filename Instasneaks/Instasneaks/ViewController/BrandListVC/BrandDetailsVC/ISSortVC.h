//
//  ISSortVC.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 22/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sortVCDelegate <NSObject>

@optional
-(void)didSelectData:(NSString*)strText;
@end

@interface ISSortVC : UIViewController
@property (assign, nonatomic) id<sortVCDelegate> delegate;
@end
