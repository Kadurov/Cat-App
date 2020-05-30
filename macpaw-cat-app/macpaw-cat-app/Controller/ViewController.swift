//
//  ViewController.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 17.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*NetworkService.shared.getCatCategories(onSuccess: { (Categories) in
            print(Categories)
        }) { (errorMessage) in
            print(errorMessage)
        }*/
        
        /*NetworkService.shared.getCatBreeds(onSuccess: { (Breeds) in
            print(Breeds)
        }) { (errorMessage) in
            print(errorMessage)
        }*/
        
        NetworkService.shared.getCats(onSuccess: { (Cat) in
            print(Cat)
        }) { (errorMessage) in
            print(errorMessage)
        }
        // Do any additional setup after loading the view.
    }


}

