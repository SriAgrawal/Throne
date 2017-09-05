//
//  ISBrandListContainerVC.m
//  Instasneaks
//
//  Created by Suresh patel on 13/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISBrandListContainerVC.h"

@interface ISBrandListContainerVC ()

@property(strong, nonatomic) NSMutableArray     * controllersArray;
@property (strong, nonatomic) ISBrandListHeaderView     * headerView;

@end

@implementation ISBrandListContainerVC

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
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Shop opened"
         properties:@{ @"Background color": @"Moody red",
                       @"Shop opened": @"absolutetly"
                       }];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor whiteColor];
    }
    self.controllersArray = [[NSMutableArray alloc] init];
    self.headerView = [ISBrandListHeaderView instantiateFromNib];
    [self.headerView.button_search addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.button_wallet addTarget:self action:@selector(walletButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.label_title setText:@"SHOP"];
    [self.headerView.button_back setHidden:YES];
    ISShopViewController * brandDetailContainer = [[ISShopViewController alloc] initWithNibName:@"ISShopViewController" bundle:nil];
    [self.controllersArray addObject:brandDetailContainer];
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
    
    [self addSubmitBUtton];
}

-(void)addSubmitBUtton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(submitCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"SUBMIT A CATEGORY" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:29.0/255.0f green:29.0/255.0f blue:29.0/255.0f alpha:1.0]];
    button.frame = CGRectMake(10.0, WIN_HEIGHT-106, WIN_WIDTH-20, 50.0);
    [button.layer setCornerRadius:3];
    [self.view addSubview:button];
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
