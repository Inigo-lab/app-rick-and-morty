//
//  SegundoViewController.swift
//  tareaCollectionView
//
//  Created by dam2 on 18/12/23.
//

import UIKit

class SegundoViewController: UIViewController {

    var personaje : PersonajesModel?
    

    @IBOutlet weak var imagen: UIImageView!
    
    @IBOutlet weak var nombre: UILabel!
    
    @IBOutlet weak var especie: UILabel!
    
    @IBOutlet weak var estado: UILabel!
    
    @IBOutlet weak var genero: UILabel!
    
    @IBOutlet weak var origen: UILabel!
    
    @IBOutlet weak var localizacion: UILabel!
    
    @IBOutlet weak var tabla: UITableView!
    
    static var capitulos = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        tabla.delegate = self
        tabla.dataSource = self

        if let personaje = personaje{
            let imageUrl = URL(string: personaje.image)
            
            let dataTask = URLSession.shared.dataTask(with: imageUrl!){ (data, _, _) in
                
                if let data = data {
                    DispatchQueue.main.async{
                        self.imagen.image = UIImage(data: data)
                    }
                }
            }
            dataTask.resume()
            
            nombre.text = "Nombre: \(personaje.name)"
            especie.text = "Especie: \(personaje.species)"
            estado.text = "Estado: \(personaje.status)"
            genero.text = "Genero: \(personaje.gender)"
            origen.text = "Origen: \(personaje.origin.name)"
            localizacion.text = "Localización: \(personaje.location.name)"
        }
        
        
        
        
    }
    

}

extension SegundoViewController : UITableViewDelegate{
    
}

extension SegundoViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        (personaje?.episode.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        celda.textLabel?.text = personaje?.episode[indexPath.row]
        
        if SegundoViewController.capitulos.contains(personaje?.episode[indexPath.row] ?? ""){
            celda.accessoryType = .checkmark
        }else{
            celda.accessoryType = .none
        }
        
        return celda
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoritosAction = UIContextualAction(style: .normal, title: "Favoritos"){ [ weak self ] (action, view, completedHandler) in
            
            self?.manejarFavoritos(indexPath.row)
            print("Pulsado favoritos")
            completedHandler(true)
            
        }
        favoritosAction.backgroundColor = .blue
        favoritosAction.image = UIImage(systemName: "star")
        
        return UISwipeActionsConfiguration(actions: [favoritosAction])
    }
    
    func manejarFavoritos(_ indexPath: Int){
        print(personaje?.episode[indexPath] ?? "a")
        SegundoViewController.capitulos.insert(personaje?.episode[indexPath] ?? "")
        tabla.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
   
    
}
