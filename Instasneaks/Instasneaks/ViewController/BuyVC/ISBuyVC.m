//
//  ISBuyVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISBuyVC.h"
#import "Header.h"
@interface ISBuyVC ()<FBSDKSharingDelegate,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray *dataSourceArray;
    ISUserInfo *objInfo;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView_Buy;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *contanerView;
@property (strong, nonatomic) IBOutlet UICollectionView *buyProductCollectionView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) IBOutlet UILabel *buyProductLbl;
@property (strong, nonatomic) IBOutlet UILabel *purchaseBtnLbl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buyCollectionHeightConstraints;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addToDropTopContraints;

@property (strong, nonatomic) UIDocumentInteractionController *document;

@end

@implementation ISBuyVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSourceArray = [[NSMutableArray alloc]init];
    [self  callBuyDetailsApi:self.productId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initialSetup
{
  //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatScreen:) name: kRefreshChatScreen object:nil];
    [self.buyCollectionHeightConstraints setConstant:(WIN_WIDTH == 320 ? 210 : 270)];
    [self.addToDropTopContraints setConstant:(WIN_WIDTH == 320 ? 15 : 65)];

    self.tableView_Buy.tableHeaderView = self.headerView;
    
   [self.buyProductCollectionView registerNib:[UINib nibWithNibName:@"ISBuyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ISBuyCollectionCell"];
       self.pageController.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _pageController.transform = CGAffineTransformMakeScale(0.7, 0.7);
    objInfo = [dataSourceArray objectAtIndex:0];
    _buyProductLbl.text = objInfo.string_Product_Name;
 NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Purchase for as low as $%d",[objInfo.string_Product_Price intValue]]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:173/255.0f green:141/255.0f blue:69/255.0f alpha:1.0f] range:NSMakeRange(23,coloredText.length-23)];
    _purchaseBtnLbl.attributedText = coloredText;
}

//-(void)refreshChatScreen:(NSNotification *)notification{
//    
//    NSString * infoId = notification.object;
//    [self callBuyDetailsApi:infoId];
//}
#pragma mark- Delegate and Data Source Method of Collection View
-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    ISBuyCollectionCell  *cell = [collectionView
                                           dequeueReusableCellWithReuseIdentifier:@"ISBuyCollectionCell"
                                           forIndexPath:indexPath];
  
    [cell.buyProductImageView setImageWithURL:[NSURL URLWithString:objInfo.string_Product_image] placeholderImage:[UIImage imageNamed:@"image-not-available"]];
    return cell;
}
#pragma mark collection view cell layout / size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return CGSizeMake(self.buyProductCollectionView.frame.size.width,self.buyProductCollectionView.frame.size.height);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //Zooming Feature
    SYPhotoBrowser * photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:[NSArray arrayWithObject:objInfo.string_Product_image] caption:objInfo.string_Product_Name];
    [photoBrowser setInitialPageIndex:0];
    [photoBrowser setPageControlStyle:SYPhotoBrowserPageControlStyleLabel];
    [self presentViewController:photoBrowser animated:YES completion:nil];
    
}
#pragma mark Action on Page Controll

