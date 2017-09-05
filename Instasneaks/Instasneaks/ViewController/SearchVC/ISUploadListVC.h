//
//  ISUploadListVC.h
//  Instasneaks
//
//  Created by Suresh patel on 26/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol uploadListVCDelegate <NSObject>

@optional
-(void)didSearchSelectData:(NSString*)strId;
-(void)searchSelectData:(NSString*)strText CategoryArray:(NSMutableArray *)category;

@end

@interface ISUploadListVC : UIViewController
@property(nonatomic) BOOL isFromAddToPicker;
@property(nonatomic,strong) NSString *Ptype;
@property (assign, nonatomic) id<uploadListVCDelegate> delegate;
@end
