//
//  ISLogoutPopUpVC.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 22/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISLogoutPopupDelegate;

@interface ISLogoutPopUpVC : UIViewController

@property (strong, nonatomic) NSString *popUpTitle;
@property (strong, nonatomic) NSString *popUpMessage;
@property (strong, nonatomic) NSString *popUpCancleBtnTitle;
@property (strong, nonatomic) NSString *popUpLogoutBtnTitle;
@property (assign, nonatomic) id <ISLogoutPopupDelegate> delegate;
@end

@protocol ISLogoutPopupDelegate<NSObject>

@optional

- (void)logoutButtonClicked:(ISLogoutPopUpVC *)logoutViewController;
- (void)cancelButtonClicked:(ISLogoutPopUpVC *)logoutViewController;

@end