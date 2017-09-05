//
//  ISAddToDropContainerVC.m
//  Instasneaks
//
//  Created by Suresh patel on 12/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISAddToDropContainerVC.h"

@interface ISAddToDropContainerVC ()<sortVCDelegate,UISearchBarDelegate,uploadListVCDelegate>

@property(strong, nonatomic) NSMutableArray     * controllersArray;

@property (strong, nonatomic) ISAddToDropHeaderView     * headerView;

@end

@implementation ISAddToDropContainerVC

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
    self.headerView = [ISAddToDropHeaderView instantiateFromNib];
    ISAddToDropViewController * addToDropContainer = [[ISAddToDropViewController alloc] initWithNibName:@"ISAddToDropViewController" bundle:nil];
    [addToDropContainer setHeaderView: self.headerView];
    [self.controllersArray addObject:addToDropContainer];
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
   
    self.headerView.searchBar.delegate = self;
    [self.headerView.burtton_back addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeCenter;
    self.segmentedPager.parallaxHeader.height = 110;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
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

#pragma mark - UISearchBar Delegate Methods


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{

    
}
-(void)searchProductWithText:(NSString *)text
{
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
     ISUploadListVC *uploadVC = [[ISUploadListVC alloc]initWithNibName:@"ISUploadListVC" bundle:nil];
    uploadVC.delegate = self;
    uploadVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    uploadVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.navigationController presentViewController:uploadVC
                                            animated:YES
                                          completion:nil];
    return NO;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
-(void)didSearchSelectData:(NSString*)strId
{
    ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
    [storeVC setIsForItemDetail:YES];
    [storeVC setItemId:[NSString stringWithFormat:@"%@",strId]];
    [self.navigationController pushViewController:storeVC animated:YES];

}
-(void)searchSelectData:(NSString*)strText CategoryArray:(NSMutableArray *)categoryArray
{
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:categoryArray];
    NSArray *arrayUnqiueCategory = [orderedSet array];
    ISBrandDetailContainerVC *storeVC = [[ISBrandDetailContainerVC alloc] initWithNibName:@"ISBrandDetailContainerVC" bundle:nil];
    storeVC.isFromSeacrh = YES;
    storeVC.categoryArrayId = (NSMutableArray*)arrayUnqiueCategory;
    [storeVC setBrandName:TRIM_SPACE(strText)];
    [self.navigationController pushViewController:storeVC animated:YES];
}
#pragma mark - IBAction Method
-(void)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
