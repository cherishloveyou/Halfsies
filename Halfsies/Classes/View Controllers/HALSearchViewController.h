//
//  SearchViewController.h
//  Halfsies
//
//  Created by Mitchell Porter on 5/18/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HALSearchViewController : UIViewController <UISearchBarDelegate>

@property NSArray *parseUsers;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)doneAddingFriends;
-(IBAction)handleBack;

@end
