//
//  ISBuyPaymentVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 19/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISBuyPaymentVC.h"
#import "BraintreeUI.h"
#import "BraintreePayPal.h"
#import "BTAppSwitch.h"

static NSString *HeaderCellIdentifier = @"ISPaymentHeaderCell";

@interface ISBuyPaymentVC ()<UITextFieldDelegate,UIGestureRecognizerDelegate,BTAppSwitchDelegate,BTDropInViewControllerDelegate>
{
    NSMutableArray *arraySectionPlaceHolder,*dataSourceArray,*imageDataArray,*countryArray;
    ISUserInfo * modalpaymentInfo,*userInfo;
    BOOL isDone;
    paymentType type;

}
@property (strong, nonatomic) IBOutlet UILabel *label_ProductCondition;
@property (strong, nonatomic) IBOutlet UILabel *label_ProductName;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *buyPaymentTableView;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UILabel *label_ProductSize;
@property (strong, nonatomic) IBOutlet UICollectionView *buyPaymentCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *buyBtn;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (strong, nonatomic) IBOutlet UIButton *label_FinalPrice;
@end

@implementation ISBuyPaymentVC

#pragma mark- Life cycle of view controller
- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [[ISUserInfo alloc]init];
    imageDataArray = [[NSMutableArray alloc] init];
    countryArray = [[NSMutableArray alloc] init];
    modalpaymentInfo = [[ISUserInfo alloc]init];
    [self apiCallForGettingCountryList];
     //[self initialSetUp];
 
}
#pragma mark- Memory management method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Helper method of view controller
-(void)initialSetUp
{
    [self.buyPaymentCollectionView registerNib:[UINib nibWithNibName:@"ISBuyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ISBuyCollectionCell"];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _pageControl.transform = CGAffineTransformMakeScale(0.7, 0.7);
    //setup header and footer of table view
    self.buyPaymentTableView.tableHeaderView = self.headerView;
    self.buyPaymentTableView.tableFooterView = self.footerView;
    
    //Register the cell used in view controller
    [self.buyPaymentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISPaymentCardsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISPaymentCardsCell class])];
    [self.buyPaymentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISPaymentHeaderCell class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderCellIdentifier];
    
    [self.buyPaymentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISShippingCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISShippingCell class])];
    [self.buyPaymentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISShipingAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISShipingAddressCell class])];
    
    [self.label_FinalPrice setTitle:[NSString stringWithFormat:@"$%.2ld",(long)[modalpaymentInfo.string_Purchase_FinalPrice integerValue ]] forState:UIControlStateNormal];
    [self.label_ProductName setText:modalpaymentInfo.string_Product_Name];
    //Data source array to store the data
    dataSourceArray = [[NSMutableArray alloc] init];
    arraySectionPlaceHolder = [[NSMutableArray alloc] initWithObjects:@"SHIP TO",@"PAYMENT INFORMATION",@"REVIEW TOTAL",@"PROMO CODE", nil];
    for (int i=0; i<4; i++)
    {
      ISUserInfo * modalSectionObj = [[ISUserInfo alloc] init];
        modalSectionObj.isTapped = NO;
        [dataSourceArray addObject:modalSectionObj];
    }
}
#pragma mark- Delegate and Data Source Method of Collection View
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageDataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISBuyCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISBuyCollectionCell" forIndexPath:indexPath];
    ISUserInfo *imageData = [imageDataArray objectAtIndex:indexPath.item];
     [cell.buyProductImageView sd_setImageWithURL:[NSURL URLWithString:imageData.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Zooming Feature
//    ISUserInfo *productZoomImage = [imageDataArray objectAtIndex:indexPath.item];
//    SYPhotoBrowser * photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:[NSArray arrayWithObject:productZoomImage.image] caption:@""];
//    [photoBrowser setInitialPageIndex:0];
//    [photoBrowser setPageControlStyle:SYPhotoBrowserPageControlStyleLabel];
//    [self presentViewController:photoBrowser animated:YES completion:nil];
}

#pragma mark collection view cell layout / size

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.buyPaymentCollectionView.frame.size.width,self.buyPaymentCollectionView.frame.size.height);
}

#pragma mark Action on Page Controll

- (IBAction)pageControlChanged:(id)sender
{
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = self.buyPaymentCollectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [self.buyPaymentCollectionView setContentOffset:scrollTo animated:YES];
}

#pragma mark Delegate Method of ScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((self.buyPaymentCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

