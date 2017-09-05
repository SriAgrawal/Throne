//
//  ISHappyThingViewController.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 06/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISHappyThingViewController.h"
#import "Header.h"

@interface ISHappyThingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,sortVCDelegate>{

    NSMutableArray *arrayBrandName, *araysSize, *arrayCondition, *arrayColor, *arrayGender;
    BOOL isDoneHide;
    NSInteger selectedTag, itemPageNumber, storePageNumber;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collctionView_Thing;
@property (assign, nonatomic) CGFloat previousScrollViewYOffset;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView_SizeSelection;
@property (strong, nonatomic) ISUserInfo        * modalObj;
@property (strong, nonatomic) ISPagination      * itemPagination;
@property (strong, nonatomic) ISPagination      * storePagination;
@property (strong, nonatomic) NSMutableArray    * itemArrayData;
@property (strong, nonatomic) NSMutableArray    * storeArrayData;
@property (strong, nonatomic) IBOutlet UIView *sizeTableHeaderView;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraints;
@end

@implementation ISHappyThingViewController

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collctionView_Thing.delegate = self;
    self.collctionView_Thing.dataSource = self;
    self.modalObj = [[ISUserInfo alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSizeTable:) name:@"FireNotificationToSelectSizeTable" object:nil];
    [self.collctionView_Thing registerNib:[UINib nibWithNibName:@"ThingCollectionViewCell"bundle:nil]forCellWithReuseIdentifier:@"ThingCollectionViewCell"];
    [self.collctionView_Thing registerNib:[UINib nibWithNibName:@"ISFeaturedCololectionCell"bundle:nil]forCellWithReuseIdentifier:@"ISFeaturedCololectionCell"];
    [self initialMethod];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
[self closedAnimation];
    if ([self.segmentType isEqualToString:@"Items"])
        [self makeApiCallToItemSearch:NO];
    else
        [self makeApiCallToItemSearch:YES];

}

