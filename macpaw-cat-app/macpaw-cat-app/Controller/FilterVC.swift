//
//  FilterVC.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 20.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var childFriendly: UISegmentedControl!
    @IBOutlet weak var dogFriendly: UISegmentedControl!
    @IBOutlet weak var energyLevel: UISegmentedControl!
    @IBOutlet weak var grooming: UISegmentedControl!
    @IBOutlet weak var healthIssue: UISegmentedControl!
    @IBOutlet weak var intelligence: UISegmentedControl!
    @IBOutlet weak var socialNeeds: UISegmentedControl!
    @IBOutlet weak var strangerFriendly: UISegmentedControl!
    @IBOutlet weak var vocalisation: UISegmentedControl!
    @IBOutlet weak var rare: UISegmentedControl!
    @IBOutlet weak var hypoallergenic: UISegmentedControl!
    @IBOutlet weak var shortLegs: UISegmentedControl!
    @IBOutlet weak var hairLess: UISegmentedControl!
    
    private var breeds: Breeds = Breeds()
    private var images: Images = Images()
    private var nameConectToImage: [String: UIImage] = [String: UIImage]()
    private var filter: [String: String] = [String: String]()
    
    @IBAction func onFindTap(_ sender: UIButton) {
        filter["Child friendly"] = childFriendly.titleForSegment(at: childFriendly.selectedSegmentIndex)
        filter["Dog friendly"] = dogFriendly.titleForSegment(at: dogFriendly.selectedSegmentIndex)
        filter["Energy level"] = energyLevel.titleForSegment(at: energyLevel.selectedSegmentIndex)
        filter["Groomin"] = grooming.titleForSegment(at: grooming.selectedSegmentIndex)
        filter["Health issue"] = healthIssue.titleForSegment(at: healthIssue.selectedSegmentIndex)
        filter["Intelligence"] = intelligence.titleForSegment(at: intelligence.selectedSegmentIndex)
        filter["Social needs"] = socialNeeds.titleForSegment(at: socialNeeds.selectedSegmentIndex)
        filter["Stranger friendly"] = strangerFriendly.titleForSegment(at: strangerFriendly.selectedSegmentIndex)
        filter["Vocalisation"] = vocalisation.titleForSegment(at: vocalisation.selectedSegmentIndex)
        filter["Rare"] = rare.titleForSegment(at: rare.selectedSegmentIndex)
        filter["Hypoallergenic"] = hypoallergenic.titleForSegment(at: hypoallergenic.selectedSegmentIndex)
        filter["Short legs"] = shortLegs.titleForSegment(at: shortLegs.selectedSegmentIndex)
        filter["Hair less"] = hairLess.titleForSegment(at: hairLess.selectedSegmentIndex)
        
        performSegue(withIdentifier: "FilterDescriptorVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.destination as? FilterDescriptorVC {
            
            segue.initVC(breeds: breeds, images: images, nameCTI: nameConectToImage, filter: filter)
        }
    }
    
    func initVC (breeds: Breeds, images: Images, nameCTI: [String: UIImage]) {
        self.breeds = breeds
        self.images = images
        self.nameConectToImage = nameCTI
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.3992092311, green: 0.3836411536, blue: 0.2096695304, alpha: 1)
        filterButton.layer.cornerRadius = filterButton.frame.height / 2
        // Do any additional setup after loading the view.
    }

}
