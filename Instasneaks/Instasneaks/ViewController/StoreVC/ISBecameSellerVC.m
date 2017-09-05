//
//  ISBecameSellerVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 13/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISBecameSellerVC.h"

@interface ISBecameSellerVC ()<UITextFieldDelegate,kDropDownListViewDelegate>
{
    ISUserInfo *objModal;
    NSMutableArray *arrayList,*arrayListId,*dataSourceArray;
    NSArray *arrayOtherType;
    DropDownListView *dropObj;
    BOOL isOtherCategory;
}
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *becameSellerTableView;

@end

@implementation ISBecameSellerVC

#pragma mark- Life Cycle of view controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    objModal = [[ISUserInfo alloc] init];
    [self.becameSellerTableView registerNib:[UINib nibWithNibName:@"ISSellerTableCell" bundle:nil] forCellReuseIdentifier:@"ISSellerTableCell"];
    arrayListId = [[NSMutableArray alloc]init];
    arrayList = [[NSMutableArray alloc]init];
    dataSourceArray = [[NSMutableArray alloc]init];
    arrayOtherType = [[NSArray alloc]init];
    [self makeAPIForCategory];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableview Delegate and datasourse

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (isOtherCategory == YES)?7:6;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISSellerTableCell *cell = (ISSellerTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ISSellerTableCell"];
    cell.sellerTextField.tag = indexPath.row + 100;
    cell.sellerTextField.delegate = self;
    if (indexPath.row == 0)
    {
        UIColor *color = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1.0f];
        cell.sellerTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"What type of items do you sell?" attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:NEO_SANS_PRO_REGULAR(12)}];
        cell.sellerTextField.text = objModal.string_ItemType;
    }
    cell.sellerTypeLbl.text = (isOtherCategory)?[@[@"Items Type",@"Other Type",@"Website",@"Instagram",@"Twitter",@"Facebook",@"Ebay"] objectAtIndex:indexPath.row]: [@[@"Items Type",@"Website",@"Instagram",@"Twitter",@"Facebook",@"Ebay"] objectAtIndex:indexPath.row];
    
    if (isOtherCategory)
        cell.sellerTextField.returnKeyType = (indexPath.row == 6)?UIReturnKeyDone:UIReturnKeyNext;
    else
        cell.sellerTextField.returnKeyType = (indexPath.row == 5)?UIReturnKeyDone:UIReturnKeyNext;
    return cell;
}

#pragma mark-Text Field Delegates

