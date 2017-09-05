//
//  ISEditProfileVC.m
//  Instasneaks
//
//  Created by Suresh patel on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISEditProfileVC.h"

static NSString *CellIdentifier = @"profileCell";

@interface ISEditProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    ISUserInfo *infoUser;
}
@property (weak, nonatomic) IBOutlet UITableView        * tableView_editProfile;
@property (weak, nonatomic) IBOutlet UIImageView        * imageView_userImage;
@property (weak, nonatomic) IBOutlet UILabel            * label_clothingSize;
@property (weak, nonatomic) IBOutlet UILabel            * label_shoesSize;
@property (weak, nonatomic) IBOutlet UIView             * view_topBarView;
@property (assign, nonatomic) CGFloat previousScrollViewYOffset;

@property (strong, nonatomic) IBOutlet UIView           * containerView;
@property (strong, nonatomic) CarbonTabSwipeNavigation  * pageVC;
@property (strong, nonatomic) NSArray                   * arrayItems;

@end

@implementation ISEditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    infoUser = [[ISAppUserData sharedObject] objectUserInfo];
    [self.containerView setFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-21)];
    [self callApiForProfile];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.view_topBarView setAlpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod{
    
    self.arrayItems = @[@"LOCKER", @"PURCHASED ITEMS", @"DROPS"];
    
    self.pageVC = [[CarbonTabSwipeNavigation alloc]initWithItems:self.arrayItems delegate:self];
   
    [self.pageVC.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];
    
    // set up page style
    
    [self.pageVC setTabExtraWidth:0];
    [self.pageVC setTabBarHeight:48];
    
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:0];
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:1];
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:2];
    
    // Custimize segmented control
    [self.pageVC setNormalColor:[UIColor colorWithRed:150/255.0f green:150/255.0f  blue:150/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 12 : 13)];
    [self.pageVC setSelectedColor:[UIColor colorWithRed:48/255.0f green:48/255.0f  blue:48/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 12 : 13)];
    [self.pageVC setIndicatorColor:[UIColor colorWithRed:180/255.0f green:155/255.0f  blue:91/255.0f  alpha:1.0f]];
    [self.pageVC setIndicatorHeight:4];

}
- (IBAction)doneAction:(id)sender
{
    [self updateProfileApi];
    
}

#pragma mark - UIButton Actions

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)profileButtonAction:(id)sender {
    
    YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"" otherButtonTitles:[NSArray arrayWithObjects:@"Take photo", @"Choose From Gallery", @"Cancel", nil] dismissOnSelect:NO];
    [options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel) {
        if (isCancel){
            NSLog(@"cancelled");
        }
        else{
            switch (buttonIndex) {
                case 0:
                {
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    {
                        UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                        imagePickerController.delegate = self;
                        [self presentViewController:imagePickerController animated:YES completion:^{}];
                    }
                }
                    break;
                    
                case 1:
                {
                    UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePickerController.delegate = self;
                    [self presentViewController:imagePickerController animated:YES completion:^{}];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }];
}
-(IBAction)clothingSizeButtonAction:(id)sender{
    
    [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:@[@"Small",@"Medium", @"Large",@"Xtra-Large",@"XX-Large", @"XXX-Large",@"26",@"28",@"30",@"31",@"32",@"33",@"34",@"36",@"38",@"40",@"42"] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex)
     {
         self.label_clothingSize.text = selectedText;
         infoUser.string_SelectSize = selectedText;
     }];

}

