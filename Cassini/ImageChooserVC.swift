//
//  ImageChooserVC.swift
//  Cassini
//
//  Created by Chris Wu on 12/15/18.
//  Copyright © 2018 Wu Personal Team. All rights reserved.
//

import UIKit

class ImageChooserVC: UIViewController, UISplitViewControllerDelegate {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let url = DemoURLs.NASA[identifier] {
                if let ivc = segue.destination.content as? ImageVC {
                    ivc.imageUrl = url
                    ivc.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        print("collapseSecondary called")
        return true
    }
}

extension UIViewController {
    var content : UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }
        else {
            return self
        }
    }
}
