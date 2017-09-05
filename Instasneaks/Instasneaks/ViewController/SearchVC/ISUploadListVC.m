//
//  ISUploadListVC.m
//  Instasneaks
//
//  Created by Suresh patel on 26/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISUploadListVC.h"

static NSString *CellIdentifier = @"uploadListCell";

@interface ISUploadListVC ()<UITableViewDelegate, UITableViewDataSource>
{
    ISUserInfo *userInfo;
    int pageNumber;
    BOOL  isSearch;
}
@property (strong, nonatomic) IBOutlet UILabel *uploadNavLabel;
@property (weak, nonatomic) IBOutlet UITableView        * tableView_uploadList;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UISearchBar        * searchBar_uploadList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomContraints;

@property (strong, nonatomic) NSMutableArray            * uploadListData;


@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) UIRefreshControl  * refreshControl;
@property (strong, nonatomic) ISPagination      * pagination;

@end

@implementation ISUploadListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isFromAddToPicker == YES)
    {
        self.uploadNavLabel.text = @"UPLOAD";
        self.containerView.hidden = NO;
        self.tableViewBottomContraints.constant = 65.0f;
    }
    else
    {
        self.uploadNavLabel.text = @"SEARCH";
        self.tableViewBottomContraints.constant = 0.0f;
        self.containerView.hidden = YES;
        self.headerView.hidden = YES;
    }
        
    [self initialMethod];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod{
    [self.searchBar_uploadList becomeFirstResponder];
    [self.tableView_uploadList registerNib:[UINib nibWithNibName:@"ISUploadListCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
     [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{                                                                                      NSFontAttributeName: [UIFont fontWithName:@"NeoSansPro-Regular" size:14],                                                                                                 }];
    self.uploadListData = [[NSMutableArray alloc] init];
    userInfo = [[ISUserInfo alloc] init];
    self.pagination = [[ISPagination alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView_uploadList addSubview:self.refreshControl];
    pageNumber = 1;
}
- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    [self.tableView_uploadList reloadData];
    [self.tableView_uploadList layoutIfNeeded];
    [refreshControl endRefreshing];
    pageNumber = 1;
    if(isSearch)
    [self makeApiCallToSearch:pageNumber];
}
#pragma mark - UIButton Actions

- (IBAction)backButtonAction:(id)sender
{
    [self.view endEditing:YES];
    isSearch = NO;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)commonBtnAction:(UIButton *)sender
{
     [self.view endEditing:YES];

    
}
#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if(isSearch){
        return self.uploadListData.count;
   }
    return 0;
};

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ISUploadListCell *cell = (ISUploadListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
     ISUserInfo *productInfo = [self.uploadListData objectAtIndex:indexPath.row];
    cell.label_brandName.text = productInfo.title;
    cell.label_color.text =    [NSString stringWithFormat:@"Color:%@",productInfo.color_code];
    [cell.imageView_item sd_setImageWithURL:[NSURL URLWithString:productInfo.image] placeholderImage:[UIImage imageNamed:@"nike"]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    ISUserInfo * storeInfo = [self.uploadListData objectAtIndex:indexPath.item];
     [self dismissViewControllerAnimated:NO completion:nil];
    [self.delegate didSearchSelectData:[NSString stringWithFormat:@"%lu", (unsigned long)storeInfo.id]];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

#pragma mark - Scroll View Delegate Methods
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (self.pagination.total_pages > pageNumber) {
            pageNumber++;
            if(isSearch)
            [self makeApiCallToSearch:pageNumber];
        }
    }
}

#pragma mark - UISearchBar Delegate Methods
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        [self.uploadListData removeAllObjects];
         isSearch = NO;
        [self.tableView_uploadList reloadData];
    }
    else
    {
        isSearch = YES;
        userInfo.string_SearchText = text;
        pageNumber = 1;
        [searchBar setShowsCancelButton:YES animated:YES];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(searchProductWithText:) withObject:TRIM_SPACE(text) afterDelay:2.0];
    }
}
-(void)searchProductWithText:(NSString *)text
{
    [self makeApiCallToSearch:pageNumber];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (ISUserInfo* categoryInfo in self.uploadListData) {
        [categoryArray addObject:categoryInfo.string_Category_id];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.delegate searchSelectData:searchBar.text CategoryArray:categoryArray];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    userInfo.string_SearchText=searchBar.text;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
     [self.view endEditing:YES];
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    isSearch = NO;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - Web Service Method

-(void)makeApiCallToSearch:(int)pageNo
{
    
    NSString *apiSearch = [NSString stringWithFormat:@"items?page=%d&q[title_cont]=%@&q[category_id_eq]=",pageNo,(userInfo.string_SearchText == nil)?@"":userInfo.string_SearchText];
    [[ISServiceHelper helper] request:nil apiName:apiSearch method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
            {    if (pageNumber == 1)
                    [self.uploadListData removeAllObjects];
               self.uploadListData =  [self parseSearchData:resultDict];
                if (self.uploadListData.count > 0)
                {
                    self.searchBar_uploadList.enablesReturnKeyAutomatically = YES;
                }
               [self.tableView_uploadList reloadData];
           });
     }];
}
-(NSMutableArray *)parseSearchData:(NSDictionary *)productDic
{
    NSMutableArray *productArray = [productDic objectForKeyNotNull:@"items" expectedObj:[NSMutableArray array]];
  if(productArray.count){
    for (NSMutableDictionary *dic  in productArray)
    {
        ISUserInfo *productInfo = [ISUserInfo parseDataFromDict:dic];
        productInfo.string_Category_id = [dic objectForKeyNotNull:@"category_id" expectedObj:@""];
        [_uploadListData addObject:productInfo];
    }
  }
  else{
      [self showErrorAlertWithTitle:@"Search Result Not Found"];
  
  }
    self.pagination = [ISPagination parseDataFromDict:[productDic objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
    return self.uploadListData;
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}
@end
