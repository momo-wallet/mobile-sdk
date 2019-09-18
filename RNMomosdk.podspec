
Pod::Spec.new do |s|
  s.name         = "RNMomosdk"
  s.version      = "1.2.9"
  s.summary      = "RNMomosdk"
  s.description  = <<-DESC
                  RNMomosdk
                   DESC
  s.homepage     = "https://github.com/author/RNMomosdk.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "momodevelopment" => "lanhluu.vn@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/author/RNMomosdk.git", :tag => "RNMomosdk" }
  s.source_files  = "RNMomosdk/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end
