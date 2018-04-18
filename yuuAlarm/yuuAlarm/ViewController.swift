//
//  ViewController.swift
//  yuuAlarm
//
//  Created by USER on 2015/01/03.
//  Copyright (c) 2015年 TakuyaIshitsuka. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let buttonImage:UIImage = UIImage(named: "pressButtonImage.png")!
    
    let audioPath = [NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("voice01", ofType: "m4a")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("voice02", ofType: "m4a")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("voice03", ofType: "m4a")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("voice04", ofType: "m4a")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("voice05", ofType: "m4a")!)]
/////////////////////////////////////////////////////////////////////////
    var setTime:NSDate = NSDate()
    
    let dateFormatter:NSDateFormatter = NSDateFormatter()

    var voicePlayer:AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var switchImageView: UIImageView!

    @IBOutlet weak var pressButton: UIButton!
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    @IBOutlet weak var slider: UISlider!
    
    var alarmFlag = false
    var flag = false
    var volumeFlag = false
    
    var notif = UILocalNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // アプリ全体のステータスバーの色を白くする
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        let nowTime:NSDate = NSDate()
        
        // スライダーの色
        slider.maximumTrackTintColor = UIColor.redColor()
        
        
        // プレスボタンの初期画像を設定
        pressButton.setImage(buttonImage, forState: UIControlState.Normal)
        
        // pressButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        // スイッチの初期画像を設定
        switchImageView.image = UIImage(named: "offImage.png")
        
        // 現在年月日時刻を文字列データとして取得
        var nowTimeReplace:String = getTimeStringData(nowTime)
        
        // 現在年月日時刻を年、月、日、時間、分に分割して取得
        var nowTimeInput = getTimeDivision(nowTimeReplace)
        
        // 時間で判定
        switch nowTimeInput.3 {
            
            // 時間が0時、1時、2時台
            case "00", "08", "16":
                imageView.image = UIImage(named: "yuuImage01.jpg")
                break
            // 時間が4時、5時、6時台
            case "01", "09", "17":
                imageView.image = UIImage(named: "yuuImage02.jpg")
                break
            // 時間が7時、8時、9時台
            case "02", "10", "18":
                imageView.image = UIImage(named: "yuuImage03.jpg")
                break
            // 時間が10時、11時、12時台
            case "03", "11", "19":
                imageView.image = UIImage(named: "yuuImage04.jpg")
                break
            // 時間が13時、14時、15時台
            case "04", "12", "20":
                imageView.image = UIImage(named: "yuuImage05.jpg")
                break
            // 時間が16時、17時、18時台
            case "05", "13", "21":
                imageView.image = UIImage(named: "yuuImage06.jpg")
                break
            // 時間が19時、20時、21時台
            case "06", "14", "22":
                imageView.image = UIImage(named: "yuuImage07.jpg")
                break
            // 時間が22時、23時、24時台
            case "07", "15", "23":
                imageView.image = UIImage(named: "yuuImage08.jpg")
                break
            
            default:
                break
        }
        
        // アラームスイッチの初期化
        alarmSwitch.on = false
        alarmSwitch.onTintColor = UIColor.redColor()
        alarmSwitch.tintColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setDatePicker(sender: UIDatePicker) {
        
        // データピッカーで設定した年月日時刻
        setTime = sender.date
        
        // タイマーを１秒間隔で起動
        var alarm = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "onAlarm", userInfo: nil, repeats: true)
        
        alarmFlag = false
        
    }
    
    @IBAction func changeSwitch(sender: UISwitch) {
        
        if sender.on == true{
            flag = true
            switchImageView.image = UIImage(named: "onImage.png")
        }else{
            flag = false
            switchImageView.image = UIImage(named: "offImage.png")
        }
        
    }
    
    
    @IBAction func moveSlider(sender: UISlider) {
        if volumeFlag == false{
            return
        }
        voicePlayer.volume = sender.value
        
    }
    
    @IBAction func pressButton(sender: UIButton) {
        
        setVoice()
        voicePlayer.stop()
        voicePlayer.play()
        
    }

    func onAlarm () {
        
        // 現在時刻を取得
        let nowTime:NSDate = NSDate()
        
        // 現在年月日時刻を文字列データとして取得
        var nowTimeReplace:String = getTimeStringData(nowTime)
        
        // 現在年月日時刻を年、月、日、時間、分に分割して取得
        var nowTimeInput = getTimeDivision(nowTimeReplace)
        
        // データピッカーで取得した年月日時刻を文字列データとして取得
        var setTimeReplace:String = getTimeStringData(setTime)
        
        // データピッカーで設定した年月日時刻を年、月、日、時間、分に分割して取得
        var setTimeInput = getTimeDivision(setTimeReplace)

        if alarmFlag == true{
            return
        }
        if(flag == true){
            if nowTimeInput.0 == setTimeInput.0 &&
                nowTimeInput.1 == setTimeInput.1 &&
                nowTimeInput.2 == setTimeInput.2 &&
                nowTimeInput.3 == setTimeInput.3 &&
                nowTimeInput.4 == setTimeInput.4 &&
                alarmFlag == false{
                    
                alarmFlag = true
                    
                voicePlayer = AVAudioPlayer(contentsOfURL: audioPath[0]!, error: nil)
                    
                voicePlayer.stop()
                voicePlayer.play()
                    

                notif.fireDate = setTime
                notif.alertBody = "バカヤロー!!"
                notif.soundName = UILocalNotificationDefaultSoundName
                UIApplication.sharedApplication().scheduleLocalNotification(notif)
                
                var alert = UIAlertController(title: "アラート1", message: "バカヤロー‼︎", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:{action in println("OK") }))
                
                //presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func getTimeStringData (time : NSDate) -> String {
        
        // データフォーマットを独自フォーマットで取得
        dateFormatter.dateFormat = "yyyy/MM/dd:HH:mm"
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        
        // 年月日時刻を文字列として取得
        var timeConvert:String = dateFormatter.stringFromDate(time)
        
        // 取得した年月日時刻文字列の"/"をトリムする
        var timeTemp:String = timeConvert.stringByReplacingOccurrencesOfString("/", withString: "", options: nil, range: nil)
        
        // 取得した年月日時刻(文字列)の":"をトリムする
        var timeReplace:String = timeTemp.stringByReplacingOccurrencesOfString(":", withString: "", options: nil, range: nil)
        
        return timeReplace
    }
    
    func getTimeDivision (time : String) -> (String, String, String, String, String) {
        
        // 年の文字範囲を取得
        let yearStartIndex = advance(time.startIndex, 0)
        let yearEndIndex = advance(time.startIndex, 4)
        let year:String = time.substringFromIndex(yearStartIndex).substringToIndex(yearEndIndex)
        
        // 月の文字範囲を取得
        let monthStartIndex = advance(time.startIndex, 4)
        let monthEndIndex = advance(time.startIndex, 2)
        let month:String = time.substringFromIndex(monthStartIndex).substringToIndex(monthEndIndex)
        
        // 日の文字範囲を取得
        let dayStartIndex = advance(time.startIndex, 6)
        let dayEndIndex = advance(time.startIndex, 2)
        let day:String = time.substringFromIndex(dayStartIndex).substringToIndex(dayEndIndex)
        
        // 時間の文字範囲を取得
        let hourStartIndex = advance(time.startIndex, 8)
        let hourEndIndex = advance(time.startIndex, 2)
        let hour:String = time.substringFromIndex(hourStartIndex).substringToIndex(hourEndIndex)
        
        // 分の文字範囲を取得
        let minuteStartIndex = advance(time.startIndex, 10)
        let minuteEndIndex = advance(time.startIndex, 2)
        let minute:String = time.substringFromIndex(minuteStartIndex).substringToIndex(minuteEndIndex)
        
        return (year, month, day, hour, minute)
    }

    func setVoice () {
        volumeFlag = true
        var randomNumber = Int(arc4random()) % audioPath.count
        switch randomNumber{
        case 0:
            voicePlayer = AVAudioPlayer(contentsOfURL: audioPath[0]!, error: nil)
            break
        case 1:
            voicePlayer = AVAudioPlayer(contentsOfURL: audioPath[1]!, error: nil)
            break
        case 2:
            voicePlayer = AVAudioPlayer(contentsOfURL: audioPath[2]!, error: nil)
            break
        case 3:
            voicePlayer = AVAudioPlayer(contentsOfURL: audioPath[3]!, error: nil)
            break
        case 4:
            voicePlayer = AVAudioPlayer(contentsOfURL: audioPath[4]!, error: nil)
            break
        case 5:
            voicePlayer = AVAudioPlayer(contentsOfURL: audioPath[5]!, error: nil)
            break
        default :
            break
        }
    }
}

