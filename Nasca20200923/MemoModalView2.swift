//
//  MemoModalView2.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/08.
//

import SwiftUI

struct MemoModalView: View {
    
    @State var modal = true
    @State var ini_tagtext = ini_tag()
//    let animation : Namespace.ID
        
    var body: some View {
        
        MemoView(init_tagtext: ini_tagtext, modal : modal)
    }
}