#pragma mark - Init Method
-(void)initialMethod
{
    self.containerViewBottomConstraints.constant = WIN_HEIGHT-self.containerView.frame.origin.y;
    [self.view bringSubviewToFront:self.containerView];
    [self.tableView_SizeSelection setHidden:YES];
    
    arrayBrandName = [[NSMutableArray alloc] init];
    araysSize = [[NSMutableArray alloc] init];
    arrayCondition = [[NSMutableArray alloc] init];
    arrayColor = [[NSMutableArray alloc] init];
    arrayGender = [[NSMutableArray alloc] init];
    self.itemArrayData = [[NSMutableArray alloc] init];
    self.storeArrayData = [[NSMutableArray alloc] init];

    [self.tableView_SizeSelection registerNib:[UINib nibWithNibName:NSStringFromClass([ISFilterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISFilterCell class])];
    [self.tableView_SizeSelection setTableHeaderView:self.sizeTableHeaderView];
    
    self.modalObj.string_itemSize = @"";
    self.modalObj.string_itemBrandName = @"";
    self.modalObj.string_itemCondition = @"";
    self.modalObj.string_itemColor = @"";
    self.modalObj.string_gender = @"";
    self.modalObj.string_itemSort = @"";
    itemPageNumber = 1;
    storePageNumber = 1;
    [self makeApiCallToItemSearch:YES];
}
#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate and UITableViewDataSource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (selectedTag) {
        case 1:
            return  araysSize.count;
            break;
        case 2:
            return  arrayCondition.count;
            break;
        case 3:
            return arrayBrandName.count;
            break;
        case 4:
            return arrayColor.count;
            break;
        case 5:
            return arrayGender.count;
            break;
        default:
            break;
    }
    return arrayColor.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView_SizeSelection){
        if (isDoneHide)
            return 0;
        else
            return 30.0;
        }
    else
        return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView_SizeSelection)
    {
        UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView_SizeSelection.frame.size.width, 30)];
        UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-80, 10, 80, 20)];
        [doneBtn setTitleColor:[UIColor colorWithRed:173/255.0f green:141/255.0f blue:69/255.0f alpha:1.0] forState:UIControlStateNormal];
        [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bView addSubview:doneBtn];
         return bView;
    }
    else
        return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ISFilterCell *cell = (ISFilterCell *)[tableView dequeueReusableCellWithIdentifier:@"ISFilterCell"];
     cell.backgroundColor = [UIColor clearColor];
    switch (selectedTag)
    {
        case 1:
        {
            ISUserInfo* modalSizeObj =[araysSize objectAtIndex:indexPath.row];
            cell.filterLbl.text = modalSizeObj.string_itemSize;
            cell.checkImageView.hidden = (modalSizeObj.isSelected == NO)? YES: NO;
        }
            break;
        case 2:{
            ISUserInfo* modalCondtionObj =[arrayCondition objectAtIndex:indexPath.row];
            cell.filterLbl.text = modalCondtionObj.string_itemCondition;
            cell.checkImageView.hidden = (modalCondtionObj.isSelected == NO)? YES: NO;
        }
            break;
        case 3:
        {
            ISUserInfo* modalBrandObj =[arrayBrandName objectAtIndex:indexPath.row];
            cell.filterLbl.text = modalBrandObj.string_Product_Name;
            cell.checkImageView.hidden = (modalBrandObj.isSelected == NO)? YES: NO;
        }
            break;
        case 4:
        {
            ISUserInfo* modalColorObj =[arrayColor objectAtIndex:indexPath.row];
            cell.filterLbl.text = modalColorObj.string_itemColor;
            cell.checkImageView.hidden = (modalColorObj.isSelected == NO)? YES: NO;
        }
            break;
        case 5:
        {
            ISUserInfo* modalGenderObj =[arrayGender objectAtIndex:indexPath.row];
            cell.filterLbl.text = modalGenderObj.string_gender;
            cell.checkImageView.hidden = (modalGenderObj.isSelected == NO)? YES: NO;
        }
            break;
        default:
            break;
    }
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
      NSString * selectedValue;
    switch (selectedTag)
    {
        case 0:
            break;
        case 1:{
            ISUserInfo* modalSizeObj =[araysSize objectAtIndex:indexPath.row];
            modalSizeObj.isSelected = !modalSizeObj.isSelected;
            selectedValue = modalSizeObj.string_itemSize;
            if ([[modalSizeObj.string_itemSize lowercaseString] isEqualToString:[@"All" lowercaseString]] && indexPath.row == 0)
            {
                for (int all = 0; all < araysSize.count ;all++) {
                    ISUserInfo* obj = [araysSize objectAtIndex:all];
                    if (all == 0) {
                        obj.item_id = @"";
                        obj.isSelected = YES;
                    }
                    else
                        obj.isSelected = NO;
                }
            }else{
                ISUserInfo* obj = [araysSize objectAtIndex:0];
                obj.isSelected = NO;
            }
            [self.tableView_SizeSelection reloadData];
        }
            break;
        case 2:
        {
            ISUserInfo* conditionInfo = [arrayCondition objectAtIndex:indexPath.row];
            
            if ([[conditionInfo.string_itemCondition lowercaseString] isEqualToString:[@"New" lowercaseString]])
            {
                conditionInfo.isSelected = !conditionInfo.isSelected;
                selectedValue = @"New";
            }
            else if ([[conditionInfo.string_itemCondition lowercaseString] isEqualToString:[@"Used" lowercaseString]])
            {conditionInfo.isSelected = !conditionInfo.isSelected;
                selectedValue = @"Used";
            }
            else
            {
                conditionInfo.isSelected = !conditionInfo.isSelected;
                selectedValue = @"All";
            }
            _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            [self closedAnimation];
            itemPageNumber = 1;
            storePageNumber = 1;
            [self makeApiCallToItemSearch:YES];
        }
            break;
        case 3:
        {
            ISUserInfo* modalBrandObj =[arrayBrandName objectAtIndex:indexPath.row];
            modalBrandObj.isSelected = !modalBrandObj.isSelected;
            selectedValue = modalBrandObj.string_Product_Name;
            if ([[modalBrandObj.string_Product_Name lowercaseString] isEqualToString:[@"All" lowercaseString]]){
                for (int all = 0; all < arrayBrandName.count ;all++) {
                    ISUserInfo* obj = [arrayBrandName objectAtIndex:all];
                    if (all == 0) {
                        obj.string_Product_Id = @"";
                        obj.isSelected = YES;
                    }
                    else
                        obj.isSelected = NO;
                }
            }
            else{
                ISUserInfo* obj = [arrayBrandName objectAtIndex:0];
                obj.isSelected = NO;
            }
            [self.tableView_SizeSelection reloadData];
        }
            break;
        case 4:
        {
            ISUserInfo* modalColorObj =[arrayColor objectAtIndex:indexPath.row];
            modalColorObj.isSelected = !modalColorObj.isSelected;
            selectedValue = modalColorObj.string_itemColor;
            if ([[modalColorObj.string_itemColor lowercaseString] isEqualToString:[@"All" lowercaseString]]){
                for (int all = 0; all < arrayColor.count ;all++) {
                    ISUserInfo* obj = [arrayColor objectAtIndex:all];
                    if (all == 0) {
                        obj.store_id = @"";
                        obj.isSelected = YES;
                    }
                    else
                        obj.isSelected = NO;
                }
            }
            else{
                ISUserInfo* obj = [arrayColor objectAtIndex:0];
                obj.isSelected = NO;
            }
            
            [self.tableView_SizeSelection reloadData];
        }
            
            break;
        case 5:{
            ISUserInfo* obj = [arrayGender objectAtIndex:indexPath.row];
            
            if ([[obj.string_gender lowercaseString] isEqualToString:[@"Male" lowercaseString]])
            {
                selectedValue = @"Male";
                obj.isSelected = !obj.isSelected;
                obj.string_gender = @"Male";
            }
            else
            {  obj.isSelected = !obj.isSelected;
                obj.string_gender = @"Female";
                selectedValue = @"Female";
            }
            _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            [self closedAnimation];
            itemPageNumber = 1;
            storePageNumber = 1;
            [self makeApiCallToItemSearch:YES];;
        }
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectItem:atIndex:)]) {
        [self.delegate didSelectItem:selectedValue atIndex:selectedTag];
    }
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([self.segmentType isEqualToString:@"Items"])
        return self.itemArrayData.count;
    else
        return self.storeArrayData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.segmentType isEqualToString:@"Items"])
    {
        ISFeaturedCololectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISFeaturedCololectionCell" forIndexPath:indexPath];
        ISUserInfo * storeInfo = [self.itemArrayData objectAtIndex:indexPath.item];
        [cell.label_StoreName setText:storeInfo.store_name];
        [cell.label_ProductName setText:storeInfo.title];
        [cell.label_PricelLabel setText:[NSString stringWithFormat:@"$%@", storeInfo.price]];
        [cell.imageview_ProductImage sd_setImageWithURL:[NSURL URLWithString:storeInfo.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];

        return cell;
    }
    else
    {
        ThingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThingCollectionViewCell" forIndexPath:indexPath];
        ISUserInfo * storeInfo = [self.storeArrayData objectAtIndex:indexPath.item];
        [cell.imageView_BackgroundView sd_setImageWithURL:[NSURL URLWithString:storeInfo.store_background] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        [cell.imageView_UserProfile sd_setImageWithURL:[NSURL URLWithString:storeInfo.store_logo] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        [cell.label_UserName setText:storeInfo.full_name];
        [cell.label_NoOfProduct setText:storeInfo.store_name];
        cell.favBtn.tag = indexPath.item+100;
        [cell.favBtn setSelected:storeInfo.isSelected];
        [cell.favBtn addTarget:self action:@selector(favoriteButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.segmentType isEqualToString:@"Items"])
        return CGSizeMake(collectionView.frame.size.width/2-5, 234);
    else
        return CGSizeMake(collectionView.frame.size.width/2-7, 210);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.segmentType isEqualToString:@"Items"])
    {
        ISUserInfo * storeInfo = [self.itemArrayData objectAtIndex:indexPath.item];
        ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
        [storeVC setIsForItemDetail:YES];
        [storeVC setItemId:[NSString stringWithFormat:@"%lu", (unsigned long)storeInfo.id]];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    else
    {
        ISUserInfo *obj = [self.storeArrayData objectAtIndex:indexPath.item];
        ISDetailContainerVC *shopVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
        shopVC.storeId = [NSString stringWithFormat:@"%ld",(unsigned long)obj.id ];
        [self.navigationController pushViewController:shopVC animated:YES];
    }
}
#pragma UIButton Action Method

-(void)showSizeTable:(NSNotification *)notificationInfo{
    
    NSDictionary * dict = notificationInfo.object;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = [[dict objectForKey:@"buttonTag"] intValue];
    button.selected = [[dict objectForKey:@"select"] boolValue];
    [self commonBtnAction:button];
}
-(void)favoriteButtonAction:(UIButton *)button withEvent:(UIEvent *)event
{
    NSIndexPath * indexPath = [self.collctionView_Thing indexPathForItemAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.collctionView_Thing]];
    
    ISUserInfo * storeInfo = [self.storeArrayData objectAtIndex:indexPath.item];
    if (storeInfo.isSelected)
        [self makeApiToRemoveStoreFavourite:storeInfo];
    else
        [self makeApiToAddStoreFavourite:storeInfo];
}
- (void)commonBtnAction:(UIButton *)sender
{
    isDoneHide = NO;
    switch (sender.tag)
    {
        case 100:
        {
            [self closedAnimation];
            _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            ISSortVC *sortVC = [[ISSortVC alloc] init];
            sortVC.delegate = self;
            sortVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:sortVC animated:YES completion:nil];
        }
            break;
        case 101:
        {
            if (sender.selected == NO)
            {
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
               _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
               _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 1;
            [self.tableView_SizeSelection reloadData];
        }
            break;
        case 102:
        {
            isDoneHide = YES;
            if (sender.selected == NO)
            {
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
               _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 2;
            [self.tableView_SizeSelection reloadData];
        }
            break;
        case 103:
        {
            if (sender.selected == NO)
            {
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
               _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 3;
            [self.tableView_SizeSelection reloadData];
        }
            break;
        case 104:
        {
            if (sender.selected == NO)
            {
               _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 4;
            [self.tableView_SizeSelection reloadData];
        }
            break;
        case 105:
        {
            isDoneHide = YES;
            if (sender.selected == NO)
            {
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
               _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 5;
            [self.tableView_SizeSelection reloadData];
        }
            break;
        default:
            break;
    }
}
#pragma mark- Animation of View
-(void)setUpAnimation
{
    [self.tableView_SizeSelection setHidden:NO];
    self.containerViewBottomConstraints.constant = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)closedAnimation
{
    self.containerViewBottomConstraints.constant = WIN_HEIGHT-self.containerView.frame.origin.y;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)doneBtnAction:(UIButton *)sender {
    
    _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    [self closedAnimation];
    itemPageNumber = 1;
    storePageNumber = 1;
    [self makeApiCallToItemSearch:YES];
    
}
#pragma mark - Custom Delegate Methods
-(void)didSelectData:(NSString*)strText
{
    if ([strText isEqualToString:@"Popular"])
        self.modalObj.string_itemSort = @"clicks desc";
    else if ([strText isEqualToString:@"Newest"])
        self.modalObj.string_itemSort = @"created_at desc";
    else if ([strText isEqualToString:@"Price: High to Low"])
        self.modalObj.string_itemSort = @"price desc";
    else
        self.modalObj.string_itemSort = @"price asc";
    itemPageNumber = 1;
    storePageNumber = 1;

    [self makeApiCallToItemSearch:YES];
}

#pragma mark - Scroll View Delegate Methods
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if ([self.segmentType isEqualToString:@"Items"]){
            if (self.itemPagination.total_pages > itemPageNumber) {
                itemPageNumber++;
                [self makeApiCallToItemSearch:NO];
            }
        }
        else{
            if (self.storePagination.total_pages > storePageNumber) {
                storePageNumber++;
                [self makeApiCallToStoreSearch];
            }
        }
    }
}
#pragma mark - Web Service Method
-(void)makeApiCallToItemSearch:(BOOL)isStoreSearch
{
    NSString *apiSearch = [NSString stringWithFormat:@"items/item_search_from_filter?page=%ld",(long)itemPageNumber];
    
    //====================Item Array
    NSMutableDictionary *paramItem = [[NSMutableDictionary alloc] init];
    NSMutableArray* brandItemArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in arrayBrandName){
        if (sizeInfo.isSelected) {
            [brandItemArray addObject:sizeInfo.string_Product_Id];
        }
    }
    [paramItem setValue:brandItemArray forKey:@"brand_id_in"];
    
    [paramItem setValue:@"" forKey:@"category_id_eq"];
    
    NSMutableArray* colorItemArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in arrayColor){
        if (sizeInfo.isSelected) {
            [colorItemArray addObject:sizeInfo.store_id];
        }
    }
    [paramItem setValue:colorItemArray forKey:@"color_id_in"];
    
    if ([_modalObj.string_itemCondition isEqualToString:@"New"]) {
        [paramItem setValue:@"0" forKey:@"condition_eq"];
    }
    else if ([_modalObj.string_itemCondition isEqualToString:@"Used"]) {
        [paramItem setValue:@"1" forKey:@"condition_eq"];
    }
    else {
        [paramItem setValue:@"" forKey:@"condition_eq"];
    }
    [paramItem setValue: ([_modalObj.string_gender isEqualToString:@"Male"]?@"0":@"1") forKey:@"gender_eq"];
    
    NSMutableArray* sizeItemArray = [[NSMutableArray alloc] init];
    
    for(ISUserInfo* sizeInfo in araysSize){
        if (sizeInfo.isSelected) {
            [sizeItemArray addObject:sizeInfo.item_id];
        }
    }
    [paramItem setValue:sizeItemArray forKey:@"size_id_in"];
    [paramItem setValue:_modalObj.string_itemSort forKey:@"s"];
    [paramItem setValue:@"" forKey:@"title_cont"];
    
     NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:paramItem forKey:@"q"];
    [[ISServiceHelper helper] request:param apiName:apiSearch method:POST completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 if (itemPageNumber == 1)
                     [self.itemArrayData removeAllObjects];
                 [self.itemArrayData addObjectsFromArray:[self parseTrendingItemsData:[resultDict objectForKeyNotNull:kItems expectedObj:[NSArray array]]]];
                 [self apiCallForSelection];
                 self.itemPagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
                 [self.collctionView_Thing reloadData];
                 
                 if (isStoreSearch)
                     [self makeApiCallToStoreSearch];
             }
        });
     }];
}

