//
//  NSString+Validator.m
//  Apple-O-Pol
//
//  Created by KrishnaKant kaira on 04/06/14.
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//

#import "NSString+Validator.h"

@implementation NSString (Validator)

- (CGFloat)getEstimatedHeightWithFont:(UIFont*)font withWidth:(CGFloat)width {
    
    if (!self || !self.length)
        return 0;
    
    CGFloat labelSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        
        CGRect rect = [self boundingRectWithSize : (CGSize){width, CGFLOAT_MAX}
                                         options : NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes : @{ NSFontAttributeName: font }
                                         context : nil];
        labelSize = rect.size.height;
    }
    else {
        CGRect rect = [self boundingRectWithSize : (CGSize){width, CGFLOAT_MAX}
                                         options : NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes : @{ NSFontAttributeName: font }
                                         context : nil];
        labelSize = rect.size.height;
    }
    
    return labelSize;
}

// Checking if String is Empty
-(BOOL)isBlank {
    
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}

//Checking if String is empty or nil
-(BOOL)isValid {
    
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

// remove white spaces from String
- (NSString *)removeWhiteSpacesFromString {
    
	NSString *trimmedString = [self stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return trimmedString;
}

// Counts number of Words in String
- (NSUInteger)countNumberOfWords {
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil])
        count++;
	
    return count;
}

