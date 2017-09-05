//
//  ISPrivacyPolicyVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISPrivacyPolicyVC.h"
#import "Header.h"
@interface ISPrivacyPolicyVC (){

    ISUserInfo *info ;

}
@property (strong, nonatomic) IBOutlet UITextView *textView_Content;

@end

@implementation ISPrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    info = [[ISUserInfo alloc]init];
    [self apiCallForPrivacyPolicy];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - webservice for Privacy
-(void)apiCallForPrivacyPolicy
{
    NSString *apiName = [NSString stringWithFormat:@"%@/1",kApiFaq];
[[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if ([[resultDict objectForKey:kCode] integerValue] == 200)
                                [self parseData:resultDict];
                            
                        });
     }];
    
}
-(void)parseData:(NSDictionary *)result{
    
    NSMutableDictionary *faqInfo = [result objectForKeyNotNull:@"static_page" expectedObj:[NSMutableDictionary dictionary]];
    
    [info setContentFaq:[faqInfo objectForKeyNotNull:@"content" expectedObj:@""]];
    self.textView_Content.text =info.contentFaq;
    
}
@end
