//
//  ISRecentActivityVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 21/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISRecentActivityVC.h"
#import "Header.h"

@interface ISRecentActivityVC ()
{
    NSMutableArray *dataSourceArray,*imageArray;
    int pageNumber;
}
@property (strong, nonatomic) IBOutlet UITableView *recentActivityTableView;
@property (strong, nonatomic) UIRefreshControl  * refreshControl;
@property (strong, nonatomic) IBOutlet UIView *noItemView;
@property (strong, nonatomic) ISPagination      * pagination;
@end

@implementation ISRecentActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initialSetup
{
    [self.recentActivityTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISRecentActivityCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISRecentActivityCell class])];
    dataSourceArray = [[NSMutableArray alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.recentActivityTableView addSubview:self.refreshControl];
    pageNumber = 1;
    [self performSelector:@selector(makeApiCallToRecentActivityList:) withObject:nil afterDelay:0.3];

}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    [self.recentActivityTableView reloadData];
    [self.recentActivityTableView layoutIfNeeded];
    [refreshControl endRefreshing];
    pageNumber = 1;
    [self makeApiCallToRecentActivityList:pageNumber];
}
#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ISRecentActivityCell *cell = (ISRecentActivityCell *)[self.recentActivityTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISRecentActivityCell class])];
    cell.recentActivityImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    
    ISUserInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    if ([info.recentNotiableType isEqualToString:@"offer"])
    {
           cell.recentActivityImageView.image = [UIImage imageNamed:@"ico_notif_offer"];
    }
    else if ([info.recentNotiableType isEqualToString:@"sold"])
    {
         cell.recentActivityImageView.image = [UIImage imageNamed:@"ico_notif_sold"];
    }
    else if ([info.recentNotiableType isEqualToString:@"favorited"])
    {
        cell.recentActivityImageView.image = [UIImage imageNamed:@"ico_notif_favorited"];
    }
    cell.recentActivityUserLbl.text = info.recentMessage;
    cell.recentActivity.text = info.string_Product_Name;
//    NSString* filter = @"%K CONTAINS %@";
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"SELF", @"a"];
//    NSArray* filteredData = [imageArray filteredArrayUsingPredicate:predicate];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ISBrandDetailsVC *brandVC = [[ISBrandDetailsVC alloc]initWithNibName:@"ISBrandDetailsVC" bundle:nil];
    //    [self.navigationController pushViewController:brandVC animated:YES];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (self.pagination.total_pages > pageNumber) {
            pageNumber++;
            [self makeApiCallToRecentActivityList:pageNumber];
        }
    }
    
}
#pragma mark - Web Service Method
-(void)makeApiCallToRecentActivityList:(int)pageNo
{
        if (!pageNo) {
            pageNo = pageNumber;
        }
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[NSNumber numberWithInt:pageNo] forKey:@"page"];
    
    [[ISServiceHelper helper] request:param apiName:kApiRecentActivity method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (pageNumber == 1)
                 [dataSourceArray removeAllObjects];
            [dataSourceArray addObjectsFromArray:[self parseNotificationData:[resultDict objectForKeyNotNull:@"notifications" expectedObj:[NSArray array]]]];
             self.pagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
              self.noItemView.hidden = (dataSourceArray.count == 0)?NO:YES;
             [self.recentActivityTableView reloadData];
         });
     }];
}


-(NSMutableArray * )parseNotificationData:(NSArray *)notificationArray{
    
    NSMutableArray * arrayData = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in notificationArray)
    {
        ISUserInfo *notifyData = [[ISUserInfo alloc] init];
        notifyData.recentId = [dict objectForKeyNotNull:@"id" expectedObj:@""];
        notifyData.recentMessage = [dict objectForKeyNotNull:@"message" expectedObj:@""];
        notifyData.recentNotiableId = [dict objectForKeyNotNull:@"notable_id" expectedObj:@""];
        notifyData.recentNotiableType = [dict objectForKeyNotNull:@"notable_type" expectedObj:@""];
        notifyData.recentSenderId = [dict objectForKeyNotNull:@"sender_id" expectedObj:@""];
        notifyData.string_Product_Id = [dict objectForKeyNotNull:@"product_id" expectedObj:@""];
        notifyData.string_Product_Name = [dict objectForKeyNotNull:@"product_name" expectedObj:@""];
        [arrayData addObject:notifyData];
    }

    return arrayData;
}

@end
