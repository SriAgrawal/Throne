//
//  ISShopCollectionsVC.m
//  Instasneaks
//
//  Created by Suresh patel on 18/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopCollectionsVC.h"
#import <FBSDKShareKit/FBSDKSharingContent.h>
#import "Social/SocialDefines.h"

static NSString *CellIdentifier = @"productDetailCell";
static NSString *collectionCellIdentifier = @"collectionsCell";
static NSString *HeaderCellIdentifier = @"ISSeactionHeaderCell";

@interface ISShopCollectionsVC ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate,FBSDKSharingDelegate,UIDocumentInteractionControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    NSMutableArray *images;
    ISUserInfo *productDataInfo;
    NSInteger favouriteIndex;
}

@property (strong, nonatomic) IBOutlet UICollectionView * collectionView_items;
@property (strong, nonatomic) IBOutlet UITableView      * tableView_itemDetail;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_collectionImage;
@property (strong, nonatomic) IBOutlet UIButton         * buyBtn;
@property (strong, nonatomic) IBOutlet UILabel          * label_brandTitle;
@property (strong, nonatomic) IBOutlet UIView           * tableFooterView;
@property (strong, nonatomic) IBOutlet UIView           * tableHeaderView;

@property (strong, nonatomic) UIDocumentInteractionController *document;

@property (strong, nonatomic) NSMutableArray * productDetailArray;
@property (strong, nonatomic) NSMutableArray * itemDataArray;

@end

