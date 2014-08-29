Pod::Spec.new do |s|
  s.name         = "MVPagination"
  s.version      = "1.0"
  s.summary      = "A delightful MVPagination class with pagination a array, object from Core Data, from URL or JSON for iOS"
  s.homepage     = "https://github.com/Namvt/MVPagination"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Michael Vu" => "namvt@rubify.com" }
  s.source       = { :git => "https://github.com/Namvt/MVPagination.git", :tag => "1.0" }

  s.source_files = 'Classes/**/*.{h,m}'
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'

  s.dependency 'ObjectiveSugar'
end
