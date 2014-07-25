//
//  FinishedHalfsieVC.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 3/6/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALFinishedHalfsieVC.h"
#import <Social/Social.h>
#import<Accounts/Accounts.h>
#import "HALAppDelegate.h"
#import "HALInboxViewController.h"
#import <Parse/Parse.h>
#import "UIImage+Resize.h"

@interface HALFinishedHalfsieVC () <UIActionSheetDelegate, UIAlertViewDelegate, UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSString *recipientId;
@property (strong, nonatomic) NSString *originalSender;
@property (strong, nonatomic) NSString *twitterStatus;
@property (strong, nonatomic) UIAlertView *reportAlertView;
@property (strong, nonatomic) UIDocumentInteractionController *dic;

@end

@implementation HALFinishedHalfsieVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Final setup of View Controller
    [self setupNavigation];
    [self setupProperties];
    [self setupViews];
}

#pragma mark - Document Interaction Delegate
- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate
{
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}


#pragma mark - Instagram
- (void)shareToInstagram
{
    
     //Create white image of 640 x 640
     
     CGSize imageSize = CGSizeMake(640, 640);
     UIColor *fillColor = [UIColor whiteColor];
     UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
     CGContextRef context = UIGraphicsGetCurrentContext();
     [fillColor setFill];
     CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
     UIImage *whiteSquareImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
    
    
     //Scale down self.image
     CGSize size = CGSizeMake(360, 640);
     self.image = [self.image resizedImage:size interpolationQuality:kCGInterpolationLow];
    
     //Create the final image combining whiteSquareImage with self.image.
     //self.image should be placed in the center of whiteSquareImage
    
     CGSize newSize = CGSizeMake(640, 640);
     UIGraphicsBeginImageContext(newSize);
     
     // Use existing opacity as is
     [whiteSquareImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
     
     // Apply supplied opacity if applicable
     [self.image drawInRect:CGRectMake(140,0,360,640) blendMode:kCGBlendModeNormal alpha:0.8];
     
     UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
    
    
    UIImage *screenShot = finalImage;
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.igo"];
    [UIImagePNGRepresentation(screenShot) writeToFile:savePath atomically:YES];
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.igo"];
    NSURL *igImageHookFile = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath]];
    self.dic.UTI = @"com.instagram.photo";
    self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
    self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    [self.dic presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=MEDIA_ID"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        [self.dic presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
    }
    else
    {
        NSLog(@"No Instagram Found");
    }
}



#pragma mark - Setup View Controller's Properties
- (void)setupProperties
{
    
    
    self.senderName = [self.messagePassedFromInbox objectForKey:@"senderName"];
    self.recipientId = [self.messagePassedFromInbox objectForKey:@"recipientIds"];
    self.originalSender = [self.messagePassedFromInbox objectForKey:@"originalSender"];
    
    self.currentUser = [PFUser currentUser];
    
    
    PFFile *imageFile = [self.messagePassedFromInbox objectForKey:@"file"];
    
    self.imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
    
    self.imageData = [NSData dataWithContentsOfURL:self.imageFileURL];
    

}

#pragma mark - Setup View Controller's Views
- (void)setupViews
{
    if([UIScreen mainScreen].bounds.size.height == 568) {
        
        self.image = [[UIImage alloc]initWithData:self.imageData];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:self.image];
        imageView.frame = CGRectMake(0, 0, 320, 568);
        
        [self.view addSubview:imageView];
        [self.view sendSubviewToBack:imageView];
        
    } else {
        
        self.image = [[UIImage alloc]initWithData:self.imageData];
        
        UIImageView *imageView2 = [[UIImageView alloc]initWithImage:self.image];
        imageView2.frame = CGRectMake(0, -30, 320, 568);
        
        [self.view addSubview:imageView2];
        [self.view sendSubviewToBack:imageView2];
    }
}

