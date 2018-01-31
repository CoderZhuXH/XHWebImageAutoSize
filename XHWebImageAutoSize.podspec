Pod::Spec.new do |s|
  s.name         = "XHWebImageAutoSize"
  s.version      = "1.1.2"
  s.summary      = "网络图片尺寸/高度自适应解决方案"
  s.homepage     = "https://github.com/CoderZhuXH/XHWebImageAutoSize"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Zhu Xiaohui" => "977950862@qq.com"}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/CoderZhuXH/XHWebImageAutoSize.git", :tag => s.version }
  s.source_files = "XHWebImageAutoSize", "*.{h,m}"
  s.requires_arc = true
end
