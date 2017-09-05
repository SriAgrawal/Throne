//
//  ISCollectionsContainerVC.m
//  Instasneaks
//
//  Created by Suresh patel on 27/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISCollectionsContainerVC.h"

@interface ISCollectionsContainerVC ()

@property(strong, nonatomic) NSMutableArray     * controllersArray;
@property (strong, nonatomic) ISBrandListHeaderView     * headerView;

@end

@implementation ISCollectionsContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPagerController];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.segmentedPager scrollToTopAnimated:NO];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpPagerController
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
    self.controllersArray = [[NSMutableArray alloc] init];
    self.headerView = [ISBrandListHeaderView instantiateFromNib];
    [self.headerView.button_back setHidden:!self.isForItemDetail];
    
    [self.headerView.label_title setText:(self.isForItemDetail ? @"BUY" : @"HOME")];
    if (self.isForItemDetail) {
        
        [self.headerView.button_back addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        ISShopCollectionsVC *storeVC = [[ISShopCollectionsVC alloc] initWithNibName:@"ISShopCollectionsVC" bundle:nil];
        [storeVC setItemId:self.itemId];
        [self.headerView.button_search setImage:[UIImage imageNamed:@"ico_share_tittlebar"] forState:UIControlStateNormal];
        [self.headerView.button_wallet setImage:[UIImage imageNamed:@"ico_drop_off"] forState:UIControlStateNormal];
        [self.headerView.button_wallet setImage:[UIImage imageNamed:@"ico_drop_on"] forState:UIControlStateSelected];
        [storeVC setNavigationBarView:self.headerView];
        [self.controllersArray addObject:storeVC];
    }
    else{
        [self.headerView.button_search addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView.button_wallet addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        ISCollectionsVC * homeVC = [[ISCollectionsVC alloc] initWithNibName:@"ISCollectionsVC" bundle:nil];
        [self.controllersArray addObject:homeVC];
    }
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    
    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeCenter;
    self.segmentedPager.parallaxHeader.height = 64;
    self.segmentedPager.parallaxHeader.minimumHeight = 0;
    self.segmentedPager.controlHeight = 0;
    self.segmentedPager.bounces = NO;
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor greenColor]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor greenColor];
    [self.segmentedPager reloadData];
}

- (IBAction)submitCategoryAction:(id)sender
{
    ISSubmitCategoryVC *submit =  [[ISSubmitCategoryVC alloc] initWithNibName:@"ISSubmitCategoryVC" bundle:nil];
    [self.navigationController pushViewController:submit animated:YES];
}

#pragma mark <MXSegmentedPagerDelegate>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager{
    return 1;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}

#pragma mark <MXPageControllerDataSource>

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"Simple"][index];
}

- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index{
    
    return [self.controllersArray objectAtIndex:index];
}

#pragma mark - IBAction Method

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    ISAddToDropContainerVC *uploadVC = [[ISAddToDropContainerVC alloc]initWithNibName:@"ISAddToDropContainerVC" bundle:nil];
    [self.navigationController pushViewController:uploadVC animated:YES];
}

- (void)walletButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    ISWalletVC *walletVC = [[ISWalletVC alloc]initWithNibName:@"ISWalletVC" bundle:nil];
    [self.navigationController pushViewController:walletVC animated:YES];
}


@end
