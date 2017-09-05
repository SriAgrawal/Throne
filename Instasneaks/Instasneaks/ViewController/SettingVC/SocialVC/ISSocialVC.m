//
//  ISSocialVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISSocialVC.h"
#import "Header.h"

@interface ISSocialVC ()
{
     NSMutableArray *dataSourceArray;
}
@property (strong, nonatomic) IBOutlet UITableView *socialTableView;

@end

@implementation ISSocialVC

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
    
    [self.socialTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISSettingTableCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISSettingTableCell class])];
   
    dataSourceArray = [[NSMutableArray alloc] initWithObjects:@"Follow on Twitter",@"Follow on Facebook",@"Follow on Instagram",@"THRONE Website",@"Wallet",@"Share THRONE",@"Rate THRONE",nil];
    
}
#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ISSettingTableCell *cell = (ISSettingTableCell *)[self.socialTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISSettingTableCell class])];
    cell.settingLbl.text = [dataSourceArray objectAtIndex:indexPath.row];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self followingSocial:indexPath.row];
}

-(void)followingSocial:(long)socialType
{
    UIApplication *myApp = UIApplication.sharedApplication;
    switch (socialType) {
        case 0:
                {
                    NSURL *twitterAppURL = [NSURL URLWithString:@"https://mobile.twitter.com/thronexyz"];
                    if ([myApp canOpenURL:twitterAppURL])
                        [myApp openURL:[NSURL URLWithString:@"https://mobile.twitter.com/thronexyz"]];
                    else
                        [myApp openURL:[NSURL URLWithString:@"https://mobile.twitter.com/thronexyz"]];
                }
            break;
        case 1:
            {
                NSURL *facebookAppURL = [NSURL URLWithString:@"fb://"];
                if ([myApp canOpenURL:facebookAppURL])
                    [myApp openURL:[NSURL URLWithString:@"fb://page/?id=437163259683795"]];
                else
                    [myApp openURL:[NSURL URLWithString:@"https://m.facebook.com/THRONExyz/"]];
            }
            break;
        case 2:
            {
                NSURL *instragramAppURL = [NSURL URLWithString:@"https://www.instagram.com/throne.xyz/"];
                if ([myApp canOpenURL:instragramAppURL])
                    [myApp openURL:[NSURL URLWithString:@"https://www.instagram.com/throne.xyz/"]];
                else
                    [myApp openURL:[NSURL URLWithString:@"https://www.instagram.com/throne.xyz/"]];
            }
            break;
        case 3:
                    [myApp openURL:[NSURL URLWithString:@"http://throne.xyz/"]];
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
