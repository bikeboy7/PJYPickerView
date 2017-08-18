//
//  PJYPickerView.swift
//  PJYPickerView
//
//  Created by boy on 2017/7/27.
//  Copyright © 2017年 pjy. All rights reserved.
//

import UIKit

@objc protocol PJYPickerViewDelegate {
    @objc optional func numDidChange(num: Int)
}


class PJYPickerView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private static let cellid = "PJYPiickerCellId"
    
    private let numImageView : UIImageView = UIImageView()
    
    static let cellWidth: CGFloat = 15.0 * 5.0
    
    private var collectionView: UICollectionView? = nil
    
    private let flowLayout = UICollectionViewFlowLayout.init()
    
    private let alphaViewTag = 100
    
    private let alphaView = UIView()
    
    private let gradientLayer: CAGradientLayer = CAGradientLayer.init()
    
    
    
    let numTextField = UITextField.init()

    weak var delegate: PJYPickerViewDelegate?

    var num: Int = 0
    
    var maxNum = 100000
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override var backgroundColor: UIColor? {
        didSet{
            super.backgroundColor = backgroundColor
            
            setAlphaView(color: backgroundColor!)            
            
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TextFieldTextDidChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
    }
    
    convenience init(num: Int, backgroundColor: UIColor = UIColor.white, frame: CGRect = CGRect()) {
        
        self.init(frame: frame)
        
        self.changeNum(num)
        
        self.backgroundColor = backgroundColor
        
    }
    
    func initView() {
        
        self.backgroundColor = UIColor.white
        
        numImageView.image = UIImage(named: "PJYPickerView.bundle/my_picker_bg")
        numImageView.isUserInteractionEnabled = true
        self.addSubview(numImageView)

        numTextField.textAlignment = .center
        numTextField.textColor = .white
        numTextField.keyboardType = .numberPad
        numTextField.font = UIFont.init(name: "PingFang SC", size: 16.0)
        numImageView.addSubview(numTextField)
        numTextField.text = "0"
        
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.minimumLineSpacing = 0.0
        
        collectionView = UICollectionView.init(frame: CGRect(), collectionViewLayout: flowLayout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.bounces = false
        collectionView?.backgroundColor = .clear
        collectionView?.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView!)
        
        collectionView?.register(PickerViewCell.self, forCellWithReuseIdentifier: PJYPickerView.cellid)
        
        self.backgroundColor = UIColor.white
        
        
        alphaView.isUserInteractionEnabled = false
        addSubview(alphaView)
        
        
        setAlphaView(color: .white)
        
        
        
    }
    
    func setAlphaView(color: UIColor) {
        
        /*
         CAGradientLayer是CALayer的一个特殊子类，用于生成颜色渐变的图层
        colors    渐变的颜色
        locations    渐变颜色的分割点
        startPoint&endPoint    颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
         */
        
        if gradientLayer.superlayer == nil {
            gradientLayer.locations = [NSNumber.init(value: 0.0), NSNumber.init(value: 0.5), NSNumber.init(value: 1.0)]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0)
            alphaView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        gradientLayer.colors = [color.withAlphaComponent(0.7).cgColor, color.withAlphaComponent(0.0).cgColor, color.withAlphaComponent(0.7).cgColor]

        
    }
    
    override func layoutSubviews() {
        let textWidth: CGFloat = 64.0
        numImageView.frame = CGRect(x: frame.width / 2.0 - textWidth / 2.0, y: 0, width: textWidth, height: 33.0)
        numTextField.frame = CGRect(x: 0, y: 0, width: numImageView.frame.width, height: 28.0)
        
        collectionView?.frame = CGRect(x: 0, y: numImageView.frame.maxY,    width: frame.width, height: frame.height - numImageView.frame.height)
        
        flowLayout.sectionInset = UIEdgeInsetsMake(0, frame.width / 2.0 - PJYPickerView.cellWidth / 2.0, 0, frame.width / 2.0 - PJYPickerView.cellWidth / 2.0)

        alphaView.frame = (collectionView?.frame)!
        gradientLayer.frame = CGRect(x: 0, y: 0, width: alphaView.frame.width, height: alphaView.frame.height)

        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxNum / 10 / 5 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: PJYPickerView.cellWidth, height: 46.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PJYPickerView.cellid, for: indexPath) as! PickerViewCell
        
        
        cell.text = "\(indexPath.row * 50)元"
        
        cell.isHiddenLeft = indexPath.row == 0

        cell.isHiddenRight = indexPath.row == collectionView.numberOfItems(inSection: 0) - 1
        
        cell.setNeedsDisplay()

        
        return cell
    }
    
    
    
    public func changeNum(_ num: Int) {
        self.num = num
        collectionView?.contentOffset = CGPoint(x: PJYPickerView.cellWidth / 5.0 * CGFloat(num) / 10.0, y: collectionView!.contentOffset.y)
        self.numTextField.text = "\(num)"
    }
    
    func TextFieldTextDidChange(notify: Notification) {
        if let obj = notify.object as? UITextField, obj == self.numTextField, var value = Int(numTextField.text!) {
            
            if value > maxNum {
                numTextField.text = "\(maxNum)"
                value = maxNum
            }
            
            num = value
            
            collectionView?.contentOffset = CGPoint(x: CGFloat(num) * (PJYPickerView.cellWidth / 5.0) / 10.0, y: collectionView!.contentOffset.y)
            
            
            if let delegate = self.delegate, let action =  delegate.numDidChange {
                action(num)
            }
            
        }
        
    }
    
    //UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            num = Int(scrollView.contentOffset.x / (PJYPickerView.cellWidth / 5.0) * 10.0)
            if !numTextField.isFirstResponder {
                numTextField.text = "\(num)"
            }
            
            if let delegate = self.delegate, let action =  delegate.numDidChange {
                action(num)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        numTextField.resignFirstResponder()
    }
    
    
    
}
