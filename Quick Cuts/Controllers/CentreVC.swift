//
//  CentreVCViewController.swift
//  Quick Cuts
//
//  Created by Neeraj Sharma on 29/04/24.
//

import UIKit

class CentreVC: UIViewController {
    

    @IBOutlet weak var centreCollectionView: UICollectionView!{
        didSet{
            centreCollectionView.registerCellFromNib(cellID: "CentreCollectionViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}


    


extension CentreVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CentreCollectionViewCell", for: indexPath) as! CentreCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( collectionView.frame.width - 10 ) / 2
        let height = (width * 109) / 169
        return CGSize(width: width, height: height)
    }
}

