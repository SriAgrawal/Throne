//
//  NSString+Validator.h
//  Apple-O-Pol
//
//  Created by KrishnaKant kaira on 04/06/14.
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Validator)

- (CGFloat)getEstimatedHeightWithFont:(UIFont*)font withWidth:(CGFloat)width;

- (BOOL)isBlank;
- (BOOL)isValid;
- (NSString *)removeWhiteSpacesFromString;


- (NSUInteger)countNumberOfWords;
- (BOOL)containsString:(NSString *)subString;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisarray:(NSArray*)array;

+ (NSString *)getStringFromArray:(NSArray *)array;
- (NSArray *)getArray;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;
+(BOOL)validateAddress:(NSString *)address;
-(BOOL)isValidateUsername;
- (BOOL)isValidEmail;
- (BOOL)isVAlidPhoneNumber;
- (BOOL)isVAlidCardNumber;
- (BOOL)isValidUrl;
- (BOOL)isVAlidCSV;
- (BOOL)isVAlidExpiryDate;
+(BOOL)validateFirstName:(NSString *)firstName;
+(BOOL)validateLastName:(NSString *)lastName;
+ (NSAttributedString*)getAttributedStringWithcustomFontAndColor:(NSString*)text :(NSString *)str1 :(NSString *)str2  withFont1 :(UIFont *)font1 withFont2 :(UIFont *)font2 withColor1 :(UIColor *)color1 withColor2:(UIColor *)color2;
-(BOOL)isValidPinCode;
-(NSString*)getFormattedPhoneNumber;
-(NSString*)getFormattedCardNumber;
-(NSString*)getFormattedExpiryDate;
-(NSString*)getPhoneNumberFromFormattedPhoneNumberString;
-(NSString*)getCardNumberFromFormattedCardNumberString;
-(NSString*)getExpiryDateFromFormattedExpiryDateString;

@end
