//
//  FindFriendsViewController.h
//  Halfsies
//
//  Created by Mitchell Porter on 5/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PotentialFriend.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"


@interface FindFriendsViewController : UIViewController <MBProgressHUDDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


@property (nonatomic, strong) PFUser *currentUser;



@property (nonatomic, retain) UITableView *addFriendsTableView;

@property (nonatomic, strong) UITableViewCell *cell;


@property (nonatomic, strong) UIButton *addFriendButton;



@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;



@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) MBProgressHUD *refreshHUD;

@property (strong, nonatomic) NSMutableArray *friends;

@property (strong, nonatomic) NSArray *parseUsers;




-(void)handleBack;
-(void)finishedAddingFriends;





@end
