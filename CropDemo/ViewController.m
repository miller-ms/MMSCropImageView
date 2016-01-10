//
//  ViewController.m
//  CropDemo
//
//  Created by William Miller on 12/1/15.
//  Copyright © 2015 Miller Mobilesoft. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Cropping.h"

@interface ViewController () <UIGestureRecognizerDelegate>

{
    
    CGPoint dragOrigin;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dragOrigin = CGPointZero;
    
    [self.cropView removeFromSuperview];
    
//    [self.imageView addSubview:self.cropView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)crop:(UIButton *)sender {
    
    UIImage* croppedImage; // = self.imageView.image;
    
    croppedImage =  [self.imageView crop];
    
    self.croppedView.image = croppedImage;
}




@end
