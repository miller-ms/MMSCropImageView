//
//  UIImage+Cropping.m
//
//  Created by William Miller on 10/28/15.
//  Copyright © 2015 Miller Mobilesoft. All rights reserved.
//

#import "UIImage+Cropping.h"


// static inline double radians (double degrees) {return degrees * M_PI/180;}


@implementation UIImage (Cropping)


/* scaleSize: calculates a return size by aspect scaling the fromSize to fit within the destination size while giving priority to the width or height depending on which preference will maintain both the return width and height within the destination ie the return size will return a new size where both width and height are less than or equal to the destinations.
 */

+(CGSize)scaleSize:(CGSize)fromSize toSize:(CGSize)toSize {
    
    CGSize scaleSize = CGSizeZero;
    
    if (fromSize.width >= toSize.width) {  // give priority to width if it is larger than the destination width
        
        scaleSize.width = roundf(toSize.width);
        
        scaleSize.height = roundf(scaleSize.width * fromSize.height / fromSize.width);
        
    } else if (fromSize.height >= toSize.height) {  // then give priority to height if it is larger than destination height
        
        scaleSize.height = roundf(toSize.height);
        
        scaleSize.width = round(scaleSize.height * fromSize.width / fromSize.height);
        
    } else {  // otherwise the source size is smaller in all directions.  Scale on width
        
        scaleSize.width = roundf(toSize.width);
        
        scaleSize.height = roundf(scaleSize.width * fromSize.height / fromSize.width);
        
        if (scaleSize.height > toSize.height) { // but if the new height is larger than the destination then scale height
            
            scaleSize.height = roundf(toSize.height);
            
            scaleSize.width = roundf(scaleSize.height * fromSize.width / fromSize.height);
        }
        
    }
    
    return scaleSize;
}


/* scaleBitmapToSize: returns an UIImage scaled to the input dimensions. Oftentimes the underlining CGImage does not match the orientation of the UIImage. This routing scales the UIImage dimensions not the CGImage's, and so it swaps the height and width of the scale size when it detects the UIImage is oriented differently.
 */
-(UIImage*)scaleBitmapToSize:(CGSize)scaleSize

{
    
    /* round the size of the underlying CGImage and the input size.
     */
    
//    CGSize gImageSize = CGSizeMake(CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
    
    scaleSize = CGSizeMake(round(scaleSize.width), round(scaleSize.height));
    
    /* if the underlying CGImage is oriented differently than the UIImage then swap the width and height of the scale size. This method assumes the size passed is a request on the UIImage's orientation.
     */
    
//    if (gImageSize.height == self.size.width && gImageSize.width == self.size.height) {
    
    if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationRight) {
            
        scaleSize = CGSizeMake(round(scaleSize.height), round(scaleSize.width));
    }
    
    /* Create a bitmap context in the dimensions of the scale size and draw the underlying CGImage into the context.
     */
    CGContextRef context = CGBitmapContextCreate(nil, scaleSize.width, scaleSize.height, CGImageGetBitsPerComponent(self.CGImage), CGImageGetBytesPerRow(self.CGImage)/CGImageGetWidth(self.CGImage)*scaleSize.width, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage));
    
    CGContextDrawImage(context, CGRectMake(0, 0, scaleSize.width, scaleSize.height), self.CGImage);
    
    /* realize the CGImage from the context.
     */
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);  // context is no longer needed so release it.
    
    /* realize the CGImage into a UIImage.
     */
    UIImage* returnImg = [UIImage imageWithCGImage:imgRef];
    
    CGImageRelease(imgRef);  // release the CGImage as it is no longer needed.

    return returnImg;
    
}

/* translateCropRect:inBounds: translates the origin of the crop rectangle to match the orientation of the underlying CGImage.
 */
-(CGRect)translateCropRect:(CGRect)cropRect inBounds:(CGSize)boundSize {
    
    CGRect transformedRect = cropRect;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
            transformedRect.origin.x = boundSize.height - (cropRect.size.height + cropRect.origin.y);
            transformedRect.origin.y = cropRect.origin.x;
            transformedRect.size = CGSizeMake(cropRect.size.height, cropRect.size.width);
            break;
            
        case UIImageOrientationRight:
            transformedRect.origin.x = cropRect.origin.y;
            transformedRect.origin.y = boundSize.width - (cropRect.size.width + cropRect.origin.x);
            transformedRect.size = CGSizeMake(cropRect.size.height, cropRect.size.width);
            break;
            
        case UIImageOrientationDown:
            transformedRect.origin.x = boundSize.width - (cropRect.size.width + cropRect.origin.x);
            transformedRect.origin.y = boundSize.height - (cropRect.size.height + cropRect.origin.y);
            break;

        case UIImageOrientationUp:
            break;

        case UIImageOrientationDownMirrored:
            transformedRect.origin.x = cropRect.origin.x;
            transformedRect.origin.y = boundSize.height - (cropRect.size.height + cropRect.origin.y);
            break;

        case UIImageOrientationLeftMirrored:
            transformedRect.origin.x = cropRect.origin.y;
            transformedRect.origin.y = cropRect.origin.x;
            transformedRect.size = CGSizeMake(cropRect.size.height, cropRect.size.width);
            break;
            
        case UIImageOrientationRightMirrored:
            transformedRect.origin.x = boundSize.height - (cropRect.size.height + cropRect.origin.y);
            transformedRect.origin.y = boundSize.width - (cropRect.size.width + cropRect.origin.x);
            transformedRect.size = CGSizeMake(cropRect.size.height, cropRect.size.width);            
            break;
            
        case UIImageOrientationUpMirrored:
            transformedRect.origin.x = boundSize.width - (cropRect.size.width + cropRect.origin.x);
            transformedRect.origin.y = cropRect.origin.y;
            break;
            
            
        default:
            break;
    }
    
    return transformedRect;
}
/* cropRectangle:inFrame returns a new UIImage cut from the cropArea of the underlying image.  It first scales the underlying image to the scale size before cutting the crop area from it. The returned CGImage is in the dimensions of the cropArea and it is oriented the same as the underlying CGImage as is the imageOrientation.
 */
-(UIImage*)cropRectangle:(CGRect)cropRect inFrame:(CGSize)frameSize {
    
    frameSize = CGSizeMake(round(frameSize.width), round(frameSize.height));
    
    /* resize the image to match the zoomed content size
     */
    UIImage* img = [self scaleBitmapToSize:frameSize];
    
    /* crop the resized image to the crop rectangel.
     */
    CGImageRef cropRef = CGImageCreateWithImageInRect(img.CGImage, [self translateCropRect:cropRect inBounds:frameSize]);
    
    UIImage* croppedImg = [UIImage imageWithCGImage:cropRef scale:1.0 orientation:self.imageOrientation];
    
    return croppedImg;
    
}

@end
