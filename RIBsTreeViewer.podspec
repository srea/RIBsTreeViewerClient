Pod::Spec.new do |spec|
  spec.name         = "RIBsTreeViewer"
  spec.version      = "0.0.1"
  spec.summary      = "This library provides part of the ability to visualize the RIBs Tree in real-time in a browser."
  spec.description  = <<-DESC
  The attached RIBs are retrieved recursively, and at regular intervals, the tree structure. You can also get the View of a particular RIB as an image.
                   DESC

  spec.homepage     = "https://github.com/srea/"
  spec.license      = "MIT"
  spec.author             = { "Yuki Tamazawa" => "yuki.tamazawa@icloud.com" }
  spec.social_media_url   = "https://twitter.com/yukimikan88"
  spec.platform     = :ios, "13.0"

  spec.source       = { :git => "https://github.com/srea/RIBsTreeViewerClient.git", :tag => "#{spec.version}" }

  spec.source_files  = "RIBsTreeViewerClient/Sources/**/*.swift"
end
