//
//  LaunchViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/28/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import "HALLaunchViewController.h"

@interface HALLaunchViewController ()

@end

@implementation HALLaunchViewController


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
    

    self.launchBackground.image = [UIImage imageNamed:@"launchBackground"];
    
    
    if([UIScreen mainScreen].bounds.size.height == 480) {
        
        

        
        
    } else {
        
        
        
        
    }
    
    
    
    
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
   
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:NO];
    [self.navigationController setNavigationBarHidden:NO];    // it shows

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
