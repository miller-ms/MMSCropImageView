//
//  DragCropRectRecognizer.m
//  CropDemo
//
//  Created by William Miller on 12/3/15.
//
//  Copyright © 2016 William Miller, http://millermobilesoft.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
