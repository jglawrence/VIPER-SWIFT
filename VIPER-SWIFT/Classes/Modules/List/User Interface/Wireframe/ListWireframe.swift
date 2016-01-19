//
//  ListWireframe.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

let ListViewControllerIdentifier = "ListViewController"

class ListWireframe : NSObject {
    var addWireframe : AddWireframe?
    var listPresenter : ListPresenter?
    var rootWireframe : RootWireframe?
    var listViewController : ListViewController?
    
    func presentListInterfaceFromWindow(window: UIWindow) {
        guard let viewController = listViewControllerFromStoryboard(),
            listPresenter = listPresenter else { return }
        viewController.eventHandler = listPresenter
        listViewController = viewController
        listPresenter.userInterface = viewController
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentAddInterface() {
        if let listViewController = listViewController {
            addWireframe?.presentAddInterfaceFromViewController(listViewController)
        }
    }
    
    func listViewControllerFromStoryboard() -> ListViewController? {
        let storyboard = mainStoryboard()
        return storyboard.instantiateViewControllerWithIdentifier(ListViewControllerIdentifier) as? ListViewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    }
    
}