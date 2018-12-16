//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Chris Wu on 12/14/18.
//  Copyright © 2018 Wu Personal Team. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {
    var imageView = UIImageView()
    
    var imageUrl : URL? {
        didSet {
            image = nil
            if (view.window != nil) {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            
            //Optional Chaining for the following case
            /*
             prepare segue will set the imageURL, and didSet of imageURL will set the image to nil to remove the old image from the scrollView before fetching image. The setting of image will use OUTLET scrollView. While the life cycle of VC has it that prepare Segue happens before the outlets are set. So optional chaining here says only sets the scrollView's content size if scrollView itself is set.
             */
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.addSubview(imageView)
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func fetchImage() {
        if let url = imageUrl {  //Closure always capture local variables; the imageUrl is copied to a local variable to be captured with the closure. Also make sure no work is done unless imageURL is not nil. The if let thing is unwrapping
                spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in  //self won't be held in the heap by the closure only(if the VC is not there, then let it)
                let urlContent = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContent,
                        url == self?.imageUrl {  //Now imageUrl of self might be set by the main queue to get some other image. So we need comparison to make sure the captured value of url is still the requested imageUrl
                        //Self doesn't have a pointer to this closure so no memory cycle
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if image == nil {
            fetchImage()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if (imageUrl == nil) {
//            imageUrl = DemoURLs.stanford
//        }
    }
    
}