#pragma mark- Delegate and Datesource method of table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ISUserInfo * modalSectionObj = [dataSourceArray objectAtIndex:section];
    switch (section)
    {
        case 0:
        {
            return  (modalSectionObj.isTapped)? 4 : 0;
            break;
        }
            
        case 1:
        {
            return  (modalSectionObj.isTapped)? 2 : 0;
            
        }
            break;
        case 2:
            return 0;
            break;
        case 3:
        {
            return  (modalSectionObj.isTapped)? 1 : 0;
            break;
        }
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 50;
    }
    else if (indexPath.section == 1)
    {
        return 80;
    }
    else
    {
        return 60;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ISPaymentHeaderCell *sectionHeaderCell = (ISPaymentHeaderCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderCellIdentifier];
    
    //Custom section header view
    
    sectionHeaderCell.placeHolderLbl.text = [arraySectionPlaceHolder objectAtIndex:section];
    sectionHeaderCell.addBtn.tag = section+100;
    
    [sectionHeaderCell.addBtn addTarget:self action:@selector(sectionExpand:) forControlEvents:UIControlEventTouchUpInside];
    
    ISUserInfo * modalSectionObj = [dataSourceArray objectAtIndex:section];
    sectionHeaderCell.addBtnWidthConstraints.constant = (section == 2?0:30);
    sectionHeaderCell.selectedLbl.textColor = [UIColor colorWithRed:135/255.0f green:135/255.0f blue:135/255.0f alpha:1.0f];
    switch (section)
    {
        case 0:
            sectionHeaderCell.selectedLbl.text = modalpaymentInfo.string_Address;
            break;
        case 1:
            sectionHeaderCell.selectedLbl.text = modalpaymentInfo.string_paymentMode;
            break;
        case 2:
        {
            if(dataSourceArray.count){
                sectionHeaderCell.selectedLbl.textColor = [UIColor colorWithRed:207/255.0f green:184/255.0f blue:104/255.0f alpha:1.0f];
                sectionHeaderCell.selectedLbl.text = ([modalpaymentInfo.string_Country isEqualToString:@"United State"])?[NSString stringWithFormat:@"$%ld USD(including shipping)",(long)[modalpaymentInfo.string_Purchase_NationalPrice integerValue]]:[NSString stringWithFormat:@"$%ld USD(including shipping)",(long)[modalpaymentInfo.string_Purchase_WorldPrice integerValue]];
            }
        }
            break;
        case 3:
            sectionHeaderCell.selectedLbl.text = modalpaymentInfo.string_promoCode;
            break;
        default:
            break;
    }
    [sectionHeaderCell.addBtn setImage:(modalSectionObj.isTapped)?[UIImage imageNamed:@"ico_disclosure_down"]:[UIImage imageNamed:@"ico_plus"] forState:UIControlStateNormal];
    sectionHeaderCell.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIN_WIDTH, 55.0)];
    [sectionHeaderCell.backgroundView setBackgroundColor:[UIColor whiteColor]];
    return sectionHeaderCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISPaymentCardsCell *cell = (ISPaymentCardsCell *)[self.buyPaymentTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISPaymentCardsCell class])];
    ISShippingCell *Shipingcell = (ISShippingCell *)[self.buyPaymentTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISShippingCell class])];
    Shipingcell.shippingTextField.delegate = self;
    ISShipingAddressCell *ShipingAddresscell = (ISShipingAddressCell *)[self.buyPaymentTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISShipingAddressCell class])];
    ShipingAddresscell.addressTextField.delegate = self;
    ShipingAddresscell.phoneTextField.delegate = self;
    
    
    switch (indexPath.section)
    {
        case 0:
            if (indexPath.row == 0)
            {
                Shipingcell.shippingTextField.tag = 0;
                [Shipingcell.shippingTextField placeHolderWith:@"Enter name"];
                Shipingcell.shippingTextField.text = modalpaymentInfo.string_UserName;
                return Shipingcell;
            }
            else if (indexPath.row == 1)
            {
                Shipingcell.shippingTextField.tag = 1;
                [Shipingcell.shippingTextField placeHolderWith:@"Enter address" ];
                Shipingcell.shippingTextField.text = modalpaymentInfo.string_Address;
                return Shipingcell;
            }
            else if (indexPath.row == 2 || indexPath.row == 3)
            {
                ShipingAddresscell.addressTextField.tag = indexPath.row;
                ShipingAddresscell.phoneTextField.tag = indexPath.row + 100;
                
                if (ShipingAddresscell.addressTextField.tag == 2 && ShipingAddresscell.phoneTextField.tag == 102)
                {
                    ShipingAddresscell.downArrowImageView.hidden = YES;
                    [ShipingAddresscell.addressTextField placeHolderWith:@"Enter phone number"];
                    ShipingAddresscell.addressTextField.keyboardType = UIKeyboardTypePhonePad;
                    ShipingAddresscell.addressTextField.inputAccessoryView = [PATextField toolBarForNumberPad:self withString:@"Done"];
                    [ShipingAddresscell.phoneTextField placeHolderWith:@"Enter State"];
                    ShipingAddresscell.addressTextField.text = modalpaymentInfo.string_ContactNumber;
                    ShipingAddresscell.phoneTextField.text = modalpaymentInfo.string_State;
                    
                }
                else if (ShipingAddresscell.addressTextField.tag == 3 && ShipingAddresscell.phoneTextField.tag == 103)
                {
                    ShipingAddresscell.downArrowImageView.hidden = NO;
                    [ShipingAddresscell.addressTextField placeHolderWith:@"Enter zip code"];
                    ShipingAddresscell.addressTextField.keyboardType = UIKeyboardTypeNumberPad;
                    ShipingAddresscell.addressTextField.text = modalpaymentInfo.string_ZipCode;
                    ShipingAddresscell.addressTextField.inputAccessoryView = [PATextField toolBarForNumberPad:self withString:@"Done"];
                    [ShipingAddresscell.phoneTextField placeHolderWith:@"Enter Country"];
                    ShipingAddresscell.phoneTextField.text = modalpaymentInfo.string_Country;
                    
                    //                    ShipingAddresscell.phoneTextField.returnKeyType = UIReturnKeyDone;
                }
                return ShipingAddresscell;
            }
            else
            {
                
                return cell;
                
            }
            break;
        case 1:
        {
            cell.cardBtn.tag = indexPath.row;
            if (cell.cardBtn.tag == 0)
            {
                [cell.cardBtn setTitle:@"PAYPAL" forState:UIControlStateNormal];
                [cell.cardBtn addTarget:self action:@selector(creditCardAction:) forControlEvents:UIControlEventTouchUpInside];
                //[cell.cardBtn setImage:[UIImage imageNamed:@"ico_paypal"] forState:UIControlStateNormal];
                //  [cell.cardBtn setContentMode:UIViewContentModeScaleAspectFit];
            }
            else
            {
                [cell.cardBtn setTitle:@"CREDIT CARD" forState:UIControlStateNormal];
                [cell.cardBtn addTarget:self action:@selector(creditCardAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            return cell;
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            Shipingcell.shippingTextField.tag = 500;
            [Shipingcell.shippingTextField placeHolderWith:@"Enter Promo Code"];
            Shipingcell.shippingTextField.text = modalpaymentInfo.string_promoCode;
            Shipingcell.shippingTextField.returnKeyType = UIReturnKeyDone;
            return Shipingcell;
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)countryPicker:(UITextField *)sender
{
    [self.view endEditing:YES];
    [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:countryArray AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex)
     {
         sender.text = selectedText;
         modalpaymentInfo.string_Country = selectedText;
     }];

}
-(void)doneWithNumberPad
{
    [self.view endEditing:YES];
}

#pragma mark-Text Field Delegates
- (void)textFieldDidEndEditing:(PATextField *)textField
{
    [self.view layoutIfNeeded];
    
    switch (textField.tag)
    {
        case 0:
            modalpaymentInfo.string_UserName = textField.text;
            break;
        case 1:
            modalpaymentInfo.string_Address = textField.text;
            break;
        case 2:
            modalpaymentInfo.string_ContactNumber = textField.text;
            break;
        case 3:
            modalpaymentInfo.string_ZipCode = textField.text;
         
            break;
        case 102:
               modalpaymentInfo.string_State = textField.text;
            break;
        case 103:
            modalpaymentInfo.string_Country = textField.text;
            break;
        case 500:
            modalpaymentInfo.string_promoCode = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyNext)
    {
      
        if (textField.tag == 102)
        {
            [KTextField(3) becomeFirstResponder];
            return YES;
        }

        else
        {
            [KTextField(textField.tag+1) becomeFirstResponder];
        }
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case 2:
            if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 12)
                return NO;
            break;
        case 3:
            if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 6)
                return NO;
            break;
    }
    return YES;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 103)
    {
        [self countryPicker:textField];
        return NO;
    }
    return YES;
}
#pragma mark- UIButton Action Method

