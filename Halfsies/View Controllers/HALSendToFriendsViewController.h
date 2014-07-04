//
//  SendToFriendsViewController.h
//  PhotoTest1
//
//  Created by Mitchell Porter on 2/28/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HALSendToFriendsViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, retain) UIImage *halfsiesPhotoToSend;
@property (nonatomic, strong) UIButton *sendToUserButton;
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) NSMutableArray *finalUsersToGoHalfsiesWith;
@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic, strong) UIAlertView *alertView1;
@property (nonatomic, strong) UIAlertView *alertView2;

- (IBAction)finishedChoosingUsersToGoHalfsiesWith;
- (IBAction)handleBack;

@end