#pragma mark - Naviation Methods
- (void)setupNavigation
{
    [self.navigationController setNavigationBarHidden:YES];
    
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Share Button Methods
- (IBAction)shareButton
{
    self.shareButtonForActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Report User" otherButtonTitles:@"Share on Instagram", @"Share on Twitter", @"Save to Library" ,@"Copy Share Link",nil];
    
    [self.shareButtonForActionSheet showInView:self.view];
}

#pragma mark - Action Sheet Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == self.shareButtonForActionSheet.destructiveButtonIndex) {
        
        self.reportAlertView = [[UIAlertView alloc]initWithTitle:@"Report User" message:@"By tapping the OK button, you will be reporting this user and the content they sent you as inappropriate." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        [self.reportAlertView show];
    }
    
    if (buttonIndex == 1) {
        NSLog(@"Instagram share button pressed.");
        [self shareToInstagram];
    }
    
    // Check if it's the correct action sheet and the delete button (the only one) has been selected.
    if (buttonIndex == 2) {
        
        NSLog(@"twitter2");
        //Twitter code from Techtopia
        
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                      ACAccountTypeIdentifierTwitter];
        
        [account requestAccessToAccountsWithType:accountType
                                         options:nil
                                      completion:^(BOOL granted, NSError *error)
         {
             
             if(error) {
                 
                 NSLog(@"There has been an error: %@", error);
             }
             
             
             if(granted == NO) {
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Halfsies needs permission to share to your twitter account. Please go to Settings > Privacy > Twitter and enable Halfsies." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     
                     [alertView show];
                     
                 });
                 
                 
             }
             
             
             
             
             if (granted == YES)
             {
                 // Get account and communicate with Twitter API
                 
                 
                 //Now that access has been granted, we need to place the Twitter account in an object.
                 
                 
                 NSArray *arrayOfAccounts = [account
                                             accountsWithAccountType:accountType];
                 
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount =
                     [arrayOfAccounts lastObject];
                     
                     
                     
                     if([self.currentUser.username isEqualToString:self.senderName]) {
                         
                         
                         self.twitterStatus = [[NSString alloc]initWithFormat:@"Just finished going halfsies with %@. #halfsies halfsies.co/app", self.originalSender];
                         
                         
                     }
                     
                     if(![self.currentUser.username isEqualToString:self.senderName]) {
                         
                         
                         
                         self.twitterStatus = [[NSString alloc]initWithFormat:@"Just finished going halfsies with %@. #halfsies halfsies.co/app", self.senderName];
                         
                     }
                     
                     NSDictionary *message = @{ @"status": self.twitterStatus};
                     
                     
                     NSURL *requestURL = [NSURL
                                          URLWithString:@"https://api.twitter.com"
                                          @"/1.1/statuses/update_with_media.json"];
                     
                     SLRequest *postRequest = [SLRequest
                                               requestForServiceType:SLServiceTypeTwitter
                                               requestMethod:SLRequestMethodPOST
                                               URL:requestURL parameters:message];
                     
                     postRequest.account = twitterAccount;
                     
                     
                     
                     [postRequest addMultipartData:self.imageData
                                          withName:@"media[]"
                                              type:@"image/jpeg"
                                          filename:@"image.jpg"];
                     
                     [postRequest setAccount:postRequest.account];
                     
                     
                     //Finally, we assign the object and post the request to the Twitter API.
                     
                     
                     
                     [postRequest
                      performRequestWithHandler:^(NSData *responseData,
                                                  NSHTTPURLResponse *urlResponse, NSError *error)
                      {
                              NSLog(@"Twitter HTTP response: %i",
                                    [urlResponse statusCode]);
                          
                          if(error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  UIAlertView *twitterShareFailure = [[UIAlertView alloc]initWithTitle:@"Failure" message:@"Something went wrong when trying to share to Twitter. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  
                                  [twitterShareFailure show];
                              });
                              
                          } else if (!error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  UIAlertView *twitterShareSuccess = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your finished halfsie was successfully shared to Twitter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  
                                  [twitterShareSuccess show];
                              });

                          }
                          
                      }];
                     
                 }
    
             }
 
         }];
}
    
 
    if(buttonIndex == 3) {
        
        
        
        
        if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Halfsies does not currently have permission to save photos to your library. Please go to Settings > Privacy > Photos and tap the button next to Halfsies." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
            [alertView show];
        }
        
        if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
            
            [library writeImageToSavedPhotosAlbum:self.image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if(error) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Halfsies does not currently have permission to save photos to your library. Please go to Settings > Privacy > Photos and tap the button next to Halfsies." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                    
                } else if (!error) {
                    
                    UIAlertView *librarySaveSuccessAlertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your finished halfsie was successfully saved to your photo library!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [librarySaveSuccessAlertView show];
               
                }
                
            }];
    
        }
        
        
        if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
            
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
            
            [library writeImageToSavedPhotosAlbum:self.image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if(error) {
                    
                    NSString *errorString = [[NSString alloc]initWithFormat:@"%@", error];
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                    
                } else if (!error) {
                    
                    UIAlertView *librarySaveSuccessAlertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your finished halfsie was successfully saved to your photo library!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [librarySaveSuccessAlertView show];
                }
                
            }];
       
        }
  
    }
    
    
    
    if(buttonIndex == 4) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.URL = self.imageFileURL;
    }
    
    
    if(buttonIndex == 5) {
        
        NSLog(@"old report");
}
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet

{
    
    
}

#pragma mark - Alert View Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.reportAlertView && buttonIndex == 1) {

        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - Back Button
- (IBAction)backButton
{
    HALInboxViewController *ivc;
    [self.navigationController pushViewController:ivc animated:YES];
}


@end
