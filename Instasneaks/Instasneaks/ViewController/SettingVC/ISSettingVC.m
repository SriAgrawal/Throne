//
//  ISSettingVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISSettingVC.h"
#import "Header.h"
#import <MessageUI/MessageUI.h>

@interface ISSettingVC ()<ISLogoutPopupDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray *dataSourceArray;
}
@property (strong, nonatomic) IBOutlet UITableView *settingTableView;

@end

@implementation ISSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Helping method of view controller
-(void)initialSetup
{
    
    [self.settingTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISSettingTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISSettingTableCell class])];
    dataSourceArray = [[NSMutableArray alloc] initWithObjects:@"Notification Settings", @"Recent Activity", @"Wallet", @"Social", @"Rate this App", @"Help/FAQ", @"Contact Us", @"Log Out",nil];
    
}
#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ISSettingTableCell *cell = (ISSettingTableCell *)[self.settingTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISSettingTableCell class])];
    cell.settingLbl.text = [dataSourceArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 7)
    {
        [cell.settingLbl setTextColor:[UIColor redColor]];
    }
    else
        [cell.settingLbl setTextColor:[UIColor colorWithRed:60/255.0f green:68/255.0f blue:76/255.0f alpha:1.0f]];
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
                ISNotificationVC *brandVC = [[ISNotificationVC alloc]initWithNibName:@"ISNotificationVC" bundle:nil];
                [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case 1:
        {
                ISRecentActivityVC *brandVC = [[ISRecentActivityVC alloc]initWithNibName:@"ISRecentActivityVC" bundle:nil];
                [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case 2:
        {
              ISWalletVC *brandVC = [[ISWalletVC alloc]initWithNibName:@"ISWalletVC" bundle:nil];
                [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case 3:
        {
            ISSocialVC *brandVC = [[ISSocialVC alloc]initWithNibName:@"ISSocialVC" bundle:nil];
            [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case 4:
        {
              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/throne-buy-sneakers-sell-shoes/id844339182?mt=8"]];
        }
            break;
        case 5:
        {
                ISHelpFAQVC *brandVC = [[ISHelpFAQVC alloc]initWithNibName:@"ISHelpFAQVC" bundle:nil];
                [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;
        case 6:
        {
            [[HSHelpStack instance] showHelp:self];
            
//            [self mailComposer];
        }
            break;
        case 7:
        {
            ISLogoutPopUpVC *popUpViewController = [[ISLogoutPopUpVC alloc] initWithNibName:@"ISLogoutPopUpVC" bundle:nil];
            popUpViewController.delegate = self;
            popUpViewController.popUpTitle = @"LOG OUT";
            popUpViewController.popUpMessage = @"Are you sure you want to log out?";
            popUpViewController.popUpCancleBtnTitle = @"Cancel";
            popUpViewController.popUpLogoutBtnTitle = @"Log out";
            [self presentPopupViewController:popUpViewController animationType:MJPopupViewAnimationFade];
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logoutButtonClicked:(ISLogoutPopUpVC *)logoutViewController
{
    [self apiForLogout];
}

- (void)cancelButtonClicked:(ISLogoutPopUpVC *)logoutViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void)mailComposer
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *emailTittle=@"";
        NSString *messageBody=@"";
        NSArray *toRecipents = nil;
        MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
        mail.mailComposeDelegate=self;
        [mail setSubject:emailTittle];
        [mail setMessageBody:messageBody isHTML:NO];
        [mail setToRecipients:toRecipents];
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}
#pragma mark - email delegate method

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{

}
#pragma mark- Webservices call for logout

-(void)apiForLogout
{
    [[ISServiceHelper helper] request:nil apiName:kApiLogout method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if ([[resultDict objectForKey:kCode] integerValue] == 200)
                            {
                                [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                                [USERDEFAULT setBool:NO forKey:kIsLoggedIn];
                                [USERDEFAULT removeObjectForKey:kAuthentication_Token];
                                [USERDEFAULT removeObjectForKey:kEmail];
                                [FBSDKAccessToken setCurrentAccessToken:nil];
                                [FBSDKProfile setCurrentProfile:nil];
                                [USERDEFAULT removeObjectForKey:@"productId"];
                                [USERDEFAULT synchronize];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        });
     }];
}
@end