//
//  PersonajesModel.swift
//  tareaCollectionView
//
//  Created by dam2 on 14/12/23.
//

import Foundation


struct PersonajesModel : Decodable{
    var id : Int
    var name : String
    var status : String
    var species : String
    var type : String
    var gender : String
    var origin : OriginModel
    var location : LocationModel
    var image : String
    var episode : [String]
    var url : String
    var created : String
}
