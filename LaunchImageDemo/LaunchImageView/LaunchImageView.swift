//
//  LaunchImageView.swift
//  LaunchImageDemo
//
//  Created by yeeaoo on 16/6/24.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit
import SDWebImage

let mainHeight = UIScreen.main.bounds.height
let mainWidth = UIScreen.main.bounds.width
// 闭包
typealias myClickClosure = ((NSInteger) -> Void)
// 枚举
enum LaunchImageType {
    // 全屏的广告
    case fullScreenAdType
    // 带logo的广告
    case logoAdType
}
class LaunchImageView: UIView {

    var lImageView: UIImageView!
    // 倒计时总时长,默认6秒
    var time: NSInteger! = 6
    // 计时器
    var countDownTimer: Timer!
    var myWindow: UIWindow!
    var skipBtn: UIButton!
    // 闭包
    var clickClosure: myClickClosure?
    // 
    var isClick: String! = "1"
    // 倒计时总时长
    var secondsCountDown: NSInteger!

    
    init(frame: CGRect,window: UIWindow,type: LaunchImageType,url: String) {
        
        super.init(frame: frame)
        self.myWindow = window
        self.secondsCountDown = 6
        window.makeKeyAndVisible()
        
        // 获取启动图片
        let viewSize = window.bounds.size
        // 横屏请设置成 @"Landscape"
        let viewOrientation = "Portrait"
        var launchImageName = ""
        
        // AnyObject ->(转换成) Array 用 as! [[String: AnyObject]]
        let imagesDict = (Bundle.main.infoDictionary!)["UILaunchImages"] as! [[String: AnyObject]]
        
        
        for dict in imagesDict {
            
            let imageSize = CGSizeFromString((dict["UILaunchImageSize"] as! String))
            if imageSize.equalTo(viewSize) && viewOrientation == (dict["UILaunchImageOrientation"] as! String){
                
                launchImageName = dict["UILaunchImageName"] as! String
                
            }
        }
       
        let launchImage = UIImage(named: launchImageName)
        self.backgroundColor = UIColor(patternImage: launchImage!)
        self.frame = CGRect(x: 0, y: 0, width: mainWidth, height: mainHeight)
        
        if type == .fullScreenAdType {
            
            self.lImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: mainWidth, height: mainHeight))
            
        } else {
            
            self.lImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: mainWidth, height: mainHeight - mainWidth/3))

        }
        
        self.skipBtn = UIButton(type: .custom)
        self.skipBtn.frame = CGRect(x: mainWidth - 70, y: 20, width: 60, height: 30)
        self.skipBtn.backgroundColor = UIColor.brown
        self.skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.skipBtn.addTarget(self, action: #selector(LaunchImageView.skipBtnClick), for: .touchUpInside)
        self.lImageView.addSubview(self.skipBtn)
        
        let maskPath = UIBezierPath(roundedRect: self.skipBtn.bounds, byRoundingCorners: [.bottomRight,.topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.skipBtn.bounds
        maskLayer.path = maskPath.cgPath
        self.skipBtn.layer.mask = maskLayer
        
        
        let manager = SDWebImageManager.shared()
        
        manager?.downloadImage(with: URL(string: url), options: .retryFailed, progress: { (receivedSize, NSInteger) in
            
            
            
            }) { (image, error, cacheType, finished, imageURL) in
              
                if (image != nil) {
                    
                    self.lImageView.image = self.imageCompressForWidth(image!, defineWidth: mainWidth)
                    
                }
        }
        
        self.lImageView.tag = 1101
        self.lImageView.backgroundColor = UIColor.red
        self.addSubview(self.lImageView)
        

        let tap = UITapGestureRecognizer(target: self, action: #selector(LaunchImageView.activiTap(_:)))
        self.lImageView.isUserInteractionEnabled = true
        self.lImageView.addGestureRecognizer(tap)
        
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.8
        opacityAnimation.fromValue = NSNumber(value: 0.0 as Float)
        opacityAnimation.toValue = NSNumber(value: 0.8 as Float)
        
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        
        self.lImageView.layer.add(opacityAnimation, forKey: "animateOpacity")
        
        self.countDownTimer = Timer(timeInterval: 1, target: self, selector: #selector(LaunchImageView.onTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.countDownTimer, forMode: RunLoopMode.defaultRunLoopMode)
        self.countDownTimer.fire()
        self.myWindow.addSubview(self)
    }
    //MARK: - 点击按钮关闭广告
    func skipBtnClick() {
        
        self.isClick = "2"
        self.startcloseAnimation()
        
    }
    //MARK: - 手势-点击广告
    func activiTap(_ tap: UITapGestureRecognizer) {
        
        self.isClick = "1"
        self.startcloseAnimation()

    }
    //MARK: - 开启关闭动画
    func startcloseAnimation() {
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.5
        opacityAnimation.fromValue = NSNumber(value: 1.0 as Float)
        opacityAnimation.toValue = NSNumber(value: 0.3 as Float)
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = kCAFillModeForwards

        self.lImageView.layer.add(opacityAnimation, forKey: "animateOpacity")


        Timer.scheduledTimer(timeInterval: opacityAnimation.duration, target: self, selector: #selector(LaunchImageView.closeAddImgAnimation), userInfo: nil, repeats: false)
        
    }
    //MARK: - 关闭动画完成时处理事件
    func closeAddImgAnimation() {
        
        if self.countDownTimer != nil {
            self.countDownTimer.invalidate()
            self.countDownTimer = nil
        }
 
        self.isHidden = true
        self.lImageView.isHidden = true
        self.isHidden = true
        
        if self.isClick == "1" {
            // 点击广告
            self.clickClosure!(1100)
            
        } else if self.isClick == "2" { 
        
            // 点击跳过
            self.clickClosure!(1101)
        } else {
           // 点击跳过
            self.clickClosure!(1102)

        }
        
    }
    //MARK: - 计时器
    func onTimer() {
       
        print("onTimer")
        
        if self.time == 0 {
            
            self.time = 6
        }
        if self.secondsCountDown <= self.time {
            
            self.secondsCountDown = secondsCountDown - 1
            self.skipBtn.setTitle(String(format: "%ld | 跳过", self.secondsCountDown), for: UIControlState())
            
        }
        if self.secondsCountDown == 0 {
            
            self.isClick = "3"
            self.countDownTimer.invalidate()
            self.countDownTimer = nil
            self.startcloseAnimation()
        }
        
    }
    
    //MARK: - 指定宽度按比例缩放
    func imageCompressForWidth(_ sourceImage: UIImage,defineWidth: CGFloat) -> UIImage{
        
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = defineWidth
        let targetHeight = height / (width / targetWidth)
        let size = CGSize(width: targetWidth, height: targetHeight)
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        if imageSize.equalTo(size) == false {
            
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            
            if widthFactor > heightFactor {
                
                scaleFactor = widthFactor
                
            } else {
                
                scaleFactor = heightFactor
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if(widthFactor > heightFactor) {
                
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
                
            }else if(widthFactor < heightFactor){
                
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }

            
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        if newImage == newImage {
            
            print("scale image fail")
        }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
