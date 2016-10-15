//
//  XYAddPhotoViewController.m
//  XYImagePicker
//
//  Created by Slobodan Kovrlija on 10/14/16.
//  Copyright © 2016 Slobodan Kovrlija. All rights reserved.
//

#import "XYAddPhotoViewController.h"

@interface XYAddPhotoViewController ()

@end

@implementation XYAddPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addedPhotoImageView.image = self.addedImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
