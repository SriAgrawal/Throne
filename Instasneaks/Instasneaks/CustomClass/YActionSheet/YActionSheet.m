//
//  YSortActionSheet.m
//
//  Created by yuvraj on 12/01/15.
//  Copyright (c) 2015 yuvrajsinh. All rights reserved.
//

#import "YActionSheet.h"

#define TITLE_VIEW_HEIGHT 54.0
#define TABLE_ROW_HEIGHT 53.0

#define kYActionTitleColor [UIColor colorWithRed:187/255.0 green:187/255.0 blue:200/255.0 alpha:1.0]
#define kYActionButtonTitleColor [UIColor blackColor]
#define kYOptionTextColor [UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1.0]
#define kYActionSeparatorColor [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]
#define kYActionCancelButtonColor [UIColor colorWithRed:234.0/255.0 green:89.0/255.0 blue:106.0/255.0 alpha:1.0]

@implementation YActionSheet{
    NSString *title;
    NSArray *otherTitles;
    UITableView *tableViewOptions;
    BOOL dismissOnSelect;
    UIButton *btnDismiss;
}

@synthesize selectedIndex = _selectedIndex;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithTitle:(NSString *)titleText otherButtonTitles:(NSArray *)buttonTitles dismissOnSelect:(BOOL)dismiss{
    if (self = [super init]){
        title = [NSString stringWithString:titleText];
        otherTitles = [NSArray arrayWithArray:buttonTitles];
        dismissOnSelect = dismiss;
        _selectedIndex = 0;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setupDismissView];
        // Setup TableView
        [self setupTableView];
    }
    return self;
}

#pragma mark - View Setup Methods
- (void)setupDismissView{
    btnDismiss = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDismiss.backgroundColor = [UIColor clearColor];
    btnDismiss.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [btnDismiss addTarget:self action:@selector(dissmissActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDismiss];
}


- (void)setupTableView{
    // Add TableView to show options
    tableViewOptions = [[UITableView alloc] initWithFrame:self.frame];
    tableViewOptions.backgroundColor = [UIColor whiteColor];
    tableViewOptions.dataSource = self;
    tableViewOptions.delegate = self;
    tableViewOptions.bounces = NO;
    tableViewOptions.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewOptions.showsVerticalScrollIndicator = NO;
    tableViewOptions.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:tableViewOptions];
}

#pragma mark - Show/Hide ActionSheet
- (void)showInViewController:(UIViewController *)inController withYActionSheetBlock:(YActionBlock)handler{
    blockHandler = handler;
    
    CGRect frame = inController.view.frame;
    self.frame = frame;
    btnDismiss.frame = frame;

    // Calculate Height for TableView
    CGFloat optionsHeight = otherTitles.count * TABLE_ROW_HEIGHT;
    CGFloat totalHeight = (title.length ? TITLE_VIEW_HEIGHT : 0.0) + optionsHeight;
    // Defalut set table frame to out of screen
    CGRect tableFrame = CGRectMake(0.0, frame.size.height, frame.size.width, totalHeight);
    tableViewOptions.frame = tableFrame;
    
    [inController.view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        
        // Animate TableView from bottom
        CGRect newFrame = tableViewOptions.frame;
        newFrame.origin.y = frame.size.height-totalHeight;
        tableViewOptions.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    [tableViewOptions reloadData];
}

- (void)dissmissActionSheet{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        // Animate TableView from bottom
        CGRect newFrame = tableViewOptions.frame;
        newFrame.origin.y = self.frame.size.height;
        tableViewOptions.frame = newFrame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Button Clicks
- (void)btnCancelActionSheetClick:(id)sender{
    if (blockHandler) {
        blockHandler(-1, YES);
    }
    
    [self dissmissActionSheet];
}

- (void)btnDismissActionSheetClick:(id)sender{
    
    if (blockHandler) {
        blockHandler(self.selectedIndex, NO);
    }
    
    [self dissmissActionSheet];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABLE_ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (title.length ? TITLE_VIEW_HEIGHT : 0.0);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, TITLE_VIEW_HEIGHT)];
    lblTitle.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f  blue:250/255.0f  alpha:1.0f];
    lblTitle.textColor = kYActionTitleColor;
    lblTitle.font = NEO_SANS_PRO_REGULAR(15);
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    lblTitle.text = title;
    
    UIView *viewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0.0, lblTitle.frame.size.height-1, lblTitle.frame.size.width, 1.0)];
    viewSeperator.backgroundColor = kYActionSeparatorColor;
    viewSeperator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [lblTitle addSubview:viewSeperator];
    
    return (title.length ? lblTitle : nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return otherTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];

    UIView *viewSeperator = [cell.contentView viewWithTag:1111];
    if (!viewSeperator) {
        viewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, self.frame.size.width, 1.0)];
        viewSeperator.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        viewSeperator.tag = 1111;
        viewSeperator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:viewSeperator];
    }
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1234];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 11.0, 20.0, 20.0)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.tag = 1234;
        [cell.contentView addSubview:imgView];
    }
    
    // Check for selected/ non-selected row
    if (self.selectedIndex==indexPath.row){
        [imgView setImage:[UIImage imageNamed:@"check"]];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else
        [imgView setImage:[UIImage imageNamed:@"uncheck"]];
    
    cell.textLabel.font = NEO_SANS_PRO_REGULAR(16);
    cell.textLabel.backgroundColor = [UIColor clearColor];
    NSString *strLast = [otherTitles lastObject];
    if ([strLast isEqualToString:@""])
    {
           cell.textLabel.textColor = (((otherTitles.count-2) == indexPath.row) ? kYActionCancelButtonColor : kYOptionTextColor);
    }
    else{
      cell.textLabel.textColor = (((otherTitles.count-1) == indexPath.row) ? kYActionCancelButtonColor : kYOptionTextColor);
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [otherTitles objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    if (blockHandler) {
        blockHandler(self.selectedIndex, ((otherTitles.count-1) == indexPath.row));
    }
    [self dissmissActionSheet];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Unselect this cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1234];
    if (imgView) {
        [imgView setImage:[UIImage imageNamed:@"uncheck"]];
    }
}


@end
