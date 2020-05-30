//
//  GaleryVC.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 18.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit

class GaleryVC: UIViewController, UIScrollViewDelegate {
    private var images: [UIImage] = [UIImage]()
    @IBOutlet weak var galerySrcoll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galerySrcoll.delegate = self
        // Do any additional setup after loading the view.
        setPictures()
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.3992092311, green: 0.3836411536, blue: 0.2096695304, alpha: 1)
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func setPictures () {
        for i in 0..<images.count {
            
            let img = UIImageView()
            
            img.contentMode = .scaleAspectFit
            img.frame = CGRect(x: Double(view.frame.width * CGFloat(i)), y: 0, width:       Double(view.frame.width), height: Double(view.frame.height))
            img.image = images[i]
            
            
            
            galerySrcoll.contentSize.width = view.frame.width * CGFloat(i + 1)
            
            galerySrcoll.addSubview(img)
        }
    }
    
    
    
    
    
    @IBAction func goBackSwipe(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    func initGaleryVC (imagesOfCat img: [UIImage]) {
        images = img
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
