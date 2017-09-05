//
//  ISShopByStore.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopByStore.h"
#import "CarbonTabSwipeNavigation.h"
#import "ISDirectoryViewController.h"
#import "ISFeaturedViewController.h"
@interface ISShopByStore ()<CarbonTabSwipeNavigationDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView * view_topBar;
@property (strong, nonatomic) IBOutlet UILabel * label_seperator;
@property (assign, nonatomic) CGFloat previousScrollViewYOffset;

@property (strong, nonatomic) CarbonTabSwipeNavigation *pageVC;
@property (strong, nonatomic) NSArray *arrayItems;

@end

@implementation ISShopByStore

#pragma mark- Life cycle of View Controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetup];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark- Setup Method for View Controller
-(void)initialSetup
{
    self.arrayItems = @[@"Featured", @"Directory"];
    
    self.pageVC = [[CarbonTabSwipeNavigation alloc]initWithItems:self.arrayItems delegate:self];
    //[self.pageVC insertIntoRootViewController:self];
    
    [self.pageVC.view setFrame:self.contentView.bounds];
    [self.contentView addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];
    
    // set up page style
    
    [self.pageVC setTabExtraWidth:0];
    [self.pageVC setTabBarHeight:48];
    
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:0];
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:1];
    // Custimize segmented control
    
    [self.pageVC setNormalColor:[UIColor colorWithRed:150/255.0f green:150/255.0f  blue:150/255.0f  alpha:1.0f] font:[UIFont fontWithName:@"NeoSansPro-Regular" size:16]];
    [self.pageVC setSelectedColor:[UIColor colorWithRed:48/255.0f green:48/255.0f  blue:48/255.0f  alpha:1.0f]];
    [self.pageVC setIndicatorColor:[UIColor brownColor]];
    [self.pageVC setIndicatorHeight:4];
    [self.pageVC setCurrentTabIndex:self.index withAnimation:NO];
}
#pragma mark - Memory Management Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIButton Actions
- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbontTabSwipeNavigation viewControllerAtIndex:(NSUInteger)index {
    switch (index)
    {
    case 0:
        {
            ISFeaturedViewController *lockerVC = [[ISFeaturedViewController alloc] initWithNibName:@"ISFeaturedViewController" bundle:nil];
            //lockerVC.isUserId = self.idInfo;
            return lockerVC;
        }
    case 1:
        {
            ISDirectoryViewController *itemsVC= [[ISDirectoryViewController alloc] initWithNibName:@"ISDirectoryViewController" bundle:nil];
            // itemsVC.isUserId = self.idInfo;
            return itemsVC;
        }
    default:
        {
            return nil;
        }
    }
}
- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}
@end
