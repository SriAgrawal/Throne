//
//  ISShopSearchVC.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopSearchVC.h"
#import "ISAlphabetCell.h"
#import "ISUploadListCell.h"
#import "Header.h"
@interface ISShopSearchVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView_Shop;
@property (strong, nonatomic) NSMutableArray *storeDetail;

@end

@implementation ISShopSearchVC

#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _storeDetail = [[NSMutableArray alloc]init];
    [self apiCallForSelectAlphabet:self.alphabet];
    [self.tableView_Shop registerNib:[UINib nibWithNibName:@"ISUploadListCell" bundle:nil] forCellReuseIdentifier:@"uploadListCell"];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableview Delegate and datasourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _storeDetail.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ISUploadListCell *cell = (ISUploadListCell *)[tableView dequeueReusableCellWithIdentifier:@"uploadListCell"];
    ISUserInfo *storeName = [self.storeDetail objectAtIndex:indexPath.row];
    cell.label_brandName.text = storeName.store_name;
   [cell.imageView_item sd_setImageWithURL:[NSURL URLWithString:storeName.store_logo] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    cell.label_color.text =storeName.title;
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISUserInfo *storeName = [self.storeDetail objectAtIndex:indexPath.row];
    ISDetailContainerVC *storeDetails = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
    storeDetails.storeId = [NSString stringWithFormat:@"%lu",(unsigned long)storeName.id];
    [self.navigationController pushViewController:storeDetails animated:YES];
}
#pragma mark - UIButton Action method
-(void)apiCallForSelectAlphabet:(NSString *)alphabets
{
    NSString *apiNameForSearch = [NSString stringWithFormat:@"stores?q[categories_id_eq]=%@&q[store_name_start]=%@&?page=%d",self.categoryId,alphabets,1];
    [[ISServiceHelper helper] request:nil apiName:apiNameForSearch method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if ([[resultDict objectForKey:kCode]integerValue] == 200)
                            {   [_storeDetail removeAllObjects];
                                _storeDetail =[self parseDataFromResultDict:resultDict];
                                [self.tableView_Shop reloadData];
                            }
                            else{
                                
                                [self showErrorAlertWithTitle:[resultDict objectForKeyNotNull:kMessage expectedObj:@""]];
                            }
                        });
     }];
}
-(NSMutableArray *)parseDataFromResultDict:(NSDictionary *)dict{
    NSArray *storeArray = [dict objectForKeyNotNull:@"stores" expectedObj:[NSArray array]];
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
     for (NSDictionary *itemDict in storeArray) {
        ISUserInfo *info = [ISUserInfo parseDataFromDict:itemDict];
        [itemArray addObject:info];
    }
    return itemArray;
}
#pragma mark - Alert Method
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}

@end
