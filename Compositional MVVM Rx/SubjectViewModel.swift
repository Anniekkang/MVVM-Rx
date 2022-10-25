//
//  SubjectViewModel.swift
//  Compositional MVVM Rx
//
//  Created by 나리강 on 2022/10/25.
//

import Foundation
import RxSwift

struct Contact {
    var name : String
    var age : Int
    var number : String
    
    
}


class SubjectViewModel {
    
    var contactData = [
        Contact(name: "annie", age: 23, number: "01012341244"),
        Contact(name: "nari", age: 30, number: "01012341246"),
        Contact(name: "linda", age: 22, number: "01012341245")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData(){
        list.onNext(contactData)
        
        
    }
    
    func resetData(){
        list.onNext([])
        
    }
    
    
    func newData(){
        let new = Contact(name: "minji", age: Int.random(in: 1...40), number: "")
        contactData.append(new)//이거 없으면 덮어쓰기됨
        list.onNext(contactData)
    }
    
    func filterData(query : String) {
        
        let result = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
        list.onNext(result)
        
        
    }
}
