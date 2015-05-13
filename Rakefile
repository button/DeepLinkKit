desc "Runs the specs"
task :spec do
  sh "xcodebuild test -workspace 'DeepLinkKit.xcworkspace' -scheme 'ReceiverDemo' -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' | xcpretty -c"
end

desc "Synchronizes Xcode project folder with Xcode groups"
task :sync do
  sh "synx -e '/Pod Metadata' -e '/Pods' DeepLinkKit.xcodeproj"
end

desc "Runs pod install with --no-repo-update flag"
task :update do
  sh "pod install --no-repo-update"
end

task :default => [:update]
