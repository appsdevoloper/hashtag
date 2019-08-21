//
//  HomeViewController.swift
//  Demo
//
//  Created by Apple on 29/07/19.
//  Copyright © 2019 demo. All rights reserved.
//

import UIKit
import NextGrowingTextView

class KeyboardViewController: UIViewController, UITextViewDelegate {

  @IBOutlet weak var inputContainerView: UIView!
  @IBOutlet weak var inputContainerViewBottom: NSLayoutConstraint!
  @IBOutlet weak var growingTextView: NextGrowingTextView!
  @IBOutlet var toolbarview: UIView!
  @IBOutlet weak var cornerView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(KeyboardViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    self.growingTextView.layer.cornerRadius = 4
    //self.growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
    self.growingTextView.backgroundColor = UIColor.clear
    self.growingTextView.placeholderAttributedText = NSAttributedString(
      string: "Placeholder text",
      attributes: [
        .font: self.growingTextView.textView.font!,
        .foregroundColor: UIColor.gray
      ]
    )
    growingTextView.textView.inputAccessoryView = toolbarview
    
    // MARK: TapGesture For Self View
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    self.view.addGestureRecognizer(tap)
    
    // MARK: View Background
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    
    //MARK:- Corner Radius of only two side of UIViews
    self.cornerView.roundCorners([.topLeft, .topRight], radius: 12)
  }
  
  @IBAction func sendAction(_ sender: Any) {
    self.growingTextView.resignFirstResponder()
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.growingTextView.becomeFirstResponder()
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    self.growingTextView.resignFirstResponder()
    self.dismiss(animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  /*@IBAction func handleSendButton(_ sender: AnyObject) {
    self.growingTextView.textView.text = ""
    self.view.endEditing(true)
  }*/

  @objc func keyboardWillHide(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        //key point 0,
        self.inputContainerViewBottom.constant =  0
        //textViewBottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
      }
    }
  }
  
  @objc func keyboardWillShow(_ sender: Notification) {
    if let userInfo = (sender as NSNotification).userInfo {
      if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
        self.inputContainerViewBottom.constant = keyboardHeight
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          self.view.layoutIfNeeded()
        })
      }
    }
  }
}

extension UIView {
  
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
  
}

