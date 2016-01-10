//
//  MMSCropImageView.m
//  CropDemo
//
//  Created by William Miller on 12/7/15.
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


#import "MMSCropImageView.h"
#import "DragCropRectRecognizer.h"
#import "UIImage+Cropping.h"

@interface MMSCropImageView ()

{

@private
    
    // The dragOrigin is the first point the user touched to begin the drag operation to delineate the crop rectangle.
    CGPoint dragOrigin;
    
    // The rectangular view that the user sizes over the image to delineate the crop rectangle
    UIView* cropView;
    
    // Gesture recognizer for delineating the crop rectangle attached to the imageView
    DragCropRectRecognizer* dragGesture;
    
    // Tap gesture attached to the imageView when detected the cropView is hidden
    UITapGestureRecognizer* hideGesture;
    
    // Swallow gesture consumes taps inside the cropView without acting upon them.  This is required since without it taps in the crop view are handled by the tap gesture of the imageView.
    UITapGestureRecognizer* swallowGesture;
    
    // Moves an existing cropView around to any location over the imageView.
    UIPanGestureRecognizer* moveGesture;
    
    // The first touchpoint when the user began moving the cropView
    CGPoint touchOrigin;
}

@end

@implementation MMSCropImageView


-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initializeInstance];

    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self initializeInstance];
    }
    
    return self;
}

-(void)initializeInstance {
    
    
    dragOrigin = CGPointZero;
    
    // initialize the view with zero size and positioned outside the visible region of the  imageview.
    cropView = [[UIView alloc] initWithFrame:CGRectMake(-1.0, -1.0, 0.0, 0.0)];
    
    cropView.hidden = true;  // the cropView is initially hidden
    
    cropView.backgroundColor = [UIColor whiteColor];  // background color is white
    
    cropView.alpha = 0.65;  // the background is modestly transparent
    
    cropView.layer.borderWidth = 1.0;  // the crop rectangle has a solid border
    
    cropView.layer.borderColor = [[UIColor whiteColor] CGColor];  // the crop border is white
    
    [self addSubview:cropView];  // add the cropView to the imageView
    
    // Create the drag gesture and attach it to the imageView.
    dragGesture = [[DragCropRectRecognizer alloc] initWithTarget:self action:@selector(dragRectangle:)];
    
    [self addGestureRecognizer:dragGesture];
    
    dragGesture.delegate = self;
    
    // Create the hide gesture and attach it to the imageview.
    hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCropRectangle:)];
    
    [self addGestureRecognizer:hideGesture];
    
    hideGesture.delegate = self;

    // Create the move gesture and attach it to the cropView
    moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveRectangle:)];
    
    [cropView addGestureRecognizer:moveGesture];
    
    moveGesture.delegate = self;
    
    // Create the swall gesture and attach it to the cropView.
    swallowGesture = [[UITapGestureRecognizer alloc] init];
    
    [cropView addGestureRecognizer:swallowGesture];
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    
    /* Enable to recognize the pan and tap gestures simultaneous for both the imageView and cropView
     */
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        
        return YES;
        
    }
    
    return NO;
    
}

/* moveRectangle: finger was touched within the boundaries of the crop view.  Move the crop view as the touchpoint coordinates change.
 */

- (IBAction)moveRectangle:(UIPanGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        /*  save the crop view frame's origin to compute the changing position as the finger glides around the screen.  Also, save the first touch point compute the amount to change the frames orign.
         */
        
        touchOrigin = [gesture locationInView:self];
        
        dragOrigin = cropView.frame.origin;
        
    } else  {
        
        
        /* Compute the change in x and y coordinates with respect to the original touch point.  Compute a new x and y point by adding the change in x and y to the crop view's origin before it was moved. Make this point the new origin.
         */
        
        CGFloat dx, dy;
        
        CGPoint currentPt = [gesture locationInView:self];
        
        dx = currentPt.x - touchOrigin.x;
        
        dy = currentPt.y - touchOrigin.y;
        
        cropView.frame = CGRectMake(dragOrigin.x + dx, dragOrigin.y + dy, cropView.frame.size.width, cropView.frame.size.height);
        
    }
    
}

/* dragRectangle: this method resizes the cropView frame as the user drags their finger across the UIImageView.  The first tap point becomes the frame's origin and is referenced through the pan duration to compute size and to set the frame's origin.
 */

- (IBAction)dragRectangle:(DragCropRectRecognizer *)gesture {
    
    CGRect cropRect = CGRectZero;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        /* set the origin for the remainder of the pan gesture to the first touchpoint.
         */
        
        cropView.hidden = false;
        
        cropRect.origin = dragOrigin = gesture.origin;
        
    } else {
        
        cropRect = cropView.frame;
        
        CGPoint currentPoint = [gesture locationInView:self];
        
        if (currentPoint.x >= dragOrigin.x && currentPoint.y >= dragOrigin.y) {
            
            /* finger is dragged down and right with respect to the origin start (Quadrant III);  cropViews origin is the original touchpoint.
             */
            
            cropRect.origin = dragOrigin;
            
            cropRect.size = CGSizeMake(currentPoint.x - cropRect.origin.x, currentPoint.y - cropRect.origin.y);
            
        } else if (currentPoint.x <= dragOrigin.x && currentPoint.y <= dragOrigin.y) {
            
            /* the finger is dragged up and left with respect to the origin start (Quadrant I); Since the frame origin always represents the upper left corner, the frame rectangle's origin is set to the current point, and the start origin is the bottom right corner.
             */
            
            cropRect.origin = currentPoint;
            
            cropRect.size = CGSizeMake(dragOrigin.x - currentPoint.x, dragOrigin.y - currentPoint.y);
            
        } else if (currentPoint.x < dragOrigin.x) {
            
            /* logic falls here when the x coordinate dimension is changing in the opposite direction of the y coordinate and moving down and to the left (Quadrant IV).  Thhe frame rectangle's origin is a combination of the current x coordinate and the start origin's y.
             */

            
            cropRect.origin = CGPointMake(currentPoint.x, dragOrigin.y);
            
            cropRect.size = CGSizeMake(dragOrigin.x - currentPoint.x, currentPoint.y - dragOrigin.y); // cropRect.size.height
            
        } else if (currentPoint.y < dragOrigin.y) {
            
            /* Logic falls here when the y coordinate dimension is changing in the opposite direction of the y coordinate and moving up and to the right (Quadrant II). The frame rectangle's origin is a combination of the current y coordinate and the start origin's x.
             */

            
            cropRect.origin = CGPointMake(dragOrigin.x, currentPoint.y);
            
            cropRect.size = CGSizeMake(currentPoint.x - dragOrigin.x, dragOrigin.y - currentPoint.y);
            
        }
        
    }
    
    /* set the new crop view frame rectangle.
     */
    cropView.frame = cropRect;
}

/* hideCropRectangle: the crop view becomes hidden when the user taps outside the crop view frame.
 */
- (IBAction)hideCropRectangle:(UITapGestureRecognizer *)gesture {
    
    
    if (!cropView.hidden) {
        
        cropView.hidden = true;
        
        cropView.frame = CGRectMake(-1.0, -1.0, 0.0, 0.0);
        
    }
    
}

/* crop: returns a new UIImage cut from the crop view frame that overlays it.  The underlying CGImage of the returned UIImage has the dimensions of the crop view's frame.
 */

-(UIImage*)crop {
    
    UIImage* croppedImage;
    
    croppedImage = [self.image cropRectangle:cropView.frame inFrame:self.frame.size];
    
    return croppedImage;
    
}

@end
