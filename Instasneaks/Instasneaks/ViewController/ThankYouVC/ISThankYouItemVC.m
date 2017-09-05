//
//  ISThankYouItemVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 13/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISThankYouItemVC.h"

@interface ISThankYouItemVC ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageTopContraints;
@property (strong, nonatomic) IBOutlet UIImageView *thankYouImageView;
@property (strong, nonatomic) IBOutlet UILabel *thankYouMessageLbl;
@end

@implementation ISThankYouItemVC

#pragma mark- Life Cycle of View Controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageTopContraints.constant = (WIN_WIDTH == 320)?50.0f:150.0f ;
    
    if (self.isFromSubmitCategory == NO)
    {
        self.thankYouMessageLbl.text = @"We've received your request! We will be contacting you shortly.";
        self.thankYouImageView.image = [UIImage imageNamed:@"img_dropscollection"];
    }
}
#pragma mark- Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- UIButton Action Method
- (IBAction)greatBtnAction:(id)sender
{
    for (UIViewController *controller in  self.navigationController.viewControllers)
    {
        //Do not forget to import YourViewController.h
        if ([controller isKindOfClass:[ISTabBarController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}
@end