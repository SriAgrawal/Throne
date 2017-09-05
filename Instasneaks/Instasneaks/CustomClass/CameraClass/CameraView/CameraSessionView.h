//
//  CACameraSessionDelegate.h
//
//  Created by Christopher Cohen & Gabriel Alvarado on 1/23/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import "CameraShutterButton.h"

///Protocol Definition
@protocol CACameraSessionDelegate <NSObject>

@optional - (void)didCaptureImage:(UIImage *)image;
@optional - (void)didCaptureImageWithData:(NSData *)imageData;

@end

@interface CameraSessionView : UIView
@property (nonatomic, strong) CaptureSessionManager *captureManager;
//Variable vith the current camera being used (Rear/Front)
@property (nonatomic, assign) CameraType cameraBeingUsed;
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, strong) NSString *btnTitle;
@property (nonatomic,assign) BOOL isFromEditProfile;
@property (nonatomic, strong) UIView *topBarView; 
@property (nonatomic, strong) CameraShutterButton *cameraShutter;
//@property (nonatomic, assign)CGFloat currentFrontISO;
//@property (nonatomic, assign) CGFloat currentBackISO;
//Delegate Property
@property (nonatomic, weak) id <CACameraSessionDelegate> delegate;

//API Functions
-(void)setTopBarColor:(UIColor *)topBarColor;
-(void)hideFlashButton;
-(void)hideCameraToogleButton;
-(void)hideDismissButton;
-(void)setupCaptureManager:(CameraType)camera;
-(void)composeInterface;
- (void)onTapFlashButton:(UIButton *)sender;
@end