- (IBAction)pageControlChanged:(id)sender
{
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = self.buyProductCollectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [self.buyProductCollectionView setContentOffset:scrollTo animated:YES];
}
#pragma mark Delegate Method of ScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((self.buyProductCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageController.currentPage = page;
}
#pragma mark- Button Action Method
- (IBAction)addToDropAction:(id)sender
{
    
    YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"Add to Drop" otherButtonTitles:[NSArray arrayWithObjects:@"Add to Existing Drop",@"Create New",@"Cancel", nil] dismissOnSelect:NO];
    [options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel) {
        if (isCancel){
            NSLog(@"cancelled");
        }
        else{
            switch (buttonIndex) {
                case 0:
                {
                    ISSelectDropVC *selectDropVC = [[ISSelectDropVC alloc]initWithNibName:@"ISSelectDropVC" bundle:nil];
                    selectDropVC.productId = objInfo.string_Product_Id;
                    [self.navigationController  pushViewController:selectDropVC animated:YES];
                }
                    break;
                    
                case 1:
                {
                   ISMakeCollectionVC *makeVC = [[ISMakeCollectionVC alloc]initWithNibName:@"ISMakeCollectionVC" bundle:nil];
                   [self.navigationController  pushViewController:makeVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)favouriteAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self makeApiCallToAddFavourite];
    
}

- (IBAction)shareButtonAction:(id)sender
{
    YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"" otherButtonTitles:[NSArray arrayWithObjects:@"Share to Facebook", @"Tweet", @"Share to Instagram", @"Copy share URL", @"SMS", @"Flag", @"Cancel", nil] dismissOnSelect:NO];
    [options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel) {
        if (isCancel){
            NSLog(@"cancelled");
        }
        else{
            switch (buttonIndex) {
                case 0:
                {
                    NSURL *imageURL =
                    [NSURL URLWithString:objInfo.string_Product_image];
                    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                    content.contentURL = [NSURL
                                          URLWithString:[NSString stringWithFormat:@"https://throne.app.link/dashboard?id=%@",self.productObj.string_Product_Id]];
                    content.imageURL = imageURL;
                    content.contentTitle = objInfo.string_Product_Name;
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
    [tweetSheet setInitialText:[NSString stringWithFormat:@"https://throne.app.link/dashboard?id=%@",objInfo.string_Product_Id]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}
-(void)shareOnInstagram
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
    {
     
        NSData *imageData = UIImagePNGRepresentation(nil); //convert image into .png format.
        NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
        NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
        [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
        NSLog(@"image saved");
        
        CGRect rect = CGRectMake(0 ,0 , 0, 0);
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIGraphicsEndImageContext();
        NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
        NSLog(@"jpg path %@",jpgPath);
        NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
        NSLog(@"with File path %@",newJpgPath);
        NSURL *igImageHookFile = [[NSURL alloc]initFileURLWithPath:newJpgPath];
        NSLog(@"url Path %@",igImageHookFile);
        
        self.document.UTI = @"com.instagram.exclusivegram";
        // self.documentController = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
        
        self.document=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
        NSString *caption = @"#Your Text"; //settext as Default Caption
        self.document.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
        [self.document presentOpenInMenuFromRect:rect inView: self.view animated:YES];
    }
    else
    {
        UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Instagram Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errMsg show];
    }
}
-(void)copyUrl
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[NSString stringWithFormat:@"https://throne.app.link/dashboard?id=%@",objInfo.string_Product_Id]];
}
//Body of SMS
- (void)showSMS
{
    if(![MFMessageComposeViewController canSendText]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error" andMessage:@"Your device doesn't support SMS!" onController:self];
        return;
    }
    
    NSArray *recipents = nil;
    NSString *message = [NSString stringWithFormat:@"https://throne.app.link/dashboard?id=%@",objInfo.string_Product_Id];
    
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
- (IBAction)buyNewAction:(id)sender
{
    if ([self.productObj.string_Product_Price intValue] == 0)
    {
        [self showErrorAlertWithTitle:@"Sorry! there is no listing for this product"];
    }
    else
    {
        ISSelectSizeVC *selectSizeVC = [[ISSelectSizeVC alloc]initWithNibName:@"ISSelectSizeVC" bundle:nil];
        selectSizeVC.productId = self.productObj.string_Product_Id;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:selectSizeVC animated:NO];
    }
}
#pragma mark - Web Service Method For Signup
-(void)makeApiCallToAddFavourite
{
    NSString *apiName = [NSString stringWithFormat:@"products/%ld/%@",(long)[objInfo.string_Product_Id integerValue],kApiAddFavourite];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self showErrorAlertWithTitle:([[resultDict objectForKey:kCode]integerValue] == 200)?[resultDict objectForKey:kMessage]:[resultDict objectForKey:kMessage]];
                        });
     }];
}

-(void)callBuyDetailsApi:(NSString *)pId
{
    NSString *apiName = [NSString stringWithFormat:@"products/%ld",(long)[pId integerValue]];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if([[resultDict objectForKey:kCode]integerValue] == 200)
                            {
                                [dataSourceArray removeAllObjects];
                                [self parseDataFromresult:resultDict];
                                [self initialSetup];
                            }
                            else
                            {
                                [self showErrorAlertWithTitle: [resultDict objectForKey:kMessage]];
                            }
                        });
     }];
}
-(void)parseDataFromresult:(NSDictionary *)dict{
    
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
    infoDict= [dict objectForKeyNotNull:@"product" expectedObj:@""];
    ISUserInfo *info =[[ISUserInfo alloc]init];
    [info setString_Product_Id:[infoDict objectForKeyNotNull:@"id" expectedObj:@""]];
    [info setString_Product_Name:[infoDict objectForKeyNotNull:@"name" expectedObj:@""]];
    [info setString_Product_Price:[infoDict objectForKeyNotNull:@"lowest_price" expectedObj:@""]];
    [info setString_Product_image:[infoDict objectForKeyNotNull:@"image" expectedObj:@""]];
    [info setString_Product_Color:[infoDict objectForKeyNotNull:@"colorway" expectedObj:@""]];
    [dataSourceArray addObject:info];
}
-(void)callflagStatusApi
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:@"true" forKey:@"flag"];
    NSString *apiName = [NSString stringWithFormat:@"products/%ld/%@",(long)[objInfo.string_Product_Id integerValue],@"update_flag"];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:PATCH completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self showErrorAlertWithTitle:([[resultDict objectForKey:kCode]integerValue] == 200)?[resultDict objectForKey:kMessage]:[resultDict objectForKey:kMessage]];
                        });
     }];
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error
                                 andButtonsWithTitle:@[@"OK"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                       }];
}

@end
