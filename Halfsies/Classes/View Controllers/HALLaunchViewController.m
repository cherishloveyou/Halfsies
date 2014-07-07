//
//  LaunchViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/28/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import "HALLaunchViewController.h"

@interface HALLaunchViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *launchBackground;

/** Segue to the TOS screen */
- (IBAction)termsOfService;

@end

@implementation HALLaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.launchBackground.image = [UIImage imageNamed:@"launchBackground"];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        // is something supposed to go here?
    } else {
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)termsOfService
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.halfsies.co/terms"]];
}

@end
