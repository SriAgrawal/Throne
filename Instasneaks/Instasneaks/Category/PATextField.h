//
//  PATextField.h
//  PulmonaryApp
//
//  Created by Chandra Shekhar on 4/11/16.
//  Copyright © 2016 Chandra Shekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum setErrorType {
    
    defaultType = 1,
    activeType,
    errortype
} Type;


@interface PATextField : UITextField

@property (nonatomic, setter=setPaddingValue:) IBInspectable NSInteger paddingValue;
@property (nonatomic, strong) IBInspectable UIImage *paddingIcon;
@property (strong, nonatomic) NSIndexPath *indexPath; // use if cell for getting easily the cell & txtfield
- (void)setPlaceholderImage:(UIImage *)iconImage;
//- (void)placeHolder:(NSString *)text;


/***************** Changethe border color of uitextfield according to its state  ****************/

- (void)setErrorStatus:(Type)status;
- (void)active;
- (void)inactive;
- (void)error;
- (void)checkForError;
- (void)placeHolderWith:(NSString *)text;
+(UIToolbar*)toolBarForNumberPad:(UIViewController *)controller withString:(NSString *)text;

@end
