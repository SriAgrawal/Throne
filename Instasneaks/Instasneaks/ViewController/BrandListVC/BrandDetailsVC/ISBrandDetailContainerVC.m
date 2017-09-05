//
//  ISBrandDetailContainerVC.m
//  Instasneaks
//
//  Created by Suresh patel on 13/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISBrandDetailContainerVC.h"

@interface ISBrandDetailContainerVC ()

@property(strong, nonatomic) NSMutableArray     * controllersArray;



@end

@implementation ISBrandDetailContainerVC

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
    self.headerView = [ISBrandDetailHeaderView instantiateFromNib];

    if (self.isFromSeacrh == YES)
    {
        self.headerView.label_header.text = self.brandName;
        HappyViewController * brandDetailContainer = [[HappyViewController alloc] initWithNibName:@"HappyViewController" bundle:nil];
        [brandDetailContainer setHeaderView: self.headerView];
        [brandDetailContainer setSearchString:self.brandName];
        brandDetailContainer.categoryArrayId = self.categoryArrayId;
        [self.controllersArray addObject:brandDetailContainer];
    }
    else
    {
        self.headerView.label_header.text = self.brandName;
        ISBrandDetailsVC * brandDetailContainer = [[ISBrandDetailsVC alloc] initWithNibName:@"ISBrandDetailsVC" bundle:nil];
        brandDetailContainer.categoryId = self.categoryId;
        [brandDetailContainer setHeaderView: self.headerView];
        [brandDetailContainer setBrandName:self.brandName];
        brandDetailContainer.brandType = self.brandType;
        [self.controllersArray addObject:brandDetailContainer];
    }
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    
    [self.headerView.burtton_back addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.headerView.burtton_search addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headerView.burtton_short addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_size addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_condition addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_brand addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_color addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.button_gender addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeCenter;
    self.segmentedPager.parallaxHeader.height = 114;
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

#pragma mark - IBAction Method

-(void)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchBtnAction:(id)sender
{
    ISAddToDropContainerVC * uploadVC = [[ISAddToDropContainerVC alloc] initWithNibName:@"ISAddToDropContainerVC" bundle:nil];
    [self.navigationController pushViewController:uploadVC animated:YES];

}
- (void)commonButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSDictionary * dict;
    switch (sender.tag)
    {
        case 100:
        {
            sender.selected = !sender.selected;
            dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"100" forKey:@"buttonTag"];
            [dict setValue:(sender.selected == NO ? @"NO":@"YES")forKey:@"select"];
            
        }
            break;
        case 101:
        {
            sender.selected = !sender.selected;
            dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"101" forKey:@"buttonTag"];
            [dict setValue:(sender.selected == NO ? @"YES":@"NO")forKey:@"select"];
        }
            break;
        case 102:
        {
            sender.selected = !sender.selected;
            dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"102" forKey:@"buttonTag"];
            [dict setValue:(sender.selected == NO ? @"YES":@"NO")forKey:@"select"];
        }
            break;
        case 103:
        {
            sender.selected = !sender.selected;
            dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"103" forKey:@"buttonTag"];
           [dict setValue:(sender.selected == NO ? @"YES":@"NO")forKey:@"select"];
        }
            break;
        case 104:
        {
            sender.selected = !sender.selected;
            dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"104" forKey:@"buttonTag"];
            [dict setValue:(sender.selected == NO ? @"YES":@"NO")forKey:@"select"];
        }
            break;
        case 105:
        {
            sender.selected = !sender.selected;
            dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"105" forKey:@"buttonTag"];
            [dict setValue:(sender.selected == NO ? @"YES":@"NO")forKey:@"select"];
        }
            break;
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FireNotificationToSelectSizeTable" object:dict];
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
