//
//  PlaceholderTextView.h
//  Screens
//
//  Created by Anshu on 12/04/16.
//  Copyright © 2016 Anshu. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface PlaceholderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;
@property (nonatomic, strong) UILabel *placeHolderLabel;

-(void)textChanged:(NSNotification*)notification;

@end
