Pod::Spec.new do |s|
  
  s.name         = 'HJSynchronize'
  s.version      = '0.0.1'
  s.summary      = 'A short description'
  s.homepage     = "https://github.com/panghaijiao/HJSynchronize"

  s.license      = 'MIT'

  s.author       = { 'panghaijiao' => '275742376@qq.com' }

  s.platform     = :ios, '8.0'

  s.source       = { :git => "https://github.com/panghaijiao/HJSynchronizeDemo.git", :tag => "0.0.1" }

  s.source_files  = 'HJSynchronize/**/*.{h,m}'

end
