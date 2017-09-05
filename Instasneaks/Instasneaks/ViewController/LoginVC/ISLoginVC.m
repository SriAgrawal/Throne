//
//  ISLoginVC.m
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISLoginVC.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ISLoginVC ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton           * button_twitter;
@property (weak, nonatomic) IBOutlet UIButton           * button_facebook;
@property(strong, nonatomic) UIAlertAction              * okAction;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet UIView           * videoContainerView;
@end

@implementation ISLoginVC

#pragma mark -View Life cycle methods.
- (void)viewDidLoad {
    [super viewDidLoad];
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
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Action Method

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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


-(void)methodToShowPopupWithTextField:(NSMutableDictionary *)param{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter email address." preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *alertRef = controller;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    self.okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
        [param setValue:text forKey:kEmail];
        [self makeApiCallToLoginUserWithInfo:param andProvider:@"twitter"];
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

- (IBAction)facebookLoginAction:(id)sender {
    
    [self.view endEditing:YES];
    [[FacebookLogin sharedManager] getFacebookInfoWithCompletionHandler:self completionBlock:^(NSDictionary *dict, NSString *error)
    {
        if (dict == nil)
            [self showErrorAlertWithTitle:error];
        else
        [self makeApiCallToLoginUserWithInfo:dict andProvider:@"facebook"];
    }];
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

-(void)makeApiCallToLoginUserWithInfo:(NSDictionary *)dict andProvider:(NSString *)provider{
    
    NSMutableDictionary * deviceParam = [[NSMutableDictionary alloc] init];
    [deviceParam setValue:[USERDEFAULT valueForKey:kDevice_Token] forKey:kDevice_Token];
    [deviceParam setValue:@"ios" forKey:kDevice_Type];
    [deviceParam setValue:provider forKey:kProvider];
    [deviceParam setValue:dict[@"id"] forKey:kUID];
    [deviceParam setValue:dict[kEmail] forKey:kEmail];
    [deviceParam setValue:[USERDEFAULT valueForKey:kLatitude] forKey:kLatitude];
    [deviceParam setValue:[USERDEFAULT valueForKey:kLongitude] forKey:kLongitude];


    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:deviceParam forKey:kUser];
    [[ISServiceHelper helper] request:param apiName:kApiSocial_Sign_in method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
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
