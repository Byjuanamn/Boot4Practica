//
//  ViewController.swift
//  Boot4Practica
//
//  Created by Juan Antonio Martin Noguera on 21/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var acount: AZSCloudStorageAccount!
    var blobClient: AZSCloudBlobClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupAzureStorageConnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAzureStorageConnect() {
        let credetials = AZSStorageCredentials(accountName: "juanboot4", accountKey: "4GrSb/HgrXwXBxWhpe8SzZkqdyDpUERY4kzZfE93Ud1Kea168R6GVyOOK0tIH9CvjnSkcgJp4wRkMRUpjBhilQ==")
        do {
            acount = try AZSCloudStorageAccount(credentials: credetials, useHttps: true)
            blobClient = acount.getBlobClient()
            readAllContainers()
            
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    fileprivate func readAllContainers() {
        blobClient.listContainersSegmented(with: nil,
                                           prefix: nil,
                                           containerListingDetails: AZSContainerListingDetails.all,
                                           maxResults: -1,
                                           completionHandler: { (error, containersResults) in
                                            
                                            if let _ = error {
                                                print("\(error?.localizedDescription)")
                                                return
                                            }
                                            
                                            for item in (containersResults?.results)! {
                                                print(item)
                                            }
        
        
        })

    }


}

























