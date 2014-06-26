#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//The above are the 2 delegates required for creating a media capture/camera app.

- (void)imagePickerController:pickerController didFinishPickingMediaWithInfo:(NSDictionary *)info;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]);
    NSLog(@"%hhd", [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]);
    NSLog(@"%hhd", [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]);
    NSLog(@"%hhd", [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)showCameraUI{
    
    //Initializes and allocates memory for the pcikerController
    
    UIImagePickerController * pickerController = [[UIImagePickerController alloc]init];
    
    //Sets the pickerController's media types to all available media types(both photo and video)
    
    pickerController.mediaTypes = [UIImagePickerController  availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    
    //Sets the pickerController's source type.

    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

    
    
    //Sets the pickerController's delegate to itself.
    
    pickerController.delegate = self;
    
    //Picker controller calls itself, and calls it's method and sets it's presentViewController to itself, makes it animated while bringing the user to the photo and video taking screen.
    

    [self presentViewController:pickerController animated:YES completion:nil];
    
   
}

//This implements ???
//Notice how an NSDictionary object called "info" is created.

- (void)imagePickerController:pickerController didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Below is the block of code that saves the photo or video to the camera roll.
    
    //This creates an NSString object called mediaType and then calls a method for the NSDictionary object named info.
    
    // objectForKey means "Returns the value associated with a given key." So when we type objectForKey:UIImagePickerControllerMediaType it is saying "Please return the value for the key called UIImagePickerControllerMediaType.
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    //Now we have an "if else" statement that depends on what type of value is actually returned for the key.
    
    //Our if statement says, if the media type returned is equal to the string object called kUTTypeImage, then create a UIImage object called image and call and set it to equal the result of calling a method for the NSDictionary object called "info", and the return the value of it's UIImagePickerControllerOriginalImage key.
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //After that it uses the UIImageWriteToSavedPhotosAlbum function and set's it's Parameters to whatever the image object was just set to, and then nil, nil, and nil.

        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
        
        // This is the "else" part of the "if else" statement.
        // We are now setting up the rules if the user decides to take and save a video.
        // If the mediaType variable contains a string value of "kUTTypeMovie" then we will run the body of code...
        // Here is the code body. We create an NSURL object called movieUrl and set it to a method call. The method call is for the info object and the method/message is objectForKey and then our input is whatever the UIImahePickerController MediaURL is set to.
        //The second statement in our code body is UISaveVideoAtPathToSavedPhotosAlbum which does exactly what it's name says and then it takes the parameters of a method, and then nil, nil, and nil.
        
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        NSURL *movieUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        UISaveVideoAtPathToSavedPhotosAlbum([movieUrl relativePath], nil, nil, nil);
        
        
    }
    
    //Once it is done executing the above if statement, it calls a method for the pickerController object, which is basically the entire screen when the user can take a picture ot video, and then calls it's method to dismiss the screen aka exit and returns back to the main app screen. The method being called is dismissModalViewControllerAnimated. We give an input of YES and then on the completion message we give an input of nil.
    
    [pickerController dismissViewControllerAnimated:YES completion:nil];
    
    
    
}





@end
