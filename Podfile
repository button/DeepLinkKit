xcodeproj 'DeepLinkSDK.xcodeproj', 'Test' => :debug

target 'SenderDemo', :exclusive => true do
    pod 'DeepLinkSDK', :path => '.'
end

target 'ReceiverDemo', :exclusive => true do
    pod 'DeepLinkSDK', :path => '.'
end

target 'Tests', :exclusive => true do
    pod 'Specta', :git => 'https://github.com/specta/specta.git',
    :commit => '16949f4021a5560b1c78c439ad07d596c36cbac3'
    pod 'Expecta'
    pod 'OCMock'
end
