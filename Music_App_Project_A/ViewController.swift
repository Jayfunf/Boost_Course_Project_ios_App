//
//  ViewController.swift
//  Music_App_Project_A
//
//  Created by Minhyun Cho on 2021/07/12.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer!
    var timer: Timer!
    
    @IBOutlet var playBTN: UIButton!
    @IBOutlet var playLabel: UILabel!
    @IBOutlet var playSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializePlayer()
    }
    
    func initializePlayer() {
        
        guard let soundAsset: NSDataAsset = NSDataAsset(name: "sound") else {
            print("음원 파일 에셋을 가져올 수 없습니다")
            return
        }
        
        do {
            try self.player = AVAudioPlayer(data: soundAsset.data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        
        self.playSlider.maximumValue = Float(self.player.duration) //슬라이더의 길이 설정
        self.playSlider.minimumValue = 0
        self.playSlider.value = Float(self.player.currentTime)
    }
    func updateTimeLabelText(time: TimeInterval) { //타임라벨 업데이트
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        self.playLabel.text = timeText
    }
    func makeAndFireTimer() { //타이머
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
          
            if self.playSlider.isTracking { return }
            
            self.updateTimeLabelText(time: self.player.currentTime)
            self.playSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    
    @IBAction func playBTN(_ sender: UIButton){
        if sender.isSelected{
            self.player?.play()
            
        }
        else{
            self.player?.pause()
            
        }
    }
    
    
}

