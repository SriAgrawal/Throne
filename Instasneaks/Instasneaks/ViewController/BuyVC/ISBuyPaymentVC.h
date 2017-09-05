//
//  ISBuyPaymentVC.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

typedef enum paymentType : long
{
    kPayPal=0,
    kCreditCard,
    kShipping,
    kPayment,
    kreviewTotal,
    
} paymentType;

@interface ISBuyPaymentVC : UIViewController
@property (nonatomic,strong) NSString *buyConditions;
@property (nonatomic,strong) NSString *buyPrices;
@property (nonatomic,strong) NSString *buySizes;
@property (nonatomic,strong) NSString *productsId;
@property (nonatomic,strong) NSString *productName;
@end
