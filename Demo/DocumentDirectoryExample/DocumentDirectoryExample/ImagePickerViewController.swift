//
//  ImagePickerViewController.swift
//  DocumentDirectoryExample
//
//  Created by MBA0202 on 5/27/18.
//  Copyright © 2018 MBA0202. All rights reserved.
//

import UIKit
import Photos

class ImagePickerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let kCellReuseIdentifier = "CollectionViewCell"
    fileprivate let kColumnCnt: Int = 3
    fileprivate let kCellSpacing: CGFloat = 2
    fileprivate var fetchResult: PHFetchResult<PHAsset>!
    fileprivate var imageManager = PHCachingImageManager()
    fileprivate var targetSize = CGSize.zero
    var photoAsset = PHAsset()
    var path: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        loadPhotos()

    }

    func configCollectionView() {
        let imgWidth = (collectionView.frame.width - (kCellSpacing * (CGFloat(kColumnCnt) - 1))) / CGFloat(kColumnCnt)
        targetSize = CGSize(width: imgWidth, height: imgWidth)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = targetSize
        layout.minimumInteritemSpacing = kCellSpacing
        layout.minimumLineSpacing = kCellSpacing
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: kCellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: kCellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func loadPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchResult = PHAsset.fetchAssets(with: .image, options: options)
    }
    
    func updateView() {
        loadPhotos()
        collectionView.reloadData()
    }

    @IBAction func dismissButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func importButtonTouchUpInside(_ sender: UIButton) {
        let imageRequestOptions = PHImageRequestOptions()
        PHImageManager.default().requestImageData(for: photoAsset, options: imageRequestOptions, resultHandler: { (_ imageData: Data?, _ dataUTI: String?, _ orientation: UIImageOrientation, _ info: [AnyHashable: Any]?) -> Void in
            if let anInfo = info {
                print("info = \(anInfo)")
            }
            if info?["PHImageFileURLKey"] != nil {
                self.path = info?["PHImageFileURLKey"] as? URL
                guard let data = imageData else {
                    fatalError("dm")
                }
                self.saveImageToDocumennt(data: data)
            }
        })
        deletePhoto()
    }

    func saveImageToDocumennt(data: Data) {
        let fileManager = FileManager.default
        i += 1
        let name = "test\(i).png"
        arrImageName.append(name)
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }

    func deletePhoto() {
        PHPhotoLibrary.shared().performChanges({
            let assets: NSArray = [self.photoAsset]
            PHAssetChangeRequest.deleteAssets(assets)
        }) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.updateView()
                }
            } else {
                self.alert(error: error!)
            }
        }
    }
}

extension ImagePickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuseIdentifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        let photoAsset = fetchResult.object(at: indexPath.item)
        imageManager.requestImage(for: photoAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, info) -> Void in
            cell.config(image: image)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
}

extension ImagePickerViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.imageManager.startCachingImages(for: indexPaths.map { self.fetchResult.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.imageManager.stopCachingImages(for: indexPaths.map { self.fetchResult.object(at: $0.item) }, targetSize: self.targetSize, contentMode: .aspectFill, options: nil)
        }
    }
}

extension ImagePickerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoAsset = fetchResult.object(at: indexPath.item)
        self.photoAsset = photoAsset
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        cell.select()
    }
}
