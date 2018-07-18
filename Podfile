platform :ios, '8.0'
use_frameworks!

target ‘YouBao’ do
   pod 'ReactiveCocoa', :git => 'https://github.com/zhao0/ReactiveCocoa.git', :tag => '2.5.2'
   pod 'Masonry'
   pod 'MGSwipeTableCell'
   pod 'MJExtension'
   pod 'SDWebImage'
   pod 'SDWebImage/GIF'
   pod 'YYText'
   pod 'pop'
   pod 'BRPickerView'
   pod 'XHLaunchAd'
   pod 'PPNetworkHelper'
   pod 'MBProgressHUD'
   pod 'MJRefresh'
   pod 'IQKeyboardManager'
   
   
   # 主模块(必须)
   pod 'mob_sharesdk'
   # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
   pod 'mob_sharesdk/ShareSDKUI'
   # 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
   pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
   pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
   pod 'mob_sharesdk/ShareSDKPlatforms/WeChatFull'
   # 使用配置文件分享模块（非必需）
   pod 'mob_sharesdk/ShareSDKConfigFile'
   # 扩展模块（在调用可以弹出我们UI分享方法的时候是必需的）
   pod 'mob_sharesdk/ShareSDKExtension'
   # 短信
   pod 'mob_smssdk'
end
