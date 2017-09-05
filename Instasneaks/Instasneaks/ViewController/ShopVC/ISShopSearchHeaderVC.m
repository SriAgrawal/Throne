//
//  ISShopSearchHeaderVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 14/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopSearchHeaderVC.h"
#import "Header.h"

@interface ISShopSearchHeaderVC ()<CarbonTabSwipeNavigationDelegate>
@property (strong, nonatomic) CarbonTabSwipeNavigation *pageVC;
@property (strong, nonatomic) NSArray *arrayItems;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (assign, nonatomic) NSInteger     index;
@end

@implementation ISShopSearchHeaderVC
#pragma mark - Life Cylce of View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}
#pragma mark -Memory Mangement Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup Method of View Controller
-(void)initialSetup
{
    self.arrayItems =  [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    self.pageVC = [[CarbonTabSwipeNavigation alloc]initWithItems:self.arrayItems delegate:self];
    //[self.pageVC insertIntoRootViewController:self];
    
    [self.pageVC.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];
    
    // set up page style
    
    [self.pageVC setTabExtraWidth:0];
    [self.pageVC setTabBarHeight:48];
    
    for (int i=0; i<_arrayItems.count; i++)
    {
        [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/8
         
                                   forSegmentAtIndex:i];
    }
    // Custimize segmented control
    
    [self.pageVC setNormalColor:[UIColor colorWithRed:150/255.0f green:150/255.0f  blue:150/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 13 : 15)];
    [self.pageVC setSelectedColor:[UIColor colorWithRed:48/255.0f green:48/255.0f  blue:48/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 13 : 15)];
    [self.pageVC setIndicatorColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f  blue:255.0f/255.0f  alpha:1.0f]];
    [self.pageVC setIndicatorHeight:1];
    [self.pageVC setCurrentTabIndex:self.index withAnimation:NO];
}
#pragma mark - UIButton Actions
- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbontTabSwipeNavigation viewControllerAtIndex:(NSUInteger)index
{
    ISShopSearchVC *lockerVC = [[ISShopSearchVC alloc] initWithNibName:@"ISShopSearchVC" bundle:nil];
    lockerVC.alphabet = [self.arrayItems objectAtIndex:index];
    lockerVC.categoryId = self.categoryId;
    return lockerVC;
}
- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}
@end