-(void)creditCardAction:(UIButton *)sender
{
    for (ISUserInfo * modalObj in dataSourceArray)
    {
        modalObj.isTapped = NO;
    }
  modalpaymentInfo.string_paymentMode = (sender.tag == 1)?@"CREDIT CARD":@"PAYPAL";
    [self.buyPaymentTableView reloadData];
}

-(void)sectionExpand:(UIButton *)sender
{
    BOOL isOpen = NO;
    NSInteger index = [sender tag]%100;
    ISUserInfo * modalSectionObj = [dataSourceArray objectAtIndex:index];
    isOpen = modalSectionObj.isTapped;
    for (ISUserInfo * modalObj in dataSourceArray)
    {
        modalObj.isTapped = NO;
    }
    modalSectionObj.isTapped = !isOpen;
    [dataSourceArray replaceObjectAtIndex:index withObject:modalSectionObj];
    
    switch (index)
    {
        case 0:
        {
            if (modalSectionObj.isTapped == NO)
            {
                [self.buyBtn setTitle:@"BUY" forState:UIControlStateNormal];
            }
            else
            {
            isDone = YES;
            [self.buyBtn setTitle:@"DONE" forState:UIControlStateNormal];
            }
    
            break;
        }
       case 3:
        {
            if (modalSectionObj.isTapped == NO)
            {
                [self.buyBtn setTitle:@"BUY" forState:UIControlStateNormal];
            }
            else
            {
                isDone = NO;
                [self.buyBtn setTitle:@"DONE" forState:UIControlStateNormal];
            }
            
            break;
        }
        case 1:
        {
            [self.buyBtn setTitle:@"BUY" forState:UIControlStateNormal];
        }
            break;
    
        default:
            break;
    }
    [self.buyPaymentTableView reloadData];
}

