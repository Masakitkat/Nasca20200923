//
//  MemoModal_game.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/10.
//

import SwiftUI

struct MemoModal_game: View {
    
    @State var modal = true
    @State var game = true
    
    @State var conc_image = Color.white.opacity(0.3)
    @State var conc_text = ""
    @State var abst_image = Color.white.opacity(0.3)
    @State var abst_text = ""
    @State var activeSheet : ActiveSheet?
    
    var body: some View {
        MemoView(modal : $modal, game : game, conc_image : conc_image, conc_text : conc_text, abst_image : abst_image, abst_text : abst_text)
    }
}
