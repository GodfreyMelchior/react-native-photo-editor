//
//  PhotoEditor.swift
//  PhotoEditor
//
//  Created by Donquijote on 27/07/2021.
//

import Foundation
import UIKit
import Photos
import SDWebImage
import AVFoundation
//import ZLImageEditor

public enum ImageLoad: Error {
    case failedToLoadImage(String)
}

@objc(PhotoEditor)
class PhotoEditor: NSObject, ZLEditImageControllerDelegate {
    var window: UIWindow?
    var bridge: RCTBridge!

    var resolve: RCTPromiseResolveBlock!
    var reject: RCTPromiseRejectBlock!

    var successDialogEnabled: Bool = true
    var successDialogTitle: String = "Success"
    var successDialogMessage: String = "Image saved successfully!"
    var successDialogButtonText: String = "OK"
    
    @objc(open:withResolver:withRejecter:)
    func open(options: NSDictionary, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void {
        
        // handle path
        guard let path = options["path"] as? String else {
            reject("DONT_FIND_IMAGE", "Dont find image", nil)
            return;
        }
        
        getUIImage(url: path) { image in
            DispatchQueue.main.async {
                //  set config
                self.setConfiguration(options: options, resolve: resolve, reject: reject)
                self.presentController(image: image)
            }
        } reject: {_ in
            reject("LOAD_IMAGE_FAILED", "Load image failed: " + path, nil)
        }
    }
    
    func onCancel() {
        self.reject("USER_CANCELLED", "User has cancelled", nil)
    }
    
    private func setConfiguration(options: NSDictionary, resolve:@escaping RCTPromiseResolveBlock,reject:@escaping RCTPromiseRejectBlock) -> Void{
        self.resolve = resolve;
        self.reject = reject;

        // Success dialog options
        if let successDialog = options["successDialog"] as? NSDictionary {
            self.successDialogEnabled = successDialog["enabled"] as? Bool ?? true
            self.successDialogTitle = successDialog["title"] as? String ?? "Success"
            self.successDialogMessage = successDialog["message"] as? String ?? "Image saved successfully!"
            self.successDialogButtonText = successDialog["buttonText"] as? String ?? "OK"
        }

        // Stickers
        let stickers = options["stickers"] as? [String] ?? []
        ZLImageEditorConfiguration.default().imageStickerContainerView = StickerView(stickers: stickers)
        
        
        //Config
        ZLImageEditorConfiguration.default().editDoneBtnBgColor = UIColor(red:255/255.0, green:238/255.0, blue:101/255.0, alpha:1.0)

        ZLImageEditorConfiguration.default().editImageTools = [.clip, .draw, .filter, .imageSticker, .textSticker]
        
        //Filters Lut
        do {
            let filters = ColorCubeLoader()
            ZLImageEditorConfiguration.default().filters = try filters.load()
        } catch {
            assertionFailure("\(error)")
        }
    }
    
    private func presentController(image: UIImage) {
        if let controller = UIApplication.getTopViewController() {
            controller.modalTransitionStyle = .crossDissolve

            ZLEditImageViewController.showEditImageVC(parentVC:controller , image: image, delegate: self) { [weak self] (resImage, editModel) in
                guard let self = self else { return }

                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

                let destinationPath = URL(fileURLWithPath: documentsPath).appendingPathComponent(String(Int64(Date().timeIntervalSince1970 * 1000)) + ".png")

                do {
                    try resImage.pngData()?.write(to: destinationPath)

                    // Show success dialog if enabled
                    if self.successDialogEnabled {
                        self.showSuccessDialog(imagePath: destinationPath.absoluteString)
                    } else {
                        self.resolve(destinationPath.absoluteString)
                    }
                } catch {
                    debugPrint("writing file error", error)
                }
            }
        }
    }

    private func showSuccessDialog(imagePath: String) {
        if let controller = UIApplication.getTopViewController() {
            let alert = UIAlertController(title: self.successDialogTitle, message: self.successDialogMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.successDialogButtonText, style: .default, handler: { [weak self] _ in
                self?.resolve(imagePath)
            }))
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func getUIImage (url: String ,completion:@escaping (UIImage) -> (), reject:@escaping(String)->()){
        if let path = URL(string: url) {
            SDWebImageManager.shared.loadImage(with: path, options: .continueInBackground, progress: { (recieved, expected, nil) in
            }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
                DispatchQueue.main.async {
                    if(error != nil){
                        print("error", error as Any)
                        reject("false")
                        return;
                    }
                    if downloadedImage != nil{
                        completion(downloadedImage!)
                    }
                }
            })
        }else{
            reject("false")
        }
    }
    
}

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        
        return base
    }
}
