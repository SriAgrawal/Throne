//
//  ISHelpFAQVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISHelpFAQVC.h"
#import "Header.h"

@interface ISHelpFAQVC ()
{
    NSMutableArray *dataSourceArray;
}
@property (strong, nonatomic) IBOutlet UITableView *helpFaqTableView;

@end

@implementation ISHelpFAQVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Helping method of view controller
-(void)initialSetup
{
    
    [self.helpFaqTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISSettingTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISSettingTableCell class])];
    
   
    dataSourceArray = [[NSMutableArray alloc] initWithObjects:@"Walkthrough",@"FAQ",@"Help",@"Privacy Policy - Terms of Service",nil];
}
#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ISSettingTableCell *cell = (ISSettingTableCell *)[self.helpFaqTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISSettingTableCell class])];
    cell.settingLbl.text = [dataSourceArray objectAtIndex:indexPath.row];
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
        }
            break;
            
        case 1:
        {
            ISFAQVC * helpVC = [[ISFAQVC alloc] initWithNibName:@"ISFAQVC" bundle:nil];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 2:
        {
            [[HSHelpStack instance] showHelp:self];
//            ISHelpVC * helpVC = [[ISHelpVC alloc] initWithNibName:@"ISHelpVC" bundle:nil];
//            [self.navigationController pushViewController:helpVC animated:YES];
        }
            break;
        case 3:
        {
            ISPrivacyPolicyVC *brandVC = [[ISPrivacyPolicyVC alloc]initWithNibName:@"ISPrivacyPolicyVC" bundle:nil];
            [self.navigationController pushViewController:brandVC animated:YES];
        }
            break;

        default:
            break;
    }
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
