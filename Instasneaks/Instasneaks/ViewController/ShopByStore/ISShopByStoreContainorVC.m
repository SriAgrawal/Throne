//
//  ISShopByStoreContainorVC.m
//  Instasneaks
//
//  Created by Suresh patel on 12/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopByStoreContainorVC.h"

@interface ISShopByStoreContainorVC ()

@property(strong, nonatomic) NSMutableArray  * controllersArray;
@property(strong, nonatomic) ISShopByStoreHeaderView        * headerView;
@end
@implementation ISShopByStoreContainorVC

#pragma mark - Life cycle of View controller
- (void)viewDidLoad
{
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
#pragma mark - Memory Management warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup Method for the View
-(void)setUpPagerController{
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }

    self.controllersArray = [[NSMutableArray alloc] init];
    self.headerView = [ISShopByStoreHeaderView instantiateFromNib];
    ISFeaturedViewController * featuredVC = [[ISFeaturedViewController alloc] initWithNibName:@"ISFeaturedViewController" bundle:nil];
    featuredVC.categoryId = self.categoryId;
    ISDirectoryViewController * directoryVC = [[ISDirectoryViewController alloc] initWithNibName:@"ISDirectoryViewController" bundle:nil];
    [self.controllersArray addObject:featuredVC];
    [self.controllersArray addObject:directoryVC];
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    
    [self.headerView.button_left addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.button_right addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.lable_title.text = @"SHOP BY STORE";
    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeCenter;
    self.segmentedPager.parallaxHeader.height = 64;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    self.segmentedPager.controlHeight =44;
    self.segmentedPager.bounces = NO;
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:150/255.0f green:150/255.0f  blue:150/255.0f  alpha:1.0f], NSFontAttributeName: [UIFont fontWithName:@"NeoSansPro-Regular" size:16]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:48/255.0f green:48/255.0f  blue:48/255.0f  alpha:1.0f], NSFontAttributeName: [UIFont fontWithName:@"NeoSansPro-Regular" size:16]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:180/255.0f green:155/255.0f  blue:91/255.0f  alpha:1.0f];
    [self.segmentedPager reloadData];
}
#pragma mark - IBAction Method
-(void)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    ISAddToDropContainerVC * uploadVC = [[ISAddToDropContainerVC alloc] initWithNibName:@"ISAddToDropContainerVC" bundle:nil];
    [self.navigationController pushViewController:uploadVC animated:YES];
}
#pragma mark <MXSegmentedPagerDelegate>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager{
    return 2;
}
- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}
#pragma mark <MXPageControllerDataSource>
- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return @[@"Featured", @"Directory"][index];
}
- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index{
        return [self.controllersArray objectAtIndex:index];
}
@end
