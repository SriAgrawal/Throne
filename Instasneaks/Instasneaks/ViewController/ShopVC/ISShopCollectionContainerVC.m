//
//  ISShopCollectionContainerVC.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopCollectionContainerVC.h"

@interface ISShopCollectionContainerVC ()<sortVCDelegate>

@property(strong, nonatomic) NSMutableArray     * controllersArray;
@property (strong, nonatomic) ISShopCollectionHeaderView     * headerView;
@end

@implementation ISShopCollectionContainerVC

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
#pragma mark - Memory Mangement Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup Method for the pagerController
-(void)setUpPagerController
{
    self.controllersArray = [[NSMutableArray alloc] init];
    self.headerView = [ISShopCollectionHeaderView instantiateFromNib];
    ISShopViewController * addToDropContainer = [[ISShopViewController alloc] initWithNibName:@"ISShopViewController" bundle:nil];
    [self.controllersArray addObject:addToDropContainer];
    self.segmentedPager.backgroundColor = [UIColor whiteColor];
    
    [self.headerView.burtton_back addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_done addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_short addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_size addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_condition addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_brand addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.burtton_color addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.segmentedPager.parallaxHeader.view = self.headerView;
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeBottom;
    self.segmentedPager.parallaxHeader.height = 114;
    self.segmentedPager.parallaxHeader.minimumHeight = 20;
    self.segmentedPager.controlHeight = 0;
    self.segmentedPager.bounces = NO;
    [self.segmentedPager reloadData];
}
#pragma mark - IBAction Method
-(void)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commonButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSDictionary * dict;
    switch (sender.tag)
    {
        case 100:
        {
            _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"buttonTag", nil];
        }
            break;
        case 101:
        {
            if (sender.selected == NO)
            {
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                sender.selected = YES;
            }
            else
            {
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                sender.selected = NO;
            }
            dict = [NSDictionary dictionaryWithObjectsAndKeys:@"101", @"buttonTag", nil];
        }
            break;
        case 102:
        {
            
            if (sender.selected == NO)
            {
                sender.selected = YES;
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            }
            else
            {
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                sender.selected = NO;
            }
            dict = [NSDictionary dictionaryWithObjectsAndKeys:@"102", @"buttonTag", nil];
        }
            break;
        case 103:
        {
            if (sender.selected == NO)
            {
                sender.selected = YES;
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            }
            else
            {
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                sender.selected = NO;
            }
            dict = [NSDictionary dictionaryWithObjectsAndKeys:@"103", @"buttonTag", nil];
        }
            break;
        case 104:
        {
            if (sender.selected == NO)
            {
                sender.selected = YES;
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            }
            else
            {
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                sender.selected = NO;
            }
            dict = [NSDictionary dictionaryWithObjectsAndKeys:@"104", @"buttonTag", nil];
        }
            break;
        case 106:
        {
            if (sender.selected == NO)
            {
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                sender.selected = YES;
            }
            else
            {
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                sender.selected = NO;
            }
            dict = [NSDictionary dictionaryWithObjectsAndKeys:@"106", @"buttonTag", nil];
        }
            break;
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FireNotificationToShowSizeTable" object:dict];
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
