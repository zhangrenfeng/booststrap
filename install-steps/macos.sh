# Program:
#   系统配置脚本
# History:
#   1018/12/27  renfeng.zhang   0.1.0

sudo bash install-steps/guest_account.sh disable

# 默认情况下, 键盘最上面一排的F1-F12都有各自的作用, 可以将他们理解为特殊按键, 而不是普通的F1-F12
# 编码时, 这些特殊按键有些浪费, 而很多IDE提供的快捷键都需要F1-F12, 尤其在断点调试时很有用, 以 XCode 为例说明:
#   1. F6: 执行下一行代码
#   2. F7: 调到代码内部执行
#   3. F8: 跳出当前代码块, 和 F7 的作用相反
# 如F6为特殊按钮键时, 需要同时按下左下角的 fn 键和顶部的 F6 键才能触发单步调试功能, 效率低下.
# 故可以将 F1-F12 修改为标准按键， 修改后原来特殊按键的功能需要同时按下 fn 和 F1-F12 才能触发.
defaults write -globalDomain com.apple.keyboard.fnState -int 1

# 完全键盘控制, 很多操作都会弹出系统的弹窗, 如果没有开启完全键盘控制, 只能通过鼠标或回车键进行确认或取消
# 如果开启了完全键盘控制, 则可以通过空格键进行选中, Tab 键在多个按钮之间进行切换
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# 自动显示/隐藏 Dock
defaults write com.apple.dock autohide -bool true

# 移除自动隐藏 Dock 的触发时间, 把鼠标移动到屏幕呼出Dock有一个短延迟, 将该延迟设置为0
defaults write com.apple.Dock autohide-delay -float 0

# 显示电量百分比
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# 关闭菜单栏透明
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# 通过减少延迟时间, 可以加速窗口大小调整时的动画
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Finder 中显示文件名后缀
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 关闭镜像验证, 在打开 .dmg 格式的安装文件时, 默认会先验证镜像, 如果文件本身很大, 验证的时间会很长, 下面的命令关闭验证
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# 隐藏桌面的全部文件, 这些文件可以在 Finder 中的桌面中看到
defaults write com.apple.finder CreateDesktop false
# 在快速预览中开启文本选择功能
defaults write com.apple.finder QLEnableTextSelection -boolean true
# 在桌面显示 硬盘，外置磁盘，CD DVD iPod，已连接的服务器
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -boolean false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -boolean false
# 更改扩展名之前不显示警告
defaults write com.apple.finder FXEnableExtensionChangeWarning -boolean false

# 开启轻按点击功能, 只要轻轻地触碰触摸板, 不用真的按下去, 就可以点击了
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# TODO

# 开启三指拖拽功能, 移动窗口时, 只要用三个手机即可拖拽, 而不用先点击选中窗口, 再拖拽
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# 显示 ~/Library/ 目录
chflags nohidden ~/Library

# 禁用文字自动更正
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# 隐藏 MenuBar 中的 Spotlight 图标
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# 隐藏 MenuBar 中的 Siri 图标
cp config/com.apple.Siri.plist ~/Library/Preferences/

# 隐藏 MenuBar 中的输入法图标
cp config/com.apple.systemuiserver.plist ~/Library/Preferences/

# 开启模拟器全屏模式
defaults write com.apple.iphonesimulator AllowFullscreenMode -bool YES

# 关闭第三方程序验证
# sudo spctl --master-disable
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# 使配置生效
for app in Finder Dock Mail SystemUIServer
do
    killall "$app" > /dev/null 2>&1
done