//
//  ISInviteFriendsVC.m
//  Instasneaks
//
//  Created by Suresh patel on 25/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISInviteFriendsVC.h"

static NSString *CellIdentifier = @"inviteFriendsCell";

@interface ISInviteFriendsVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView        * tableView_inviteFriends;
@property (weak, nonatomic) IBOutlet UISearchBar        * searchBar_inviteFriends;

@property (strong, nonatomic) KTSContactsManager        * contactsManager;
@property (strong, nonatomic) NSMutableArray            * contactsDataArray;
@property (strong, nonatomic) NSMutableArray            * searchedDataArray;
@property (strong, nonatomic) NSMutableArray            * dataSourceArray;
@property (strong, nonatomic) NSMutableArray            * phoneDataArray;

@property (nonatomic, assign) bool isFiltered;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraints;


@end

@implementation ISInviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod{
    
    _phoneDataArray = [[NSMutableArray alloc] init];
    _dataSourceArray  = [[NSMutableArray alloc] init];
    [self.tableView_inviteFriends registerNib:[UINib nibWithNibName:@"ISInviteFriendsCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{                                                                                      NSFontAttributeName: [UIFont fontWithName:@"NeoSansPro-Regular" size:14],                                                                                                 }];
    // observer for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    [self loadData];
}

- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.contactsDataArray = [NSMutableArray arrayWithArray:contacts];
         
         for (int i =0 ; i<self.contactsDataArray.count; i++)
         {
             ISUserInfo *contactInfo = [[ISUserInfo alloc] init];
             contactInfo.isSelected = NO;
             
             NSDictionary *contact = [self.contactsDataArray objectAtIndex:i];
             contactInfo.string_UserName = [contact objectForKey:@"name"];
             contactInfo.itemImage = [contact objectForKey:@"image"];
             for (NSDictionary *dic in [contact objectForKey:@"phones"])
             {
                 contactInfo.string_ContactNumber = [dic objectForKey:@"value"];
             }
             [_dataSourceArray addObject: contactInfo];
         }
         [self.tableView_inviteFriends reloadData];
     }];
}
- (void)keyboardDidShow: (NSNotification *) notif
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    self.tableBottomConstraints.constant = 216.0f;
}
- (void)keyboardDidHide: (NSNotification *) notif
{
     //self.tableBottomConstraints.constant = 0.0f;
}
- (void)hideGesture:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    self.tableBottomConstraints.constant = 0.0f;
}
#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isFiltered ? self.searchedDataArray.count : self.dataSourceArray.count);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ISInviteFriendsCell *cell = (ISInviteFriendsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
//    NSDictionary *contactInfo = [(self.isFiltered ? self.dataSourceArray : self.contactsDataArray) objectAtIndex:indexPath.row];

    ISUserInfo *obj = [(self.isFiltered ? self.searchedDataArray : self.dataSourceArray) objectAtIndex:indexPath.item];
    cell.button_checkBox.selected = obj.isSelected;
    [cell.button_checkBox addTarget:self action:@selector(checkBoxButtonAction:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.label_friendName.text = obj.string_UserName;
    UIImage *image = obj.itemImage;
    cell.imageView_friendImage.image = (image != nil) ? image : [UIImage imageNamed:@"ico_user"];

    return cell;
}
#pragma mark - UISearchBar Delegate Methods

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    //NSLog(@"searchBar ... text.length: %d", text.length);
    
    if(text.length == 0)
    {
        self.isFiltered = NO;
        [searchBar resignFirstResponder];
        self.tableBottomConstraints.constant = 0.0f;
    }
    else
    {
        self.searchedDataArray = [[NSMutableArray alloc] init];
        self.isFiltered = YES;
        for (ISUserInfo* item in self.dataSourceArray)
        {
            //case insensative search - way cool
            if ([item.string_UserName rangeOfString:text options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [self.searchedDataArray addObject:item];
            }
        }
    }//end if-else
    
    [self.tableView_inviteFriends reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //User hit Search button on Keyboard
    [searchBar resignFirstResponder];
    self.tableBottomConstraints.constant = 0.0f;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableBottomConstraints.constant = 0.0f;
    self.isFiltered = NO;
    [self.tableView_inviteFriends reloadData];
}
#pragma mark - UIButton Actions
- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneButtonAction:(id)sender
{
    [self.phoneDataArray removeAllObjects];
    for (ISUserInfo *obj in self.dataSourceArray) {
        if (obj.isSelected) {
            if ([obj.string_ContactNumber containsString:@"+"]== NO)
            {
                BDVCountryNameAndCode *bDVCountryNameAndCode = [[BDVCountryNameAndCode alloc] init];
                
                obj.string_ContactNumber = [NSString stringWithFormat:@"+%@%@",[bDVCountryNameAndCode prefixForCurrentLocale],obj.string_ContactNumber];
                [self.phoneDataArray addObject:obj.string_ContactNumber];
            }
            [self.phoneDataArray addObject:obj.string_ContactNumber];
        }
    }
    [self makeApiCallToMMS];
}
-(void)checkBoxButtonAction:(UIButton *)button withEvent:(UIEvent *)event{
    
    NSIndexPath * indexPath = [self.tableView_inviteFriends indexPathForRowAtPoint:[[[event touchesForView:button] anyObject] locationInView:self.tableView_inviteFriends]];
    
    ISUserInfo *obj = [(self.isFiltered ? self.searchedDataArray : self.dataSourceArray) objectAtIndex:indexPath.item];
    obj.isSelected = !obj.isSelected;
    
    [self.tableView_inviteFriends reloadData];
}
- (IBAction)inviteALLAction:(id)sender
{
    for (ISUserInfo *contactInfo in _dataSourceArray)
    {
        contactInfo.isSelected = YES;
    }
    [self.tableView_inviteFriends reloadData];
}

#pragma mark - Web Service Method For InviteFriend Via MMS
-(void)makeApiCallToMMS
{
    NSString *apiName = @"user/send_message_twilio";
    NSMutableDictionary *userParam = [[NSMutableDictionary alloc] init];
    [userParam setValue:self.phoneDataArray forKey:@"mobile"];
    [userParam setValue:[NSString stringWithFormat:@"“THIS APP IS LIT! DOWNLOAD AND GET $5 OFF OF YOUR FIRST ORDER: https://throne.app.link/dashboard?Code=%@",_promoCodeString]forKey:@"link"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:userParam forKey:@"user"];
    [[ISServiceHelper helper] request:param apiName:apiName method:POST completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            if([[resultDict objectForKey:kCode]integerValue] == 200)
                            {
                                [self showErrorAlertWithTitle:[resultDict objectForKey:kMessage]];
                            }
                            else
                            {
                                [self showErrorAlertWithTitle:[resultDict objectForKey:kMessage]];
                            }
                        });
     }];
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error
                                 andButtonsWithTitle:@[@"OK"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                           [self.tableView_inviteFriends reloadData];
                                       }];
}
@end