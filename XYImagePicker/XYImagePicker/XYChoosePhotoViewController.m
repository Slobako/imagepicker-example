//
//  XYChoosePhotoViewController.m
//  XYImagePicker
//
//  Created by Slobodan Kovrlija on 10/14/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import "XYChoosePhotoViewController.h"
#import "XYAddPhotoViewController.h"

@interface XYChoosePhotoViewController ()

@property (strong, nonatomic)UIImage *pickedImage;
@property (strong, nonatomic)UIImagePickerController *picker;
@property (nonatomic)BOOL isImageSaved;

@end

@implementation XYChoosePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)addPhotoTapped:(id)sender {
    
    //first create an alert with no title nor message, with preferred style “action sheet”
    UIAlertController *addPhotoAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //next, we have to add actions to our alert; we will need three - “cancel action”, “take a photo action” and “choose from library action”
    
    //add alert action for “cancel”
    //since “cancel” doesn’t evoke any further action other then dismissing the alert controller, we can leave the completion handler block empty
    [addPhotoAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    //add alert action for “take a photo”
    //here, we want to start the camera to take a photo when this action is tapped, so we add a call to “takePhoto” method in the completion block
    [addPhotoAlert addAction:[UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }]];
    
    //add alert action for “choose from library”
    //here, like above, we need to call a “chooseFromLibrary” method in the completion block in case a user chooses this action
    [addPhotoAlert addAction:[UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseFromLibrary];
    }]];
    
    //and of course, the most important part is to make sure to display the alert controller
    [self presentViewController:addPhotoAlert animated:YES completion:nil];
    
}

- (void)takePhoto {
    
    //create a new instance of the UIImagePickerController
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //assign the delegate to self
    imagePickerController.delegate = (id)self;
    //define the controller’s presentation style - modal; OverFullScreen - because we want the views beneath the presented content to remain in the view hierarchy when the presentation finishes
    imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    //define the source type for the controller, in this case it’s a camera
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //if you want to allow image cropping, set the allowEditing property to YES
    imagePickerController.allowsEditing = YES;
    
    //for a smoother user experience, assign the set imagePickerController to the picker property of the current view controller
    self.picker = imagePickerController;
    
    //present the picker controller
    [self presentViewController:self.picker animated:YES completion:nil];
    
    //since the picked image isn’t saved to the library, set this tag to NO (you’ll be checking its value later)
    self.isImageSaved = NO;
}

- (void)chooseFromLibrary {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = (id)self;
    imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    //the only difference in setting up the image picker is in this step, where we want to make sure the source type is set to photo library
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    
    self.picker = imagePickerController;
    
    [self presentViewController:self.picker animated:YES completion:nil];
    
    //since the image from the gallery is already saved, we set this tag to YES
    self.isImageSaved = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //make sure to put the key for "edited image" here, not "original" (if editing is already allowed, otherwise the original would be saved, not cropped)
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //assign this image to pickedImage
    self.pickedImage = image;
    
    //if the image was not chosen from the library (i.e. it hasn’t been saved), save it
    if (!self.isImageSaved) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    }
    
    //dismiss the picker controller (camera or photo library view) and when that action is completed, segue to the next view controller
    [picker dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"addPhotoSegue" sender:self];
    }];
    
}

- (void) image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Image not saved" preferredStyle:UIAlertControllerStyleAlert];
        
        [errorAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
    }
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     //destination view controller is of class XYAddPhotoViewController and its property addedImage should be equal to pickedImage
     XYAddPhotoViewController *destVC = segue.destinationViewController;
     destVC.addedImage = self.pickedImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
