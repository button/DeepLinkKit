xcodeproj 'DeepLinkSDK.xcodeproj', 'Test' => :debug

target 'SenderDemo', :exclusive => true do
    pod 'DeepLinkSDK', :path => '.'
end

target 'ReceiverDemo', :exclusive => true do
    pod 'DeepLinkSDK', :path => '.'
end

target 'Tests', :exclusive => true do
    pod 'Specta'
    pod 'Expecta'
    pod 'OCMock'
end
