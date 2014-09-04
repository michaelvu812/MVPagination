Pod::Spec.new do |s|
  s.name         = "MVPagination"
  s.version      = "1.0"
  s.summary      = "A delightful MVPagination class with pagination a array, object from Core Data, from URL or JSON for iOS"
  s.homepage     = "https://github.com/Namvt/MVPagination"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Michael Vu" => "namvt@rubify.com" }
  s.source       = { :git => "https://github.com/Namvt/MVPagination.git", :tag => "1.0" }
  s.source_files = 'Classes'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.3.1'
  s.dependency 'MBProgressHUD', '~> 0.8'
  s.dependency 'ObjectiveRecord', '~> 1.5.0'
  s.frameworks = 'CoreData'
  s.resource = 'MVPagination.bundle'
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.prefix_header_contents = <<-EOS
  #ifdef __OBJC__
    #import <CoreData/CoreData.h>
    #import <AFNetworking/AFNetworking.h>
    #import "ObjectiveRecord.h"
    #import "NSBundle+Localized.h"
    #import "MBProgressHUD.h"
    #define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
    #undef MVLocalizedString
    #define MVLocalizedString(key, comment) \
        [[NSBundle bundleWithName:@"MVPagination.bundle"] localizedStringForKey:(key) value:@"" table:nil]
  #endif
  EOS
end
