//
//  CancelServiceVC.swift
//  Quick Cuts
//
//  Created by Amit Kumar Dhal on 23/04/24.
//

import UIKit

class CancelServiceVC: UIViewController {
    
    private var contentSizeObservation:NSKeyValueObservation?

    @IBOutlet weak var cancelReasonCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelServiceCollectionViewOutlet: UICollectionView! {
        didSet{
            cancelServiceCollectionViewOutlet.registerCellFromNib(cellID: "CancelServiceCollectionCell")
            contentSizeObservation = cancelServiceCollectionViewOutlet.observe(\.contentSize, options: [.new]) { [weak self] cancelServiceCollectionViewOutlet, change in
                self?.cancelServiceCollectionViewOutlet.invalidateIntrinsicContentSize()
                self?.cancelReasonCollectionViewHeightConstraint.constant = cancelServiceCollectionViewOutlet.contentSize.height
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension CancelServiceVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CancelServiceCollectionCell", for: indexPath) as! CancelServiceCollectionCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let b = ( collectionView.layer.frame.width - 30 ) / 3
        let l = ( collectionView.layer.frame.width - 30 ) / 3
        return CGSize(width: b, height: l)
    }
}
