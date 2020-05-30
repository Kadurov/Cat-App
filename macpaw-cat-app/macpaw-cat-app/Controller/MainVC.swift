//
//  MainVC.swift
//  macpaw-cat-app
//
//  Created by Kadir Kadyrov on 17.05.2020.
//  Copyright © 2020 Kadir Kadyrov. All rights reserved.
//

import UIKit
import CoreData
let appDelegate = UIApplication.shared.delegate as? AppDelegate

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var catTable: UITableView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var searchIcon: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    
    private var breeds: Breeds = Breeds()
    private var images: Images = Images()
    private var nameConectToImage: [String: UIImage] = [String: UIImage]()
    
    static  var favorites: Breeds = Breeds()
    static public var favoritesNames: [FavoritesCoreData] = [FavoritesCoreData]()
    static public var favoritesImages: Images = Images()
    
    private var typeOfTable: TableType = .mainTable
    
    private var nameToFind: String = ""
    private var breedToFind: Breeds = Breeds()
    private var favoritesToFind: Breeds = Breeds()
    

    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        catTable.dataSource = self
        catTable.delegate = self
        searchBar.delegate = self
        favoritesButton.alpha = 0.25
        self.navigationController?.isNavigationBarHidden = true

        
        NetworkService.shared.getCatBreeds(onSuccess: { (Breeds) in
            self.breeds = Breeds
            //self.catTable.reloadData()
            self.updateImages()
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
        
        
        //catTable.reloadData()
    }
    @IBAction func swipeToRight(_ sender: Any) {
        favoritesButton.alpha = 0.25
        allButton.alpha = 1.0
        typeOfTable = .mainTable
        prepareToFind()
    }
    @IBAction func swipeTableToLeft(_ sender: Any) {
        favoritesButton.alpha = 1.0
        allButton.alpha = 0.25
        typeOfTable = .favoritesTable
        fetch { (complete) in
            debugPrint(complete)
        }
        prepareToFind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch { (complete) in
            debugPrint(complete)
        }
        prepareToFind()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func changeEdetingFind(_ sender: UITextField) {
        nameToFind = sender.text ?? ""
        prepareToFind()
    }
    
    
    
    func prepareToFind () {
        breedToFind.removeAll()
        favoritesToFind.removeAll()
        catTable.reloadData()
    }
    

    @IBAction func onClickedAllButton(_ sender: Any) {
        favoritesButton.alpha = 0.25
        allButton.alpha = 1.0
        typeOfTable = .mainTable
        prepareToFind()
    }
    
    @IBAction func onClickedFavoritesButton(_ sender: Any) {
        favoritesButton.alpha = 1.0
        allButton.alpha = 0.25
        typeOfTable = .favoritesTable
        fetch { (complete) in
            debugPrint(complete)
        }
        prepareToFind()
    }
    
    
    func updateImages () {
        for breed in breeds {
            NetworkService.shared.getImage(imageOfBreed: breed.id, onSuccess: { (Images) in
                self.images.append(contentsOf: Images)
                self.connectNameToImage(name: breed.name, url: Images[0].url)
            }) { (error) in
                debugPrint(error)
            }
        }
    }
    

    func connectNameToImage (name: String, url: String) {
        NetworkService.shared.downloadPicture(CatURL: url, onSuccess: { (UIImage) in
            self.nameConectToImage[name] = UIImage
            self.catTable.reloadData()
        }) { (errorMes) in
            debugPrint(errorMes)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nameToFind == "" {
            if typeOfTable == .mainTable {
                progressView.setProgress(Float(Float(self.nameConectToImage.count) / 60.0), animated: true)
                if self.nameConectToImage.count > 60 {
                    prepareTheView()
                    return self.nameConectToImage.count
                } else {
                    return 0
                }
            }
            if typeOfTable == .favoritesTable {
                return MainVC.self.favorites.count
            }
        } else {
            if typeOfTable == .mainTable {
                countAllCellsByName(nameOfBreed: nameToFind)
                return breedToFind.count
            }
            if typeOfTable == .favoritesTable {
                countFavoriteCellsByName(nameOfBreed: nameToFind)
                return favoritesToFind.count
            }
        }
        
        return 0
    }
    
    func prepareTheView () {
        progressView.isHidden = true
        catTable.isHidden = false
        favoritesButton.isHidden = false
        allButton.isHidden = false
        searchBar.isHidden = false
        searchIcon.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        fetch { (complete) in
            debugPrint(complete)
        }
    }
    
    func countAllCellsByName (nameOfBreed name: String) {
        for one in nameConectToImage {
            let smallName = name.lowercased()
            
            let nameOfCat = one.key.lowercased()
            
            if nameOfCat.contains(smallName) {
                breedToFind.append(findInBreed(nameOfBreed: one.key))
            }
        }
        
    }
    
    func countFavoriteCellsByName (nameOfBreed name: String) {
        
        for one in MainVC.self.favorites {
            let smallName = name.lowercased()
            
            let nameOfCat = one.name.lowercased()
            
            if nameOfCat.contains(smallName) {
                favoritesToFind.append(one)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if nameToFind == "" {
            if typeOfTable == .mainTable {
                if let cell = catTable.dequeueReusableCell(withIdentifier: "CatCell") as? CatCell {
                    
                    if nameConectToImage[breeds[indexPath.row].name] != nil {
                        cell.updateCell(nameOfCat: breeds[indexPath.row].name, image:       nameConectToImage[breeds[indexPath.row].name]!)
                    }
                    return cell
                } else {
                    return CatCell()
                }
            } else
                if typeOfTable == .favoritesTable {
                    if let cell = catTable.dequeueReusableCell(withIdentifier: "CatCell") as? CatCell {
                        
                        if nameConectToImage[MainVC.favorites[indexPath.row].name] != nil {
                            cell.updateCell(nameOfCat: MainVC.favorites[indexPath.row].name, image:       nameConectToImage[MainVC.favorites[indexPath.row].name]!)
                        }
                        return cell
                    } else {
                        return CatCell()
                    }
                } else {
                    return CatCell()
            }
        } else {
            if typeOfTable == .mainTable {
                if let cell = catTable.dequeueReusableCell(withIdentifier: "CatCell") as? CatCell {
                    
                    if nameConectToImage[breedToFind[indexPath.row].name] != nil {
                        cell.updateCell(nameOfCat: breedToFind[indexPath.row].name, image:       nameConectToImage[breedToFind[indexPath.row].name]!)
                    }
                    
                    
                    
                    return cell
                } else {
                    return CatCell()
                }
            } else
            if typeOfTable == .favoritesTable {
                    if let cell = catTable.dequeueReusableCell(withIdentifier: "CatCell") as? CatCell {
                        if nameConectToImage[favoritesToFind[indexPath.row].name] != nil {
                            cell.updateCell(nameOfCat: favoritesToFind[indexPath.row].name, image:       nameConectToImage[favoritesToFind[indexPath.row].name]!)
                        }
                        return cell
                    } else {
                        return CatCell()
                    }
                } else {
                    return CatCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if typeOfTable == .favoritesTable {
            let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { (contextualAction, view, boolValue) in
                boolValue(true)
                self.remove(at: indexPath)
                self.fetch { (complete) in
                    debugPrint(complete)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
            
            deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
        return UISwipeActionsConfiguration()
    }
    
    func remove (at index: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(MainVC.favoritesNames[index.row])
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NewDescriptionVC", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let descriptiomVC = segue.destination as? NewDescriptionVC {
            let indexPath: IndexPath = sender as! IndexPath
            
            if nameToFind == "" {
                if typeOfTable == .favoritesTable {
                    if nameConectToImage[MainVC.favorites[indexPath.row].name] != nil {
                        descriptiomVC.initDescriptionVC(nameConectToImage: nameConectToImage[MainVC.favorites[indexPath.row].name]!, image:MainVC.favoritesImages[indexPath.row], breed: MainVC.favorites[indexPath.row], isFavorites: true)
                        
                    }
                } else {
                    if nameConectToImage[breeds[indexPath.row].name] != nil {
                        descriptiomVC.initDescriptionVC(nameConectToImage: nameConectToImage[breeds[indexPath.row].name]!,
                                                        image: images[indexPath.row],
                                                        breed: breeds[indexPath.row],
                                                        isFavorites: isItFavorites(breedName: breeds[indexPath.row].name))
                    }
                }
            } else {
                if typeOfTable == .favoritesTable {
                    if nameConectToImage[favoritesToFind[indexPath.row].name] != nil {
                        descriptiomVC.initDescriptionVC(
                            nameConectToImage: nameConectToImage[favoritesToFind[indexPath.row].name]!,
                            image: findInImages(nameOfBreed: favoritesToFind[indexPath.row].name),
                            breed: favoritesToFind[indexPath.row],
                            isFavorites: true)
                        
                    }
                } else {
                    if nameConectToImage[breedToFind[indexPath.row].name] != nil {
                        descriptiomVC.initDescriptionVC(
                            nameConectToImage: nameConectToImage[breedToFind[indexPath.row].name]!,
                            image: findInImages(nameOfBreed: breedToFind[indexPath.row].name),
                            breed: breedToFind[indexPath.row],
                            isFavorites: isItFavorites(breedName: breedToFind[indexPath.row].name))
                    }
                }
            }
        }
        
        if let segue = segue.destination as? FilterVC {
            segue.initVC(breeds: breeds, images: images, nameCTI: nameConectToImage)
        }
    }
    
    func isItFavorites(breedName name: String) -> Bool {
        for breed in MainVC.favorites {
            if (name == breed.name) {
                return true
            }
        }
        return false
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<FavoritesCoreData>(entityName: "FavoritesCoreData")
        
        do {
            let favorites = try managedContext.fetch(fetchRequest)

            insertToFavoritesFromCoreData(favorites: favorites)
            MainVC.favoritesNames = favorites
            
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func insertToFavoritesFromCoreData (favorites: [FavoritesCoreData]) {
        if breeds.count != 0 && images.count != 0{
            var favImg = Images()
            var favBreed = Breeds()
            for name in favorites {
                favImg.append(findInImages(nameOfBreed: name.name!))
                favBreed.append(findInBreed(nameOfBreed: name.name!))
            }
            
            MainVC.favoritesImages = favImg
            MainVC.favorites = favBreed
        }
    }
    
    func findInBreed (nameOfBreed name: String) -> Breed {
        for breed in breeds {
            if(breed.name == name) {
                return breed
            }
        }
        return breeds[0]
    }
    
    func findInImages (nameOfBreed name: String) -> ImageFullVersion {
        for img in images {
            if img.breeds![0].name == name {
                return img
            }
        }
        return images[0]
    }
    
}
