//
//  DragCropRectRecognizer.m
//  CropDemo
//
//  Created by William Miller on 12/3/15.
//  Copyright © 2015 Miller Mobilesoft. All rights reserved.
//

#import "DragCropRectRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation DragCropRectRecognizer

/* touchesBegan:withEvent: override the UIPanGestureRecognizer to identify the point that began the touch gesture.  When the action method is called and the gesture state is UIGestureRecognizerStateBegan, the point returned from locationInView is not the point that began the gesture.  This routine sets the origin of the pan gesture.
 */

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

    NSEnumerator* touchEnumerator = [touches objectEnumerator];
    
    UITouch* touch;
    
    while (touch = [touchEnumerator nextObject]) {
        if (touch.phase == UITouchPhaseBegan) {
            self.origin = [touch locationInView:self.view];
            break;
        };
    }
    
    [super touchesBegan:touches withEvent:event];
    
}
@end
