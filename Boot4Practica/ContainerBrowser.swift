

import UIKit

class ContainerBrowser: UIViewController {

    var blobClient: AZSCloudBlobClient!
    var nameCurrentContainer: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = nameCurrentContainer

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readAllBlobs(inContainer: nameCurrentContainer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func readAllBlobs(inContainer current: String){
        let container = blobClient.containerReference(fromName: current)
        
        container.listBlobsSegmented(with: nil,
                                     prefix: nil,
                                     useFlatBlobListing: true,
                                     blobListingDetails: AZSBlobListingDetails.all,
                                     maxResults: -1) { (error, results) in
                                        
                                        if let _ = error {
                                            print("\(error?.localizedDescription)")
                                            return
                                        }
                                        
                                        for item in (results?.blobs)! {
                                            print("\(item)")
                                        }
                                        
                                        DispatchQueue.main.async {
                                            /// aqui sincronizar
                                        }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}














