//
//  ISDirectoryViewController.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISDirectoryViewController.h"
#import "ISDirectoryCell.h"
@interface ISDirectoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSorucearray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview_Directory;
@end

@implementation ISDirectoryViewController

#pragma mark- Life cycle of View Controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    dataSorucearray = [[NSMutableArray alloc]init];
    [self.tableview_Directory registerNib:[UINib nibWithNibName:@"ISDirectoryCell" bundle:nil] forCellReuseIdentifier:@"ISDirectoryCell"];
    //Call Api For All Category
    [self makeAPIForCategory];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark- Memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Table view Delegate and DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSorucearray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     ISDirectoryCell  *cell = (ISDirectoryCell *)[tableView dequeueReusableCellWithIdentifier:@"ISDirectoryCell"];
    ISUserInfo *info = [dataSorucearray objectAtIndex:indexPath.row];
    [cell.label_Directory setText:info.name];
     return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISUserInfo *info = [dataSorucearray objectAtIndex:indexPath.row];
    ISShopSearchHeaderVC *searchVC = [[ISShopSearchHeaderVC  alloc] initWithNibName:@"ISShopSearchHeaderVC" bundle:nil];
    searchVC.categoryId = [NSString stringWithFormat:@"%ld",(unsigned long)info.id];
    [self.navigationController pushViewController:searchVC animated:YES];
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
                 [dataSorucearray removeAllObjects];
                 dataSorucearray = [self parseDataFromResultDict:[resultDict objectForKeyNotNull:@"category" expectedObj:[NSArray array]]];
                 [self.tableview_Directory reloadData];
             }
             else{
                 
                 [self showErrorAlertWithTitle:[resultDict objectForKeyNotNull:kMessage expectedObj:@""]];
             }
         });
     }];
}
//Parse the data for category
-(NSMutableArray *)parseDataFromResultDict:(NSMutableArray *)arrayData
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in arrayData)
    {
        ISUserInfo *objModal = [ISUserInfo parseDataFromDict:dic];
        [dataArray addObject:objModal];
    }
    return dataArray;
}
//Show Alert View Method
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}
@end
