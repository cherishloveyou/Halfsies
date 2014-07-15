

#import "SearchViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SearchViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *firstButtonImage = [UIImage imageNamed:@"donebutton"];
    
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    
    
    UIButton *someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:firstButtonImage forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(doneAddingFriends)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    CGRect frame2 = CGRectMake(0, 0, 25, 25);
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"backarrow2"];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:frame2];
    
    
    
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];
    
    [self.searchBar setShowsCancelButton:NO];
    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.searchBar setPlaceholder:@"Search by username"];
    
    [self.searchBar setDelegate:self];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    ;
    
    // Setup the parse query here.
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:self.searchBar.text];
    
    self.parseUsers = [query findObjects];
   
    
    [self.tableView reloadData];
    
    if (self.parseUsers.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Username Not Found" message:@"Remember that usernames are case sensitive." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parseUsers count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (self.parseUsers.count > 0) {
        PFUser *user = [self.parseUsers objectAtIndex:indexPath.row];
        
        
        NSString *firstNameForTableView = user.username;
        // Create cell button
        
        UIImage *addUserButtonImage = [UIImage imageNamed:@"addfriend1"];
        
        UIImage *addUserButtonImageHighlighted = [UIImage imageNamed:@"addfriend10selected"];
        
        UIButton *addUserButton = [[UIButton alloc]init];
        
        addUserButton.frame = CGRectMake(237, 7, 70, 30);
        
        [addUserButton setImage:addUserButtonImage forState:UIControlStateNormal];
        [addUserButton setImage:addUserButtonImageHighlighted forState:UIControlStateHighlighted];
        [addUserButton setImage:addUserButtonImageHighlighted forState:UIControlStateSelected];
        
        [addUserButton addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        // Set cell button's tag.
        
        addUserButton.tag = indexPath.row;
        
        // Set cell's title.
        
        [cell.textLabel setText:firstNameForTableView];
        
        // Set cell's subtitle
        
        
        // Add button to cell's content view.
        
        [cell.contentView addSubview:addUserButton];
    }
    return cell;
}

- (void) handleTouchUpInside:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    PFUser *currentUser = [PFUser currentUser];

    UIButton *cellButton = (UIButton *) sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:0];

    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
    
    // This takes all of the extra blank space out of the username before we place it inside the array.
    
    cell.detailTextLabel.text = [cell.detailTextLabel.text stringByReplacingOccurrencesOfString:@"    " withString:@""];
    
    // This if statement helps to both add names into the "usersToAddToFriendsList" array and take them out.
    
    if (sender.state == 5) {

        PFRelation *friendsRelation = [[PFUser currentUser]relationforKey:@"friendsRelation"];
        
        PFUser *user = [self.parseUsers objectAtIndex:indexPath.row];
        
        [friendsRelation addObject:user];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"%@ %@", error, [error userInfo]);
            }
        }];

        [PFCloud callFunction:@"editUser" withParameters:@{
                                                           @"userId": user.objectId
                                                           }];
    } else {

        // This removes the username from the array.
        
        PFRelation *friendsRelation = [[PFUser currentUser]relationforKey:@"friendsRelation"];
        PFUser *user = [self.parseUsers objectAtIndex:indexPath.row];
        
        [friendsRelation removeObject:user];
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                NSLog(@"%@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (IBAction) handleBack
{
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction) doneAddingFriends
{
    [self performSegueWithIdentifier:@"searchFriendsToMCVC" sender:self];
}

@end
