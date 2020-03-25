//
//  ViewController.swift
//  AirDrop2
//
//  Created by Ari Wasch on 3/6/20.
//  Copyright © 2020 Ari Wasch. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Photos
class ViewController: UIViewController {
    var bannerView: GADBannerView!
    var images = [PHAsset()]
        
    @IBOutlet weak var textBox: UITextView!
    
    override func viewDidLoad() {
        textBox.text = "Welcome to Air Drop Roullete! \nPush the button below to Air Drop a random picture in your camera roll."
        super.viewDidLoad()
        getImages()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
//             bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = "ca-app-pub-2716001497678491/6235834506"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        // Do any additional setup after loading the view.
    }

    @IBAction func send(_ sender: Any) {
        airDrop()
    }
        
    func getImages(){
        images = [PHAsset()]
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        assets.enumerateObjects({(object, count, stop) in
        self.images.append(object)
    //            print(object.description)
        })
        self.images.reverse()
        print(images.count)
        print("LDFHDHFKLHKLFHDSLKFHLKDSFJLKS")

    }
    func airDrop(){
        getImages()
        if(images.count-1 > 0){
        var random: Int = Int.random(in: 0..<images.count-1)
        print(random)
        let image = getAssetThumbnail(asset: images[random])
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            controller.excludedActivityTypes = [.mail, .assignToContact, .message, .openInIBooks]
            let date = images[random].creationDate!.description
            let alert = UIAlertController(title: "Air Drop Roullete", message: "Would you like to AirDrop a photo from \(date[(date.index(date.startIndex, offsetBy: 0))..<(date.index(date.endIndex, offsetBy: -15))])?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "AirDrop", style: UIAlertAction.Style.destructive, handler: { action in
                self.present(controller, animated: true, completion: nil)
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }
        }
        
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelWidth), contentMode: .aspectFit, options: option, resultHandler: {(result, info) ->Void
            in
                thumbnail = result!
            })
        return thumbnail
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
}
