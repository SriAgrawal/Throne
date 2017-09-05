//
//  ISNewsDetailVC.m
//  Instasneaks
//
//  Created by Suresh patel on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISNewsDetailVC.h"
static NSString *CellIdentifier = @"itemDetailCell";

@interface ISNewsDetailVC ()<FBSDKSharingDelegate,UIDocumentInteractionControllerDelegate,MFMessageComposeViewControllerDelegate,UIWebViewDelegate>{
    ISUserInfo *info;
    NSString *preCommunityId;
}

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) UIDocumentInteractionController *document;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorForLoad;

@property (strong, nonatomic) IBOutlet UILabel *label_newsTips;
@property (strong, nonatomic) UIRefreshControl  * refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *community_TitleLbl;

@end

@implementation ISNewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    info = [[ISUserInfo alloc]init];
     [self apiCallForShowNewsDetails];
    //[self initialMethod];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod
{
    for (int pos = 0; pos<self.newsArray_id.count; pos++)
    {
        
        ISUserInfo *infoObj = [self.newsArray_id objectAtIndex:pos];
        if ([infoObj.string_community_id isEqualToString:self.community_id])
        {
            info.string_community_Url = infoObj.string_community_Url;
            info.string_community_title = infoObj.string_community_title;
            preCommunityId = infoObj.string_community_id;
            [self loadWebViewWithUrl];
            if (pos == self.newsArray_id.count-1)
            {
                ISUserInfo *infoObj = [self.newsArray_id objectAtIndex:pos];
                NSString *labelText = infoObj.string_community_title;
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NeoSansPro-Medium" size:20] range:NSMakeRange(0, [labelText length])];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
                self.label_newsTips.attributedText = attributedString ;
                self.community_id = infoObj.string_community_id;
                break;
            }
            else
            {
                ISUserInfo *infoObj = [self.newsArray_id objectAtIndex:pos+1];
                NSString *labelText = infoObj.string_community_title;
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NeoSansPro-Medium" size:20] range:NSMakeRange(0, [labelText length])];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
                 self.label_newsTips.attributedText = attributedString ;
                self.community_id = infoObj.string_community_id;
                break;
            }
        }
    }
}
#pragma mark -*************** WebView delegate Method ******************-

- (void)loadWebViewWithUrl{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:info.string_community_Url]]];
    _webView.delegate = self;
    self.community_TitleLbl.text = info.string_community_title;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UIButton Actions

- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)shareButtonAction:(id)sender{
    YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"" otherButtonTitles:[NSArray arrayWithObjects:@"Share to Facebook", @"Tweet", @"Share to Instagram", @"Copy share URL", @"SMS", @"Flag", @"Cancel", nil] dismissOnSelect:NO];
    [options showInViewController:self withYActionSheetBlock:^(NSInteger indexPath, BOOL isCancel) {
        if (isCancel){
            NSLog(@"cancelled");
        }
        else{
            switch (indexPath) {
                case 0:
                {
                    NSURL *imageURL =
                    [NSURL URLWithString:info.image];
                    
                    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                    content.contentURL = [NSURL
                                          URLWithString:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER https://throne.app.link/dashboard?type=news"];
                    content.imageURL = imageURL;
                    content.contentTitle = @"My Share Title";
                    [content setContentDescription:@"My THRONE APP"];
                    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
                }
                    break;
                case 1:
                {
                    [self shareOnTwitter];
                }
                    break;
                case 2:
                {
                    UIImageView *instaImage = [[UIImageView alloc] init];
                    [instaImage sd_setImageWithURL:[NSURL URLWithString:info.image] placeholderImage:[UIImage imageNamed:@"image-not-available"]];
                    [self shareOnInstagram:instaImage];
                }
                    break;
                case 3:
                {
                    UIPasteboard *pb = [UIPasteboard generalPasteboard];
                    [pb setString:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER https://throne.app.link/dashboard?type=news"]];
                }
                    break;
                case 4:
                {
                    [self showSMS];
                }
                    break;
                case 5:
                {
                    [self callflagStatusApi];
                }
                    break;
                default:
                    break;
            }
        }
    }];
}
#pragma mark - CustomMethod

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"returned back to app from facebook post");
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"canceled!");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = @"There was a problem sharing. Please try again!";
    [self showErrorAlertWithTitle:message];
}

-(void)shareOnTwitter
{
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER https://throne.app.link/dashboard?type=news"]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}
-(void)shareOnInstagram:(UIImageView *)newsMedia
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *imagePath = [NSString stringWithFormat:@"%@/image.igo",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        [fileManager removeItemAtPath:imagePath error:nil];
        [UIImagePNGRepresentation(newsMedia.image) writeToFile:imagePath atomically:YES];
        self.document.delegate = self;
        self.document.UTI = @"com.instagram.exclusivegram";
        // self.documentController = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
        
        self.document=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
        NSString *caption = @"#Your Text"; //settext as Default Caption
        self.document.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
        [self.document presentOpenInMenuFromRect:self.view.frame inView: self.view animated:YES];
        [self showErrorAlertWithTitle:@"Instagram share successfully!"];
    }
    else
    {
        UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Instagram Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errMsg show];
    }
}

//Body of SMS
- (void)showSMS
{
    if(![MFMessageComposeViewController canSendText]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error" andMessage:@"Your device doesn't support SMS!" onController:self];
        return;
    }
    
    NSArray *recipents = nil;
    NSString *message =[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER https://throne.app.link/dashboard?type=news"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}
#pragma mark - MFMessageComposeViewControllerDelegate delegate method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Message Send!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [warningAlert show];
            
        }
            break;
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error
                                 andButtonsWithTitle:@[@"OK"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                       }];
}
#pragma webservice for show news detail
-(void)apiCallForShowNewsDetails
{
    [[ISServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"communities/%@",self.community_id]method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self parseDataFromDict:[resultDict objectForKeyNotNull:@"community" expectedObj:@""]];
            [self initialMethod];
        });
    }];
}
-(void)parseDataFromDict:(NSDictionary *)dict{
    
    [info setString_community_Url:[dict objectForKeyNotNull:@"community_url" expectedObj:@"" ]];
    [info setString_community_title:[dict objectForKeyNotNull:@"title" expectedObj:@""]];
}

-(void)callflagStatusApi
{
    NSString *apiName = [NSString stringWithFormat:@"communities/%ld/%@",(long)[self.community_id integerValue],@"community_flag"];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self showErrorAlertWithTitle:([[resultDict objectForKey:kCode]integerValue] == 200)?[resultDict objectForKey:kMessage]:[resultDict objectForKey:kMessage]];
         });
     }];
}
#pragma mark- UIButton Action Method

- (IBAction)downArrowAction:(id)sender
{
    [self initialMethod];
}
- (IBAction)upArrowAction:(id)sender
{
    int position = 0;
    for (int i=0; i< self.newsArray_id.count; i++)
    {
        ISUserInfo *obj = [self.newsArray_id objectAtIndex:i];
        if ([preCommunityId isEqualToString:obj.string_community_id])
        {
            position = i;
            if (position == 0)
            {
                ISUserInfo *obj = [self.newsArray_id objectAtIndex:0];
                self.community_id = obj.string_community_id;
            }
            else
            {
                ISUserInfo *obj = [self.newsArray_id objectAtIndex:position-1];
                self.community_id = obj.string_community_id;
            }
            break;
        }
    }
    [self initialMethod];
}
@end
