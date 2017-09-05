//
//  ISDetailContainerVC.m
//  Instasneaks
//
//  Created by Suresh patel on 19/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISDetailContainerVC.h"

@interface ISDetailContainerVC ()

@property(strong, nonatomic) NSMutableArray                     * controllersArray;
@property(strong, nonatomic) ISDetailHeaderView                 * headerView;

@end

@implementation ISDetailContainerVC

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

-(void)setUpPagerController{
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
    
    self.controllersArray = [[NSMutableArray alloc] init];
   
    ISStoreDetailVC * detailVC = [[ISStoreDetailVC alloc] initWithNibName:@"ISStoreDetailVC" bundle:nil];
    detailVC.storeId = _storeId;
    detailVC.isMyStore = self.isMyStore;
    [self.controllersArray addObject:detailVC];
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
     self.headerView = [ISDetailHeaderView instantiateFromNib];
    [self.headerView.button_left addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.lable_title.text = @"STORE DETAILS";
    self.headerView.label_itemsCount.attributedText = [self getAttributrdTextForItemCount:@"27"];
    detailVC.headerView = self.headerView;
    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeCenter;
    self.segmentedPager.parallaxHeader.height = 390;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    self.segmentedPager.controlHeight = 44;
    self.segmentedPager.bounces = NO;
    // Segmented Control customization
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedPager.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:150/255.0f green:150/255.0f  blue:150/255.0f  alpha:1.0f], NSFontAttributeName: [UIFont fontWithName:@"NeoSansPro-Regular" size:16]};
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:48/255.0f green:48/255.0f  blue:48/255.0f  alpha:1.0f], NSFontAttributeName: [UIFont fontWithName:@"NeoSansPro-Regular" size:16]};
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:200.0/255.0f green:200.0/255.0f  blue:200.0/255.0f  alpha:1.0f];
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 2.0f;
    [self.segmentedPager reloadData];
}

-(NSMutableAttributedString *)getAttributrdTextForItemCount:(NSString *)string{
    
    NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ITEMS %@", string]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(6, string.length)];
    return coloredText;
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
    return 1;
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didSelectViewWithTitle:(NSString *)title {
    NSLog(@"%@ page selected.", title);
}
#pragma mark <MXPageControllerDataSource>

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index {
    return ([self.isMyStore isEqualToString:@"Mine"])?@[@"MY ITEMS"][index]:@[@"ITEMS FOR SELL"][index];
}
- (UIViewController *)segmentedPager:(MXSegmentedPager *)segmentedPager viewControllerForPageAtIndex:(NSInteger)index{
    
    return [self.controllersArray objectAtIndex:index];
}
@end
