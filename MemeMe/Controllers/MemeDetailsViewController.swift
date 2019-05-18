//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by Ahmed Almaged on 13/09/1440 AH.
//  Copyright © 1440 Ahmed Almaged. All rights reserved.
//

import UIKit

class MemeDetailsViewController: UIViewController {
   
    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.label.text = meme.top + " " + meme.bottom
        self.tabBarController?.tabBar.isHidden = true
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

}
