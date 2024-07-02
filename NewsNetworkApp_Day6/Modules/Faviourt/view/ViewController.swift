//
//  ViewController.swift
//  NewsNetworkApp_Day6
//
//  Created by Rawan Elsayed on 29/04/2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    static var cameFromCoreData = false
    var favViewModel = FavViewModel()
    
    @IBOutlet weak var FavoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavoriteTableView.delegate = self
        FavoriteTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FavViewModel.bindResultToView = { [weak self ] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.FavoriteTableView.reloadData()
            }
        }
        FavViewModel.fetchDataFromCoreData()
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavViewModel.newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        
        let newsItem = FavViewModel.newsItems[indexPath.row]
        if let author = newsItem.value(forKey: "author") as? String {
            cell.textLabel?.text = author
        }
        
        if let imageUrlString = newsItem.value(forKey: "imageUrl") as? String,
           let imageData = Data(base64Encoded: imageUrlString),
           let image = UIImage(data: imageData) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(named: "images.jpeg")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        let selectedNewsItem = FavViewModel.newsItems[indexPath.row]
        let news = FavViewModel.convertToNewsObject(newsManagedObject: selectedNewsItem)
        ViewController.cameFromCoreData = true
        
        let viewModel = NewDetailsViewModel()
        viewModel.newsItem = news
        detailsVC.newDetailsViewModel = viewModel
        navigationController?.pushViewController(detailsVC, animated: true)
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let newsItemToRemove = FavViewModel.newsItems[indexPath.row]
            FavViewModel.newsItems.remove(at: indexPath.row)
            FavoriteTableView.deleteRows(at: [indexPath], with: .fade)
            FavViewModel.removeFromCoreData( object: newsItemToRemove)

            
        }
    }
}

