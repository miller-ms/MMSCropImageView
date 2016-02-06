Pod::Spec.new do |s|
  s.name         = "MMSCropImageView"
  s.version      = "0.4.1"
  s.summary      = "MMSCropImageView is an objective-c subclass of the UIImageView to give features to crop the image."
  s.description  = <<-DESC
                   MMSCropImageView gives the basic feature of drawing and positioning a crop rectangle over an image and
                   returning a UIImage cut from the crop region.
                   DESC
  s.homepage     = "https://github.com/miller-ms/MMSCropImageView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "William Miller" => "support@millermobilesoft.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/miller-ms/MMSCropImageView.git", :tag => s.version.to_s }
  s.source_files = "MMSCropImageView/*.{h,m}"
  s.frameworks   = "UIKit", "CoreGraphics"
end
