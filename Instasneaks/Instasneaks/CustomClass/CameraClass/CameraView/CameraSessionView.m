//
//  CACameraSessionDelegate.h
//
//  Created by Christopher Cohen & Gabriel Alvarado on 1/23/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

#import "CameraSessionView.h"
#import <ImageIO/ImageIO.h>

//Custom UI classes
#import "CameraToggleButton.h"
#import "CameraFlashButton.h"
#import "CameraDismissButton.h"
#import "CameraFocalReticule.h"
#import "Constants.h"
#import "Header.h"
@interface CameraSessionView () <CaptureSessionManagerDelegate,UIGestureRecognizerDelegate>
{
    //Size of the UI elements variables
    CGSize shutterButtonSize;
    CGSize topBarSize;
    CGSize barButtonItemSize;
    
    
    BOOL flashMode;
}

//Primative Properties
@property (readwrite) BOOL animationInProgress;

//Object References
@property (nonatomic, strong) CameraToggleButton *cameraToggle;
@property (nonatomic, strong) CameraFlashButton *cameraFlash;
@property (nonatomic, strong) CameraDismissButton *cameraDismiss;
@property (nonatomic, strong) CameraFocalReticule *focalReticule;

//Temporary/Diagnostic properties
@property (nonatomic, strong) UILabel *ISOLabel, *apertureLabel, *shutterSpeedLabel;

@end

@implementation CameraSessionView

