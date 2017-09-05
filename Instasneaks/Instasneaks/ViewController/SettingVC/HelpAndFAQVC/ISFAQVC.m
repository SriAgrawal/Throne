//
//  ISFAQVC.m
//  Instasneaks
//
//  Created by Suresh patel on 22/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISFAQVC.h"

static NSString *CellIdentifier = @"faqCell";

@interface ISFAQVC ()<UITableViewDelegate, UITableViewDelegate>{

    ISUserInfo *info;

}

@property (weak, nonatomic) IBOutlet UITableView        * tableView_faq;

@property (strong, nonatomic) NSMutableArray        * faqDataArray;

@end

@implementation ISFAQVC

- (void)viewDidLoad {
    [super viewDidLoad];
    info = [[ISUserInfo alloc]init];
    [self apiCallForFAQ];
    [self initialMethod];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methods

-(void)initialMethod{
  
    [self.tableView_faq registerNib:[UINib nibWithNibName:@"ISFAQCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.tableView_faq.estimatedRowHeight = 44.0;
    self.tableView_faq.rowHeight = UITableViewAutomaticDimension;
    //self.faqDataArray = [NSMutableArray arrayWithObjects:faqInfoFirst, faqInfo, nil];
}

#pragma mark - UIButton Actions

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ISFAQCell *cell = (ISFAQCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.row) {
        case 0:
            cell.label_title.text = @"What is THRONE?" ;
            cell.label_detail.attributedText = [self methodToAddSpaceBetweenText:(info.contentFaq == nil)?@"":info.contentFaq] ;
            break;
        case 1:
            cell.label_title.text = @"Now does It works?" ;
            cell.label_detail.attributedText = [self methodToAddSpaceBetweenText:(info.contentFaq == nil)?@"":info.contentFaq] ;
            break;

        default:
            break;
    }
    

    return cell;
}

-(NSMutableAttributedString *)methodToAddSpaceBetweenText:(NSString *)string{
 
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return  attributedString;
}
#pragma mark-FAQ Servoce Api
-(void)apiCallForFAQ
{
     NSString *apiName = [NSString stringWithFormat:@"%@/3",kApiFaq];
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if ([[resultDict objectForKey:kCode] integerValue] == 200)
                            {
                               
                                [self parseData:resultDict];
                                [self.tableView_faq reloadData];
                            }
                          
                        
                        });
     }];
    
}
-(void)parseData:(NSDictionary *)result{

    NSMutableDictionary *faqInfo = [result objectForKeyNotNull:@"static_page" expectedObj:[NSMutableDictionary dictionary]];
    
        [info setContentFaq:[faqInfo objectForKeyNotNull:@"content" expectedObj:@""]];


}
@end
