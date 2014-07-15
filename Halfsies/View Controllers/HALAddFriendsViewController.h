//
//  AddFriendsViewController.h
//  PhotoTest1
//
//  Created by Mitchell Porter on 1/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface HALAddFriendsViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, retain) UITableView *addFriendsTableView;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) UIButton *addFriendButton;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) MBProgressHUD *refreshHUD;

-(IBAction)finishedAddingFriends;

@end