-(void)makeApiCallToStoreSearch
{
NSString *apiSearch = [NSString stringWithFormat:@"stores/store_search_from_filter?page=%ld",(long)storePageNumber];
    
    NSMutableDictionary *paramStore = [[NSMutableDictionary alloc] init];
    [paramStore setValue:@"" forKey:@"categories_id_eq"];
    
    NSMutableArray* brandStoreArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in arrayBrandName){
        if (sizeInfo.isSelected) {
            [brandStoreArray addObject:sizeInfo.string_Product_Id];
        }
    }
    [paramStore setValue:brandStoreArray forKey:@"items_brand_id_in"];
    
    NSMutableArray* colorStoreArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in arrayColor){
        if (sizeInfo.isSelected) {
            [colorStoreArray addObject:sizeInfo.store_id];
        }
    }
    [paramStore setValue:colorStoreArray forKey:@"items_color_id_in"];
    
    
    if ([_modalObj.string_itemCondition isEqualToString:@"New"]) {
        [paramStore setValue:@"0" forKey:@"items_condition_eq"];
    }
    else if ([_modalObj.string_itemCondition isEqualToString:@"Used"]) {
        [paramStore setValue:@"1" forKey:@"items_condition_eq"];
    }
    else {
        [paramStore setValue:@"" forKey:@"items_condition_eq"];
    }
    [paramStore setValue:([_modalObj.string_gender isEqualToString:@"Male"]?@"0":@"1")  forKey:@"gender_eq"];
    
    //size
    NSMutableArray* sizeStoreArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in araysSize){
        if (sizeInfo.isSelected) {
            [sizeStoreArray addObject:sizeInfo.item_id];
        }
    }
    [paramStore setValue:sizeStoreArray forKey:@"items_size_id_in"];
    [paramStore setValue:@"" forKey:@"items_title_con"];
    
     NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setValue:paramStore forKey:@"store_q"];
    [[ISServiceHelper helper] request:param apiName:apiSearch method:POST completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (storePageNumber == 1)
                 [self.storeArrayData removeAllObjects];
             [self.storeArrayData addObjectsFromArray:[self parseTrendingItemsData:[resultDict objectForKeyNotNull:@"stores" expectedObj:[NSArray array]]]];
             //[self apiCallForSelection];
             self.storePagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
             [self.collctionView_Thing reloadData];
         });
     }];
}
-(void)makeApiToRemoveStoreFavourite:(ISUserInfo *)storeInfo
{
    NSString *apiName = [NSString stringWithFormat:@"stores/%lu/remove_favourite", (unsigned long)storeInfo.id];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:DELETE completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 storeInfo.isSelected = !storeInfo.isSelected;
                 [self.collctionView_Thing reloadData];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
         });
     }];
}
-(void)makeApiToAddStoreFavourite:(ISUserInfo *)storeInfo
{
    NSString *apiName = [NSString stringWithFormat:@"stores/%lu/add_favourite", (unsigned long)storeInfo.id];
    
    [[ISServiceHelper helper] request:nil apiName:apiName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 storeInfo.isSelected = !storeInfo.isSelected;
                 [self.collctionView_Thing reloadData];
             }
             else
                 [self showErrorAlertWithTitle: [error localizedDescription]];
         });
     }];
}
-(void)apiCallForSelection
{
    NSMutableDictionary*param = [[NSMutableDictionary alloc] init];
    [param setValue:self.categoryArrayId forKey:@"category_id"];
    [[ISServiceHelper helper] request:param apiName:[NSString stringWithFormat:@"stores/filterlist_bycategories"] method:POST completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error == nil) {
                 
                 [arrayColor removeAllObjects];
                 [araysSize removeAllObjects];
                 [arrayBrandName removeAllObjects];
                 [arrayCondition removeAllObjects];
                 [arrayGender removeAllObjects];

                 [self parseFilterData:[resultDict objectForKeyNotNull:@"filter" expectedObj:[NSDictionary dictionary]]];
                 [self.tableView_SizeSelection reloadData];
             }
         });
     }];
}
-(void)parseFilterData:(NSDictionary *)filterProductData
{
    for (NSMutableDictionary *dicColor in [filterProductData objectForKeyNotNull:@"colors" expectedObj:[NSArray array]]) {
        ISUserInfo* modalColorObj = [[ISUserInfo alloc] init];
        modalColorObj.store_id = [dicColor objectForKeyNotNull:@"id" expectedObj:@""];
        modalColorObj.isSelected = NO;
        if (arrayColor.count == 0) {
            modalColorObj.string_itemColor = @"All";
            [arrayColor addObject:modalColorObj];
        }
        else{
            modalColorObj.string_itemColor = [dicColor objectForKeyNotNull:@"name" expectedObj:@""];
            [arrayColor addObject:modalColorObj];
        }
    }
    for (NSMutableDictionary *dicSize in [filterProductData objectForKeyNotNull:@"sizes" expectedObj:[NSArray array]]) {
        ISUserInfo* modalSizeObj = [[ISUserInfo alloc] init];
        modalSizeObj.item_id = [dicSize objectForKeyNotNull:@"id" expectedObj:@""];
        modalSizeObj.isSelected = NO;
        if (araysSize.count == 0) {
            modalSizeObj.string_itemSize = @"All";
            [araysSize addObject:modalSizeObj];
        }
        else{
            modalSizeObj.string_itemSize = [dicSize objectForKeyNotNull:@"name" expectedObj:@""];
            [araysSize addObject:modalSizeObj];
        }
        
    }
    for (NSMutableDictionary *dicBrand in [filterProductData objectForKeyNotNull:@"brands" expectedObj:[NSArray array]]) {
        ISUserInfo* modalBrandObj = [[ISUserInfo alloc] init];
        modalBrandObj.string_Product_Id = [dicBrand objectForKeyNotNull:@"id" expectedObj:@""];
        modalBrandObj.isSelected = NO;
        if(arrayBrandName.count == 0){
            modalBrandObj.string_Product_Name = @"All";
            [arrayBrandName addObject:modalBrandObj];
        }
        else{
            modalBrandObj.string_Product_Name= [dicBrand objectForKeyNotNull:@"name" expectedObj:@""];
            [arrayBrandName addObject:modalBrandObj];
        }
    }
    for (NSString * string in @[@"All",@"New",@"Used"]) {
        ISUserInfo* modalConditionObj = [[ISUserInfo alloc] init];
        modalConditionObj.isSelected = NO;
        modalConditionObj.string_itemCondition = string;
        [arrayCondition addObject:modalConditionObj];
    }
    
    for (NSString * string in [filterProductData objectForKeyNotNull:@"gender" expectedObj:[NSArray array]]) {
        
        ISUserInfo* modalGenderObj = [[ISUserInfo alloc] init];
        if ([[NSString stringWithFormat:@"%@", string] isEqualToString:@"0"]) {
            modalGenderObj.isSelected = NO;
            modalGenderObj.string_gender = @"Male";
            [arrayGender addObject:modalGenderObj];
        }
        else{
            modalGenderObj.isSelected = NO;
            modalGenderObj.string_gender = @"Female";
            [arrayGender addObject:modalGenderObj];
        }
    }
}
-(NSMutableArray*)parseTrendingItemsData:(NSArray *)itemsArray
{
    NSMutableArray *popularStoresArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic  in itemsArray)
    {
        ISUserInfo *productInfo = [ISUserInfo parseDataFromDict:dic];
        [productInfo setIsSelected:[[dic objectForKeyNotNull:kIs_Favourite] boolValue]];
        [productInfo setFull_name:[dic objectForKeyNotNull:@"fullname" expectedObj:[NSString string]]];
        _modalObj.string_Category_id =[dic objectForKeyNotNull:@"category_id" expectedObj:[NSString string]];
        [popularStoresArray addObject:productInfo];
    }
    return popularStoresArray;
}
#pragma mark - Alert Warning Method
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}
@end