@implementation ISShopCollectionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tableView_itemDetail.tableHeaderView = self.tableHeaderView;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    CGRect rect = self.tableFooterView.frame;
    rect.size.height = 25*244+65;
    self.tableFooterView.frame = rect;
    CGSize size = self.tableView_itemDetail.contentSize;
    self.tableView_itemDetail.contentSize = CGSizeMake(WIN_WIDTH, size.height + rect.size.height);
    [self.tableView_itemDetail setTableFooterView:self.tableFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod
{
    [[Mixpanel sharedInstance] track:@"Shop Opened" properties:@{ @"Background color": @"Moody brown", @"Shop open": @"absolutetly"}];
    
        //self.label_brandTitle.text = productInfo.string_Product_Name;
    UINib *cellNib = [UINib nibWithNibName:@"ISShopCollectionsCell" bundle:nil];
    [self.collectionView_items registerNib:cellNib forCellWithReuseIdentifier:@"shopCollectionsCell"];
    [self.tableView_itemDetail registerNib:[UINib nibWithNibName:@"ISProductDetailCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.tableView_itemDetail registerNib:[UINib nibWithNibName:@"ISCollectionsCell" bundle:nil] forCellReuseIdentifier:collectionCellIdentifier];
    [self.tableView_itemDetail registerNib:[UINib nibWithNibName:@"ISHomeTableCell" bundle:nil] forCellReuseIdentifier:@"homeTableCell"];
    [self.tableView_itemDetail registerNib:[UINib nibWithNibName:NSStringFromClass([ISSeactionHeaderCell class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderCellIdentifier];

    self.tableView_itemDetail.estimatedRowHeight = 44.0;
    self.tableView_itemDetail.rowHeight = UITableViewAutomaticDimension;
    self.navigationController.navigationBarHidden =YES;
    
    self.productDetailArray = [[NSMutableArray alloc] init];
    self.itemDataArray = [[NSMutableArray alloc] init];
    
    [self.navigationBarView.button_search addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBarView.button_wallet addTarget:self action:@selector(favBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [self makeWebApiCallToGetItemDetail];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreenWithObject:) name:@"refreshScreenForTheItem" object:nil];
}
-(void)refreshScreenWithObject:(NSNotification *)userInfo{
    
    NSDictionary * objecInfo = [userInfo object];
    self.itemId = [NSString stringWithFormat:@"%@", [objecInfo objectForKeyNotNull:@"item_id" expectedObj:@""]];
    [self makeWebApiCallToGetItemDetail];
}
-(void)populateDataOnTheScreen
{
    [self.navigationBarView.button_wallet setSelected:productDataInfo.isItemSelected];
    ISUserInfo * productInfo1 = [[ISUserInfo alloc] init];
    productInfo1.string_title = @"DESCRIPTION";
    productInfo1.string_detail = productDataInfo.item_description;
    
    ISUserInfo * productInfo2 = [[ISUserInfo alloc] init];
    productInfo2.string_title = @"SHIP FROM";
    productInfo2.string_detail = productDataInfo.shipping_location;
    
    ISUserInfo * productInfo3 = [[ISUserInfo alloc] init];
    productInfo3.string_title = @"RETURN POLICY";
    productInfo3.string_detail = @"Thus item is final sale, nonreturnable and non-exchangeable";
    
    [self.productDetailArray removeAllObjects];
    [self.productDetailArray addObject:productInfo1];
    [self.productDetailArray addObject:productInfo2];
    [self.productDetailArray addObject:productInfo3];

    [self.imageView_collectionImage sd_setImageWithURL:[NSURL URLWithString:productDataInfo.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    [self.label_brandTitle setText:productDataInfo.title];
    [self.buyBtn setAttributedTitle:[self getAttributrdTextForItemPrice:productDataInfo.price] forState:UIControlStateNormal];
    [self.tableView_itemDetail reloadData];
}

-(NSMutableAttributedString *)getAttributrdTextForItemPrice:(NSString *)string{
    
    NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"BUY NOW $%@", string]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:190.0/255.0f green:155.0/255.0f blue:44.0/255.0f alpha:1.0f] range:NSMakeRange(0, 7)];
    return coloredText;
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return self.productDetailArray.count;
        }
            break;
            
        case 1:
        {
            return 1;
        }
            break;
            
        case 2:
        {
            return 1;
        }
            break;
            
        default:
            break;
    }
    
    return 0;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            return tableView.rowHeight;
        }
            break;
            
        case 1:
        {
            return 162.0;
        }
            break;
            
        case 2:
        {
            return 240*(self.itemDataArray.count/2 + self.itemDataArray.count%2) + 20;
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ISProductDetailCell *cell = (ISProductDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        ISUserInfo * productInfo = [self.productDetailArray objectAtIndex:indexPath.row];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:productInfo.string_detail];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [productInfo.string_detail length])];
        cell.label_detail.attributedText = attributedString ;
        cell.label_title.text = productInfo.string_title;
        return cell;
    }
    else if (indexPath.section == 1){
        
        ISCollectionsCell *cell = (ISCollectionsCell *)[tableView dequeueReusableCellWithIdentifier:collectionCellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.collectionCell registerNib:[UINib nibWithNibName:@"ISShopCollectionsCell"bundle:nil]forCellWithReuseIdentifier:@"shopCollectionsCell"];

        cell.collectionCell.delegate = self;
        cell.collectionCell.dataSource = self;
        [cell.label_userName setText:productDataInfo.store_name];
        [cell.userProfileImage sd_setImageWithURL:[NSURL URLWithString:productDataInfo.store_logo] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        [cell.button_favorite addTarget:self action:@selector(addFavoriteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button_userProfile addTarget:self action:@selector(storeDetailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button_favorite setSelected:productDataInfo.isSelected];
        [cell.button_favorite setTag:1234];
        [cell.collectionCell reloadData];
        return cell;
    }
    
    else{
        
        ISHomeTableCell *cell = (ISHomeTableCell *)[tableView dequeueReusableCellWithIdentifier:@"homeTableCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.homeCollectionView setScrollEnabled:NO];
        [cell.homeCollectionView registerNib:[UINib nibWithNibName:@"ISFeaturedCololectionCell"bundle:nil]forCellWithReuseIdentifier:@"ISFeaturedCololectionCell"];
        [cell.homeCollectionView setBackgroundColor:[UIColor colorWithRed:241/255.0f green:244/255.0f blue:247/255.0f alpha:1.0f]];
        cell.homeCollectionView.delegate = self;
        cell.homeCollectionView.dataSource = self;
        [cell.homeCollectionView reloadData];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ((section == 2) ? 50.0f : 0.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        ISSeactionHeaderCell *sectionHeaderCell = (ISSeactionHeaderCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderCellIdentifier];
        
        //Custom section header view
        sectionHeaderCell.sepreatorView.hidden = YES;
        sectionHeaderCell.seactionLbl.text = @"   You May Like";
        sectionHeaderCell.seactionLbl.font = NEO_SANS_PRO_REGULAR(15);
        sectionHeaderCell.seeAllBtn.hidden = YES;
        sectionHeaderCell.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIN_WIDTH, 55.0)];
        [sectionHeaderCell.backgroundView setBackgroundColor:[UIColor whiteColor]];
        return sectionHeaderCell;
    }
    else{
        return [UIView new];
    }
}
#pragma mark - collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if (view.tag == 111) {
        
        return productDataInfo.buyersImageArray.count;
    }
    else{
        return self.itemDataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 111) {
        
        ISShopCollectionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopCollectionsCell" forIndexPath:indexPath];
        ISUserInfo * imageInfo = [productDataInfo.buyersImageArray objectAtIndex:indexPath.item];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        return cell;
    }
    else{
        ISFeaturedCololectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISFeaturedCololectionCell" forIndexPath:indexPath];
        
        ISUserInfo * storeInfo = [self.itemDataArray objectAtIndex:indexPath.item];
        [cell.label_StoreName setText:storeInfo.store_name];
        [cell.label_ProductName setText:storeInfo.title];
        [cell.label_PricelLabel setText:[NSString stringWithFormat:@"$%@", storeInfo.price]];
        [cell.imageview_ProductImage sd_setImageWithURL:[NSURL URLWithString:storeInfo.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 111) {
        
        return CGSizeMake(94, 94);
    }
    else{
        return CGSizeMake((WIN_WIDTH-30)/2, 230);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    favouriteIndex = indexPath.item;
}
#pragma mark - UIButton Actions

-(void)addFavoriteButtonAction:(id)sender{
    
    if (productDataInfo.isSelected) {
        [self makeApiToRemoveStoreFavourite];
    }
    else{
        [self makeApiToAddStoreFavourite];
    }
}
-(void)storeDetailButtonAction:(id)sender{
    
    ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
    storeVC.storeId = productDataInfo.store_id;
    [self.navigationController pushViewController:storeVC animated:YES];
}

- (IBAction)zoomBtnAction:(id)sender
{
    //Zooming Feature
    SYPhotoBrowser * photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:[NSArray arrayWithObject:self.imageView_collectionImage.image] caption:productDataInfo.string_Product_Name];
    [photoBrowser setInitialPageIndex:0];
    [photoBrowser setPageControlStyle:SYPhotoBrowserPageControlStyleLabel];
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyButtonAction:(id)sender
{
    ISBuyPaymentVC *buyPay = [[ISBuyPaymentVC alloc] initWithNibName:@"ISBuyPaymentVC" bundle:nil];
    buyPay.productsId = productDataInfo.item_id;
    [self.navigationController pushViewController:buyPay animated:YES];
}

-(void)showingDataForView
{
    NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Purchase for as Low as $%ld",(long)[productDataInfo.string_Product_Price integerValue]]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:173/255.0f green:141/255.0f blue:69/255.0f alpha:1.0f] range:NSMakeRange(23,coloredText.length-23)];
    productDataInfo.string_Product_Id = productDataInfo.string_Product_Id;
}

- (IBAction)favBtnAction:(UIButton *)sender
{
    if (productDataInfo.isItemSelected)
        [self makeApiToRemoveItemFavourite];
    else
        [self makeApiToAddItemFavourite];
    [self.tableView_itemDetail reloadData];
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
                    NSURL *imageURL = [NSURL URLWithString:productDataInfo.string_Product_image];
                    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                    content.contentURL = [NSURL
                    URLWithString:[NSString stringWithFormat:@"https://throne.app.link/dashboard?id=%@",productDataInfo.item_id]];
                    content.imageURL = imageURL;
                    content.contentTitle = productDataInfo.string_Product_Name;
                    [content setContentDescription:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER"];
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
        [tweetSheet setInitialText:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER https://throne.app.link/dashboard?id=%@",productDataInfo.item_id]];
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
        [UIImagePNGRepresentation(self.imageView_collectionImage.image) writeToFile:imagePath atomically:YES];
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
    [pb setString:[NSString stringWithFormat:@"THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER https://throne.app.link/dashboard?id=%@",productDataInfo.item_id]];
}
//Body of SMS
- (void)showSMS
{
    if(![MFMessageComposeViewController canSendText]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error" andMessage:@"Your device doesn't support SMS!" onController:self];
        return;
    }
    
    NSArray *recipents = nil;
    NSString *message = [NSString stringWithFormat:@"https://throne.app.link/dashboard?id=%@",productDataInfo.item_id];
    
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


#pragma mark- UIButton Methods

- (IBAction)buyNewButtonAction:(id)sender
{
    if ([productDataInfo.string_Product_Price intValue] == 0)
    {
        [self showErrorAlertWithTitle:@"Sorry! there is no listing for this product"];
    }
    else
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    }
}
- (IBAction)otherUserProfileAction:(id)sender
{
    ISOtherProfileVC *otherVC = [[ISOtherProfileVC alloc] initWithNibName:@"ISOtherProfileVC" bundle:nil];
    [self.navigationController pushViewController:otherVC animated:YES];
}

#pragma mark - Web Service Methods

-(void)makeWebApiCallToGetItemDetail{
    
    NSString *apiName = [NSString stringWithFormat:@"items/%@", self.itemId];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 
                 [self.itemDataArray removeAllObjects];
                 NSDictionary * iteminfo = [resultDict objectForKeyNotNull:kItem expectedObj:[NSDictionary dictionary]];
                 productDataInfo = [ISUserInfo parseDataFromDict:iteminfo];
                 [productDataInfo setItem_description:[iteminfo objectForKeyNotNull:kDescription expectedObj:@""]];
                 [productDataInfo setItem_id:[iteminfo objectForKeyNotNull:kUserId expectedObj:@""]];
                 NSDictionary * storeInfo = [iteminfo objectForKeyNotNull:kStore expectedObj:[NSDictionary dictionary]];
                 [productDataInfo setStore_name:[storeInfo objectForKeyNotNull:kStore_Name expectedObj:@""]];
                 [productDataInfo setStore_logo:[storeInfo objectForKeyNotNull:kStore_Logo expectedObj:@""]];
                 [productDataInfo setStore_id:[storeInfo objectForKeyNotNull:kUserId expectedObj:@""]];
                 [productDataInfo setBuyersImageArray:[self parseSliderImageData:[storeInfo objectForKeyNotNull:kItems expectedObj:[NSArray array]]]];
                 [productDataInfo setIsSelected:[[storeInfo objectForKeyNotNull:kIs_Favourite] boolValue]];
                 [productDataInfo setIsItemSelected:[[iteminfo objectForKeyNotNull:kIs_Favourite] boolValue]];
                 self.itemDataArray = [self parseYouMayLikeItemsData:[resultDict objectForKeyNotNull:kRelated_Items expectedObj:[NSArray array]]];
                 [self populateDataOnTheScreen];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
        });
     }];
}

-(NSMutableArray *)parseSliderImageData:(NSArray *)imageArray
{
    NSMutableArray *dropArray = [NSMutableArray array];
    for (NSDictionary *dic in imageArray)
    {
        ISUserInfo *imageInfo = [ISUserInfo parseDataFromDict:dic];
        [dropArray addObject:imageInfo];
    }
    return dropArray;
}

-(NSMutableArray*)parseYouMayLikeItemsData:(NSArray *)itemsArray
{
    NSMutableArray *popularStoresArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic  in itemsArray)
    {
        ISUserInfo *productInfo = [ISUserInfo parseDataFromDict:dic];
        [popularStoresArray addObject:productInfo];
    }
    return popularStoresArray;
}

-(void)makeApiToRemoveStoreFavourite
{
    NSString *apiName = [NSString stringWithFormat:@"stores/%@/remove_favourite", productDataInfo.store_id];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:DELETE completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 productDataInfo.isSelected = !productDataInfo.isSelected;
                 [(UIButton *)[self.view viewWithTag:1234] setSelected:productDataInfo.isSelected];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
        });
     }];
}

