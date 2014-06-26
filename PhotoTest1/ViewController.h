#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property UIImagePickerController * pickerController;

-(IBAction)showCameraUI;


@end
