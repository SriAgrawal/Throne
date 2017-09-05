//
//  ISSignupVC.m
//  Instasneaks
//
//  Created by Suresh patel on 03/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISSignupVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ISSignupVC ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton           * button_login;
@property(strong, nonatomic) UIAlertAction              * okAction;
@property (weak, nonatomic) IBOutlet UIView           * videoContainerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;

@end

@implementation ISSignupVC

#pragma mark -View Life cycle methods.

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"login %d",[USERDEFAULT boolForKey:kIsLoggedIn]);
    if ([USERDEFAULT boolForKey:kIsLoggedIn])
    {
        [APPDELEGATE navigateToHome];
    }
 
    self.logoTopConstraint.constant = (WIN_WIDTH == 375 || WIN_WIDTH > 375)?100:50;
    //[self playingMPPlayerWithVideo:@"THRONE"];
    [self initialSetup];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Helper Method

-(void)initialSetup
{
    [self.navigationController setNavigationBarHidden:YES];
    
    self.button_login.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.button_login.titleLabel.numberOfLines = 2;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Already have account\nSIGN IN here"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
    [attributedString addAttributes:dict range:NSMakeRange(0, [@"Already have account\nSIGN IN here" length])];
    [self.button_login setAttributedTitle:attributedString forState:UIControlStateNormal];
    self.button_login.titleLabel.textColor = [UIColor whiteColor];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action Method

- (IBAction)twitterLoginAction:(id)sender {
    
    [self.view endEditing:YES];
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            
            NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
            TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userID];
            [client loadUserWithID:userID completion:^(TWTRUser *user, NSError *error) {
                NSMutableDictionary * deviceParam = [[NSMutableDictionary alloc] init];
                [deviceParam setValue:session.userID forKey:@"id"];
                [deviceParam setValue:user.profileImageLargeURL forKey:kImage];
                [deviceParam setValue:user.name forKey:@"name"];

                [self methodToShowPopupWithTextField:deviceParam];
                NSLog(@"signed in as %@", [session userName]);

                NSLog(@"Profile image url = %@", user.profileImageLargeURL);
            }];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}

- (IBAction)facebookLoginAction:(id)sender {
    
    [self.view endEditing:YES];
    [[FacebookLogin sharedManager] getFacebookInfoWithCompletionHandler:self completionBlock:^(NSDictionary *dict, NSString *error) {
        NSLog(@"UserInfo ---- %@", dict);
        if (dict == nil)
            [self showErrorAlertWithTitle:error];
        else
        [self makeApiCallToRegisterUserWithInfo:dict andProvider:@"facebook"];
    }];
}

- (IBAction)alreadyHaveAnAccountAction:(id)sender {
    
    [self.view endEditing:YES];
    ISLoginVC * loginVC = [[ISLoginVC alloc] initWithNibName:@"ISLoginVC" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)methodToShowPopupWithTextField:(NSMutableDictionary *)param{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter email address." preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *alertRef = controller;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    self.okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
        [param setValue:text forKey:kEmail];
        [self makeApiCallToRegisterUserWithInfo:param andProvider:@"twitter"];
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

#pragma mark - Web Service Method For Signup

-(void)makeApiCallToRegisterUserWithInfo:(NSDictionary *)dict andProvider:(NSString *)provider{
    
    NSMutableDictionary * userParam = [[NSMutableDictionary alloc] init];
    [userParam setValue:[USERDEFAULT valueForKey:kLatitude] forKey:kLatitude];
    [userParam setValue:[USERDEFAULT valueForKey:kLongitude] forKey:kLongitude];
    [userParam setValue:dict[kEmail] forKey:kEmail];
    [userParam setValue:dict[@"name"] forKey:@"full_name"];
    [userParam setValue:@"" forKey:@"referrer"];
    [userParam setValue:@"0" forKey:kRole];
    NSMutableDictionary * devicesParam = [[NSMutableDictionary alloc] init];
    [devicesParam setValue:[USERDEFAULT valueForKey:kDevice_Token] forKey:kDevice_Token];
    [devicesParam setValue:@"ios" forKey:kDevice_Type];
    [userParam setValue:[NSMutableArray arrayWithObject:devicesParam] forKey:kDevices_Attributes];

    NSMutableDictionary * identitiesParam = [[NSMutableDictionary alloc] init];
    [identitiesParam setValue:provider forKey:kProvider];
    [identitiesParam setValue:dict[@"id"] forKey:kUID];
    [identitiesParam setValue:[[[dict objectForKeyNotNull:@"picture" expectedObj:[NSDictionary dictionary]] objectForKeyNotNull:@"data" expectedObj:[NSDictionary dictionary]] objectForKeyNotNull:@"url" expectedObj:[NSDictionary dictionary]] forKey:@"profile_url"];
    
    if ([provider isEqualToString:@"twitter"]) {
        [identitiesParam setValue:[dict objectForKeyNotNull:kImage expectedObj:@""] forKey:@"profile_url"];
    }
    [userParam setValue:[NSMutableArray arrayWithObject:identitiesParam] forKey:kIdentities_Attributes];

    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:userParam forKey:kUser];
    [[ISServiceHelper helper] request:param apiName:kApiUsers method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[resultDict objectForKey:kCode]integerValue] != 200)
            {
                [self showErrorAlertWithTitle:[resultDict objectForKey:kMessage]];
            }
            else
            {
                [USERDEFAULT setValue:[[resultDict objectForKeyNotNull:kUser] objectForKeyNotNull:kUserId expectedObj:@""] forKey:kUserId];
                [USERDEFAULT setValue:[[resultDict objectForKeyNotNull:kUser] objectForKeyNotNull:kAuthentication_Token expectedObj:@""] forKey:kAuthentication_Token];
                [USERDEFAULT setValue:[[resultDict objectForKeyNotNull:kUser] objectForKeyNotNull:kEmail expectedObj:@""] forKey:kEmail];
                [USERDEFAULT setBool:YES forKey:kIsLoggedIn];
                [USERDEFAULT synchronize];
                [APPDELEGATE navigateToHome];
            }
        });
    }];
    
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error
                                 andButtonsWithTitle:@[@"OK"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                       }];
}

@end
