//
//  ISNotificationVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISNotificationVC.h"
#import "Header.h"

@interface ISNotificationVC ()
{
      ISUserInfo * notifyInfo;
}
@property (strong, nonatomic) IBOutlet UITableView *notificationTableView;

@end

@implementation ISNotificationVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showNotification];
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Helping method of view controller
-(void)initialSetup
{
    notifyInfo = [[ISUserInfo alloc] init];
    [self.notificationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISNotificationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISNotificationCell class])];

}
#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ISNotificationCell *cell = (ISNotificationCell *)[self.notificationTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISNotificationCell class])];
    cell.notificationLbl.text = [@[@"News",@"Friends Joined THRONE",@"Item Shipped"]objectAtIndex:indexPath.row];
    
    
    cell.notifySwitch.tag = indexPath.row +100;
    [cell.notifySwitch addTarget:self
                          action:@selector(methodForSwitch:) forControlEvents:UIControlEventValueChanged];
    
    if (indexPath.row == 0)
    {
        cell.notificationDiscriptionLbl.text = @"Do you want to receive a notification from the THRONE staff?";
        cell.notifySwitch.on = (notifyInfo.isNews)?YES:NO;
    }
    else if(indexPath.row == 1)
    {
        cell.notificationDiscriptionLbl.text = @"Do you want to receive a notification when your friends join THRONE?";
    cell.notifySwitch.on = (notifyInfo.isFriend_joint)?YES:NO;
    }
    else
    {
        cell.notificationDiscriptionLbl.text = @"Do you want to receive a notification when your item has shipped?";
    cell.notifySwitch.on = (notifyInfo.isItem_shipped)?YES:NO;
    }
   
    return  cell;
}


#pragma mark- Switch Button Action Method

-(void)methodForSwitch:(UISwitch *)sender
{
    
        if (sender.tag == 100)
    {
        if ([sender isOn])
        {
             notifyInfo.isNews = YES;
            NSLog(@"its on!");
        } else
        {
            NSLog(@"its off!");
            notifyInfo.isNews = NO;
        }
        
    }else if (sender.tag == 101)
    {
        if ([sender isOn])
        {
             notifyInfo.isFriend_joint = YES;
            NSLog(@"its on!");
        } else
        {
            NSLog(@"its off!");
            notifyInfo.isFriend_joint = NO;
        }
    }
    else
    {
        if ([sender isOn])
        {
            NSLog(@"its on!");
            notifyInfo.isItem_shipped = YES;
        } else
        {
            NSLog(@"its off!");
            notifyInfo.isItem_shipped = NO;
        }
    }
    [self apiCallForUpdateNotifiaction];

}


#pragma mark- UIButton Action Method
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WebService Api Call For Notification

-(void)apiCallForUpdateNotifiaction{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:[NSString stringWithFormat:@"%@",notifyInfo.isNews ? @"true" : @"false"] forKey:@"news"];
    [param setValue:[NSString stringWithFormat:@"%@",notifyInfo.isItem_shipped ? @"true" : @"false"]forKey:@"item_shipped"];
    [param setValue:[NSString stringWithFormat:@"%@",notifyInfo.isFriend_joint ? @"true" : @"false"] forKey:@"friend_joint"];
    [[ISServiceHelper helper]request:param apiName:kNotification method:PUT completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    }];
}

-(void)showNotification{
    
    [[ISServiceHelper helper]request:nil apiName:kNotification method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *dict = [resultDict valueForKey:@"notification_setting"];
            [notifyInfo setIsNews:[[dict objectForKeyNotNull:@"news" expectedObj:@""] isEqualToString:@"1"]?YES:NO];
            [notifyInfo setIsFriend_joint:[[dict objectForKeyNotNull:@"friend_joint" expectedObj:@""] isEqualToString:@"1"]?YES:NO];
            [notifyInfo setIsItem_shipped:[[dict objectForKeyNotNull:@"item_shipped" expectedObj:@""] isEqualToString:@"1"]?YES:NO];
            [self.notificationTableView reloadData];
            
        });
    }];
}

@end