-(IBAction)shoesSizeButtonAction:(id)sender{
    
[[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:@[@"2",@"2.5",@"3",@"3.5",@"4",@"4.5",@"5",@"6",@"6.5",@"7",@"7.5",@"8",@"8.5",@"9",@"9.5",@"10",@"10.5", @"11",@"11.5", @"12",@"12.5", @"13",@"13.5",@"14",@"14.5",@"15",@"15.5"] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex)
     {
         self.label_shoesSize.text = selectedText;
     }];
}
#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.imageView_userImage setImage:image];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        infoUser.image = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbontTabSwipeNavigation viewControllerAtIndex:(NSUInteger)index {
    switch (index) {
        case 0: {
            ISLockerVC *lockerVC = [[ISLockerVC alloc] initWithNibName:@"ISLockerVC" bundle:nil];
            lockerVC.isFromOtherprofile = NO;
            return lockerVC;
        }
        case 1:{
            ISLockerVC *purchasedItemsVC= [[ISLockerVC alloc] initWithNibName:@"ISLockerVC" bundle:nil];
            purchasedItemsVC.isFromOtherprofile = NO;
            return purchasedItemsVC;
        }
        case 2:{
       
        }
            
        default:{
            return nil;
            
        }
    }
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ISCollectionsCell *cell = (ISCollectionsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}

#pragma mark - UIScrollView Protocols Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (![self shouldScroll]) {
        return;
    }
    CGRect rect = self.view_topBarView.frame;
    CGFloat height = rect.size.height-20;
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    if (scrollOffset <= -scrollView.contentInset.top) {
        rect.origin.y = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        rect.origin.y = -height;
    } else {
        rect.origin.y = MIN(20, MAX(-height, rect.origin.y - scrollDiff)); //MIN(20, MAX(-size, frame.origin.y - scrollDiff))
    }
    [self.view_topBarView setAlpha:rect.origin.y/20];
    self.view_topBarView.frame = rect;
    
    CGRect tableFrame = self.tableView_editProfile.frame;
    tableFrame.origin.y = rect.origin.y + rect.size.height;
    tableFrame.size.height = self.view.frame.size.height - (rect.size.height + rect.origin.y);
    
    self.tableView_editProfile.frame = tableFrame;
    self.previousScrollViewYOffset = scrollOffset;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (![self shouldScroll]) {
        return;
    }
    
    [self stoppedScrolling];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (![self shouldScroll]) {
        return;
    }
    if (!decelerate) {
        [self stoppedScrolling];
    }
    
}

-(BOOL)shouldScroll{
    
    CGFloat value = self.tableView_editProfile.contentSize.height - -[UIScreen mainScreen].bounds.size.height;
    return (value > 120);
}

-(void)stoppedScrolling{
    
    CGRect rect = self.view_topBarView.frame;
    if (rect.origin.y) {
        [self animateNavBarTo:(-(rect.size.height - 1))];
    }
}

-(void)animateNavBarTo:(CGFloat)y{
    
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:0.2];
    CGRect rect = self.view_topBarView.frame;
    self.view_topBarView.frame = rect;
    [self.view layoutSubviews];
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
#pragma mark-Api Method

-(void)updateProfileApi
{
    NSMutableDictionary *userParam = [[NSMutableDictionary alloc] init];
    [userParam setValue:infoUser.string_SelectSize forKey:@"clothing_size"];
    [userParam setValue:infoUser.image forKey:@"image"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userParam forKey:@"user"];
    [[ISServiceHelper helper]request:param apiName:kUpdateProfile method:PUT completionBlock:^(NSDictionary *resultDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[resultDict objectForKey:@"code"] integerValue ]==200)
            {
                NSLog(@"Update Profile");
                [self showErrorAlertWithTitle:@"Update Profile Successfully"];
            }
            else
            {
                NSLog(@"Error in response:%@",error);
                
            }
        });
    }];
}
-(void)callApiForProfile
{
    
    [[ISServiceHelper helper]request:nil apiName:[NSString stringWithFormat:@"user"] method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[resultDict objectForKey:@"code"] integerValue ]==200)
            {
                [self initialMethod];
                [self.tableView_editProfile reloadData];
            }
            else
            {
                NSLog(@"Error in response:%@",error);
            }
        });
    }];
}

-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error
                                 andButtonsWithTitle:@[@"OK"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
                                        {
                                           
                                            [self.navigationController popViewControllerAnimated:YES];
                                       }];
}
@end
