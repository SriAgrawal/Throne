//
//  ISSortVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 22/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISSortVC.h"
#import "Header.h"

@interface ISSortVC ()
{
    ISUserInfo *modalObj;
    NSString *selectedText;
    NSMutableArray *dataSourceArray;
}
@property (strong, nonatomic) IBOutlet UITableView *sortTableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) NSMutableArray *filterArray;
@end

@implementation ISSortVC

- (void)viewDidLoad
{
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
    [self.sortTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISFilterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISFilterCell class])];
    dataSourceArray = [[NSMutableArray alloc] init];
        self.filterArray = [[NSMutableArray alloc]initWithObjects:@"Popular",@"Newest",@"Price: High to Low",@"Price: Low to High",nil];
    for (int i=0; i< _filterArray.count; i++)
    {
          modalObj = [[ISUserInfo alloc] init];
        modalObj.isTapped = NO;
        [dataSourceArray addObject:modalObj];
    }
    
   // self.sortTableView.tableFooterView = _footerView;

}
#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISFilterCell *cell = (ISFilterCell *)[self.sortTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISFilterCell class])];
    cell.filterLbl.text = [self.filterArray objectAtIndex:indexPath.row];
    modalObj = [dataSourceArray objectAtIndex:indexPath.row];
    cell.checkImageView.image = (modalObj.isTapped == YES) ?[UIImage imageNamed:@"ico_Check"] :[UIImage imageNamed:@""];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i=0; i< _filterArray.count; i++)
    {
        modalObj = [[ISUserInfo alloc] init];
        modalObj.isTapped = NO;
        [dataSourceArray replaceObjectAtIndex:i withObject:modalObj];
    }
    modalObj = [dataSourceArray objectAtIndex:indexPath.row];
    selectedText = [self.filterArray objectAtIndex:indexPath.row];
    
      modalObj.isTapped = modalObj.isTapped == NO ? YES : NO;
    [self.delegate didSelectData:selectedText];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.sortTableView reloadData];
}
- (IBAction)closeAction:(id)sender
{
//     [self.delegate didSelectData:selectedText];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
