//
//  ISLogoutPopUpVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 22/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISLogoutPopUpVC.h"
#import "Header.h"

@interface ISLogoutPopUpVC ()
@property (strong, nonatomic) IBOutlet UILabel *popTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *popUpMessageLbl;
@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation ISLogoutPopUpVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.popTitleLbl.text = self.popUpTitle;
    if ([self.popUpTitle isEqualToString:@"CONGRATULATIONS!"])
    {
        [self.cancelBtn setTitle:self.popUpCancleBtnTitle forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.cancelBtn.backgroundColor = [UIColor whiteColor];
        self.logoutBtn.hidden = YES;
        
    }
    self.popUpMessageLbl.text = self.popUpMessage;
    [self.cancelBtn setTitle:self.popUpCancleBtnTitle forState:UIControlStateNormal];
    [self.logoutBtn setTitle:self.popUpLogoutBtnTitle forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)acceptBtnAction:(UIButton *)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(logoutButtonClicked:)]) {
        [self.delegate logoutButtonClicked:self];
    }
}

- (IBAction)declineBtnAction:(UIButton *)sender
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

@end
