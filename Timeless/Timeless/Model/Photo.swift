//
//  Photo.swift
//  Timeless
//
//  Created by Michele Coppola on 15/12/24.
//

import Foundation

struct APIResponse: Codable {
    let items: [Photo]
}

struct Photo: Codable, Identifiable {
    var id: String
    var title: [String]?
    var dcTitleLangAware: DcLangAware
    var dcCreator: [String]?
    var dcDescription: [String]?
    var dcDescriptionLangAware: DcLangAware?
    var edmPreview: [String]
    var edmTimespanLabelLangAware : DcLangAware?
    
    static let example = Photo(id: "123", title: ["Quadro Bello"], dcTitleLangAware: DcLangAware(en: ["Nice Painting"]) , dcCreator: ["Caravaggio"], dcDescription: ["Descrizione Quadro Bello"], dcDescriptionLangAware: DcLangAware(en: ["Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos, qui ratione voluptatem"]), edmPreview: ["https://upload.wikimedia.org/wikipedia/commons/7/73/Bild-Ottavio_Leoni%2C_Caravaggio.jpg"], edmTimespanLabelLangAware: DcLangAware(zxx: ["1600"]))
    
    static let example2 = Photo(id: "456", title: ["Photographic Service Naples, 1966"], dcTitleLangAware: DcLangAware(en: ["Photographic Service Naples, 1966"]) , dcCreator: ["Chenneso"], dcDescription: ["Descrizione Photo"], dcDescriptionLangAware: DcLangAware(en: ["Photo Description"]), edmPreview: ["https://upload.wikimedia.org/wikipedia/commons/e/ea/Jack.signalman.jpg"], edmTimespanLabelLangAware: DcLangAware(zxx: ["1893"]))
}

struct DcLangAware: Codable {
    var en: [String]?
    var zxx: [String]?
}
