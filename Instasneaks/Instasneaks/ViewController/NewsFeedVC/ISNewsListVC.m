//
//  ISNewsListVC.m
//  Instasneaks
//
//  Created by Suresh patel on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISNewsListVC.h"
#import "ISDateUtility.h"
#import "YTPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Mixpanel/Mixpanel.h"


static NSString *cellIdentifier = @"newsFeedCell";

@interface ISNewsListVC ()<UITableViewDelegate, UITableViewDataSource,FBSDKSharingDelegate,YTPlayerViewDelegate,
UIDocumentInteractionControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    int pageNumber;
}
@property (strong, nonatomic) UIRefreshControl  * refreshControl;
@property (strong, nonatomic) ISPagination      * pagination;
@property (strong, nonatomic) IBOutlet UITableView * tableView_newsFeed;
@property (strong, nonatomic) IBOutlet UIButton * button_createCollections;
@property (assign, nonatomic) CGFloat previousScrollViewYOffset;

@property (strong, nonatomic) UIDocumentInteractionController *document;
@property (strong, nonatomic) NSMutableArray        * communityListArray;
@end

@implementation ISNewsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod{

    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Media opened"
         properties:@{ @"Background color": @"Moody yellow",
                       @"Media opened": @"absolutetly"
                       }];
    
    self.communityListArray = [NSMutableArray array];
    [self.tableView_newsFeed registerNib:[UINib nibWithNibName:@"ISNewsFeedCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    self.tableView_newsFeed.estimatedRowHeight = 380.0;
    self.tableView_newsFeed.rowHeight = UITableViewAutomaticDimension;
    
    self.pagination = [[ISPagination alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView_newsFeed addSubview:self.refreshControl];
    pageNumber = 1;
    [self makeApiCallToGetCommunityList:pageNumber];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    [self.tableView_newsFeed reloadData];
    [self.tableView_newsFeed layoutIfNeeded];
    [refreshControl endRefreshing];
    pageNumber = 1;
    [self makeApiCallToGetCommunityList:pageNumber];
}

#pragma TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _communityListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return self.tableView_newsFeed.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ISNewsFeedCell *cell = (ISNewsFeedCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ISUserInfo * objInfo = [self.communityListArray objectAtIndex:indexPath.row];
    cell.label_videoTime.textColor = [UIColor colorWithRed:127/255.0f green:127/255.0f blue:127/255.0f alpha:1.0f];
    cell.label_brandName.textColor = [UIColor colorWithRed:127/255.0f green:127/255.0f blue:127/255.0f alpha:1.0f];
    cell.label_brandName.text = objInfo.string_itemBrandName;
    if ([objInfo.string_community_type isEqualToString:@"Throne"])
    {
        cell.youTubeVideoView.hidden = YES;
        cell.imageView_newsFeed.hidden = NO;
        [cell.imageView_newsFeed sd_setImageWithURL:[NSURL URLWithString:objInfo.string_community_media] placeholderImage:[UIImage imageNamed:@"image-not-available"]];
        cell.label_videoTime.textColor = [UIColor colorWithRed:173/255.0f green:141/255.0f blue:69/255.0f alpha:1.0f];
        cell.label_brandName.textColor = [UIColor colorWithRed:173/255.0f green:141/255.0f blue:69/255.0f alpha:1.0f];
    }
    else
    {
        
        cell.imageView_newsFeed.hidden = YES;
         cell.youTubeVideoView.hidden = NO;
        NSDictionary *playerVars = @{
                                     @"playsinline" : @1,
                                     };
        NSArray *arrayUrl = [objInfo.string_community_vedioUrl componentsSeparatedByString:@"="];
        [cell.youTubeVideoView loadWithVideoId:[arrayUrl lastObject]playerVars:playerVars];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.label_newsTitle.text = objInfo.string_community_title;
    cell.label_videoTime.text = objInfo.string_community_createDate;
    NSString *labelText = objInfo.string_community_content;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,[labelText length])];
    cell.label_newsDetail.attributedText = attributedString ;
    cell.button_share.tag = indexPath.row +100;
    [cell.button_share addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *newsIdArray = [[NSMutableArray alloc] init];
    for (ISUserInfo *newsIdObj in self.communityListArray)
    {
        if ([newsIdObj.string_community_type isEqualToString:@"Throne"])
                [newsIdArray addObject:newsIdObj];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ISUserInfo * objInfo = [self.communityListArray objectAtIndex:indexPath.row];
    if ([objInfo.string_community_type isEqualToString:@"Throne"])
    {
    ISNewsDetailVC * detailVC = [[ISNewsDetailVC alloc] initWithNibName:@"ISNewsDetailVC" bundle:nil];
    detailVC.community_id= objInfo.string_community_id;
        detailVC.newsArray_id = newsIdArray;
    [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma uibutton Action

-(void)shareButtonAction:(UIButton *)sender{
    
    ISUserInfo * objInfo = [self.communityListArray objectAtIndex:sender.tag-100];
    YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"" otherButtonTitles:[NSArray arrayWithObjects:@"Share to Facebook", @"Tweet", @"Share to Instagram", @"Copy share URL", @"SMS", @"Flag", @"Cancel",@"", nil] dismissOnSelect:NO];
    [options showInViewController:self withYActionSheetBlock:^(NSInteger indexPath, BOOL isCancel) {
        if (isCancel){
            NSLog(@"cancelled");
        }
        else{
            switch (indexPath) {
                case 0:
                {
                    NSURL *imageURL =
                    [NSURL URLWithString:objInfo.string_community_media];
                    
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
                    [instaImage sd_setImageWithURL:[NSURL URLWithString:objInfo.string_community_media] placeholderImage:[UIImage imageNamed:@"image-not-available"]];
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
                    [self callflagStatusApi:objInfo.string_community_id];
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
    [tweetSheet setInitialText:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER: https://throne.app.link/dashboard?type=news"]];
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
    NSString *message =[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER: https://throne.app.link/dashboard?type=news"];
    
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

#pragma mark - UIScrollView Protocols Methods

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (self.pagination.total_pages > pageNumber) {
            pageNumber++;
            [self makeApiCallToGetCommunityList:pageNumber];
        }
    }
}
#pragma mark - Web Service Method For Get Community List
-(void)makeApiCallToGetCommunityList:(int)pageNo
{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSNumber numberWithInteger:pageNo] forKey:@"page"];
    [[ISServiceHelper helper] request:param apiName:kApiCommunities method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (pageNumber == 1)
                [self.communityListArray removeAllObjects];
            [self.communityListArray addObjectsFromArray:[self parseCommunityListDataWithList:[resultDict objectForKeyNotNull:kApiCommunities expectedObj:[NSDictionary dictionary]]]];
            
            //----->>>>>>> Pagination<<<<<------
            self.pagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
            [self.tableView_newsFeed reloadData];
        });
    }];
}
-(NSMutableArray *)parseCommunityListDataWithList:(NSArray *)array{
NSMutableArray * communityArray = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in array) {
        
        ISUserInfo * userInfo = [ISUserInfo parseDataFromDict:[dict objectForKeyNotNull:kUser expectedObj:[NSDictionary dictionary]]];
        [userInfo setString_community_id:[[dict objectForKeyNotNull:kUserId] stringValue]];
        [userInfo setString_community_title:[dict objectForKeyNotNull:kTitle expectedObj:@""]];
        [userInfo setString_itemBrandName:[dict objectForKeyNotNull:@"brand" expectedObj:@""]];
        [userInfo setString_community_content:[dict objectForKeyNotNull:kContent expectedObj:@""]];
        [userInfo setString_community_Url:[dict objectForKeyNotNull:@"community_url" expectedObj:@""]];
        [userInfo setString_community_media:[dict objectForKeyNotNull:kMedia expectedObj:@""]];
        [userInfo setString_community_clicks:[dict objectForKeyNotNull:@"clicks" expectedObj:@""]];
        [userInfo setString_community_vedioUrl:[dict objectForKeyNotNull:@"video_url" expectedObj:@""]];
        [userInfo setString_community_createDate:[ISDateUtility convertTime:[dict objectForKeyNotNull:@"updated_at" expectedObj:@""]]];
        [userInfo setString_community_type:[dict objectForKeyNotNull:@"community_type" expectedObj:@""]];
        
        [communityArray addObject:userInfo];
    }
    
    return communityArray;
}
-(void)callflagStatusApi:(NSString *)communityId
{
    NSString *apiName = [NSString stringWithFormat:@"communities/%@/%@",communityId,@"community_flag"];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self showErrorAlertWithTitle:([[resultDict objectForKey:kCode]integerValue] == 200)?[resultDict objectForKey:kMessage]:[resultDict objectForKey:kMessage]];
                        });
     }];
}
@end