-(void)drawRect:(CGRect)rect {
//    if (self) {
//        _animationInProgress = NO;
//        [self setupCaptureManager:RearFacingCamera];
//        _cameraBeingUsed = RearFacingCamera;
//        [self composeInterface];
//        
//        [[_captureManager captureSession] startRunning];
//    }
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animationInProgress = NO;
        [self setupCaptureManager:RearFacingCamera];
        _cameraBeingUsed = RearFacingCamera;
        [self composeInterface];
        
        [[_captureManager captureSession] startRunning];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

#pragma mark - Setup

-(void)setupCaptureManager:(CameraType)camera {
    
    // remove existing input
    AVCaptureInput* currentCameraInput = [self.captureManager.captureSession.inputs objectAtIndex:0];
    [self.captureManager.captureSession removeInput:currentCameraInput];
    CGRect previousFrame = _captureManager.previewLayer.frame;
    [_captureManager.previewLayer removeFromSuperlayer];
    _captureManager = nil;
    
    //Create and configure 'CaptureSessionManager' object
    _captureManager = [CaptureSessionManager new];
    
    // indicate that some changes will be made to the session
    [self.captureManager.captureSession beginConfiguration];
    
    if (_captureManager) {
        
        //Configure
        [_captureManager setDelegate:self];
        [_captureManager initiateCaptureSessionForCamera:camera];
        [_captureManager addStillImageOutput];
        [_captureManager addVideoPreviewLayer];
        [self.captureManager.captureSession commitConfiguration];
        CGRect layerRect;
        if(previousFrame.size.height == WIN_HEIGHT){
            layerRect = self.layer.bounds;
            //Preview Layer setup
            [_captureManager.previewLayer setBounds:layerRect];
      
        }else if(previousFrame.size.height == WIN_WIDTH || previousFrame.size.width == 0){
            layerRect = CGRectMake(0, (WIN_HEIGHT - WIN_WIDTH)/2, WIN_WIDTH, WIN_WIDTH);
            //Preview Layer setup
            [_captureManager.previewLayer setBounds:layerRect];
//            [_captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
        }else if(previousFrame.origin.y == 0){
            layerRect = CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT/2);
            //Preview Layer setup
            [_captureManager.previewLayer setBounds:layerRect];
//            [_captureManager.previewLayer setAnchorPoint:CGPointMake(0.5, 1.0)];
        }else{
            layerRect = CGRectMake(0, WIN_HEIGHT/2, WIN_WIDTH, WIN_HEIGHT/2);
            //Preview Layer setup
            [_captureManager.previewLayer setBounds:layerRect];
//            [_captureManager.previewLayer setAnchorPoint:CGPointMake(0.5, 0.0)];

        }
        
//        //Preview Layer setup
//        [_captureManager.previewLayer setBounds:layerRect];
              [_captureManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
        //Apply animation effect to the camera's preview layer
        CATransition *applicationLoadViewIn =[CATransition animation];
        [applicationLoadViewIn setDuration:0.6];
        [applicationLoadViewIn setType:kCATransitionReveal];
        [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [_captureManager.previewLayer addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
        
        //Add to self.view's layer
        [self.layer addSublayer:_captureManager.previewLayer];
    }
}

-(void)composeInterface {
    
           _cameraShutter = [CameraShutterButton new];
    //
    if (_captureManager) {
        
        if(WIN_HEIGHT == 480){
            _cameraShutter.frame = (CGRect){0,0, self.bounds.size.width * 0.16, self.bounds.size.width * 0.16};
          // _cameraShutter.center = CGPointMake(self.frame.size.width/2, self.frame.size.height*.5);
        
        
        }
        else if(WIN_HEIGHT==567){
        
           _cameraShutter.frame = (CGRect){0,0, self.bounds.size.width * 0.16, self.bounds.size.width * 0.16};
        
            }
        else{
        
        _cameraShutter.frame = (CGRect){0,0, self.bounds.size.width * 0.16, self.bounds.size.width * 0.16};
        
        }
        _cameraShutter.center = CGPointMake(self.frame.size.width/2, self.frame.size.height*((WIN_HEIGHT == 480)?0.920:0.885));
        _cameraShutter.tag = ShutterButtonTag;
        [_cameraShutter setImage:[UIImage imageNamed:@"ico_Takephoto"] forState:UIControlStateNormal];
        _cameraShutter.backgroundColor = [UIColor clearColor];
       // _cameraShutter.layer.borderWidth=3.0f;
//        _cameraShutter.layer.borderColor=[UIColor colorWithRed:197.0f/255.0
//                                                         green:165.0f/255.0 blue:58.0f/255.0 alpha:1.0].CGColor;
        [_cameraShutter addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_cameraShutter];
    }
//    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,500,WIN_HEIGHT/2+15,1)];
//   
//    [lineLabel setBackgroundColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:.5]];
//    [self addSubview:lineLabel];
    //
    //    //Create the top bar and add the buttons to it
    //    _topBarView = [UIView new];
    //
    //    if (_topBarView) {
    //
    //        //Setup visual attribution for bar
    //        _topBarView.frame  = (CGRect){0,0, topBarSize};
    //        _topBarView.backgroundColor = [UIColor clearColor];
    //        [self addSubview:_topBarView];
    //
    ////        //Add the flash button
    ////        _cameraFlash = [CameraFlashButton new];
    ////        if (_cameraFlash) {
    ////            _cameraFlash.frame = (CGRect){0,0, barButtonItemSize};
    ////            _cameraFlash.center = CGPointMake(_topBarView.center.x * 0.80, _topBarView.center.y);
    ////            _cameraFlash.tag = FlashButtonTag;
    ////            [_cameraFlash setImage:[UIImage imageNamed:@"camera-flash.png"] forState:UIControlStateSelected];
    ////            [_cameraFlash setImage:[UIImage imageNamed:@"camera-flashOff.png"] forState:UIControlStateNormal];
    ////
    ////            if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad ) [_topBarView addSubview:_cameraFlash];
    ////        }
    //        //Add the camera toggle button
    ////        _cameraToggle = [CameraToggleButton new];
    ////        if (_cameraToggle) {
    ////            _cameraToggle.frame = (CGRect){0,0, barButtonItemSize};
    ////            _cameraToggle.center = CGPointMake(_topBarView.center.x * 1.20, _topBarView.center.y);
    ////            _cameraToggle.tag = ToggleButtonTag;
    ////            [_cameraToggle setImage:[UIImage imageNamed:@"camera-toggle.png"] forState:UIControlStateNormal];
    ////            [_topBarView addSubview:_cameraToggle];
    //       // }
    //        //            //Add the camera dismiss button
    //        //            _cameraDismiss = [CameraDismissButton new];
    //        //            if (_cameraDismiss) {
    //        //                _cameraDismiss.frame = (CGRect){0,0, barButtonItemSize};
    //        //                _cameraDismiss.center = CGPointMake(20, _topBarView.center.y);
    //        //                _cameraDismiss.tag = DismissButtonTag;
    //        //                [_topBarView addSubview:_cameraDismiss];
    //        //            }
    //
    //        //Attribute and configure all buttons in the bar's subview
    //        for (UIButton *button in _topBarView.subviews) {
    //            button.backgroundColor = [UIColor clearColor];
    //            [button addTarget:self action:@selector(inputManager:) forControlEvents:UIControlEventTouchUpInside];
    //        }
    //    }
    
    //Create the focus reticule UIView
    _focalReticule = [CameraFocalReticule new];
    
    if (_focalReticule) {
        
        _focalReticule.frame = (CGRect){0,0, 60, 60};
        _focalReticule.backgroundColor = [UIColor clearColor];
        _focalReticule.hidden = YES;
        [self addSubview:_focalReticule];
    }
    
    //Create the gesture recognizer for the focus tap
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    if (singleTapGestureRecognizer) [self addGestureRecognizer:singleTapGestureRecognizer];
    
//    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapToggleButton)];
//    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
//    doubleTapGestureRecognizer.delegate = self;
//    [self addGestureRecognizer:doubleTapGestureRecognizer];
//
//    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if(_isClicked)
        return NO;
    return YES;
}
#pragma mark - User Interaction

-(void)inputManager:(id)sender {
    
    //If animation is in progress, ignore input
    if (_animationInProgress) return;
    
    //If sender does not inherit from 'UIButton', return
    if (![sender isKindOfClass:[UIButton class]]) return;
    
    if([self hasAccessToCamera]){
        //Input manager switch
        switch ([(UIButton *)sender tag]) {
            case ShutterButtonTag:  [self onTapShutterButton];  return;
           // case ToggleButtonTag:   [self onTapToggleButton];   return;
            case FlashButtonTag:    [self onTapFlashButton:sender];    return;
                //case DismissButtonTag:  [self onTapDismissButton];  return;
        }
    }else{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"You don't have access to camera."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];

    }
}

- (void)onTapShutterButton {
    //Animate shutter release
//    [self animateShutterRelease];
    
    //Capture image from camera
    [_captureManager captureStillImage];
}

- (void)onTapFlashButton:(UIButton *)sender{
    if(![_captureManager.activeCamera hasFlash])
        return;
    sender.selected = !sender.selected;
    NSError *error = nil;
    if (_captureManager.activeCamera && [_captureManager.activeCamera lockForConfiguration:&error]) {
        
        if ([_captureManager.activeCamera isFlashModeSupported:(AVCaptureFlashMode)[sender isSelected]]) {
            [_captureManager.activeCamera setFlashMode:(AVCaptureFlashMode)[sender isSelected]];
        }
        [_captureManager.activeCamera unlockForConfiguration];
        
    } else if (error) {
    }
}

//- (void)onTapToggleButton {
//    
////    UIButton *brightnessBtn = (UIButton *)[self.superview viewWithTag:3000];
//
//    if (_cameraBeingUsed == RearFacingCamera) {
//        [self setupCaptureManager:FrontFacingCamera];
//        _cameraBeingUsed = FrontFacingCamera;
//        [self composeInterface];
//        [[_captureManager captureSession] startRunning];
//        
//    // _cameraFlash.hidden = YES;
//    } else {
//        [self setupCaptureManager:RearFacingCamera];
//        _cameraBeingUsed = RearFacingCamera;
//        [self composeInterface];
//        [[_captureManager captureSession] startRunning];
//        //_cameraFlash.hidden = NO;
//    }
//    
////    float totalDifference = self.captureManager.activeCamera.activeFormat.minISO + self.captureManager.activeCamera.activeFormat.maxISO;
////    if (self.captureManager.activeCamera.ISO > totalDifference/2){
////        [brightnessBtn setSelected:YES];
////    }else{
////        [brightnessBtn setSelected:NO];
////    }
//
////    slider.minimumValue = self.captureManager.activeCamera.activeFormat.minISO;
////    slider.maximumValue = self.captureManager.activeCamera.activeFormat.maxISO;
////    slider.value = self.captureManager.activeCamera.ISO;
////    NSError *error = nil;
////
////    if ([self.captureManager.activeCamera lockForConfiguration:&error]){
////        if(!error){
////            if(btn.isSelected){
////                [self.captureManager.activeCamera setExposureModeCustomWithDuration:self.captureManager.activeCamera.exposureDuration ISO: self.captureManager.activeCamera.activeFormat.maxISO completionHandler:^(CMTime syncTime) {
////                }];
////            }else{
////                [self.captureManager.activeCamera setExposureModeCustomWithDuration:self.captureManager.activeCamera.exposureDuration ISO:self.captureManager.activeCamera.activeFormat.minISO completionHandler:^(CMTime syncTime) {
////                }];
////            }
////        }
////        [self.captureManager.activeCamera unlockForConfiguration];
////        
////    }
//    if (!_isClicked) {
//        [_cameraFlash setSelected:flashMode];
//    }
//    if (_isFromEditProfile) {
//        [_cameraShutter setTitle:_btnTitle forState:UIControlStateNormal];
//    }
//
//    
//}

- (void)onTapDismissButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.center = CGPointMake(self.center.x, self.center.y*3);
    } completion:^(BOOL finished) {
        [_captureManager stop];
        [self removeFromSuperview];
    }];
}

