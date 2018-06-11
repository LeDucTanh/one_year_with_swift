//
//  HomeViewController.swift
//  DocumentDirectoryExample
//
//  Created by MBA0202 on 5/27/18.
//  Copyright © 2018 MBA0202. All rights reserved.
//

import UIKit
import Photos
import GCDWebServer

var i = 0
var arrImageName: [String] = []
class HomeViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    var imagePickerController: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        initWebServer()
    }

    func initWebServer() {

        let webServer = GCDWebServer()

        webServer.addHandler(forMethod: "GET", path: "/", request: GCDWebServerRequest.self, processBlock: { request in
            return GCDWebServerDataResponse()

        })

        webServer.start(withPort: 8080, bonjourName: "GCD Web Server")

        print("Visit \(webServer.serverURL) in your web browser")
    }


    func saveImage(imageName: String) {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        let image = photoImageView.image!
        let data = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        if fileManager.fileExists(atPath: imagePath) {
            alert(title: "Message", msg: "Photo saved successfully", buttons: ["OK"]) { (actions) in
                guard let title = actions.title else { return }
                switch title {
                default: break
                }
            }
        } else {
            alert(title: "Message", msg: "Photo cannot save", buttons: ["OK"]) { (actions) in
                guard let title = actions.title else { return }
                switch title {
                default: break
                }
            }
        }
    }

    @IBAction func gotoCameraTouchUpInside(_ sender: UIButton) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func gotoAlbumTouchUpInside(_ sender: UIButton) {
        navigationController?.pushViewController(AlbumViewController(), animated: true)
    }

    @IBAction func savePhotoButtonTouchInside(_ sender: UIButton) {
        i += 1
        let name = "test\(i).png"
        arrImageName.append(name)
        saveImage(imageName: name)
    }

    @IBAction func gotoCameraRoll(_ sender: UIButton) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch (status) {
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) -> Void in
                if status == PHAuthorizationStatus.authorized {
                    self.present(ImagePickerViewController(), animated: true, completion: nil)
                }
            }
        case PHAuthorizationStatus.authorized:
            present(ImagePickerViewController(), animated: true, completion: nil)
        case PHAuthorizationStatus.restricted, PHAuthorizationStatus.denied:
            break
        }
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
}

extension UIViewController {

    func alert(error: Error) {
        alert(title: "ERROR", msg: error.localizedDescription, buttons: ["OK"], handler: nil)
    }

    func alert(title: String? = nil, msg: String, buttons: [String], handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        for button in buttons {
            let action = UIAlertAction(title: button, style: .default, handler: { action in
                handler?(action)
            })
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
}
