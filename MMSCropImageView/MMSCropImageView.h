//
//  MMSCropImageView.h
//  CropDemo
//
//  Created by William Miller on 12/7/15.
//  Copyright © 2015 Miller Mobilesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSCropImageView : UIImageView <UIGestureRecognizerDelegate>

-(UIImage*)crop;

@end
