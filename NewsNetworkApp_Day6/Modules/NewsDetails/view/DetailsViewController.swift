//
//  DetailsViewController.swift
//  NewsNetworkApp_Day6
//
//  Created by Rawan Elsayed on 29/04/2024.
//
import UIKit
import SDWebImage

class DetailsViewController: UIViewController {

    var isFavorite = false
    var newDetailsViewModel: NewDetailsViewModelProtocol!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextView!
    @IBOutlet weak var publishLabel: UILabel!
    @IBOutlet weak var descTextField: UITextView!
    @IBOutlet weak var favoriteBtn: UIButton!

    @IBAction func addToFavBtn(_ sender: UIButton) {
        isFavorite.toggle()
        if isFavorite {
            favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            NewDetailsViewModel.saveToCoreData(news: newDetailsViewModel.newsItem ?? News())
        } else {
            favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            NewDetailsViewModel.removeFromCoreData(news: newDetailsViewModel.newsItem ?? News())
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        newDetailsViewModel.bindToView = { [weak self] in
            self?.updateUI()
        }
        newDetailsViewModel.bindToView?()
    }

    private func updateUI() {
        guard let news = newDetailsViewModel.newsItem else { return }

        authorLabel.text = news.author
        titleTextField.text = news.title
        publishLabel.text = news.publishedAt
        descTextField.text = news.desription

        if ViewController.cameFromCoreData {
            ViewController.cameFromCoreData = false
            if let imageUrlString = news.imageUrl,
               let imageData = Data(base64Encoded: imageUrlString),
               let image = UIImage(data: imageData) {
                imgView.image = image
                print("image is attached from core data")
            } else {
                imgView.image = UIImage(named: "images.jpeg")
            }
        } else {
            if let imageUrlString = news.imageUrl {
                let imageUrl = URL(string: imageUrlString)
                imgView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "images.jpeg")) { _, _, _, _ in
                    print("image is attached from internet")
                }
            }
        }
        isFavorite = NewDetailsViewModel.isNewsSavedToCoreData(newsTitle: news.title ?? "")
        updateFavoriteButtonImage()
    }

    private func updateFavoriteButtonImage() {
        if isFavorite {
            favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
