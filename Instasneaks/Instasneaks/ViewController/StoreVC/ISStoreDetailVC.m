//
//  ISStoreDetailVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 10/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISStoreDetailVC.h"
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import "Social/SocialDefines.h"

@interface ISStoreDetailVC ()<FBSDKSharingDelegate,UIDocumentInteractionControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    ISUserInfo *infoObj;
    NSMutableArray *itemArray;
    int pageNumber;

}
@property (strong, nonatomic) UIDocumentInteractionController *document;
@property (strong, nonatomic) IBOutlet UICollectionView *storeItemCollection;
@property (strong, nonatomic) IBOutlet UIView *noItemView;
@property (strong, nonatomic) ISPagination      * pagination;
@property (strong, nonatomic) UIRefreshControl          * refreshControl;
@end

@implementation ISStoreDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    infoObj = [[ISUserInfo alloc] init];
    itemArray = [[NSMutableArray alloc] init];
    pageNumber = 1;
    [self performSelector:@selector(callApiForStoreProfile:) withObject:nil afterDelay:1.0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initialSetUp
{
    //Set the Star Rating
    [self.headerView.ratingView setValue:[infoObj.string_Star_Rating floatValue]];
    [self.headerView.ratingView setUserInteractionEnabled:NO];
    if ([infoObj.purchase_count integerValue] != 0)
    {[self.headerView.ratingView setUserInteractionEnabled:YES];
        [self.headerView.ratingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    //Button for Other Profile
    [self.headerView.button_right setSelected:infoObj.isSelected];
     [self.headerView.button_right addTarget:self action:@selector(favStore:) forControlEvents:UIControlEventTouchUpInside];
    
     [self.headerView.shareBtn addTarget:self action:@selector(shareLink:) forControlEvents:UIControlEventTouchUpInside];
    
    self.noItemView.hidden = (itemArray.count == 0)? NO:YES;
    _headerView.label_userName.text = infoObj.store_name;
    [_headerView.imageView_profile sd_setImageWithURL:[NSURL URLWithString:infoObj.store_logo] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    [_headerView.imageView_banner sd_setImageWithURL:[NSURL URLWithString:infoObj.store_background] placeholderImage:[UIImage imageNamed:@"img_profile_background"] options:SDWebImageProgressiveDownload];
   
    [_headerView.label_itemsCount setAttributedText:[self getAttributrdTextForItemPrice:infoObj.item_count]];
    
  [self.storeItemCollection registerNib:[UINib nibWithNibName:@"ISShopCollectionsCell"bundle:nil]forCellWithReuseIdentifier:@"shopCollectionsCell"];
    [self addRefreshController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreenWithObject:) name:@"refreshScreenForTheStore" object:nil];
}

-(void)refreshScreenWithObject:(NSNotification *)userInfo{
    
    NSDictionary * objecInfo = [userInfo object];
    self.storeId = [NSString stringWithFormat:@"%@", [objecInfo objectForKeyNotNull:@"store_id" expectedObj:@""]];
    pageNumber = 1;
    [self callApiForStoreProfile:pageNumber];
}

-(void)addRefreshController{
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.storeItemCollection addSubview:self.refreshControl];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    [self.refreshControl endRefreshing];
    pageNumber = 1;
    [self callApiForStoreProfile:1];
}

-(NSAttributedString *)getAttributrdTextForItemPrice:(NSString *)string
{
    NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ITEMS %@", string]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:118.0/255.0f green:118.0/255.0f blue:118.0/255.0f alpha:1.0f] range:NSMakeRange(0,5)];
    return coloredText;
}

#pragma mark - collectionView Delgate and DataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISShopCollectionsCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopCollectionsCell" forIndexPath:indexPath];
    ISUserInfo *imageInfo = [itemArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.storeItemCollection.frame.size.width)/3,(self.storeItemCollection.frame.size.width)/3);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISUserInfo * storeInfo = [itemArray objectAtIndex:indexPath.item];
    ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
    [storeVC setIsForItemDetail:YES];
    [storeVC setItemId:storeInfo.item_id];
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark - Scroll View Delegate Methods

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (self.pagination.total_pages > pageNumber) {
            pageNumber++;
            [self callApiForStoreProfile:pageNumber];
        }
    }
}

