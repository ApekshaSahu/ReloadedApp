//
//  ViewController.swift
//  ReloadedApp
//
//  Created by Manish Giri on 6/7/18.
//  Copyright © 2018 Manish Giri. All rights reserved.
//

import UIKit


    class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
        
        let questionImageArray = [#imageLiteral(resourceName: "part6"),#imageLiteral(resourceName: "part1"),#imageLiteral(resourceName: "part2"),#imageLiteral(resourceName: "part5"),#imageLiteral(resourceName: "part4"),#imageLiteral(resourceName: "part3")]
        let correctAns = [0,1,2,3,4,5]
        var wrongAns = Array(0..<6)
        var wrongImageArray = [UIImage]()
        var undoMoveArray = [(first:IndexPath, second:IndexPath)]()
        var numberOfMoves = 0
        
        
        var firstIndexPath:IndexPath?
        var secondIndexPath:IndexPath?
        
        let myCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            cv.allowsMultipleSelection = true
            cv.translatesAutoresizingMaskIntoConstraints = false
            return cv
            
        }()
        
        let btnSwap: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("Swap", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            btn.setTitleColor(UIColor.blue, for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
            
        }()
        
        let btnUndo: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("Undo", for: .normal)
            btn.setTitleColor(UIColor.red, for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
        
        let lblMove: UILabel = {
            let lbl = UILabel()
            lbl.textAlignment = .center
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            print("viewdidload")
            myCollectionView.delegate = self
            myCollectionView.dataSource = self
            self.title = "Puzzle"
            self.navigationController?.navigationBar.isTranslucent = false
            self.view.addSubview(myCollectionView)
            self.view.addSubview(btnSwap)
            self.view.addSubview(btnUndo)
            self.view.addSubview(lblMove)
            
            wrongImageArray = questionImageArray
            setupViews()
            
            
            
            
            // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
            // including entities and graphs.
            /* if let scene = GKScene(fileNamed: "GameScene") {
             
             // Get the SKScene from the loaded GKScene
             if let sceneNode = scene.rootNode as! GameScene? {
             
             // Copy gameplay related content over to the scene
             sceneNode.entities = scene.entities
             sceneNode.graphs = scene.graphs
             
             // Set the scale mode to scale to fit the window
             sceneNode.scaleMode = .aspectFill
             
             // Present the scene
             if let view = self.view as! SKView? {
             view.presentScene(sceneNode)
             
             view.ignoresSiblingOrder = true
             
             view.showsFPS = true
             view.showsNodeCount = true
             }
             }
             }*/
        }
        
        
      
        
        
        func setupViews() {
            print("setup")
            // myCollectionView.delegate = self
            // myCollectionView.dataSource = self
            myCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            myCollectionView.backgroundColor = UIColor.white
            
            //self.view.addSubview(myCollectionView)
            myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
            myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -21).isActive = true
            myCollectionView.heightAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            
            
            //self.view.addSubview(btnSwap)
            btnSwap.widthAnchor.constraint(equalToConstant: 200).isActive = true
            btnSwap.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 20).isActive = true
            btnSwap.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 20).isActive = true
            btnSwap.heightAnchor.constraint(equalTo: btnSwap.widthAnchor).isActive = true
            btnSwap.addTarget(self, action: #selector(btnSwapAction), for: UIControlEvents.touchUpInside)
          //  btnSwap.addTarget(self, action: #selector(btnSwapAction), for: .touchUpInside)
            
            //self.view.addSubview(btnUndo)
            btnUndo.widthAnchor.constraint(equalToConstant: 200).isActive = true
            btnUndo.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 70).isActive = true
            btnUndo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 70).isActive = true
            btnUndo.heightAnchor.constraint(equalTo: btnSwap.widthAnchor).isActive = true
            btnUndo.addTarget(self, action: #selector(btnUndoAction), for: .touchUpInside)
            
            
            // self.view.addSubview(lblMove)
            lblMove.widthAnchor.constraint(equalToConstant: 80).isActive = true
            lblMove.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 50).isActive = true
            lblMove.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            lblMove.heightAnchor.constraint(equalTo: btnSwap.widthAnchor).isActive = true
            lblMove.heightAnchor.constraint(equalToConstant: 50).isActive = true
            lblMove.text = "Moves: \(numberOfMoves)"
            
            
            
        }
        
        @objc func btnSwapAction(){
            print("swapaction")
            guard let start = firstIndexPath, let end = secondIndexPath else { return }
            myCollectionView.performBatchUpdates({
                myCollectionView.moveItem(at: start, to: end)
                myCollectionView.moveItem(at: end, to: start)
            }) { (finished) in
                print("finished")
                self.myCollectionView.deselectItem(at: start, animated: true)
                self.myCollectionView.deselectItem(at: end, animated: true)
                self.firstIndexPath = nil
                self.secondIndexPath = nil
                self.wrongImageArray.swapAt(start.item, end.item)
                self.numberOfMoves = self.numberOfMoves + 1
                self.lblMove.text = "Moves: \(self.numberOfMoves)"
                if self.wrongAns == self.correctAns {
                    let alert = UIAlertController(title: "You Won!", message: "Congratulations ", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                    
                    let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (action) in
                        self.restartGame()
                    })
                    
                    alert.addAction(okAction)
                    alert.addAction(restartAction)
                    self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    //self.present(alert,animated: true, completion: nil)
                }
            }
        }
        
        func restartGame() {
            print("restartgame")
            self.undoMoveArray.removeAll()
            wrongAns = Array(0..<6)
            wrongImageArray = questionImageArray
            firstIndexPath = nil
            secondIndexPath = nil
            self.numberOfMoves = 0
            self.lblMove.text = "Moves: \(numberOfMoves)"
            self.myCollectionView.reloadData()
        }
        
        @objc func btnUndoAction() {
            print("UndoAction")
            if undoMoveArray.count == 0 {
                return
            }
            
            let start = undoMoveArray.last?.first
            let end = undoMoveArray.last?.second
            myCollectionView.performBatchUpdates({
                myCollectionView.moveItem(at: start!, to: end!)
                myCollectionView.moveItem(at: end!, to: start!)
            }) { (finished) in
                self.wrongImageArray.swapAt((start?.item)!, (end?.item)!)
                self.wrongAns.swapAt((start?.item)!, (end?.item)!)
                self.undoMoveArray.removeLast()
                self.numberOfMoves +=  1
                self.lblMove.text = "Moves: \(self.numberOfMoves)"
            }
            
            
        }
        
        /*  let myCollectionView: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.minimumInteritemSpacing = 0
         layout.minimumLineSpacing = 0
         let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
         cv.allowsMultipleSelection = true
         cv.translatesAutoresizingMaskIntoConstraints = false
         return cv
         
         }()
         
         let btnSwap: UIButton = {
         let btn = UIButton(type: .system)
         btn.setTitle("Swap", for: .normal)
         btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
         btn.translatesAutoresizingMaskIntoConstraints = false
         return btn
         
         }()
         
         let btnUndo: UIButton = {
         let btn = UIButton(type: .system)
         btn.setTitle("Undo", for: .normal)
         btn.setTitleColor(UIColor.red, for: .normal)
         btn.translatesAutoresizingMaskIntoConstraints = false
         return btn
         }()
         
         let lblMove: UILabel = {
         let lbl = UILabel()
         lbl.textAlignment = .center
         lbl.translatesAutoresizingMaskIntoConstraints = false
         return lbl
         }()
         
         */
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 6
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            print("collection")
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
            cell.imgView.image = wrongImageArray[indexPath.item]
            return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            print("collectionview")
            if firstIndexPath == nil {
                firstIndexPath = indexPath
                collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
            }else if secondIndexPath == nil {
                secondIndexPath = indexPath
                collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
            }
            else {
                collectionView.deselectItem(at: secondIndexPath!, animated: true)
                secondIndexPath = indexPath
                collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionViewScrollPosition(rawValue: 0 ))
            }
            
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            print("collectionview")
            if indexPath == firstIndexPath {
                firstIndexPath = nil}
            else if indexPath == secondIndexPath {
                secondIndexPath = nil
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            print("collectionview")
            let width = collectionView.frame.width
            return CGSize(width: width/3, height: width/3)
        }
        
        override var shouldAutorotate: Bool {
            return true
        }
        
        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return .allButUpsideDown
            } else {
                return .all
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Release any cached data, images, etc that aren't in use.
        }
        
        override var prefersStatusBarHidden: Bool {
            return true
        }
    }
    


