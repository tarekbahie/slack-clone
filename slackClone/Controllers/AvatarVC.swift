//
//  AvatarVC.swift
//  slackClone
//
//  Created by tarek bahie on 1/19/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class AvatarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    

    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var avatarCollectionView: UICollectionView!
    
    var avatarType : AvatarType = .dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarCollectionView.delegate = self
        avatarCollectionView.dataSource = self

    }
    
    
    @IBAction func segmentControllerChanged(_ sender: Any) {
        if segmentController.selectedSegmentIndex == 0{
            avatarType = .dark
        } else {
            avatarType = .light
        }
        avatarCollectionView.reloadData()
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarCell
        cell.configureCell(index: indexPath.row, type: avatarType)
        
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if avatarType == .dark {
        UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        } else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
