//
//  ViewController.swift
//  basic-uiview-animations
//
//  Created by Marin Todorov on 8/11/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import QuartzCore

/*
    Frame 可以改变视图相对于上一级视图的位置和大小。 （如果视图已经经过了缩放、 旋转、平移之类的变换， 则需要修改 Center 和 Bounds 属性）
    Bounds 改变视图大小。
    Center 改变视图相对于上级视图的位置。
    Transform 相对于中心点进行视图缩放、旋转和平移， 这个属性只能进行二维转换。 （如果要进行三维转换， 则必须用 CoreAnimation 操作视图的 Layer 属性。）
    Alpha 改变视图的透明度。
    BackgroundColor 修改视图的背景色。
    ContentStretch 改变视图内容在视图的可用空间内的拉伸方式。


    UIViewAnimationOption LayoutSubviews            //提交动画的时候布局子控件，表示子控件将和父控件一同动画。

    UIViewAnimationOption AllowUserInteraction      //动画时允许用户交流，比如触摸

    UIViewAnimationOption BeginFromCurrentState     //从当前状态开始动画

    UIViewAnimationOption Repeat                    //动画无限重复

    UIViewAnimationOption Autoreverse               //执行动画回路,前提是设置动画无限重复

    UIViewAnimationOption OverrideInheritedDuration //忽略外层动画嵌套的执行时间

    UIViewAnimationOption OverrideInheritedCurve    //忽略外层动画嵌套的时间变化曲线

    UIViewAnimationOption AllowAnimatedContent      //通过改变属性和重绘实现动画效果，如果key没有提交动画将使用快照

    UIViewAnimationOption ShowHideTransitionViews   //用显隐的方式替代添加移除图层的动画效果

    UIViewAnimationOption OverrideInheritedOptions  //忽略嵌套继承的选项

    //时间函数曲线相关

    UIViewAnimationOption CurveEaseInOut            //时间曲线函数，由慢到快

    UIViewAnimationOption CurveEaseIn               //时间曲线函数，由慢到特别快

    UIViewAnimationOption CurveEaseOut              //时间曲线函数，由快到慢

    UIViewAnimationOption CurveLinear               //时间曲线函数，匀速

    //转场动画相关的

    UIViewAnimationOption TransitionNone            //无转场动画

    UIViewAnimationOption TransitionFlipFromLeft    //转场从左翻转

    UIViewAnimationOption TransitionFlipFromRight   //转场从右翻转

    UIViewAnimationOption TransitionCurlUp          //上卷转场

    UIViewAnimationOption TransitionCurlDown        //下卷转场

    UIViewAnimationOption TransitionCrossDissolve   //转场交叉消失

    UIViewAnimationOption TransitionFlipFromTop     //转场从上翻转

    UIViewAnimationOption TransitionFlipFromBottom  //转场从下翻转

*/



//
// Util delay function
//
func delay(#seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class ViewController: UIViewController {
    
    // MARK: ui outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    // MARK: further ui
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorization ...", "Sending credentials ...", "Failed"]
    
    // MARK: view controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        
        //add the button spinner
        spinner.frame = CGRect(x: -20, y: 6, width: 20, height: 20)
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)

        //add the status banner
        status.hidden = true
        status.center = loginButton.center
        view.addSubview(status)
        
        //add the status label
        label.frame = CGRect(x: 0, y: 0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 228.0/255.0, green: 98.0/255.0, blue: 0.0, alpha: 1.0)
        label.textAlignment = .Center
        status.addSubview(label)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        heading.center.x -= view.bounds.width
        username.center.x -= view.bounds.width
        password.center.x -= view.bounds.width
        loginButton.center.y += 30
        loginButton.alpha = 0.0
        
        animateCloud(self.cloud1);
        animateCloud(self.cloud2);
        animateCloud(self.cloud3);
        animateCloud(self.cloud4);

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            self.heading.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.3, options: .CurveEaseOut, animations: { () -> Void in
            self.username.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.4, options: .CurveEaseOut, animations: { () -> Void in
            self.password.center.x += self.view.bounds.width
            }, completion: nil)
        
        // 笔记：弹簧效果可用时间和spring参数来调
        UIView.animateWithDuration(1.2, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: nil, animations: { () -> Void in
            self.loginButton.center.y -= 30
            self.loginButton.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction func login() {
        
        let b = loginButton.bounds
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: nil, animations: { () -> Void in
            
            self.loginButton.bounds = CGRect(x: b.origin.x - 20, y: b.origin.y, width: b.size.width + 80, height: b.size.height)
            
        }) { _ in
            self.showMessages(index: 0)
        }
        
        UIView.animateWithDuration(0.33, delay: 0.0, options: .CurveEaseOut, animations: {
            if self.status.hidden {
                self.loginButton.center.y += 60
            }
            self.spinner.alpha = 1.0
            self.spinner.center = CGPoint(x: 40, y: self.loginButton.frame.size.height/2)
        }, completion: nil)
        
    }
    
    private func showMessages(#index: Int){
        UIView.animateWithDuration(0.33, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .TransitionCurlDown, animations: { () -> Void in
            self.status.center.x += self.view.frame.size.width
        }) { _ in
            self.status.hidden = true
            self.status.center.x -= self.view.frame.size.width
            self.label.text = self.messages[index]
            
            UIView.transitionWithView(self.status, duration: 0.3, options: .CurveEaseOut | .TransitionCurlDown, animations: {
                self.status.hidden = false
                }, completion: {_ in
                    delay(seconds: 1.0, { () -> () in
                        if index < self.messages.count-1 {
                            self.showMessages(index: index+1)
                        }else {
                            self.resetButton()
                        }
                    })
            })
        }
    }
    
    private func resetButton() {
        
        UIView.animateWithDuration(0.33, delay: 0.0, options: nil,
            animations: {
                
                self.spinner.center = CGPoint(x: -20, y: 16)
                self.spinner.alpha = 0.0
                self.loginButton.backgroundColor = UIColor(red: 160.0/255.0,
                    green: 214.0/255.0, blue: 90.0/255.0, alpha: 1.0)
                
            }, completion: {_ in
                
                UIView.animateWithDuration(0.5, delay: 0.0,
                    usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options:
                    nil, animations: {
                        let b = self.loginButton.bounds
                        self.loginButton.bounds = CGRect(x: b.origin.x + 20, y:
                            b.origin.y, width: b.size.width - 80, height: b.size.height)
                    }, completion:nil)
                
        })
        
    }
    
    func animateCloud(cloud: UIImageView) {
        //animate clouds
        let cloudSpeed = 20.0 / Double(view.frame.size.width)
        let duration: NSTimeInterval = Double(view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
        
        UIView.animateWithDuration(duration, delay: 0.0, options: .CurveLinear, animations: {
            //move cloud to right edge
            cloud.frame.origin.x = self.view.bounds.size.width
            }, completion: {_ in
                //reset cloud
                cloud.frame.origin.x = -self.cloud1.frame.size.width
                self.animateCloud(cloud);
        });
    }

    
}