- (IBAction)backBtnAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyBtnAction:(id)sender
{
    [self.view endEditing:YES];
    if ([self.buyBtn.titleLabel.text isEqualToString:@"DONE"])
    {
        if (isDone == YES)
        {
            if ([self isAllFieldsVerified])
            {
                for (ISUserInfo * modalObj in dataSourceArray)
                {
                    modalObj.isTapped = NO;
                }
                isDone = NO;
                [self.buyBtn setTitle:@"BUY" forState:UIControlStateNormal];
                [self.buyPaymentTableView reloadData];
            }
        }
        else
        {
            for (ISUserInfo * modalObj in dataSourceArray)
            {
                modalObj.isTapped = NO;
            }
            isDone = NO;
            [self.buyBtn setTitle:@"BUY" forState:UIControlStateNormal];
            [self.buyPaymentTableView reloadData];
        }
    }
    else
    {
        if ([self isAllFieldsVerified])
        {
            [self apiCallForGettingClientToken];
        }
    }
}
#pragma  mark- PayPal Integration

-(void)setUpPayPal:(NSString*)clientToken
{
     self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:clientToken];
    
    
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce
{
    NSLog(@"%@",paymentMethodNonce.nonce);
    // Send payment method nonce to your server for processing
//    [self postNonceToServer:paymentMethodNonce.nonce];
    modalpaymentInfo.string_nonuce = paymentMethodNonce.nonce;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self callApiForOrders];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)postNonceToServer:(NSString *)paymentMethodNonce {
    // Update URL with your server
    NSURL *paymentURL = [NSURL URLWithString:@"https://your-server.example.com/checkout"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:paymentURL];
    request.HTTPBody = [[NSString stringWithFormat:@"payment_method_nonce=%@", paymentMethodNonce] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // TODO: Handle success and failure
        
        NSLog(@"Response---->%@",response);
        NSLog(@"Erroe--->%@",error.description);
    }] resume];
}

#pragma mark - BTAppSwitchDelegate

