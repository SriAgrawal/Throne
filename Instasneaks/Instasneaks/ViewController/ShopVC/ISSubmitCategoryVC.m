//
//  ISSubmitCategoryVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 13/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISSubmitCategoryVC.h"

@interface ISSubmitCategoryVC ()<UITextFieldDelegate>
{
    ISUserInfo *objModal;
}
@property (strong, nonatomic) IBOutlet UITableView *submitTableView;
@end

@implementation ISSubmitCategoryVC

#pragma mark - Life cycle of View controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    objModal = [[ISUserInfo alloc] init];
    [self.submitTableView registerNib:[UINib nibWithNibName:@"ISSellerTableCell" bundle:nil] forCellReuseIdentifier:@"ISSellerTableCell"];
}
#pragma mark - Memory Management Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableview Delegate and datasourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISSellerTableCell *cell = (ISSellerTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ISSellerTableCell"];
    UIColor *color = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1.0f];
    cell.sellerTextField.delegate = self;
    cell.sellerTextField.returnKeyType = UIReturnKeyDone;
    cell.sellerTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"What items would you like to see on THRONE?" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:NEO_SANS_PRO_REGULAR(12)}];
    return cell;
}
#pragma mark-Text Field Delegates
- (void)textFieldDidEndEditing:(PATextField *)textField
{
    [self.view layoutIfNeeded];
  objModal.string_ItemType = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - UIButton Action Method
- (IBAction)submitAction:(id)sender
{
    [self.view endEditing:YES];
    if (![TRIM_SPACE(objModal.string_ItemType) length])
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please enter item type" andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle)
         {
         }];
    }
    else
    {
        [self callSubmitCategoryApi];
    }
}
- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}

#pragma mark- Web Service for Submit category
-(void)callSubmitCategoryApi
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *categoryParam = [[NSMutableDictionary alloc] init];
    [categoryParam setValue:objModal.string_ItemType forKey:@"name"];
    [param setValue:categoryParam forKey:@"category"];
    [[ISServiceHelper helper] request:nil apiName:@"categories" method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self showErrorAlertWithTitle:([[resultDict objectForKey:kCode]integerValue] == 200)?[resultDict objectForKey:kMessage]:[resultDict objectForKey:kMessage]];
         });
     }];
}
#pragma mark - Alert View Warning Method
-(void)showErrorAlertWithTitle:(NSString*)error
{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle)
    {
        ISThankYouItemVC *thank = [[ISThankYouItemVC alloc] initWithNibName:@"ISThankYouItemVC" bundle:nil];
        thank.isFromSubmitCategory = YES;
        [self.navigationController pushViewController:thank animated:YES];
    }];
}
@end
