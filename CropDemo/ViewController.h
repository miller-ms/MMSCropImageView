//
//  ViewController.h
//  CropDemo
//
//  Created by William Miller on 12/1/15.
//  Copyright © 2015 Miller Mobilesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragCropRectRecognizer.h"
#import "MMSCropImageView.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *cropView;
@property (weak, nonatomic) IBOutlet MMSCropImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *croppedView;
- (IBAction)crop:(UIButton *)sender;


@end

