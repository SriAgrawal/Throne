//
//  ISHelpVC.m
//  Instasneaks
//
//  Created by Suresh patel on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISHelpVC.h"
#import "Header.h"
@interface ISHelpVC ()<UITextViewDelegate>{
   
    ISUserInfo *info ;

}

@property (weak, nonatomic) IBOutlet PlaceholderTextView     * textView_help;

@end

@implementation ISHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod{
    info = [[ISUserInfo alloc]init];
    NSString *textViewText = @"";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textViewText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    NSDictionary *dict = @{NSParagraphStyleAttributeName : paragraphStyle };
    [attributedString addAttributes:dict range:NSMakeRange(0, [textViewText length])];
    self.textView_help.attributedText = attributedString ;

}
#pragma mark - UIButton Actions

- (IBAction)backButtonAction:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if ( info.string_Comment.length == 0)
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter some comment" andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            
        }];
    }
    else
    {
          [self apiCallForHelp];
    }
}

#pragma mark - UITextView Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{

    info.string_Comment = textView.text;
}

#pragma mark - webservice for Privacy
-(void)apiCallForHelp
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:info.string_Comment forKey:@"content"];
    [[ISServiceHelper helper] request:dict apiName:kApiHelp method:POST completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if ([[resultDict objectForKey:kCode] integerValue] == 200)
                                [self showErrorAlertWithTitle:[resultDict valueForKey:kMessage]];
                        });
     }];
    
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        [self.navigationController popViewControllerAnimated:YES];
        
    
    }];
}

@end