// Optional - display and hide loading indicator UI
- (void)appSwitcherWillPerformAppSwitch:(id)appSwitcher {
    
    [self showLoadingUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoadingUI:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appSwitcherWillProcessPaymentInfo:(id)appSwitcher {
    [self hideLoadingUI:nil];
}

#pragma mark - Private methods

- (void)showLoadingUI {
}

- (void)hideLoadingUI:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}


#pragma mark - Validation Methods
-(BOOL)isAllFieldsVerified{
    
    BOOL isVerified = NO;
    
    if ([TRIM_SPACE(modalpaymentInfo.string_UserName) length] == 0)
    {
        [self showErrorAlertWithTitle:KAlert_Empty_Name];
    }
    else if ([TRIM_SPACE(modalpaymentInfo.string_Address) length] == 0)
    {
        [self showErrorAlertWithTitle:KAlert_Empty_Address];
    }
    else if ([modalpaymentInfo.string_ContactNumber length] == 0)
    {
        [self showErrorAlertWithTitle:KAlert_Empty_Phone];
    }
    else if ([modalpaymentInfo.string_ContactNumber length] < 10)
    {
        [self showErrorAlertWithTitle:@"Please enter atleast 10 digits in phone number"];
    }
    else if ([modalpaymentInfo.string_ContactNumber isVAlidPhoneNumber])
    {
        [self showErrorAlertWithTitle:KAlert_Invalid_Phone];
    }
    else if ([TRIM_SPACE(modalpaymentInfo.string_State) length] == 0)
    {
        [self showErrorAlertWithTitle:KAlert_Empty_State];
    }
    else if ([modalpaymentInfo.string_ZipCode length] == 0)
    {
        [self showErrorAlertWithTitle:KAlert_Empty_Zipcode];
    }
    else if ([modalpaymentInfo.string_ZipCode length] < 6)
    {
        [self showErrorAlertWithTitle:@"Please enter atleast 6 digits in zip code"];
    }
    else if ([modalpaymentInfo.string_ZipCode isValidPinCode])
    {
        [self showErrorAlertWithTitle:KAlert_Invalid_Zipcode];
    }
    else if ([modalpaymentInfo.string_Country length] == 0)
    {
        [self showErrorAlertWithTitle:KAlert_Empty_Country];
    }
    else
    {
        isVerified = YES;
    }
    
    return isVerified;
}

#pragma mark - Webservice

-(void)apiCallForfinalPrice{
    
    NSString *apiName = [NSString stringWithFormat:@"items/%@/%@",_productsId,@"get_final_price"];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         if ([[resultDict objectForKey:kCode]integerValue] == 200)
         {
                dispatch_async(dispatch_get_main_queue(), ^{
                            
                    [self parseFinalPriceData:[resultDict objectForKeyNotNull:@"final_price" expectedObj:[NSDictionary dictionary]]];
                    [self parseShippingAddressData:[resultDict objectForKeyNotNull:@"shipping_address_details" expectedObj:[NSArray array]]];
                    [self initialSetUp];
                    [self.pageControl setNumberOfPages:imageDataArray.count];
                    [self.buyPaymentTableView reloadData];
                });
         }
     }];
}

-(void)apiCallForGettingCountryList
{
    
    NSString *apiName = [NSString stringWithFormat:@"%@",@"get_countries"];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         if ([[resultDict objectForKey:kCode]integerValue] == 200)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                                
                [self parseDataCounrty:[resultDict objectForKeyNotNull:@"countries" expectedObj:[NSArray array]]];
                [self apiCallForfinalPrice];
             });
         }
     }];
}

