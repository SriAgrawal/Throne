//
//  PATextView.h
//  PulmonaryApp
//
//  Created by Chandra Shekhar on 4/11/16.
//  Copyright © 2016 Chandra Shekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PATextView : UITextView {
    
    UILabel *_placeholderLabel;
}

@property (strong, nonatomic) NSString *placeholderText;
@property (strong, nonatomic) UIColor *placeholderColor;

@end
