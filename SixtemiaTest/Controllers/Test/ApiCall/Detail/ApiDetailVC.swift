//
//  ApiDetailVC.swift
//  SixtemiaTest
//
//  Created by Apps Avantiam on 10/6/25.
//  Copyright © 2025 Sixtemia Mobile Studio. All rights reserved.
//

import UIKit

struct ImageGridViewModel {
    let image: String
}

class ApiDetailVC: UIViewController {
    
    let data: [ImageGridViewModel] = [
        ImageGridViewModel(image: "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQYTXtd35_XwmA4kfeR_TRSxibRT9GwkLDj9trkgpfhkrIEJjdVQ0NJh5jtpyGfzi0ajH5zBeYW0OonEgjCSK9JQA"),
        ImageGridViewModel(image: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Anas_platyrhynchos_qtl1.jpg/1200px-Anas_platyrhynchos_qtl1.jpg"),
        ImageGridViewModel(image: "https://www.lavanguardia.com/files/og_thumbnail/uploads/2021/06/07/60be17e39ecfa.jpeg"),
        ImageGridViewModel(image: "https://inaturalist-open-data.s3.amazonaws.com/photos/175267007/original.jpg"),
        ImageGridViewModel(image: "https://www.fincacasarejo.com/Docs/Productos/pato-saxe_1.jpg"),
        ImageGridViewModel(image: "https://upload.wikimedia.org/wikipedia/commons/a/a4/Ramphastos_toco_-Birdworld%2C_Farnham%2C_Surrey%2C_England-8a.jpg"),
        ImageGridViewModel(image: "https://d2zp5xs5cp8zlg.cloudfront.net/image-79322-800.jpg"),
        ImageGridViewModel(image: "https://cdn.britannica.com/34/235834-050-C5843610/two-different-breeds-of-cats-side-by-side-outdoors-in-the-garden.jpg"),
        ImageGridViewModel(image: "https://www.cats.org.uk/media/13136/220325case013.jpg?width=500&height=333.49609375"),
        ImageGridViewModel(image: "https://upload.wikimedia.org/wikipedia/commons/4/4d/Cat_November_2010-1a.jpg"),
        ImageGridViewModel(image: "https://www.wnct.com/wp-content/uploads/sites/99/2022/07/Cat.jpg?w=2560&h=1440&crop=1"),
        ImageGridViewModel(image: "https://cdn.pixabay.com/photo/2018/07/31/22/08/lion-3576045_960_720.jpg"),
        ImageGridViewModel(image: "https://i.natgeofe.com/k/1d33938b-3d02-4773-91e3-70b113c3b8c7/lion-male-roar.jpg?wp=1&w=1084.125&h=609"),
        ImageGridViewModel(image: "https://www.krugerpark.co.za/images/black-maned-lion-shem-compion-786x500.jpg"),
        ImageGridViewModel(image: "https://images.photowall.com/products/46596/lion-1.jpg?h=699&q=85"),
        ImageGridViewModel(image: "https://static.wixstatic.com/media/2fa513_074592a6db8f4d4fb7ae26d02a6c03ff~mv2.jpg/v1/fill/w_528,h_528,al_c,q_80,usm_0.66_1.00_0.01,enc_avif,quality_auto/2fa513_074592a6db8f4d4fb7ae26d02a6c03ff~mv2.jpg")]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var apiUserId: Int = 0
    var apiId: Int = 0
    var apiTitle = ""
    var apiBody = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = apiTitle
        bodyLabel.text = apiBody
        
        //Style
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        bodyLabel.textAlignment = .justified
        bodyLabel.textColor = .gray
        bodyLabel.font = UIFont.systemFont(ofSize: 17)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setUpCollectionView()
        
    }
    
    private func setUpCollectionView() {
        
        collectionView.register(UINib(nibName: "ApiImageCell", bundle: nil),
                                forCellWithReuseIdentifier: "ApiImageCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.minimumLineSpacing = 8
        
        layout.minimumInteritemSpacing = 8
        
        layout.itemSize = CGSize(width: (collectionView.frame.width - 24) / 4, height: (collectionView.frame.width - 24) / 4)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
        
    }
    
}

extension ApiDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApiImageCell", for: indexPath) as? ApiImageCell
        if cell == nil {
            collectionView.register(UINib.init(nibName: "ApiImageCell", bundle: nil), forCellWithReuseIdentifier: "ApiImageCell")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApiImageCell", for: indexPath) as? ApiImageCell
        }
        cell?.configCell(image: data[indexPath.row].image)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = ApiImageVC(apiImage: data[indexPath.row].image) // Your destination
        self.present(destination, animated: true)
    }
    
}