-(void)makeApiToAddStoreFavourite
{
    NSString *apiName = [NSString stringWithFormat:@"stores/%@/add_favourite", productDataInfo.store_id];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)    
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 productDataInfo.isSelected = !productDataInfo.isSelected;
                 [(UIButton *)[self.view viewWithTag:1234] setSelected:productDataInfo.isSelected];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
         });
     }];
}
-(void)makeApiToRemoveItemFavourite
{
    NSString *apiName = [NSString stringWithFormat:@"items/%@/remove_favourite", productDataInfo.item_id];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:DELETE completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 productDataInfo.isItemSelected = !productDataInfo.isItemSelected;
                 [self.navigationBarView.button_wallet setSelected:productDataInfo.isItemSelected];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
         });
     }];
}
-(void)makeApiToAddItemFavourite
{
    NSString *apiName = [NSString stringWithFormat:@"items/%@/add_favourite", productDataInfo.item_id];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 productDataInfo.isItemSelected = !productDataInfo.isItemSelected;
                 [self.navigationBarView.button_wallet setSelected:productDataInfo.isItemSelected];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
         });
     }];
}

-(void)callflagStatusApi
{
    NSString *apiName = [NSString stringWithFormat:@"items/%ld/%@",(long)[productDataInfo.item_id integerValue],@"item_flag"];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
            [self showErrorAlertWithTitle:([[resultDict objectForKey:kCode]integerValue] == 200)?[resultDict objectForKey:kMessage]:[resultDict objectForKey:kMessage]];
         });
     }];
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshScreenForTheItem" object:nil];
}

@end
