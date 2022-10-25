//
//  RxCocoaExampleViewController.swift
//  Compositional MVVM Rx
//
//  Created by 나리강 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var simpleLabel: UILabel!
    
    
    @IBOutlet weak var simpleSwitch: UISwitch!
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    
    var disposeBag = DisposeBag()
    var nickname = Observable.just("jack")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           // self.nickname = "nari"
        }
        
        
        
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    
    //viewController deinit 되면, disposed도 동작한다.
    //또는, DisposeBag() 객체를 새롭게 넣어주거나, nil 할당 => 예외적인 케이스!(rootVC에 interval이 있는 있다면?)
    deinit {
        print("RxCocoaExampleViewController")
    }
    
    func setOperator(){
        Observable.repeatElement("jack") //infinite observable sequence -> finite로 바뀜(take)
            .take(5)//5번만 반복해
            .subscribe { value in
                print("repeat -\(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
       Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval -\(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)

        let intervalObservable2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval -\(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        let intervalObservable3 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval -\(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        //DisposeBag : 리소스 해제 관리 -
            //1. 시퀀스가 끝날 때 알아서 해제 but bind
            //2. class deinit 자동 해제될 때  (ex.bind)
            //3. disposeBag dispose 직접호출 할 때 -> dispose() 구독하는 것 마다 별도로 관리!
            //4. DisposeBag을 새롭게 할당하거나, nil 전달.
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//
//            self.disposeBag = DisposeBag() //새롭게 객체만들어주면서 기존에 있던 리소스가 알아서 정리, 한번에 리소스 정리
//            intervalObservable.dispose()
//            intervalObservable2.dispose()
//            intervalObservable3.dispose()
//        }

        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just -\(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA,itemsB)//여러개가능(just와의 차이점)
            .subscribe { value in
                print("of -\(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
    
        Observable.from(itemsA)
            .subscribe { value in
                print("from -\(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
      
        
    }
    
    
    
    func setSign(){
        //ex. 텍1(Observable), 텍2(Observable) > 레이블에 보여주기(Observar, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            
            "name is \(value1), email is \(value2)"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty//데이터의 흐름 stream
            .map { $0.count < 4 } //Int > Bool 바뀜
            .bind(to: signEmail.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4}
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .withUnretained(self) //weak self 안써도됨
            .subscribe(onNext: { vc, _ in
                vc.showAlert()
            }) // weak self > vc
//            .subscribe {[weak self] _ in
//                self?.showAlert()
//            }
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "haha", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "check", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
        
        
    }
    
    
    func setSwitch() {
        Observable.just(false) //just, of 결과같음 of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    func setTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
        
        
        //        tableView.rx.modelSelected(String.self)
        //            .subscribe { value in
        //                print(value)
        //            } onError: { error in
        //                print("error")
        //            } onCompleted: {
        //                print("complete")
        //            } onDisposed: {
        //                print("disposed")
        //            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다"
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setPickerView() {
        
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(String.self)
            .map{ $0.description }//string타입으로 반환
            .bind(to: simpleLabel.rx.text)
        //            .subscribe(onNext: { value in
        //                print(value)
        //            })
        
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    
}
