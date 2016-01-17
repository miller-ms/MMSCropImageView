## MMSCropImageView
This class provides the feature to draw a rectangle over an image by dragging a finger over it, move it, and extract the covered region into a UIImage.

<p align="center">
<img src="Screenshot.png" alt="Sample">
</p>

A simple image cropper.

## Installation
*MMSCropImageView requires iOS 9.0 or later.*

## Basic Usage

In your storyboard select the custom class MMSCropImageView for the Image View widget.

Import the class header.

``` objective-c
#import <MMSCropImageView.h>
```

Add an event handler to initiate the crop action and call the crop method on the image view.

``` objective-c
- (IBAction)crop:(UIButton *)sender {

UIImage* croppedImage; // = self.imageView.image;

croppedImage =  [self.imageView crop];

self.croppedView.image = croppedImage;
}
```

## Demo

Build and run the `CropDemo` project in Xcode to see `MMSCropImageView` in action.

## Article

An article describing the implementation of the class:  [A View Class for Cropping Images](http://www.codeproject.com/Articles/1066191/A-View-Class-for-Cropping-Images).

## Contact

William Miller

- http://github.com/miller-ms
- support@millermobilesoft.com

## License

This project is is available under the MIT license. See the LICENSE file for more info. Attribution by linking to the [project page](https://github.com/miller-ms/MMSCropImageView) is appreciated.