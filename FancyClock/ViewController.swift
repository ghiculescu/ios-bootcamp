//
//  ViewController.swift
//  FancyClock
//
//  Created by Javan Wood on 21/4/17.
//  Copyright © 2017 iOS Bootcamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("World")
        
        dateFormatter.timeStyle = .medium
        
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
        label.text = dateFormatter.string(from: Date())
        label.font = UIFont.systemFont(ofSize: 50.0)
        label.textAlignment = .center
        view.addSubview(label)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            label.text = self?.dateFormatter.string(from: Date())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

