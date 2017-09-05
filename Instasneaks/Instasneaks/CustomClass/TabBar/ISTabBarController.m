//
//  ISTabBarController.m
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISTabBarController.h"

@interface ISTabBarController ()

@end

@implementation ISTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomTabBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createCustomTabBar{
    
    ISCollectionsContainerVC *viewController1 = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
    ISBrandListContainerVC *viewController2 = [[ISBrandListContainerVC alloc] initWithNibName:@"ISBrandListContainerVC" bundle:nil];
    ISNewsFeedContainerVC *viewController3 = [[ISNewsFeedContainerVC alloc] initWithNibName:@"ISNewsFeedContainerVC" bundle:nil];
    ISProfileVC *viewController4 = [[ISProfileVC alloc] initWithNibName:@"ISProfileVC" bundle:nil];
    
    self.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, viewController3, viewController4, nil];
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    for(UITabBarItem * tabBarItem in tabBar.items){
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    
    UIImage *image1 = [UIImage imageNamed:@"ico_drop_off.png"];
    if ([image1 respondsToSelector:@selector(imageWithRenderingMode:)]){
        [tabBarItem1 setImage:[image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem2 setImage:[[UIImage imageNamed:@"ico_price_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem3 setImage:[[UIImage imageNamed:@"ico_news_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem4 setImage:[[UIImage imageNamed:@"ico_user_off.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"ico_drop_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"ico_price_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"ico_news_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"ico_user_on.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        
    } else {
        [tabBarItem1 setImage:image1];
        [tabBarItem2 setImage:[UIImage imageNamed:@"ico_price_off.png"]];
        [tabBarItem3 setImage:[UIImage imageNamed:@"ico_news_off.png"]];
        [tabBarItem4 setImage:[UIImage imageNamed:@"ico_user_off.png"]];
        [tabBarItem1 setSelectedImage:[UIImage imageNamed:@"ico_drop_on.png"]];
        [tabBarItem2 setSelectedImage:[UIImage imageNamed:@"ico_price_on.png"]];
        [tabBarItem3 setSelectedImage:[UIImage imageNamed:@"ico_news_on.png"]];
        [tabBarItem4 setSelectedImage:[UIImage imageNamed:@"ico_user_on.png"]];
    }
    [tabBar setBackgroundColor:[UIColor whiteColor]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
