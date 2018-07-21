//
//  CustomizeSegmentedControl.swift
//  Jianghu
//
//  Created by WANG, Yanqi on 2018/4/19.
//  Copyright © 2018年 InternationalTradeMaster. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizeSegmentedControl: UIControl {
    
    var buttons=[UIButton]()
    var selector:UIView!;
    var selectedValue=0;
    
    @IBInspectable
    var borderWidth:CGFloat=0{
        didSet{
            layer.borderWidth=borderWidth
        }
    }
    
    @IBInspectable
    var borderColor:UIColor=UIColor.clear{
        didSet{
            layer.borderColor=borderColor.cgColor
        }
    }
    
    @IBInspectable
    var ButtonTitleString: String = ""{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var textColor:UIColor = .lightGray{
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var selectedColor:UIColor = .darkGray{
        didSet{
            updateView()
        }
    }
    
    @objc func buttonTapped(button:UIButton){
        for btn in buttons{
            btn.setTitleColor(textColor, for: .normal)
            if btn==button{
                btn.setTitleColor(selectedColor, for: .normal)
            }
        }
        selectedValue=buttons.index(of: button)!;
        let selectorStartPosition=frame.width/CGFloat(buttons.count)*CGFloat(selectedValue)
        UIView.animate(withDuration: 0.3, animations: {
            self.selector.frame.origin.x=selectorStartPosition
            
        })
        print (self.selector.frame.origin.x);
        sendActions(for: .valueChanged)
    }
    
    
    func updateView() {
        
        buttons.removeAll()
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        let buttonTitles=ButtonTitleString.components(separatedBy: ",")
        for buttonTitle in buttonTitles{
            let button=UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
         //   button.titleLabel?.font = UIFont(name: "STXingkai", size: 20)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(UIColor.black, for: .normal)
        let sv=UIStackView(arrangedSubviews: buttons)
        let selectorWidth=frame.width/CGFloat(buttonTitles.count)
        selector=UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        let border = CALayer()
        let borderWidth = CGFloat(2.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: selector.frame.size.width*0.3, y: self.frame.size.height - borderWidth, width:  selector.frame.size.width*0.4, height: selector.frame.size.height)
        border.borderWidth = borderWidth
        selector.layer.addSublayer(border)
        self.layer.masksToBounds = true

        addSubview(selector);
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints=false
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive=true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive=true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive=true
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
 

}



