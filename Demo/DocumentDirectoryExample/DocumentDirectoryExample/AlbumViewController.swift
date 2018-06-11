//
//  AlbumViewController.swift
//  DocumentDirectoryExample
//
//  Created by MBA0202 on 5/27/18.
//  Copyright © 2018 MBA0202. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    
    fileprivate let kColumnCnt: Int = 2
    fileprivate let kCellSpacing: CGFloat = 2
    @IBOutlet weak var collectionView: UICollectionView!
    var arr: [UIImage?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        loadImages()
        print("test revert code ...")
    }

    func loadImages() {
        for name in arrImageName {
            let img = getImage(imageName: name)
            arr.append(img)
        }
    }

    func getImage(imageName: String) -> UIImage? {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath) {
            let image =  UIImage(contentsOfFile: imagePath)
            return image
        } else {
            return nil
        }
    }


    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")

        let layout = UICollectionViewFlowLayout()
        let imgWidth = (collectionView.frame.width - (kCellSpacing * (CGFloat(kColumnCnt) - 1))) / CGFloat(kColumnCnt)
        layout.itemSize = CGSize(width: imgWidth, height: 200)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        collectionView.collectionViewLayout = layout
    }
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            fatalError("error")
        }
        let img = arr[indexPath.row]
        cell.config(image: img)
        return cell
    }
}
