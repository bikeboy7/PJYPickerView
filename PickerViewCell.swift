//
//  PickerViewCell.swift
//  PJYPickerView
//
//  Created by boy on 2017/7/27.
//  Copyright © 2017年 pjy. All rights reserved.
//

import UIKit

class PickerViewCell: UICollectionViewCell {
    
    
    private let numLabel = UILabel()
    
    var text = "" {
        didSet{
            numLabel.text = text
        }
    }
    
    var isHiddenLeft: Bool = false
    
    var isHiddenRight: Bool = false

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
        
    }
    
    func initView() {
        
        backgroundColor = UIColor.clear
        
        numLabel.textColor = UIColor.init(red: 91.0 / 255.0, green: 91.0 / 255.0, blue: 91.0 / 255.0, alpha: 1)
        numLabel.font = UIFont(name: "PingFang SC", size: 14.0)
        numLabel.textAlignment = .center
        self.addSubview(numLabel)
        
    }
    
    override func layoutSubviews() {
        numLabel.frame = CGRect(x: 0, y: 20.0 + 4.0, width: frame.width, height: 20.0)
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        var point1 = CGPoint(x: rect.minX, y: 20.0)
        var point2 = CGPoint(x: rect.maxX, y: 20.0)
        
        if isHiddenLeft {
            point1 = CGPoint(x: rect.maxX / 2.0, y: 20.0)
        }
        
        if isHiddenRight {
            point2 = CGPoint(x: rect.maxX / 2.0, y: 20.0)
        }

        ctx?.addLines(between: [point1, point2])
        
        
        let space: CGFloat = PJYPickerView.cellWidth / 5.0 
        for i in 0..<5 {
            
            if (isHiddenLeft && i < 2) || (isHiddenRight && i > 2) {
               continue
            }
            
            let height: CGFloat = i == 2 ? 10.0 : 5.0
            let xx = space / 2.0 + CGFloat(i) * space
            let point1 = CGPoint(x: xx, y: 20.0)
            let point2 = CGPoint(x: xx, y: 20.0 - height)
            
            ctx?.addLines(between: [point1, point2])

        }
        
        ctx?.setStrokeColor(UIColor.init(red: 176.0 / 255.0, green: 176.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0).cgColor)

        
        ctx?.strokePath()

        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
