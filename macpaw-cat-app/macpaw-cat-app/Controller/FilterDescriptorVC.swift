//
//  FilterDescriptorVC.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 21.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit

class FilterDescriptorVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableOfCats: UITableView!
    
    private var breeds: Breeds = Breeds()
    private var images: Images = Images()
    private var nameConectToImage: [String: UIImage] = [String: UIImage]()
    private var filter: [String: String] = [String: String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.3992092311, green: 0.3836411536, blue: 0.2096695304, alpha: 1)
        tableOfCats.delegate = self
        tableOfCats.dataSource = self
        
        findCatsWithFilter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableOfCats.reloadData()
    }
    
    func findCatsWithFilter () {
        var breeds: Breeds = Breeds()
        var images: Images = Images()
        var nameConectToImage: [String: UIImage] = [String: UIImage]()
        for i in 0..<self.breeds.count {
            if ifBreedInFilter(breed: self.breeds[i]) {
                breeds.append(self.breeds[i])
                images.append(self.images[i])
                nameConectToImage[self.breeds[i].name] = self.nameConectToImage[self.breeds[i].name]
            }
        }
        
        
        
        self.breeds = breeds
        self.images = images
        self.nameConectToImage = nameConectToImage
    }
    
    func getLevelString (level: Int, type: DescriptionCellType) -> String {
        if type == .descriptionMain {
            switch level {
            case 1...2:
                return "Low"
            case 3:
                return "Medium"
            case 4...5:
                return "High"
            default:
                return "None"
            }
        } else {
            switch level {
            case 1:
                return "Yes"
            case 0:
                return "No"
            default:
                return "None"
            }
        }
    }
    
    func ifBreedInFilter (breed: Breed) -> Bool {
        if filter["Child friendly"] != getLevelString(level: breed.childFriendly!, type: .descriptionMain) && filter["Child friendly"] != "No filter" {
            return false
        }
        if filter["Dog friendly"] != getLevelString(level: breed.dogFriendly!, type: .descriptionMain) && filter["Dog friendly"] != "No filter" {
            return false
        }
        if filter["Energy level"] != getLevelString(level: breed.energyLevel!, type: .descriptionMain) && filter["Energy level"] != "No filter" {
            return false
        }
        if filter["Groomin"] != getLevelString(level: breed.grooming!, type: .descriptionMain) && filter["Groomin"] != "No filter" {
            return false
        }
        if filter["Health issue"] != getLevelString(level: breed.healthIssues!, type: .descriptionMain) && filter["Health issue"] != "No filter" {
            return false
        }
        if filter["Intelligence"] != getLevelString(level: breed.intelligence!, type: .descriptionMain) && filter["Intelligence"] != "No filter" {
            return false
        }
        if filter["Social needs"] != getLevelString(level: breed.socialNeeds!, type: .descriptionMain) && filter["Social needs"] != "No filter" {
            return false
        }
        if filter["Stranger friendly"] != getLevelString(level: breed.strangerFriendly!, type: .descriptionMain) && filter["Stranger friendly"] != "No filter" {
            return false
        }
        if filter["Vocalisation"] != getLevelString(level: breed.vocalisation!, type: .descriptionMain) && filter["Vocalisation"] != "No filter" {
            return false
        }
        if filter["Rare"] != getLevelString(level: breed.rare!, type: .descriptionYesNo) &&
            filter["Rare"] != "No filter" {
            return false
        }
        if filter["Hypoallergenic"] != getLevelString(level: breed.hypoallergenic!, type: .descriptionYesNo) && filter["Hypoallergenic"] != "No filter" {
            return false
        }
        if filter["Short legs"] != getLevelString(level: breed.shortLegs!, type: .descriptionYesNo) && filter["Short legs"] != "No filter" {
            return false
        }
        if filter["Hair less"] != getLevelString(level: breed.hairless!, type: .descriptionYesNo) &&
            filter["Hair less"] != "No filter" {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameConectToImage.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NewDescriptionVCFromFilter", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let descriptiomVC = segue.destination as? NewDescriptionVC {
            let indexPath: IndexPath = sender as! IndexPath
            if nameConectToImage[breeds[indexPath.row].name] != nil {
                descriptiomVC.initDescriptionVC(nameConectToImage: nameConectToImage[breeds[indexPath.row].name]!,
                                                image: images[indexPath.row],
                                                breed: breeds[indexPath.row],
                                                isFavorites: isItFavorites(breedName: breeds[indexPath.row].name))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableOfCats.dequeueReusableCell(withIdentifier: "CatCell") as? CatCell {
            
            if nameConectToImage[breeds[indexPath.row].name] != nil {
                cell.updateCell(nameOfCat: breeds[indexPath.row].name, image:       nameConectToImage[breeds[indexPath.row].name]!)
            }
            return cell
        } else {
            return CatCell()
        }
    }
    
    func initVC (breeds: Breeds, images: Images, nameCTI: [String: UIImage], filter: [String: String]) {
        self.breeds = breeds
        self.images = images
        self.nameConectToImage = nameCTI
        self.filter = filter
    }
       
    
    func isItFavorites(breedName name: String) -> Bool {
        for breed in MainVC.favorites {
            if (name == breed.name) {
                return true
            }
        }
        return false
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
