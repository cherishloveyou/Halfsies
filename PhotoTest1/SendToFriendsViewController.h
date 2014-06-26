//
//  SendToFriendsViewController.h
//  PhotoTest1
//
//  Created by Mitchell Porter on 2/28/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SendToFriendsViewController : UIViewController <UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;

//This is the property that we are using in the Media Capture VC to pass the captured photo file to this view controller.

@property (nonatomic, retain) UIImage *halfsiesPhotoToSend;

@property (nonatomic, strong) UIButton *sendToUserButton;

@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, strong) NSMutableArray *finalUsersToGoHalfsiesWith;

@property (nonatomic, strong) NSMutableArray *recipients;


@property (nonatomic, strong) UIAlertView *alertView1;
@property (nonatomic, strong) UIAlertView *alertView2;

-(IBAction)finishedChoosingUsersToGoHalfsiesWith;
-(IBAction)handleBack;

@end