// If string contains substring
- (BOOL)containsString:(NSString *)subString {
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

// If my string starts with given string
- (BOOL)isBeginsWith:(NSString *)string {
    return ([self hasPrefix:string]) ? YES : NO;
}

// If my string ends with given string
- (BOOL)isEndssWith:(NSString *)string {
    return ([self hasSuffix:string]) ? YES : NO;
}


// Replace particular characters in my string with new character
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar {
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

// Get Substring from particular location to given lenght
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end {
    
	NSRange r;
	r.location = begin;
	r.length = end - begin;
	return [self substringWithRange:r];
}

// Add substring to main String
- (NSString *)addString:(NSString *)string {
    
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

// Remove particular sub string from main string
-(NSString *)removeSubString:(NSString *)subString {
    
    if ([self containsString:subString]) {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}


// If my string contains ony letters
- (BOOL)containsOnlyLetters {
    
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers
- (BOOL)containsOnlyNumbers {
    
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers
- (BOOL)containsOnlyNumbersAndLetters {
    
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// If my string is available in particular array
- (BOOL)isInThisarray:(NSArray*)array {
    
    for(NSString *string in array) {
        if([self isEqualToString:string])
            return YES;
    }
    return NO;
}

// Get String from array
+ (NSString *)getStringFromArray:(NSArray *)array {
    return [array componentsJoinedByString:@" "];
}

// Convert Array from my String
- (NSArray *)getArray {
    return [self componentsSeparatedByString:@" "];
}

// Get My Application Version number
+ (NSString *)getMyApplicationVersion {
    
	NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	NSString *version = [info objectForKey:@"CFBundleVersion"];
	return version;
}

// Get My Application name
+ (NSString *)getMyApplicationName {
    
	NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	NSString *name = [info objectForKey:@"CFBundleDisplayName"];
	return name;
}

// Convert string to NSData
- (NSData *)convertToData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

// Get String from NSData
+ (NSString *)getStringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

// Is Valid Email
- (BOOL)isValidEmail {
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

+(BOOL)validateAddress:(NSString *)address
{
    
    NSString *exprs =@".*\\d+.+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    return (match ? FALSE : TRUE);
}

// Is Valid UserName
-(BOOL)isValidateUsername
{
    NSString *exprs = @"^[A-Z0-9a-z._]+$";
        NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateFirstName:(NSString *)firstName
{
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:firstName options:0 range:NSMakeRange(0, [firstName length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateLastName:(NSString *)lastName
{
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:lastName options:0 range:NSMakeRange(0, [lastName length])];
    return (match ? FALSE : TRUE);
}


-(BOOL)isValidPinCode{
    
    //US// ^\d{5}(-\d{4})?$
    //INDIA// ^[0-9]{6}$
    NSString *pinRegex = @"^\\d{5}(-\\d{5})?$";
    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
    
    BOOL pinValidates = [pinTest evaluateWithObject:self];
    return pinValidates;
}

// Is Valid Phone
- (BOOL)isVAlidPhoneNumber {
    
//    NSString *regex = @"[235689][0-9]{6}([0-9]{3})?";
    NSString *regex = @"\\+?[0-9]";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
    
    
//    NSDataDetector *matchdetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
//                                                                    error:nil];
//    NSUInteger matchNumber = [matchdetector numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
}

- (BOOL)isVAlidCardNumber {
    
    //    NSString *regex = @"[235689][0-9]{6}([0-9]{3})?";
    NSString *regex = @"\\+?[0-9]{16}";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
    
    
    //    NSDataDetector *matchdetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
    //                                                                    error:nil];
    //    NSUInteger matchNumber = [matchdetector numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
}
- (BOOL)isVAlidExpiryDate {
    
    //    NSString *regex = @"[235689][0-9]{6}([0-9]{3})?";
    NSString *regex = @"\\+?[0-9]{4}";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
    
    
    //    NSDataDetector *matchdetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
    //                                                                    error:nil];
    //    NSUInteger matchNumber = [matchdetector numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
}

- (BOOL)isVAlidCSV {
    
    //    NSString *regex = @"[235689][0-9]{6}([0-9]{3})?";
    NSString *regex = @"\\+?[0-9]{3}";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
    
    
    //    NSDataDetector *matchdetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
    //                                                                    error:nil];
    //    NSUInteger matchNumber = [matchdetector numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
}


// Is Valid URL
- (BOOL)isValidUrl {
    
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

+ (NSAttributedString*)getAttributedStringWithcustomFontAndColor:(NSString*)text :(NSString *)str1 :(NSString *)str2  withFont1 :(UIFont *)font1 withFont2 :(UIFont *)font2 withColor1 :(UIColor *)color1 withColor2:(UIColor *)color2{
    
    
    NSString *effectedStr1 = [NSString stringWithFormat:@"(%@)",str1];
    NSString *effectedStr2 = [NSString stringWithFormat:@"(%@)",str2 ];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //replacing "AND" to "and" and coloring white
    //NSString *text = [initialStr stringByReplacingOccurrencesOfString:@"AND" withString:@"and"];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:effectedStr1 options:kNilOptions error:nil];
    NSRange range = NSMakeRange(0,text.length);
    [regex enumerateMatchesInString:text options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:font1 range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color1 range:subStringRange];
    }];
    
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    //coloring all commas to white
    
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:effectedStr2 options:kNilOptions error:nil];
    NSRange range1 = NSMakeRange(0,text.length);
    [regex1 enumerateMatchesInString:text options:kNilOptions range:range1 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSFontAttributeName value:font2 range:subStringRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color2 range:subStringRange];
    }];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    return mutableAttributedString;
}

-(NSString*)getFormattedPhoneNumber{
    
    NSString *strippedValue = [self stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];

    NSString *formattedString;
    if (strippedValue.length == 0) {
        formattedString = @"";
    }else if (strippedValue.length < 3) {
        formattedString = [NSString stringWithFormat:@"(%@", strippedValue];
    }else if (strippedValue.length == 3) {
        formattedString = [NSString stringWithFormat:@"(%@) ", strippedValue];
    }else if (strippedValue.length < 6) {
        formattedString = [NSString stringWithFormat:@"(%@) %@", [strippedValue substringToIndex:3], [strippedValue substringFromIndex:3]];
    }else if (strippedValue.length == 6) {
        formattedString = [NSString stringWithFormat:@"(%@) %@-", [strippedValue substringToIndex:3], [strippedValue substringFromIndex:3]];
    }else if (strippedValue.length <= 10) {
        formattedString = [NSString stringWithFormat:@"(%@) %@-%@", [strippedValue substringToIndex:3], [strippedValue substringWithRange:NSMakeRange(3, 3)], [strippedValue substringFromIndex:6]];
    }else if (strippedValue.length >= 11) {
        formattedString = [NSString stringWithFormat:@"(%@) %@-%@ x%@", [strippedValue substringToIndex:3], [strippedValue substringWithRange:NSMakeRange(3, 3)], [strippedValue substringWithRange:NSMakeRange(6, 4)], [strippedValue substringFromIndex:10]];
    }
    return formattedString;
}

-(NSString*)getPhoneNumberFromFormattedPhoneNumberString{
    
    NSString *strippedValue = [self stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    return strippedValue;
}

-(NSString*)getFormattedCardNumber{
    
    NSString *strippedValue = [self stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    
    NSString *formattedString;
    if (strippedValue.length == 0) {
        formattedString = @"";
    }else if (strippedValue.length < 4) {
        formattedString = [NSString stringWithFormat:@"%@", strippedValue];
    }else if (strippedValue.length == 4) {
        formattedString = [NSString stringWithFormat:@"%@- ", strippedValue];
    }else if (strippedValue.length < 8) {
        formattedString = [NSString stringWithFormat:@"%@-%@", [strippedValue substringToIndex:4], [strippedValue substringFromIndex:4]];
    }else if (strippedValue.length == 8) {
        formattedString = [NSString stringWithFormat:@"%@-%@-", [strippedValue substringToIndex:4], [strippedValue substringFromIndex:4]];
    }else if (strippedValue.length < 12) {
        formattedString = [NSString stringWithFormat:@"%@-%@-%@", [strippedValue substringToIndex:4],[strippedValue substringWithRange:NSMakeRange(4,4)], [strippedValue substringFromIndex:8]];
    }else if (strippedValue.length == 12) {
        formattedString = [NSString stringWithFormat:@"%@-%@-%@-", [strippedValue substringToIndex:4],[strippedValue substringWithRange:NSMakeRange(4,4)], [strippedValue substringFromIndex:8]];
    }else if (strippedValue.length <= 16) {
        formattedString = [NSString stringWithFormat:@"%@-%@-%@-%@", [strippedValue substringToIndex:4],[strippedValue substringWithRange:NSMakeRange(4,4)], [strippedValue substringWithRange:NSMakeRange(8,4)],[strippedValue substringFromIndex:12]];
    }else if (strippedValue.length >= 16) {
        formattedString = [NSString stringWithFormat:@"%@-%@-%@-%@x%@",[strippedValue substringToIndex:4],[strippedValue substringWithRange:NSMakeRange(4,4)], [strippedValue substringWithRange:NSMakeRange(8,4)],[strippedValue substringWithRange:NSMakeRange(12,4)], [strippedValue substringFromIndex:16]];
    }
    return formattedString;
}

-(NSString*)getCardNumberFromFormattedCardNumberString{
    
    NSString *strippedValue = [self stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    return strippedValue;
}


-(NSString*)getFormattedExpiryDate{
    
    NSString *strippedValue = [self stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    
    NSString *formattedString;
    if (strippedValue.length == 0) {
        formattedString = @"";
    }else if (strippedValue.length < 2) {
        formattedString = [NSString stringWithFormat:@"%@", strippedValue];
    }else if (strippedValue.length == 2) {
        formattedString = [NSString stringWithFormat:@"%@/ ", strippedValue];
    }else if (strippedValue.length <= 4) {
        formattedString = [NSString stringWithFormat:@"%@/%@", [strippedValue substringToIndex:2], [strippedValue substringFromIndex:2]];
    }else if (strippedValue.length >= 4) {
        formattedString = [NSString stringWithFormat:@"%@/%@ x%@", [strippedValue substringToIndex:2], [strippedValue substringWithRange:NSMakeRange(2, 2)], [strippedValue substringFromIndex:4]];
    }
    return formattedString;
}

-(NSString*)getExpiryDateFromFormattedExpiryDateString{
    
    NSString *strippedValue = [self stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
    return strippedValue;
}


@end
