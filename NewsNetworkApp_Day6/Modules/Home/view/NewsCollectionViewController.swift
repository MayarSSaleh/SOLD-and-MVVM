//
//  NewsCollectionViewController.swift
//  NewsNetworkApp_Day6
//
//  Created by Rawan Elsayed on 29/04/2024.
//

import UIKit
import SDWebImage

class NewsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    static var cameFromCoreData = false

    var indicator: UIActivityIndicatorView?
    var viewModel : HomeViewModelProtocal?
    var handleCoreData : HandleCoreData?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        handleCoreData = HomeViewModel()
        indicator = UIActivityIndicatorView(style: .medium)
        indicator?.center = view.center
        indicator?.startAnimating()
        view.addSubview(indicator!)
        
        viewModel?.bindToView = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator?.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
        
        viewModel!.fetchData()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.news?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if let newsItem = viewModel!.news?[indexPath.item] {
            cell.titleInCell.text = newsItem.author
            if let imageUrl = URL(string: newsItem.imageUrl ?? "") {
                cell.imgInCell.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "images.jpeg"))
            } else {
                cell.imgInCell.image = UIImage(named: "images.jpeg")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 120)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedNews = viewModel!.news?[indexPath.item] {
            showDetailsViewController(with: selectedNews)
        }
    }
    
    func showDetailsViewController(with newsItem: News) {
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            let viewModel = NewDetailsViewModel()
            viewModel.newsItem = newsItem
            detailsVC.newDetailsViewModel = viewModel
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