- (BOOL)textFieldShouldBeginEditing:(PATextField *)textField
{
    [self.view endEditing:YES];
    if (textField.tag == 100)
    {
        [dropObj fadeOut];
        [self showPopUpWithTitle:@"Please choose the category" withOption:arrayList xy:CGPointMake(20, 80) size:CGSizeMake(WIN_WIDTH-40, WIN_HEIGHT-100) isMultiple:YES];
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(PATextField *)textField
{
    [self.view layoutIfNeeded];
    if (isOtherCategory)
    {
        switch (textField.tag)
        {
            case 100:
                objModal.string_ItemType = textField.text;
                break;
            case 101:
                objModal.string_OtherType = textField.text;
                break;
            case 102:
                objModal.string_Website = textField.text;
                break;
            case 103:
                objModal.string_Instagram = textField.text;
                break;
            case 104:
                objModal.string_Twitter = textField.text;
                break;
            case 105:
                objModal.string_Facebook = textField.text;
                break;
            case 106:
                objModal.string_Ebay = textField.text;
            default:
                break;
        }
    }
    else
    {
        switch (textField.tag)
        {
            case 100:
                objModal.string_ItemType = textField.text;
                break;
            case 101:
                objModal.string_Website = textField.text;
                break;
            case 102:
                objModal.string_Instagram = textField.text;
                break;
            case 103:
                objModal.string_Twitter = textField.text;
                break;
            case 104:
                objModal.string_Facebook = textField.text;
                break;
            case 105:
                objModal.string_Ebay = textField.text;
                break;
            default:
                break;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if (textField.returnKeyType == UIReturnKeyNext)
    {
            [KTextField(textField.tag+1) becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark- Drop Down Method

- (void)showBackgroundView
{
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT)];
    superView.tag = 1111;
    superView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:.40f];
    UIButton *removeViewBtn = [[UIButton alloc] initWithFrame:superView.bounds];
    [removeViewBtn addTarget:self action:@selector(removeViewBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:removeViewBtn];
    [self.view addSubview:superView];
}
-(void)removeViewBtnAction
{
    [(UIView *)[self.view viewWithTag:1111] removeFromSuperview];
    [dropObj fadeOut];
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    [self showBackgroundView];
    [arrayListId addObject:@"0"];
    dropObj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions optionsID:(NSArray *)arrayListId xy:point size:size isMultiple:isMultiple];
    dropObj.delegate = self;
    [dropObj showInView:self.view animated:YES];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)arryData DatalistId:(NSMutableArray *)arryDataId{
    
    [(UIView *)[self.view viewWithTag:1111] removeFromSuperview];
    [dropObj fadeOut];
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    if (arryData.count>0)
    {
       isOtherCategory = NO;
        if ([arryData containsObject:@"Others"]) {
            isOtherCategory = YES;
            [arryDataId removeObject:@"0"];
        }
        objModal.string_ItemType = [arryData componentsJoinedByString:@", "];
        dataSourceArray = arryDataId;
    }
    else
        objModal.string_ItemType=@"";
    [self.becameSellerTableView reloadData];
}
#pragma mark- UI Button Action Method
- (IBAction)submitAction:(id)sender
{
    [self.view endEditing:YES];
  
    if (isOtherCategory)
    {
        if (![TRIM_SPACE(objModal.string_ItemType) length])
        {
            [self showErrorAlertWithTitle:@"Please choose category type"];
        }
       else if (![TRIM_SPACE(objModal.string_OtherType) length])
        {
            [self showErrorAlertWithTitle:@"Please enter other type"];
        }

        else
        {
            arrayOtherType = [objModal.string_OtherType componentsSeparatedByString:@","];
            [self callApiForBecameASeller];
        }
    }
    else
    {
        if (![TRIM_SPACE(objModal.string_ItemType) length])
        {
            [self showErrorAlertWithTitle:@"Please choose category type"];
        }
        else
        {
            [self callApiForBecameASeller];
        }
     }
}
- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
    
        ISThankYouItemVC *thankYou = [[ISThankYouItemVC alloc] initWithNibName:@"ISThankYouItemVC" bundle:nil];
        [self.navigationController pushViewController:thankYou animated:YES];
    
    }];
}

#pragma mark-Api Method
-(void)callApiForBecameASeller
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
     NSMutableDictionary *urlDic = [[NSMutableDictionary alloc] init];
    [urlDic setValue:objModal.string_Facebook forKey:@"facebook"];
    [urlDic setValue:objModal.string_Instagram forKey:@"instagram"];
    [urlDic setValue:objModal.string_Ebay forKey:@"ebay"];
    [urlDic setValue:objModal.string_Twitter forKey:@"twitter"];
    [urlDic setValue:objModal.string_Website forKey:@"website"];
    [urlDic setValue:[NSNumber numberWithInt:1] forKey:@"request_for_vendor"];
    
    [param setValue:urlDic forKey:@"request_for_vendor"];
    [param setValue:arrayOtherType forKey:@"category_names"];
    [param setValue:dataSourceArray forKey:@"category_ids"];
    
    [[ISServiceHelper helper]request:param apiName:[NSString stringWithFormat:@"user/request_for_vendor"] method:PUT completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[resultDict objectForKey:@"code"] integerValue ]==200)
            {
                [self showErrorAlertWithTitle:[resultDict objectForKeyNotNull:kMessage expectedObj:@""]];
            }
            else
            {
                NSLog(@"Error in response:%@",error);
                
            }
        });
    }];
}
#pragma mark - Web service API For Feature
-(void)makeAPIForCategory
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [[ISServiceHelper helper] request:param apiName:@"categories" method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if ([[resultDict objectForKey:kCode]integerValue] == 200)
             {
                [self parseDataFromResultDict:[resultDict objectForKeyNotNull:@"category" expectedObj:[NSArray array]]];
             }
             else{
                 
                 [self showErrorAlertWithTitle:[resultDict objectForKeyNotNull:kMessage expectedObj:@""]];
             }
         });
     }];
}
-(void)parseDataFromResultDict:(NSMutableArray *)array
{
    for (NSMutableDictionary *dic in array)
    {
        ISUserInfo * categoryInfo = [ISUserInfo parseDataFromDict:dic];
        [arrayList addObject:categoryInfo];
        [arrayListId addObject:[dic objectForKeyNotNull:@"id" expectedObj:@""]];
    }
    
    ISUserInfo * catInfo = [[ISUserInfo alloc] init];
    catInfo.name = @"Others";
    catInfo.id = 0;
    [arrayList addObject:catInfo];

}
@end
