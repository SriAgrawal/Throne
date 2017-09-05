//
//  ISNewsFeedContainerVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 03/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISNewsFeedContainerVC.h"

@interface ISNewsFeedContainerVC ()

@property(strong, nonatomic) NSMutableArray     * controllersArray;

@property (strong, nonatomic) ISNewsHeaderView     * headerView;

@end

@implementation ISNewsFeedContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPagerController];
    // Do any additional setup after loading the view from its nib.
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
    self.headerView = [ISNewsHeaderView instantiateFromNib];
    ISNewsListVC * brandDetailContainer = [[ISNewsListVC alloc] initWithNibName:@"ISNewsListVC" bundle:nil];
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

@end