#pragma mark- Button Action 

- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    
    
    [self makeApiCallToRateStore:[NSString stringWithFormat:@"%.0f", sender.value]];
}

- (IBAction)favStore:(UIButton *)sender
{
    if (infoObj.isSelected) {
        [self makeApiToRemoveStoreFavourite];
    }
    else{
        [self makeApiToAddStoreFavourite];
    }
}
-(void)shareLink:(UIButton *)sender
{
YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"" otherButtonTitles:[NSArray arrayWithObjects:@"Share to Facebook", @"Tweet", @"Share to Instagram", @"Copy share URL", @"SMS", @"Flag", @"Cancel", nil] dismissOnSelect:NO];
        [options showInViewController:[APPDELEGATE navController] withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel) {
            if (isCancel){
                NSLog(@"cancelled");
            }
            else{
                switch (buttonIndex) {
                    case 0:
                    {
                        NSURL *imageURL = [NSURL URLWithString:infoObj.store_logo];
                        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                        content.contentURL = [NSURL
                                              URLWithString:[NSString stringWithFormat:@"https://throne.app.link/dashboard?id=Store%@",infoObj.store_id]];
                        content.imageURL = imageURL;
                        content.contentTitle = infoObj.store_name;
                        [content setContentDescription:@"“THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER:"];
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
                        [self shareOnInstagram];
                    }
                        break;
                    case 3:
                    {
                        [self copyUrl];
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
    [self showErrorAlertWithTitle:@"Facebook share successfully"];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"canceled!");
    [self showErrorAlertWithTitle:@"Facebook post cancel!"];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"sharing error:%@", error);
    NSString *message = @"There was a problem sharing. Please try again!";
    [self showErrorAlertWithTitle:message];
}

-(void)shareOnTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:   SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER:https://throne.app.link/dashboard?id=Store%@",infoObj.store_id]];
        [self presentViewController:tweetSheet animated:YES completion:^{
            [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result)
             {
                 if (result == SLComposeViewControllerResultCancelled)
                 {
                     NSLog(@"The user cancelled.");
                     UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"" message:@"Tweet cancelled" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                     [errMsg show];
                     // [self showErrorAlertWithTitle:@"Tweet cancelled"];
                 }
                 else if (result == SLComposeViewControllerResultDone)
                 {
                     UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"" message:@"Tweet successfully done" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                     [errMsg show];
                 }
             }];
        }];
    }
    else
    {
        [self showErrorAlertWithTitle:@"Twitter integration is not available.  A Twitter account must be set up on your device."];
    }
}
-(void)shareOnInstagram
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
    {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *imagePath = [NSString stringWithFormat:@"%@/image.igo",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        [fileManager removeItemAtPath:imagePath error:nil];
        [UIImagePNGRepresentation(_headerView.imageView_profile.image) writeToFile:imagePath atomically:YES];
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
-(void)copyUrl
{
    [self showErrorAlertWithTitle:@"Url is Copied"];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER: https://throne.app.link/dashboard?id=Store%@",infoObj.store_id]];
}
//Body of SMS
- (void)showSMS
{
    if(![MFMessageComposeViewController canSendText]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error" andMessage:@"Your device doesn't support SMS!" onController:self];
        return;
    }
    
    NSArray *recipents = nil;
    NSString *message = [NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER: https://throne.app.link/dashboard?id=Store%@",infoObj.store_id];
    
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
        case MessageComposeResultCancelled:{
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Message Cancelled!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [warningAlert show];
        }
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
-(void)callflagStatusApi
{
    NSString *apiName = [NSString stringWithFormat:@"stores/%ld/%@",(long)[infoObj.store_id integerValue],@"store_flag"];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self showErrorAlertWithTitle:([[resultDict objectForKey:kCode]integerValue] == 200)?[resultDict objectForKey:kMessage]:[resultDict objectForKey:kMessage]];
         });
     }];
}
#pragma mark-Api Method

