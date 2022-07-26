//
//  ViewController.swift
//  DSLCollection
//
//  Created by Ryan on 2022/7/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testAttritbuedText()
    }
    
    func testAttritbuedText() {
        let label = UILabel.init()
        
        label.attributedText = createAttributedText()
        label.frame = CGRect.init(x: 0, y: 0, width: 375, height: 18)
        label.center = self.view.center
        label.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        view.addSubview(label)
    }
}

extension ViewController {
    private func createAttributedText() -> NSAttributedString {
        return NSAttributedString {
            AText("呀")
                .foregroundColor(Color.black)
                .font(Font.systemFont(ofSize: 12))
                .alignment(.center)
                .baselineOffset(1.5)
            
            AText("你好")
                .foregroundColor(Color.red)
                .font(Font.systemFont(ofSize: 18))
                .alignment(.center)
            
            ImageText(UIImage(systemName: "star")!)
                .bounds(CGRect.init(x: 0, y: -1.5, width: 18, height: 18))
        }
    }
}

