//
//  LaunchViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/28/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import "LaunchViewController.h"
#import "PotentialFriend.h"

//



@interface LaunchViewController () 

@end

@implementation LaunchViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"view did load for the launch view controller.");
    
    NSLog(@"Status bar height: %f", [UIApplication sharedApplication].statusBarFrame.size.height
          );
    
    NSLog(@"Navigation bar height: %f", self.navigationController.navigationBar.bounds.size.height);
    
    //[self.navigationController setNavigationBarHidden:YES];
    
    
    
    //[self.navigationItem setBackBarButtonItem:self.backBarButton];

    
    //
    
    
    //[self.navigationItem hidesBackButton];
  /*  UIImage* firstButtonImage = [UIImage imageNamed:@"nextbutton3"];;
    
    NSLog(@"size of image: %@", NSStringFromCGSize(firstButtonImage.size));
    
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    
    //I think 30 is a good height. Now just increase the width.
    
    UIButton * someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:firstButtonImage forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(didTapSignup:)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.backBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.backBarButtonItem = self.backBarButton;
    
    */
    
    
    
    //
    
    
                                             
    //self.launchBackground.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    NSLog(@"self.launchBackground.frame: %@", NSStringFromCGRect(self.launchBackground.frame));
    
    
    self.launchBackground.image = [UIImage imageNamed:@"launchBackground"];
    
    
    if([UIScreen mainScreen].bounds.size.height == 480) {
        
        
        //self.launchBackground.image = [UIImage imageNamed:@"launchBackground"];

        
        
    } else {
        
        
        //self.launchBackground.image = [UIImage imageNamed:@"halfsies-launch-640x1136-vc-background-test1-without-buttons"];

        
    }
    
    
    NSLog(@"self.launchBackground.image: %@", self.launchBackground.image);
    
    NSLog(@"The height of your screen size is: %f", [UIScreen mainScreen].bounds.size.height);
    
    NSLog(@"The width of your screen size is: %f", [UIScreen mainScreen].bounds.size.width);
    
    
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
   
    
    NSLog(@"NSLOG FOR THE NSUSERDEFAULT: %@", [standardDefaults objectForKey:@"testing"]);
    
    //This creates a new object for Parse for testing purposes since I just signed up.
    
    //PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //[testObject setObject:@"bar" forKey:@"foo"];
    //[testObject save];
    
    
    
    
    PotentialFriend *potentialFriend = [[PotentialFriend alloc]init];
    potentialFriend.name = @"Steve";
    NSLog(@"Is potentialFriend working?: %@", potentialFriend.name);
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    
    NSLog(@"viewWillAppear");
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:NO];
    [self.navigationController setNavigationBarHidden:NO];    // it shows

    NSLog(@"viewWillDisappear.");
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login {
    
    

    [self performSegueWithIdentifier:@"launchToLoginSegue" sender:self];
    
}

-(IBAction)signup {
    

[self performSegueWithIdentifier:@"launchToSignupSegue" sender:self];
    

}

- (IBAction)termsOfService {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.halfsies.co/terms"]];
    
}



@end