-(void)apiCallForGettingClientToken
{
    
    NSString *apiName = [NSString stringWithFormat:@"%@",@"orders/get_client_token_from_braintree"];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         if ([[resultDict objectForKey:kCode]integerValue] == 200)
         {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUpPayPal:[resultDict objectForKeyNotNull:@"client_token" expectedObj:@""]];
            });
         }
     }];
}
-(void)parseDataCounrty:(NSArray *)countryDataArray
{
    for (NSMutableDictionary *dic in countryDataArray)
    {
        ISUserInfo *Obj = [[ISUserInfo alloc] init];
        Obj.string_Country = [dic objectForKeyNotNull:@"name" expectedObj:@""];
        [countryArray addObject:Obj.string_Country ];
    }
}
-(void)parseShippingAddressData:(NSArray *)shippingArray
{
    for (NSMutableDictionary *Addressdic in shippingArray)
    {
        modalpaymentInfo.string_shipping_id = [Addressdic objectForKeyNotNull:@"id" expectedObj:@""];
        modalpaymentInfo.string_UserName = [Addressdic objectForKeyNotNull:@"name" expectedObj:@""];
        modalpaymentInfo.string_Address = [Addressdic objectForKeyNotNull:@"address" expectedObj:@""];
        modalpaymentInfo.string_State= [Addressdic objectForKeyNotNull:@"state" expectedObj:@""];
        modalpaymentInfo.string_City = [Addressdic objectForKeyNotNull:@"city" expectedObj:@""];
        modalpaymentInfo.string_ZipCode = [Addressdic objectForKeyNotNull:@"postal_code" expectedObj:@""];
        modalpaymentInfo.string_Country = [Addressdic objectForKeyNotNull:@"country" expectedObj:@""];
        modalpaymentInfo.string_ContactNumber = [Addressdic objectForKeyNotNull:@"phone" expectedObj:@""];
    }
}
-(void)parseFinalPriceData:(NSDictionary *)dict
{
    [modalpaymentInfo setString_Purchase_FinalPrice:[dict objectForKeyNotNull:@"final_price" expectedObj:@""]];
    [modalpaymentInfo setWallet:(long)[dict objectForKeyNotNull:@"wallet" expectedObj:@""]];
    [modalpaymentInfo setString_Purchase_NationalPrice:[dict objectForKeyNotNull:@"final_price_with_national_shipping" expectedObj:@""]];
      [modalpaymentInfo setString_Purchase_WorldPrice:[dict objectForKeyNotNull:@"final_price_with_world_wide_shipping" expectedObj:@""]];
    NSMutableDictionary *param = [dict objectForKeyNotNull:@"item" expectedObj:@""];
    modalpaymentInfo.string_Country = [param objectForKeyNotNull:@"ships_to" expectedObj:@""];
    modalpaymentInfo.string_Product_Name = [param objectForKeyNotNull:@"title" expectedObj:@""];
    NSMutableArray *imageArray = [dict objectForKeyNotNull:@"images" expectedObj:[NSArray array]];
    for (NSMutableDictionary *imageDic in imageArray)
    {
        ISUserInfo *imageObj = [[ISUserInfo alloc] init];
        imageObj.image = [imageDic objectForKeyNotNull:@"image" expectedObj:@""];
        [imageDataArray addObject:imageObj];
    }
}
-(void)callApiForOrders
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:self.productsId forKey:@"item_id"];
    [dict setValue:modalpaymentInfo.string_nonuce forKey:@"nonce"];
    [dict setValue:[NSString stringWithFormat:@"%0.2f",modalpaymentInfo.wallet] forKey:@"wallet_amount"];
    [dict setValue:([modalpaymentInfo.string_Country isEqualToString:@"United State"])?[NSString stringWithFormat:@"%ld",(long)[modalpaymentInfo.string_Purchase_NationalPrice integerValue]]:[NSString stringWithFormat:@"%ld",(long)[modalpaymentInfo.string_Purchase_WorldPrice integerValue]] forKey:@"total"];
    [dict setValue:modalpaymentInfo.string_promoCode forKey:@"coupon"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue: modalpaymentInfo.string_shipping_id forKey:@"id"];
    [param setValue:modalpaymentInfo.string_UserName forKey:@"full_name"];
    [param setValue:modalpaymentInfo.string_Address forKey:@"address_detail"];
    [param setValue:@"" forKey:@"city"];
    [param setValue:modalpaymentInfo.string_Country  forKey:@"country"];
    [param setValue:modalpaymentInfo.string_ZipCode forKey:@"postal_code"];
    [param setValue:modalpaymentInfo.string_State forKey:@"state"];
    [param setValue:modalpaymentInfo.string_ContactNumber forKey:@"phone"];
    [dict setValue:param forKey:@"shipping_address"];
    NSMutableDictionary *paramOrders = [[NSMutableDictionary alloc]init];
    [paramOrders setValue:dict forKey:@"orders"];
    [[ISServiceHelper helper] request:paramOrders apiName:kOrders method:POST completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if ([[resultDict objectForKey:kCode]integerValue] == 200)
             {
                 [self showErrorAlertWithTitle:[resultDict objectForKeyNotNull:kMessage expectedObj:@""]];
                 
                 [[AlertView sharedManager] presentAlertWithTitle:@"" message:[resultDict objectForKeyNotNull:kMessage expectedObj:@""] andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                     
                     for (UIViewController *controller in  self.navigationController.viewControllers)
                     {
                         
                         //Do not forget to import YourViewController.h
                         if ([controller isKindOfClass:[ISTabBarController class]])
                         {
                             [self.navigationController popToViewController:controller animated:YES];
                             break;
                         }
                     }
                 }];
             }
             else{
            [self showErrorAlertWithTitle:[resultDict objectForKeyNotNull:kMessage expectedObj:@""]];
            }
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

