//
//  UIImage+Cropping.h
//
//  Created by William Miller on 10/28/15.
//  Copyright © 2015 Miller Mobilesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cropping)

+(CGSize)scaleSize:(CGSize)fromSize toSize:(CGSize)toSize;
-(UIImage*)cropRectangle:(CGRect)cropArea inFrame:(CGSize)frameSizel;

@end
