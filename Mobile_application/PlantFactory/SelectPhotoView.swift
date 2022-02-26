//
//  SelectPhotoView.swift
//  upload
//
//  Created by 珏 on 2022/2/12.
//

import Foundation
import UIKit
import BSImagePicker
import Photos

class SelectPhotoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    

    private var collectionView: UICollectionView!
    private let identifier: String = "identifier"
    private var selectedImages: [UIImage] = []
 
    @IBOutlet weak var background_img: UIImageView!
    
    //select photos
    @IBAction func select_btn(_ sender: UIButton) {
        sender.addTarget(self, action: #selector(selectImages), for: .touchUpInside)
    }
    
    // help
    @IBAction func help_btn(_ sender: Any) {
        self.performSegue(withIdentifier: "helpScreen", sender: self)
        
    }
    
    // upload button
    @IBOutlet weak var upload_btn: UIButton!
    
    @IBAction func upload_btn(_ sender: UIButton) {
        sender.addTarget(self, action: #selector(uploadToServer), for: .touchUpInside)
        
    }
    
    

    // scroll
    override func viewDidLoad() {
    super.viewDidLoad()
        // change view
        upload_btn.layer.cornerRadius = 20.0

        // photoflows
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 300, height: 300)


        collectionView = UICollectionView(frame: CGRect(x: 20, y: 120, width: view.frame.size.width - 40, height: 300), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
//        collectionView.backgroundColor = UIColor.blue
//        collectionView.backgroundView = UIImageView(image:UIImage(named: "test.png"))
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: identifier)
        view.addSubview(collectionView)
        
        
        
        //first time
        selectimg()
        
    }
    
    
    
     
    @objc private func uploadToServer(sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Loading", message: "Please wait...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
 
        var imageStr: [String] = []
        for a in 0..<self.selectedImages.count {
            let imageData: Data = self.selectedImages[a].jpegData(compressionQuality: 0.1)!
            imageStr.append(imageData.base64EncodedString())
        }
        
        // no pictures
        if imageStr == []{
            alert.dismiss(animated: true, completion: {
                let errorAlert = UIAlertController(title: "Error", message: "You have not chosen any images", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    //
                }))
                self.present(errorAlert, animated: true, completion: nil)
            })
            
            return
        
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
    
    func selectimg(){
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
     
    @objc private func selectImages(sender: UITapGestureRecognizer) {
        
        // hide background
        background_img.tintColor = UIColor.clear
        
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
 

class ImageCell: UICollectionViewCell {
    var image: UIImageView!
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
     
    private func setupViews() {
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        addSubview(image)
    }
}