-(void)makeApiToRemoveStoreFavourite
{
    NSString *apiName = [NSString stringWithFormat:@"stores/%@/remove_favourite", infoObj.store_id];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:DELETE completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 infoObj.isSelected = !infoObj.isSelected;
                 [self.headerView.button_right setSelected:infoObj.isSelected];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
         });
     }];
}

-(void)makeApiToAddStoreFavourite
{
    NSString *apiName = [NSString stringWithFormat:@"stores/%@/add_favourite", infoObj.store_id];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 infoObj.isSelected = !infoObj.isSelected;
                 [self.headerView.button_right setSelected:infoObj.isSelected];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
         });
     }];
}
-(void)callApiForStoreProfile:(NSInteger)page
{
    [[ISServiceHelper helper]request:nil apiName:[NSString stringWithFormat:@"stores/%@?page=%ld",_storeId,(long)page] method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[resultDict objectForKey:@"code"] integerValue ]==200)
            {
                
                NSMutableDictionary *storeInfoDic = [resultDict objectForKeyNotNull:@"store" expectedObj:[NSDictionary dictionary]];
                [infoObj setStore_id:[storeInfoDic objectForKeyNotNull:@"id" expectedObj:@""]];
                [infoObj setUserId:[storeInfoDic objectForKeyNotNull:@"user_id" expectedObj:@""]];
                [infoObj setString_Product_image:[storeInfoDic objectForKeyNotNull:@"user_image" expectedObj:@""]];
                [infoObj setStore_name:[storeInfoDic objectForKeyNotNull:@"store_name" expectedObj:@""]];
                [infoObj setStore_background:[storeInfoDic objectForKeyNotNull:@"store_background" expectedObj:@""]];
                [infoObj setPurchase_count:[storeInfoDic objectForKeyNotNull:@"purchase_count" expectedObj:@""]];
                [infoObj setStore_logo:[storeInfoDic objectForKeyNotNull:@"store_logo" expectedObj:@""]];
                [infoObj setItem_count:[storeInfoDic objectForKeyNotNull:kItemCount expectedObj:@""]];
                [infoObj setString_Star_Rating:[storeInfoDic objectForKeyNotNull:@"average_rating" expectedObj:@""]];
                [infoObj setIsSelected:[[storeInfoDic objectForKeyNotNull:kIs_Favourite] boolValue]];
                
                //[itemArray removeAllObjects];
                [self parseDataForItem:[storeInfoDic objectForKeyNotNull:@"items" expectedObj:[NSArray array]]];
                 self.pagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
                [self initialSetUp];
                [self.storeItemCollection reloadData];
            }
            else
            {
                NSLog(@"Error in response:%@",error);
            }
        });
    }];
}

-(void)makeApiCallToRateStore:(NSString *)rate
{
    [[ISServiceHelper helper]request:nil apiName:[NSString stringWithFormat:@"stores/%@/rate?rate=%@",self.storeId, rate] method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[resultDict objectForKey:@"code"] integerValue ]==200)
            {
                
            }
            else
            {
                NSLog(@"Error in response:%@",error);
            }
        });
    }];
}
-(void)parseDataForItem:(NSMutableArray *)arrayData
{
    for (NSMutableDictionary *dic in arrayData)
    {
        ISUserInfo *itemObj = [[ISUserInfo alloc] init];
        [itemObj setItem_id:[dic objectForKeyNotNull:@"id" expectedObj:@""]];
        [itemObj setImage:[dic objectForKeyNotNull:kImage expectedObj:@""]];
        [itemArray addObject: itemObj];
    }
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshScreenForTheStore" object:nil];
}

 
@end
