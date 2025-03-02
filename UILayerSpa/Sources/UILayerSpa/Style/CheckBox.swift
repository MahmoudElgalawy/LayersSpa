//
//  File.swift
//  
//
//  Created by marwa on 19/07/2024.
//

import Foundation
import UIKit

public class CheckBox: UIView {
    // Images
    var checkedBtn: UIButton = UIButton()
    var uncheckedBtn : UIButton = UIButton()
    
    // Bool property
   public var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.addButton(checkedBtn, 1)
                self.removeButton(uncheckedBtn, 2)
            } else {
                self.addButton(uncheckedBtn, 2)
                self.removeButton(checkedBtn, 1)
            }
        }
    }
        
    public override func awakeFromNib() {
        checkedBtn = createCheckBoxBtn()
        uncheckedBtn = createUnCheckBoxBtn()
        self.isChecked = false
    }
        
    @objc func buttonClicked(sender: UIButton) {
            isChecked = !isChecked
    }
    
    func createCheckBoxBtn() -> UIButton {
        let image = UIImage.checkBox
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        button.setBackgroundImage(image, for: UIControl.State.normal)
        button.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        return button
    }
    
    func createUnCheckBoxBtn() -> UIButton {
        let image = UIImage.uncheckedBox
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        button.setBackgroundImage(image, for: UIControl.State.normal)
        button.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        return button
    }
}