- (void)focusGesture:(id)sender {
    
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = sender;
        if (tap.state == UIGestureRecognizerStateRecognized) {
            CGPoint location = [sender locationInView:self];
           if( CGRectContainsPoint(self.captureManager.previewLayer.frame, location)){
                [self focusAtPoint:location completionHandler:^{
                    [self animateFocusReticuleToPoint:location];
                }];
            }
        }
    }
}

#pragma mark - Animation

- (void)animateShutterRelease {
    
    _animationInProgress = YES; //Disables input manager
    
    [UIView animateWithDuration:.1 animations:^{
        _cameraShutter.transform = CGAffineTransformMakeScale(1.25, 1.25);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            _cameraShutter.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            _animationInProgress = NO; //Enables input manager
        }];
    }];
}

- (void)animateFocusReticuleToPoint:(CGPoint)targetPoint
{
    _animationInProgress = YES; //Disables input manager
    
    [self.focalReticule setCenter:targetPoint];
    self.focalReticule.alpha = 0.0;
    self.focalReticule.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.focalReticule.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.focalReticule.alpha = 0.0;
        }completion:^(BOOL finished) {
            
            _animationInProgress = NO; //Enables input manager
        }];
    }];
}

//- (void)orientationChanged:(NSNotification *)notification{
//    
//    //Animate top bar buttons on orientation changes
//    switch ([[UIDevice currentDevice] orientation]) {
//        case UIDeviceOrientationPortrait:
//        {
//            //Standard device orientation (Portrait)
//            [UIView animateWithDuration:0.6 animations:^{
//                CGAffineTransform transform = CGAffineTransformMakeRotation( 0 );
//                
//                _cameraFlash.transform = transform;
//                _cameraFlash.center = CGPointMake(_topBarView.center.x * 0.80, _topBarView.center.y);
//                
//                _cameraToggle.transform = transform;
//                _cameraToggle.center = CGPointMake(_topBarView.center.x * 1.20, _topBarView.center.y);
//                
//                _cameraDismiss.center = CGPointMake(20, _topBarView.center.y);
//            }];
//        }
//            break;
//        case UIDeviceOrientationLandscapeLeft:
//        {
//            //Device orientation changed to landscape left
//            [UIView animateWithDuration:0.6 animations:^{
//                CGAffineTransform transform = CGAffineTransformMakeRotation( M_PI_2 );
//                
//                _cameraFlash.transform = transform;
//                _cameraFlash.center = CGPointMake(_topBarView.center.x * 1.25, _topBarView.center.y);
//                
//                _cameraToggle.transform = transform;
//                _cameraToggle.center = CGPointMake(_topBarView.center.x * 1.60, _topBarView.center.y);
//                
//                _cameraDismiss.center = CGPointMake(_topBarView.center.x * 0.25, _topBarView.center.y);
//            }];
//        }
//            break;
//        case UIDeviceOrientationLandscapeRight:
//        {
//            //Device orientation changed to landscape right
//            [UIView animateWithDuration:0.6 animations:^{
//                CGAffineTransform transform = CGAffineTransformMakeRotation( - M_PI_2 );
//                
//                _cameraFlash.transform = transform;
//                _cameraFlash.center = CGPointMake(_topBarView.center.x * 0.40, _topBarView.center.y);
//                
//                _cameraToggle.transform = transform;
//                _cameraToggle.center = CGPointMake(_topBarView.center.x * 0.75, _topBarView.center.y);
//                
//                _cameraDismiss.center = CGPointMake(_topBarView.center.x * 1.75, _topBarView.center.y);
//            }];
//        }
//            break;
//        default:;
//    }
//}

