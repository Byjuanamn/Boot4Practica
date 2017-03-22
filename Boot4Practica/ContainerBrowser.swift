

import UIKit

class ContainerBrowser: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var blobClient: AZSCloudBlobClient!
    var nameCurrentContainer: String!
    var model: [AZSCloudBlockBlob]! = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = nameCurrentContainer
        tableView.dataSource = self
        tableView.delegate = self

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
    
    @IBAction func uploadAction(_ sender: Any) {
        uploadLocalBlob()
    }
    
    func uploadLocalBlob() {
        let container = blobClient.containerReference(fromName: nameCurrentContainer)
        let blobLocal = container.blockBlobReference(fromName: UUID().uuidString)

        let img = UIImageJPEGRepresentation(#imageLiteral(resourceName: "imgBlob"), 0.5)!
        
        blobLocal.upload(from: img) { (error) in
            if error != nil {
                print("\(error.localizedDescription)")
                return
            }
            self.readAllBlobs(inContainer: self.nameCurrentContainer)
        }

    }
    
    func deleteBlob(blobLocal: AZSCloudBlockBlob) {
    
        blobLocal.delete { (error) in
            if let _ = error {
                print("\(error?.localizedDescription)")
                return
            }
        }
    
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
                                        
                                        self.model = results?.blobs as! [AZSCloudBlockBlob]
                                        
                                        DispatchQueue.main.async {
                                            /// aqui sincronizar
                                            self.tableView.reloadData()
                                        }
        }
        
    }

    fileprivate func downloadBlob(_ blob: AZSCloudBlockBlob) {
        let container = blobClient.containerReference(fromName: nameCurrentContainer)
        let blobLocal = container.blockBlobReference(fromName: blob.blobName)
        
        blobLocal.downloadToData { (error, data) in
            if let _ = error {
                print("\(error?.localizedDescription)")
                return
            }
            if let _ = data {
                var image = UIImage(data: data!)
                
                DispatchQueue.main.async {
                    /// pasar la imagen al main thread 
                    print("\(image.debugDescription)")
                }
            }
        }
    }

}

extension ContainerBrowser {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model[indexPath.row] as AZSCloudBlockBlob
        downloadBlob(item)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELDACONTAINER", for: indexPath)
        
        let item = model[indexPath.row] as AZSCloudBlockBlob
        
        cell.textLabel?.text = item.blobName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.isEmpty {
            return 0
        }
        
        return model.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let item = model[indexPath.row] as AZSCloudBlockBlob
            model.remove(at: indexPath.row)
            deleteBlob(blobLocal: item)
            tableView.endUpdates()
        }
    }
}














