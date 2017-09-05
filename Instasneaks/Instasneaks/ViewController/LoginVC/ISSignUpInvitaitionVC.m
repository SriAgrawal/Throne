//
//  ISSignUpInvitaitionVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 04/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISSignUpInvitaitionVC.h"
#import "Header.h"

@interface ISSignUpInvitaitionVC ()<UITextFieldDelegate>
@property(strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogin;
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *inviteOfferLbl;

@end

@implementation ISSignUpInvitaitionVC

#pragma mark- Life cycle of View Controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetUp];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Helper method of View Controller
-(void)initialSetUp
{

    [self.navigationController setNavigationBarHidden:YES];
    self.buttonLogin.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.buttonLogin.titleLabel.numberOfLines = 2;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Already have account\nSIGN IN here"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
    [attributedString addAttributes:dict range:NSMakeRange(0, [@"Already have account\nSIGN IN here" length])];
    [self.buttonLogin setAttributedTitle:attributedString forState:UIControlStateNormal];
    self.buttonLogin.titleLabel.textColor = [UIColor whiteColor];
    
    NSLog(@"%lu",(unsigned long)@"Create an account and receive $10 in".length);
    
    NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Create an account and receive $%d in",10]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:233/255.0f green:193/255.0f blue:93/255.0f alpha:1.0f] range:NSMakeRange(30,3)];
    _inviteOfferLbl.attributedText = coloredText;
    
}

#pragma mark - Button Action Method

- (IBAction)twitterLoginAction:(id)sender {
    
    [self.view endEditing:YES];
    [self methodToShowPopupWithTextField];
    //    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
    //        if (session) {
    //            [APPDELEGATE navigateToHome];
    //            NSLog(@"signed in as %@", [session userName]);
    //        } else {
    //            NSLog(@"error: %@", [error localizedDescription]);
    //        }
    //    }];
}

- (IBAction)facebookLoginAction:(id)sender {
    
    [self.view endEditing:YES];
    [[FacebookLogin sharedManager] getFacebookInfoWithCompletionHandler:self completionBlock:^(NSDictionary *dict, NSString *error) {
        NSLog(@"UserInfo ---- %@", dict);
        [APPDELEGATE navigateToHome];
    }];
}

- (IBAction)alreadyHaveAnAccountAction:(id)sender {
    
    [self.view endEditing:YES];
    ISLoginVC * loginVC = [[ISLoginVC alloc] initWithNibName:@"ISLoginVC" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)methodToShowPopupWithTextField{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter email address." preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *alertRef = controller;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    self.okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
        [APPDELEGATE navigateToHome];
        NSLog(@"Email Address -- %@", text);
    }];
    self.okAction.enabled = NO;
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
        [textField setReturnKeyType:UIReturnKeyDone];
    }];
    [controller addAction:self.okAction];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Validation Methods

-(BOOL)isValidEmail: (NSString *)checkString{
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *emailRegex =  stricterFilterString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - UITextField Delegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.okAction setEnabled:[self isValidEmail:finalString]];
    return YES;
}

#pragma mark - Web Service Method For Login

-(void)makeApiCallToLoginUser{
    
}

@end
