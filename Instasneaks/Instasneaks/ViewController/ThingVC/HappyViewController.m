//
//  HappyViewController.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 06/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "HappyViewController.h"

@interface HappyViewController ()<CarbonTabSwipeNavigationDelegate, ISHappyThingViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView * view_topBar;
@property (strong, nonatomic) IBOutlet UILabel * label_seperator;
@property (assign, nonatomic) CGFloat previousScrollViewYOffset;

@property (strong, nonatomic) CarbonTabSwipeNavigation *pageVC;
@property (strong, nonatomic) NSArray *arrayItems;
@end


@implementation HappyViewController
#pragma mark - Life Cylce of View Controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetup];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.view_topBarView setAlpha:1];
}
#pragma mark - Memory Management Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup Method of View Controller
-(void)initialSetup
{
    self.arrayItems = @[@"Items", @"Stores"];
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
    
    [self.pageVC setNormalColor:[UIColor colorWithRed:150/255.0f green:150/255.0f  blue:150/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 13 : 15)];
    [self.pageVC setSelectedColor:[UIColor colorWithRed:48/255.0f green:48/255.0f  blue:48/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 13 : 15)];
    [self.pageVC setIndicatorColor:[UIColor colorWithRed:180/255.0f green:155/255.0f  blue:91/255.0f  alpha:1.0f]];
    [self.pageVC setIndicatorHeight:4];
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
    ISHappyThingViewController *lockerVC = [[ISHappyThingViewController alloc] initWithNibName:@"ISHappyThingViewController" bundle:nil];
    lockerVC.segmentType = [_arrayItems objectAtIndex:index];
    lockerVC.categoryArrayId = self.categoryArrayId;
    [self.headerView setBackgroundColor:[UIColor redColor]];
    [lockerVC setHeaderView:self.headerView];
    //lockerVC.isUserId = self.idInfo;
    [lockerVC setDelegate:self];
    [lockerVC setSearchString:self.searchString];
    return lockerVC;
}
- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}
#pragma mark - Custom Delegate Method of DidSelect
-(void)didSelectItem:(NSString *)string atIndex:(NSUInteger)index{
    
    switch (index)
    {
        case 0:
            break;
        case 1:{
            self.headerView.sizeLbl.text = string;
        }
            break;
        case 2:
            _headerView.conditionLbl.text = string;
            
            break;
        case 3:
            _headerView.brandLbl.text = string;
            break;
        case 4:
            _headerView.colorLbl.text = string;
            
            break;
        case 5:
            _headerView.genderLbl.text = string;
            break;
        default:
            break;
    }
}
#pragma mark - UIScrollView Protocols Methods

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
@end
