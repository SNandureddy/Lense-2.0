//
//  ImageListVC.swift
//  Lens App
//
//  Created by Apple on 01/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class ImageListVC: BaseVC {
    
    //MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var headerNameLabel: UILabel!
    
    //MARK:- varibles
    var index = 0
    
    //MARK:- Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        self.setupCollectionLayout()
        self.headerNameLabel.text = BookingVM.shared.userBookingImages[self.index].photographerName ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeViews()
    }
    
    // MARK: IBAction
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.backButtonAction()
    }
    
    //MARK:- Private Methods
    private func setupCollectionLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumLineSpacing = 5
//            layout.minimumInteritemSpacing = 2
//            layout.sectionInset = UIEdgeInsets(top:0, left: 10, bottom: 0, right: 10)
//            layout.scrollDirection = .vertical
//            collectionView.collectionViewLayout = layout
        }
    }
}

//MARK:- CollectionView Datasource
extension ImageListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BookingVM.shared.userBookingImages[self.index].bookingImages.count
    }
    
    func collectionView(_ collectionsView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kImageCell, for: indexPath) as! ImageCell
        cell.imageView.sd_setImage(with: BookingVM.shared.userBookingImages[self.index].bookingImages[indexPath.row].image, placeholderImage: #imageLiteral(resourceName: "imageIcon"), completed:{ (image, error, cache, url) in
            BookingVM.shared.userBookingImages[self.index].bookingImages[indexPath.row].isCompleteCache = true
        })
        
        return cell
    }
}

//MARK:- CollectionView Delegate
extension ImageListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  BookingVM.shared.userBookingImages[self.index].bookingImages[indexPath.row].isCompleteCache
        {
            let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
            let imagevc = self.storyboard?.instantiateViewController(withIdentifier: kViewImageVC) as! ViewImageVC
            imagevc.image = cell.imageView.image!
            imagevc.listIndex = self.index
            imagevc.index = indexPath.row
            let myOneCount = BookingVM.shared.userBookingImages[self.index].downloadStatus.filter({$0 == 1}).count
            
            if myOneCount == 1 && !BookingVM.shared.userBookingImages[self.index].ratingStatus{
                imagevc.showRating = true
            }
            else{
                imagevc.showRating = false
            }
            self.navigationController?.present(imagevc, animated: true, completion: nil)
        }
        else
        {
            self.showAlert(message: kErrorWhileShowImageMessage)
        }
    }
}

//MARK: - CollectionView Flow Delegate
extension ImageListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionwidth = collectionView.bounds.width
        return CGSize(width: collectionwidth/3, height: collectionwidth/3)
    }
    
}

// MARK: - Customization
extension ImageListVC{
    func customizeViews(){
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.cornerRadius = 5
    }
}
