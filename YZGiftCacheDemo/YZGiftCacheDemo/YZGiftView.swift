//
//  YZGiftView.swift
//  YZGiftCacheDemo
//
//  Created by heyuze on 16/8/9.
//  Copyright © 2016年 HYZ. All rights reserved.
//

import UIKit

let kGiftView_Width: CGFloat = 16*5 + 120 + 50 //23*5 + 100 + 50
let kGiftView_Height: CGFloat = 32

enum AnimationState {
    case none    // 空状态
    case showing // 礼物出现
    case shaking // 正在执行摇动动画
    case shaked  // 摇动动画结束
    case hiding  // 全部动画结束，隐藏中
}


class YZGiftView: UIView {
    
    // 隐藏动画完成后执行block
    var hidenCompleteBlock: ((_ giftView: YZGiftView)->())?
    
    
    // 在容器所处的坐标
    var index: Int = 0 {
        didSet {
            let y: CGFloat = (index == 0) ? 57 : 0
            self.y = y
        }
    }
    // 当前礼物数字
    var number: Int = 0
    // 礼物视图状态
    var state: AnimationState = .none
    // 展示时间
    var showTime: Int = 3
    // share动画的缓存数组
    var caches: [Int] = [Int]()
    
    // 礼物
    var gift: YZGift? {
        didSet {
            self.alpha = 0
            self.number = 0
            self.state = .showing
            let positionY: CGFloat = (index == 0) ? 57 : 0
            self.frame = CGRect(x: -kGiftView_Width, y: positionY, width: kGiftView_Width, height: kGiftView_Height)
            
//            verifyView.image = getIconLevelImage(gift!.level)
            
            // 清空数字图片
            self.xView.image = nil
            self.firstNumberView.image = nil
            self.secondNumberView.image = nil
            self.thirdNumberView.image = nil
            self.fourthNumberView.image = nil
            
            iconView.image = UIImage(named: gift!.header)
            self.nameLabel.text = gift!.nickname
            self.giftNameLabel.text = getGiftName(gift_id: gift!.gift_id)
            self.giftView.image = UIImage(named: getGiftFileName(gift_id: gift!.gift_id))
        }
    }
    
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set up
    
