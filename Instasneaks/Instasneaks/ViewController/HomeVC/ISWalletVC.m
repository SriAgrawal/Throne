//
//  ISWalletVC.m
//  Instasneaks
//
//  Created by Suresh patel on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISWalletVC.h"
#import <MessageUI/MessageUI.h>

static NSString *CellIdentifier = @"walletCell";

@interface ISWalletVC ()<MFMailComposeViewControllerDelegate,FBSDKAppInviteDialogDelegate>
{
    ISUserInfo *walletinfo;
}

@property (weak, nonatomic) IBOutlet UIButton       * button_myPromoCode;
@property (weak, nonatomic) IBOutlet UITableView    * tableView_wallet;
@property (weak, nonatomic) IBOutlet UILabel        * label_promoCodeValue;
- (IBAction)copyBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *inviteLbl;

@end

@implementation ISWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeApiCallToMyWallet];
    [self initialMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod{
    
    [self.tableView_wallet registerNib:[UINib nibWithNibName:@"ISWalletCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"And,we'll hook up with 5$ to spend\nfor every friend that signs up"]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:173/255.0f green:141/255.0f blue:69/255.0f alpha:1.0f] range:NSMakeRange(23,2)];
    _inviteLbl.attributedText = coloredText;
    
    [self.label_promoCodeValue addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyCodeUrl:)]];
}

-(void)copyCodeUrl:(UITapGestureRecognizer *)gestureRecognizer
{
  if (gestureRecognizer.state == UIGestureRecognizerStateRecognized &&
            [gestureRecognizer.view isKindOfClass:[UILabel class]]) {
            UILabel *someLabel = (UILabel *)gestureRecognizer.view;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:someLabel.text];
             [self showErrorAlertWithTitle:@"Promo Code Copy"];
            //let the user know you copied the text to the pasteboard and they can no paste it somewhere else
        }
    }
#pragma mark-UIButton Action Method

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)messageButtonAction:(id)sender {
    
    ISInviteFriendsVC * inviteVC = [[ISInviteFriendsVC alloc] initWithNibName:@"ISInviteFriendsVC" bundle:nil];
    inviteVC.promoCodeString = walletinfo.promo_code;
    [self.navigationController pushViewController:inviteVC animated:YES];
}

- (IBAction)facebookButtonAction:(id)sender
{
     [self callFacebookInviteMethod];
}

- (IBAction)twitterButtonAction:(id)sender
{
    [self callTwitterInviteMethod];
}

- (IBAction)gmailButtonAction:(id)sender
{
    [self mailComposer];
}
#pragma mark- UITabelView DataSourse and delegates Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ISWalletCell *cell = (ISWalletCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.label_seprator.hidden = YES;
    cell.imageView_arrow.hidden = YES;
    cell.label_uperSeprator.hidden = NO;
    switch (indexPath.row) {
        case 0:{
            [cell.label_promoCode setText: @"Promo Code Balance"];
            [cell.label_description setText: [NSString stringWithFormat:@"$%d",(int)walletinfo.wallet]];
        }
            break;
        case 1:{
            [cell.label_promoCode setText: @"Invites Accepted"];
            [cell.label_description setText: walletinfo.invites_Accepted];
            cell.label_seprator.hidden = NO;
        }
            break;
            
        default:
            
            break;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

#pragma mark - Invite Through Social Method
-(void)callFacebookInviteMethod{
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://itunes.apple.com/in/app/throne-buy-sneakers-sell-shoes/id844339182?mt=8"];
    FBSDKShareLinkContent *contentLink = [[FBSDKShareLinkContent alloc] init];
    [contentLink setContentDescription:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER:"];
//    content.contentTitle = infoObj.store_name;
//    [content setContentDescription:@""];
    //optionally set previewImageURL
    // Present the dialog. Assumes self is a view controller
    // which implements the protocol `FBSDKAppInviteDialogDelegate`.
    [FBSDKAppInviteDialog showFromViewController:self
                                     withContent:content
                                        delegate:self];
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"result successfully fetch");
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = @"There was a problem sharing. Please try again!";
    [self showErrorAlertWithTitle:message];
}

-(void)callTwitterInviteMethod{
    
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER: https://throne.app.link/dashboard?Code=%@",walletinfo.promo_code]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate delegate method
-(void)mailComposer
{
     if ([MFMailComposeViewController canSendMail])
    {
        NSString *emailTittle=@"THRONE APP";
        NSString *message = [NSString stringWithFormat:@"“THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER: https://throne.app.link/dashboard?Code=%@",walletinfo.promo_code];
        NSArray *toRecipents = nil;
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
        [mail setMailComposeDelegate:self];
        [mail setSubject:emailTittle];
        [mail setMessageBody:message isHTML:NO];
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

#pragma mark - Web Service Method For Signup
-(void)makeApiCallToMyWallet
{
    NSString *apiName = @"user/my_wallet";
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if([[resultDict objectForKey:kCode]integerValue] == 200)
                            {
                                [self parseWalletData:[resultDict objectForKeyNotNull:@"user" expectedObj:[NSDictionary dictionary]]];
                                [self.tableView_wallet reloadData];
                            }
                            else
                            {
                               [self showErrorAlertWithTitle:[resultDict objectForKey:kMessage]];
                            }
                        });
     }];
}
-(void)parseWalletData:(NSDictionary *)dicts
{
    walletinfo = [[ISUserInfo alloc] init];
    [walletinfo setUserId:[dicts objectForKeyNotNull:@"id" expectedObj:@""]];
    [walletinfo setPromo_code:[dicts objectForKeyNotNull:@"promo_code" expectedObj:@""]];
    [walletinfo setInvites_Accepted:[dicts objectForKeyNotNull:@"invites_accepted" expectedObj:@""]];
    [walletinfo setWallet:[[dicts objectForKeyNotNull:@"wallet" expectedObj:@""] floatValue]];
    [walletinfo setSocial_link:[dicts objectForKeyNotNull:@"social_link" expectedObj:@""]];
    _label_promoCodeValue.text = walletinfo.promo_code ;
}
- (IBAction)copyBtnAction:(id)sender
{
   
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[NSString stringWithFormat:@"%d",(int)walletinfo.wallet]];
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error
                                 andButtonsWithTitle:@[@"OK"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                       }];
}
@end