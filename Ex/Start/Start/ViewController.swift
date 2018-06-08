//
//  ViewController.swift
//  Start
//
//  Created by Anh Tuấn on 6/8/18.
//  Copyright © 2018 Anh Tuấn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 50, y: 100, width: 200, height: 300)
        let userAvatar = UIImageView(image: UIImage(named: "123.jpg"))
        userAvatar.frame = frame
        userAvatar.contentMode = .scaleToFill
        view.addSubview(userAvatar)
        // add user name
        let userName = UILabel(frame: CGRect(x: 50, y: 450, width: 200, height: 50))
        userName.text = "User name"
        userName.backgroundColor = .lightGray
        userName.textColor = .blue
        view.addSubview(userName)
        
        //add button
        let button = UIButton(frame: CGRect(x: 50, y: 100, width: 100, height: 250))
        button.backgroundColor = .clear
        button.addTarget(self , action: #selector(buttonDidClick), for: .touchUpInside)
        view.addSubview(button)
    }
    @objc func buttonDidClick() {
        print("Button is clicked!")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