    private func setupUI() {
        self.alpha = 0
        frame = CGRect(x: 10, y: 0, width: kGiftView_Width, height: kGiftView_Height)
        backgroundColor = UIColor.clear
        
        addSubview(backgroudView)
        addSubview(iconView)
        addSubview(iconBtn)
        addSubview(verifyView)
        addSubview(nameLabel)
        addSubview(sendLabel)
        addSubview(giftNameLabel)
        addSubview(giftView)
        addSubview(numberView)

        backgroudView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(self)
            make.trailing.equalTo(giftView)
        }
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(self)
            make.width.height.equalTo(32)
        }
        iconBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(iconView)
        }
        verifyView.snp.makeConstraints { (make) in
            make.trailing.bottom.equalTo(iconView)
            make.width.height.equalTo(12)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.leading.equalTo(iconView.snp.trailing).offset(5)
            make.width.equalTo(82) //
        }
        sendLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView).offset(-2)
            make.leading.equalTo(iconView.snp.trailing).offset(5)
        }
        giftNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(sendLabel)
            make.leading.equalTo(sendLabel.snp.trailing).offset(5)
        }
        giftView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(120) //100
            make.bottom.equalTo(self)
            make.width.height.equalTo(50)
        }
        numberView.snp.makeConstraints { (make) in
            make.leading.equalTo(giftView.snp.trailing).offset(5)
            make.bottom.top.equalTo(self)
        }
    }
    
    
    // MARK: - Animation
    
    // 礼物视图初始化、出现动画
    func showGiftView(with gift: YZGift, complete: @escaping ()->()) {
        self.gift = gift
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
            self.frame = CGRect(x: 10, y: self.y, width: kGiftView_Width, height: kGiftView_Height)
        }) { (finished) in
            complete()
        }
    }
    
    func shakeAnimation(number: Int) {
        if number > 0 {
            self.caches.append(number)
        }
        if self.caches.count > 0 && self.state != .shaking {
            let cache = self.caches.first!
            self.caches.remove(at: 0)
            startShakeAnimation(number: cache, complete: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.shakeAnimation(number: -1) //传-1是为了缓存不被重复添加
            })
        }
    }
    
    // 开始连乘动画
    func startShakeAnimation(number: Int, complete: @escaping ()->()) {
        NSObject.cancelPreviousPerformRequests(withTarget: self) //取消上次的延时隐藏动画
        // 延时执行隐藏动画
        self.perform(#selector(self.doHideAnimation), with: nil, afterDelay: Double(self.showTime))
        
        self.state = .shaking
        self.number += 1
        changeNumber()
        
        startAnimation { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if number > 1 {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//                    strongSelf.startShakeAnimation(number-1, complete: complete)
//                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    strongSelf.startShakeAnimation(number: number-1, complete: complete)
                })
            } else {
                self?.state = .shaked
                complete()
            }
        }
        
    }
    
    // 隐藏动画
    func doHideAnimation() {
        self.state = .hiding
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: 10, y: self.y-50, width: kGiftView_Width, height: kGiftView_Height)
            self.alpha = 0
        }) { (finished) in
            self.state = .none
            if self.hidenCompleteBlock != nil {
                self.hidenCompleteBlock!(self)
            }
        }
    }
    
    func startAnimation(complete: @escaping ()->()) {
        /*
        let damping: CGFloat = 0.5
        let volocity: CGFloat = 0.3
        
        numberView.transform = CGAffineTransformScale(numberView.transform, 3, 3)
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: volocity, options: .AllowUserInteraction, animations: {
            self.numberView.transform = CGAffineTransformIdentity
        }) { finished in
            complete()
        }
         */
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.numberView.transform = CGAffineTransform(scaleX: 3.5, y: 3.5)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.numberView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        }) { (finished) in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                self.numberView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { (finished) in
                complete()
            })
        }
    }

    
    // MARK: - Func
    
    // 通过gift_id获取礼物名字
    private func getGiftName(gift_id: Int) -> String {
        return Gift_Name[gift_id]
    }
    
    // 通过gift_id获取礼物文件名
    private func getGiftFileName(gift_id: Int) -> String {
        return Gift_FileName[gift_id]
    }
    
    // 变化数字
    private func changeNumber() {
        xView.image = UIImage(named: "X")

        if number <= 0 {
            return
        } else if number <= 9 {
            let firstNum = number % 10
            firstNumberView.image = UIImage(named: "\(firstNum)")
        } else if number <= 99 {
            let firstNum = number / 10
            let secondNum = number % 10
            firstNumberView.image = UIImage(named: "\(firstNum)")
            secondNumberView.image = UIImage(named: "\(secondNum)")
        } else if number <= 999 {
            let firstNum = number / 100
            let secondNum = number % 100 / 10
            let thirdNum = number % 10
            firstNumberView.image = UIImage(named: "\(firstNum)")
            secondNumberView.image = UIImage(named: "\(secondNum)")
            thirdNumberView.image = UIImage(named: "\(thirdNum)")
        } else if number <= 9999 {
            let firstNum = number / 1000
            let secondNum = number % 1000 / 100
            let thirdNum = number % 100 / 10
            let fourthNum = number % 10
            firstNumberView.image = UIImage(named: "\(firstNum)")
            secondNumberView.image = UIImage(named: "\(secondNum)")
            thirdNumberView.image = UIImage(named: "\(thirdNum)")
            fourthNumberView.image = UIImage(named: "\(fourthNum)")
        }
    }
    
    
    // MARK: - UI
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        iconView.image = UIImage(named: "jinxC")
        iconView.layer.cornerRadius = 16
        iconView.layer.masksToBounds = true
        iconView.layer.borderWidth = 1
        iconView.layer.borderColor = RGB(r: 0xd4, g: 0x90, b: 0x3b, alpha: 1).cgColor
        return iconView
    }()
    
    private lazy var iconBtn: UIButton = {
        let iconBtn = UIButton()
        iconBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        iconBtn.backgroundColor = UIColor.clear
        return iconBtn
    }()
    
    private lazy var verifyView: UIImageView = {
        let verifyView = UIImageView()
        verifyView.image = UIImage(named: "icon-level-0")
        return verifyView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(text: "name", textColor: RGB(r: 0xec, g: 0xc7, b: 0x76, alpha: 1), fontSize: 13)
        return nameLabel
    }()
    
    private lazy var sendLabel: UILabel = {
        let sendLabel = UILabel(text: "送了一个", textColor: RGB(r: 0xff, g: 0xff, b: 0xff, alpha: 1), fontSize: 10)
        return sendLabel
    }()
    
    private lazy var giftNameLabel: UILabel = {
        let giftNameLabel = UILabel(text: "gift", textColor: RGB(r: 0xec, g: 0xc7, b: 0x76, alpha: 1), fontSize: 10)
        return giftNameLabel
    }()
    
    private lazy var giftView: UIImageView = {
        let giftView = UIImageView(image: UIImage(named: "戒指"))
        giftView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return giftView
    }()
    
    private lazy var numberView: UIView = {
        let numberView = UIView()
        numberView.addSubview(self.xView)
        self.xView.snp.makeConstraints { (make) in
            make.centerY.leading.equalTo(numberView)
        }
        numberView.addSubview(self.firstNumberView)
        self.firstNumberView.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberView)
            make.leading.equalTo(self.xView.snp.trailing)
        }
        numberView.addSubview(self.secondNumberView)
        self.secondNumberView.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberView)
            make.leading.equalTo(self.firstNumberView.snp.trailing)
        }
        numberView.addSubview(self.thirdNumberView)
        self.thirdNumberView.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberView)
            make.leading.equalTo(self.secondNumberView.snp.trailing)
        }
        numberView.addSubview(self.fourthNumberView)
        self.fourthNumberView.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberView)
            make.leading.equalTo(self.thirdNumberView.snp.trailing)
        }
        numberView.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.fourthNumberView)
        }
        
        return numberView
    }()
    
    private lazy var xView: UIImageView = {
        return UIImageView(image: UIImage(named: "X"))
    }()
    
    private lazy var firstNumberView = {
        return UIImageView(image: UIImage(named: "1"))
    }()
    
    private lazy var secondNumberView = {
        return UIImageView(image: UIImage(named: "2"))
    }()
    
    private lazy var thirdNumberView = {
        return UIImageView(image: UIImage(named: "3"))
    }()
    
    private lazy var fourthNumberView = {
        return UIImageView(image: UIImage(named: "4"))
    }()
    
    private lazy var backgroudView: UIView = {
        let backgroudView = UIView()
        backgroudView.backgroundColor = CONTAINER_COLOR
        backgroudView.layer.cornerRadius = 15
        backgroudView.layer.masksToBounds = true
        return backgroudView
    }()
    
}
