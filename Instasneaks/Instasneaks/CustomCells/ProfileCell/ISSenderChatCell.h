//
//  ISSenderChatCell.h
//  Instasneaks
//
//  Created by Suresh patel on 27/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ISSenderChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TTTAttributedLabel * label_chatMessage;
@property (weak, nonatomic) IBOutlet UILabel            * label_chatTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *senderWidthConstraint;

@end
