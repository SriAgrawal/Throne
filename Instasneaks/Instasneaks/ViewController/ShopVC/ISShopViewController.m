//
//  ISShopViewController.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 06/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISShopViewController.h"
#import "ISShopCollectionViewCell.h"

@interface ISShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{

    NSMutableArray *dataSourceArray;;
}
@property (strong, nonatomic) UIRefreshControl          * refreshControl;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView_ShopCollection;

@end
@implementation ISShopViewController

#pragma mark - Life cycle of View controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView_ShopCollection registerNib:[UINib nibWithNibName:@"ISShopCollectionViewCell"bundle:nil]forCellWithReuseIdentifier:@"ISShopCollectionViewCell"];
    dataSourceArray = [[NSMutableArray alloc] init];
  
    [self makeAPIForCategory];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -Memory Mangement Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method for Refresh Handler
-(void)addRefreshController
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView_ShopCollection addSubview:self.refreshControl];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    [self.refreshControl endRefreshing];
    [self makeAPIForCategory];
}

#pragma mark - collectionView Delgate and DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

  return dataSourceArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ISUserInfo *objModal = [dataSourceArray objectAtIndex:indexPath.item];
    
    ISShopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISShopCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView_BrandImage sd_setImageWithURL:[NSURL URLWithString:objModal.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    [cell.label_brandName setText:objModal.name];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/2-15,collectionView.frame.size.width/2-20);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISBrandDetailContainerVC *storeVC = [[ISBrandDetailContainerVC alloc] initWithNibName:@"ISBrandDetailContainerVC" bundle:nil];
    ISUserInfo *objModal = [dataSourceArray objectAtIndex:indexPath.item];
    storeVC.categoryId = [NSString stringWithFormat: @"%lu", (unsigned long)objModal.id];
    storeVC.brandName = objModal.name;
    [self.navigationController pushViewController:storeVC animated:YES];
}
#pragma mark - UIButton Action Method
- (IBAction)submitCategoryAction:(id)sender
{
    ISSubmitCategoryVC *submit =  [[ISSubmitCategoryVC alloc] initWithNibName:@"ISSubmitCategoryVC" bundle:nil];
    [self.navigationController pushViewController:submit animated:YES];
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
                 [dataSourceArray removeAllObjects];
                 dataSourceArray = [self parseDataFromResultDict:[resultDict objectForKeyNotNull:@"category" expectedObj:[NSArray array]]];
                 [self.collectionView_ShopCollection reloadData];
             }
             else{
                 
                 [self showErrorAlertWithTitle:[resultDict objectForKeyNotNull:kMessage expectedObj:@""]];
             }
         });
     }];
}

-(NSMutableArray *)parseDataFromResultDict:(NSMutableArray *)array
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in array)
    {
        ISUserInfo *objModal = [ISUserInfo parseDataFromDict:dic];
        [dataArray addObject:objModal];
    }
    return dataArray;
}
#pragma mark -Alert Method Warning
-(void)showErrorAlertWithTitle:(NSString*)error
{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}
@end
