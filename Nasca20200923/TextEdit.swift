//
//  TextEdit.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/27.
//

import SwiftUI

struct TextEdit: View {
    var body: some View {
        ZStack {
           
           RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color.yellow.opacity(0.6))
               .padding(.horizontal,10)
//            .frame(minHeight : 100, maxHeight: 150)
            VStack(spacing : 10){
            HStack{
                
                Circle()
                    .frame(width:10,height : 10)
                Text("そんな「無駄づくり」も、スタートして早8年目。アイデア勝負のコンテンツであるがゆえに、続けていれば、当然ネタ切れやマンネリといった問題にも直面するに違いない。どうやって回避しているのだろうか。")
                    .fontWeight(.bold)
                    .lineLimit(5)
                
                Spacer()
                
            }
                HStack{
                    Spacer()
                        .frame(width:20)
             Text("そんな「無駄づくり」も、スタートして早8年目。アイデア勝負のコンテンツであるがゆえに、続けていれば、当然ネタ切れやマンネリといった問題にも直面するに違いない。どうやって回避しているのだろうか。")
                .font(.caption)
                .lineLimit(3)
                }.frame(width : UIScreen.main.bounds.width-50,alignment : .leading)
                HStack{
                    Spacer()
                        .frame(width:20)
                    Text("2020/10/31")
                        .font(.system(size: 10))
                        .font(.caption)
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.red.opacity(0.6))
                        .font(.caption)
                    Text("\(Int.random(in : 1..<5))")
                        .font(.caption)
                
                
                    Image(systemName:"bubble.right.fill")
                        .foregroundColor(Color.yellow.opacity(0.6))
                        .font(.caption)
                    Text("\(Int.random(in : 1..<5))")
                        .font(.caption)
                    
                    Image(systemName:"arrowshape.turn.up.right.fill")
                        .foregroundColor(Color.blue.opacity(0.6))
                        .font(.caption)
                    Text("\(Int.random(in : 1..<5))")
                        .font(.caption)
                    
                    
                }
                
            }.frame(width : UIScreen.main.bounds.width-50)
            .padding(.vertical)
        }
        .frame(minHeight : 100, maxHeight: 150)
//        .frame(width : UIScreen.main.bounds.width-50)
}
}

struct TextEdit_Previews: PreviewProvider {
    static var previews: some View {
        TextEdit()
    }
}
