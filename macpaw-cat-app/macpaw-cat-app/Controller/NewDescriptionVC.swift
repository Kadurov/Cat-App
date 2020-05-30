//
//  NewDescriptionVC.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 18.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit
import CoreData
class NewDescriptionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var descriptionOfCat: UITextView!
    @IBOutlet weak var breedOfCat: UILabel!
    @IBOutlet weak var originOfCat: UILabel!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var lifeSpanOfCat: UILabel!
    @IBOutlet weak var descriptionTable: UITableView!
    @IBOutlet weak var activityCircle: UIActivityIndicatorView!
    @IBOutlet weak var catScroollGalery: UIScrollView!
    @IBOutlet weak var addToFavorites: UIButton!
    
    private var breed: Breed!
    private var image: ImageFullVersion!
    private var nameConectToImage: UIImage = UIImage()
    private var nameOfDescriptionToLevel: [String: Int] = [String: Int]()
    private var nameOfDescriptionToLevelYesNo: [String: Int] = [String: Int]()
    private var namesOfDescriptions: [String] = [String]()
    private var mainImage: UIImage = UIImage()
    private var imageToGalery: [UIImage] = [UIImage]()
    private var typeOfCell: [String: DescriptionCellType] = [String: DescriptionCellType]()
    private var isFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.3992092311, green: 0.3836411536, blue: 0.2096695304, alpha: 1)
        // set our VC
        descriptionOfCat.text = breed.breedDescription
        setVC()
        
        //
        descriptionTable.delegate = self
        descriptionTable.dataSource = self
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func swipeToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setVC () {
        imageToGalery.append(mainImage)
        setLabels()
        getNewImages()
        setFavoritesButton()
        updateHashTable()
    }
    
    func setLabels () {
        breedOfCat.text = breed.name
        lifeSpanOfCat.text = breed.lifeSpan
        originOfCat.text = breed.origin
    }
    
    
    @IBAction func onClickedAddToFavorites(_ sender: Any) {
        if !isFavorites {
            self.save()
            addToFavorites.setImage(UIImage(systemName: "star.fill"), for: .normal)
            MainVC.favorites.append(breed)
            MainVC.favoritesImages.append(image)
            isFavorites = true
        } else {
            addToFavorites.setImage(UIImage(systemName: "star"), for: .normal)
            self.remove()
            removeFromFavorites()
            isFavorites = false
        }
    }
    
    func removeFromFavorites () {
        for i in 0..<MainVC.favorites.count {
            if MainVC.favorites[i].name == breed.name {
                MainVC.favorites.remove(at: i)
                MainVC.favoritesImages.remove(at: i)
                return
            }
        }
    }
    
    func setFavoritesButton() {
        if isFavorites {
            addToFavorites.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            addToFavorites.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func getNewImages () {
        NetworkService.shared.getMubOfImage(numOfImages: 5, imageOfBreed: breed.id, onSuccess: { (Images) in
            self.addNewImages(images: Images)
            
        }) { (errorMes) in
            debugPrint(errorMes)
        }
    }
    
    func addNewImages (images: Images) {
        for image in images {
            if(image.url != self.image.url) {
                NetworkService.shared.downloadPicture(CatURL: image.url, onSuccess: { (UIImage) in
                    self.imageToGalery.append(UIImage)
                    self.setImages()
                }) { (errorMes) in
                    debugPrint(errorMes)
                }
            }
        }
    }
    
    
    
    func setImages () {
        
        if imageToGalery.count >= 4 {
            activityCircle.isHidden = true
            activityView.isHidden = true
            for i in 0..<imageToGalery.count {
                let imageView = UIImageView()
                
                imageView.image = imageToGalery[i]
                imageView.frame = CGRect(x: Double(Int(catScroollGalery.frame.width) * i), y: 0, width: Double(catScroollGalery.frame.width), height: Double(catScroollGalery.frame.height))
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
                catScroollGalery.contentSize.width = catScroollGalery.frame.width * (CGFloat(i + 1))
                catScroollGalery.addSubview(imageView)
            }
        }
    }
    
    @IBAction func imageTapped(sender: AnyObject) {
        performSegue(withIdentifier: "GaleryVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segue = segue.destination as? GaleryVC {
            segue.initGaleryVC(imagesOfCat: imageToGalery)
        }
        
        if let segue = segue.destination as? WebVC {
            
            segue.initVC(wikiURL: breed.wikipediaURL!)
        }
    }
    
    func updateHashTable() {
        if breed!.childFriendly != nil {
            nameOfDescriptionToLevel["Child friendly"] = breed.childFriendly!
            namesOfDescriptions.append("Child friendly")
            typeOfCell["Child friendly"] = .descriptionMain
        }
        if breed!.dogFriendly != nil {
            nameOfDescriptionToLevel["Dog friendly"] = breed.dogFriendly!
            namesOfDescriptions.append("Dog friendly")
            typeOfCell["Dog friendly"] = .descriptionMain
        }
        if breed!.energyLevel != nil {
            nameOfDescriptionToLevel["Energy level"] = breed.energyLevel!
            namesOfDescriptions.append("Energy level")
            typeOfCell["Energy level"] = .descriptionMain
        }
        if breed!.grooming != nil {
            nameOfDescriptionToLevel["Grooming"] = breed.grooming!
            namesOfDescriptions.append("Grooming")
            typeOfCell["Grooming"] = .descriptionMain
        }
        if breed!.healthIssues != nil {
            nameOfDescriptionToLevel["Health issue"] = breed.healthIssues!
            namesOfDescriptions.append("Health issue")
            typeOfCell["Health issue"] = .descriptionMain
        }
        if breed!.intelligence != nil {
            nameOfDescriptionToLevel["Intelligence"] = breed.dogFriendly!
            namesOfDescriptions.append("Intelligence")
            typeOfCell["Intelligence"] = .descriptionMain
        }
        if breed!.socialNeeds != nil {
            nameOfDescriptionToLevel["Social needs"] = breed.socialNeeds!
            namesOfDescriptions.append("Social needs")
            typeOfCell["Social needs"] = .descriptionMain
        }
        if breed!.strangerFriendly != nil {
            nameOfDescriptionToLevel["Stranger friendly"] = breed.strangerFriendly!
            namesOfDescriptions.append("Stranger friendly")
            typeOfCell["Stranger friendly"] = .descriptionMain
        }
        if breed!.vocalisation != nil {
            nameOfDescriptionToLevel["Vocalisation"] = breed.vocalisation!
            namesOfDescriptions.append("Vocalisation")
            typeOfCell["Vocalisation"] = .descriptionMain
        }
        //----
        if breed!.hairless != nil {
            nameOfDescriptionToLevel["Hair Less"] = breed.hairless!
            namesOfDescriptions.append("Hair Less")
            typeOfCell["Hair Less"] = .descriptionYesNo
        }
        if breed!.rare != nil {
            nameOfDescriptionToLevel["Rare"] = breed.rare!
            namesOfDescriptions.append("Rare")
            typeOfCell["Rare"] = .descriptionYesNo
        }
        if breed!.hypoallergenic != nil {
            nameOfDescriptionToLevel["Hypoallergenic"] = breed.hypoallergenic!
            namesOfDescriptions.append("Hypoallergenic")
            typeOfCell["Hypoallergenic"] = .descriptionYesNo
        }
        if breed!.shortLegs != nil {
            nameOfDescriptionToLevel["Short legs"] = breed.shortLegs!
            namesOfDescriptions.append("Short legs")
            typeOfCell["Short legs"] = .descriptionYesNo
        }
        
        
    }
    
    func initDescriptionVC (nameConectToImage: UIImage, image: ImageFullVersion, breed: Breed, isFavorites: Bool) {
        self.breed = breed
        self.image = image
        self.mainImage = nameConectToImage
        self.isFavorites = isFavorites
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesOfDescriptions.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = descriptionTable.dequeueReusableCell(withIdentifier: "DescriptionCell") as? DescriptiomCell {
                
            if nameOfDescriptionToLevel[namesOfDescriptions[indexPath.row]] != nil {

                cell.updateCell(name: namesOfDescriptions[indexPath.row],
                                level: nameOfDescriptionToLevel[namesOfDescriptions[indexPath.row]]!,
                                typeOfCell: typeOfCell[namesOfDescriptions[indexPath.row]]!)
            }
            return cell
        } else {
            return DescriptiomCell()
        }
    }
    
    func save () {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fav = FavoritesCoreData(context: managedContext)
        fav.name = breed.name
        
        do {
            try managedContext.save()
            
        } catch {
            debugPrint(error)
        }
    }
    
    func remove () {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        for i in 0..<MainVC.favoritesNames.count {
            if MainVC.favoritesNames[i].name == breed.name {
                managedContext.delete(MainVC.favoritesNames[i])
            }
        }
        
        
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
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
