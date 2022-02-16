//
//  ViewController.swift
//  upload
//
//  Created by 珏 on 2021/12/3.
//

import UIKit
import BSImagePicker
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    

    private var collectionView: UICollectionView!
    private let identifier: String = "identifier"
    private var selectedImages: [UIImage] = []
 
    
    //select photos
    @IBAction func select_btn(_ sender: UIButton) {
        sender.addTarget(self, action: #selector(selectImages), for: .touchUpInside)
    }
    
    
    // upload button
    @IBAction func upload_btn(_ sender: UIButton) {
        sender.addTarget(self, action: #selector(uploadToServer), for: .touchUpInside)
    }
    
    

    // scroll
    override func viewDidLoad() {
    super.viewDidLoad()


        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 300, height: 300)

        collectionView = UICollectionView(frame: CGRect(x: 20, y: 170, width: view.frame.size.width - 40, height: 300), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.backgroundColor = UIColor.blue
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: identifier)
        view.addSubview(collectionView)
    }
    
    
    // open url
    @IBAction func Btn_url(_ sender: UIButton) {
        if let url = URL(string: "http://192.168.31.246/pictures/website/model.php") {
            UIApplication.shared.open(url)
        }
    }
    
    
    
    
     
    @objc private func uploadToServer(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
 
        var imageStr: [String] = []
        for a in 0..<self.selectedImages.count {
            let imageData: Data = self.selectedImages[a].jpegData(compressionQuality: 0.1)!
            imageStr.append(imageData.base64EncodedString())
        }
 
        guard let data = try? JSONSerialization.data(withJSONObject: imageStr, options: []) else {
            return
        }
 
        let jsonImageString: String = String(data: data, encoding: String.Encoding.utf8) ?? ""
        let urlString: String = "imageStr=" + jsonImageString
 
        var request: URLRequest = URLRequest(url: URL(string: "http://192.168.31.246/pictures/swiftui-save-image.php")!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = urlString.data(using: .utf8)
 
        NSURLConnection.sendAsynchronousRequest(request, queue: .main, completionHandler: { (request, data, error) in
 
            guard let data = data else {
                return
            }
 
            let responseString: String = String(data: data, encoding: .utf8)!
            print("my_log = " + responseString)
 
            alert.dismiss(animated: true, completion: {
                let messageAlert = UIAlertController(title: "Success", message: responseString, preferredStyle: .alert)
                messageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    //
                }))
                self.present(messageAlert, animated: true, completion: nil)
            })
        })
        
        
        
    }
     
    @objc private func selectImages(sender: UITapGestureRecognizer) {
        let imagePicker = ImagePickerController()
        presentImagePicker(imagePicker, select: { (asset) in
        }, deselect: { (asset) in
             
        }, cancel: { (assets) in
             
        }, finish: { (assets) in
             
            self.selectedImages = []
            let options: PHImageRequestOptions = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
 
            for asset in assets {
                PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { (image, info) in
                    self.selectedImages.append(image!)
                    self.collectionView.reloadData()
                }
            }
        })
    }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data: UIImage = selectedImages[indexPath.item]
        let cell: ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ImageCell
        cell.image.image = data
        return cell
    }
 
 
}


