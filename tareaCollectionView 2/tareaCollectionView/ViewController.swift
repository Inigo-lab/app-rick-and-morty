//
//  ViewController.swift
//  tareaCollectionView
//
//  Created by dam2 on 14/12/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var personajes = [PersonajesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.downloadData()
        
    }
    
    func downloadData(){
        
        let urlString = "https://rickandmortyapi.com/api/character"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url){ (data,response,error) in
            if error != nil{
                print(error!.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                print(response)
            }
            guard let data = data else { return }
            
            let personajes = try! JSONDecoder().decode(Results.self, from: data)
            let personajesResults = personajes.results
            
            if personajes != nil {
                self.personajes = personajesResults
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }else{
                print("Se ha producido un error en los datos")
            }
            
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        personajes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celda", for: indexPath) as! MiCelda
        
        cell.label.text = personajes[indexPath.item].name
        cell.label2.text = personajes[indexPath.item].species
        let imageUrl = URL(string: personajes[indexPath.item].image)
        
        let dataTask = URLSession.shared.dataTask(with: imageUrl!){ (data, _, _) in
            
            if let data = data {
                DispatchQueue.main.async{
                    cell.imagen.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.frame.width
        
        var celdaWidth = 0
        
        if screenWidth > 700 {
            celdaWidth = Int(screenWidth/5 - 12)
        }else{
            celdaWidth = Int(screenWidth/2 - 8)
        }
        
        return CGSize(width: celdaWidth, height: celdaWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("Has tocado el botón \(indexPath.item)")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "segundoView") as! SegundoViewController
        vc.personaje = personajes[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}