#pragma mark - Camera Session Manager Delegate Methods

-(void)cameraSessionManagerDidCaptureImage
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(didCaptureImage:)])
            [self.delegate didCaptureImage:[[self captureManager] stillImage]];
        
        if ([self.delegate respondsToSelector:@selector(didCaptureImageWithData:)])
            [self.delegate didCaptureImageWithData:[[self captureManager] stillImageData]];
    }
}

-(void)cameraSessionManagerFailedToCaptureImage {
}

-(void)cameraSessionManagerDidReportAvailability:(BOOL)deviceAvailability forCameraType:(CameraType)cameraType {
}

-(void)cameraSessionManagerDidReportDeviceStatistics:(CameraStatistics)deviceStatistics {
}

#pragma mark - Helper Methods
-(BOOL)hasAccessToCamera{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(status == AVAuthorizationStatusAuthorized) {
        return YES;
        // authorized
    } else if(status == AVAuthorizationStatusDenied){
        return NO;
        // denied
    } else if(status == AVAuthorizationStatusRestricted){
        // restricted
        return NO;
    } else if(status == AVAuthorizationStatusNotDetermined){
        // not determined
        return NO;
    }
    return NO;
}
- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)())completionHandler
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];;
    CGPoint pointOfInterest = CGPointZero;
    CGSize frameSize = self.bounds.size;
    pointOfInterest = CGPointMake(point.y / frameSize.height, 1.f - (point.x / frameSize.width));
    
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        
        //Lock camera for configuration if possible
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
            }
            
            if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                [device setFocusPointOfInterest:pointOfInterest];
            }
            
            if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [device setExposurePointOfInterest:pointOfInterest];
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [device unlockForConfiguration];
            
            completionHandler();
        }
    }
    else { completionHandler(); }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - API Functions

- (void)setTopBarColor:(UIColor *)topBarColor
{
    _topBarView.backgroundColor = topBarColor;
}

- (void)hideFlashButton
{
    _cameraFlash.hidden = YES;
}

- (void)hideCameraToogleButton
{
    _cameraToggle.hidden = YES;
}

- (void)hideDismissButton
{
    _cameraDismiss.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
