//
//  PATextView.m
//  PulmonaryApp
//
//  Created by Chandra Shekhar on 4/11/16.
//  Copyright © 2016 Chandra Shekhar. All rights reserved.
//

#import "PATextView.h"

@implementation PATextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - init & dealloc
- (id)initWithCoder:(NSCoder *)aDecoder {
self = [super initWithCoder:aDecoder];
if (self) {
[self initialize];
}
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    //set the placeholder color
    _placeholderColor = [UIColor lightGrayColor];
    [self layoutGUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -

#pragma mark - Notification center
- (void)textChanged:(NSNotification *)notification {
    if (notification.object == self)
        [self layoutGUI];
}
#pragma mark -

#pragma mark - layoutGUI
- (void)layoutGUI {
    _placeholderLabel.alpha = [self.text length] > 0 || [_placeholderText length] == 0 ? 0 : 1;
}
#pragma mark -

#pragma mark - Setters
- (void)setText:(NSString *)text {
    [super setText:text];
    [self layoutGUI];
}

- (void)setPlaceholderText:(NSString*)placeholderText {
    _placeholderText = placeholderText;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor*)color { //Set placeholder color
    
    _placeholderColor = [UIColor colorWithRed:162/255.0f green:162/255.0f blue:162/255.0f alpha:0.65];;
    //    _placeholderColor = color;
    [self setNeedsDisplay];
}
#pragma mark -

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    if ([_placeholderText length] > 0) {
        if (!_placeholderLabel) {
            _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.bounds.size.width - 30, 0)];
            _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeholderLabel.numberOfLines = 0;
            _placeholderLabel.font = self.font;
            _placeholderLabel.backgroundColor = [UIColor clearColor];
            _placeholderLabel.alpha = 0;
            [self addSubview:_placeholderLabel];
        }
        self.textColor = [UIColor blackColor];
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.textColor = _placeholderColor;
        [_placeholderLabel sizeToFit];
        [self sendSubviewToBack:_placeholderLabel];
    }
    
    [self layoutGUI];
    [super drawRect:rect];
}


@end
