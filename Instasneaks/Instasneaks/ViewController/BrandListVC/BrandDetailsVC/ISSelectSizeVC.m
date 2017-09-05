//
//  ISSelectSizeVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 23/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISSelectSizeVC.h"
#import "Header.h"

@interface ISSelectSizeVC ()
@property (strong, nonatomic) IBOutlet UITableView *selectSizeTableView;
@property (strong, nonatomic) NSArray *arraySizeItems;
@property (strong, nonatomic) NSArray *arrayPrice;

@end

@implementation ISSelectSizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initialSetUp
{

    [self.selectSizeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISSelectSizeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISSelectSizeCell class])];
    self.arraySizeItems = @[@"6",@"6.5",@"7",@"7.5",@"8",@"8.5",@"9"];
    self.arrayPrice = @[@"135",@"150",@"136",@"140",@"140",@"150",@"160"];

}

#pragma mark- Table View Delegate and Data source Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.arraySizeItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ISSelectSizeCell *cell = (ISSelectSizeCell *)[self.selectSizeTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISSelectSizeCell class])];
    cell.sizeLabel.text = [self.arraySizeItems objectAtIndex:indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@",[_arrayPrice objectAtIndex:indexPath.row]];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (IBAction)crossAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
