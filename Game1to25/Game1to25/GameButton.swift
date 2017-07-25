//
//  GameButton.swift
//  Game1to25
//
//  Created by YeongsikLee on 2017. 7. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class GameButton: UIButton {
    
    // MARK: - Static Variable
    
    static var sideLength:Int = 5
    static var unallocatedNumbers:[Int] = []    /// 버튼 난수 생성 시에 중복 판별에 사용
    static var numberWillPressed: Int = 0       /// 게임 중 다음에 눌려야 할 번호를 의미
    static var isAllPressed: Bool {
        return numberWillPressed > (sideLength * sideLength)
    }
    
    
    
    // MARK: - Static Method
    
    static func initGameButtons() {
        
        let totalNumbers = sideLength * sideLength
        
        unallocatedNumbers = []
        for num in 1 ... totalNumbers {
            unallocatedNumbers.append(num)
        }
        
        numberWillPressed = 1
    }
    
    
    
    // MARK: - Public Variable
    
    var countWrongPressed: Int = 0  /// 버튼 잘 못 누른 횟수
    
    
    // MARK: - Button Life Cycle Method
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.title(for: .normal) == "\(GameButton.numberWillPressed)" {
            self.isHidden = true
            GameButton.numberWillPressed += 1
        } else {
            countWrongPressed += 1
            
            DispatchQueue.main.async {
                
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: [.curveEaseOut],
                    animations: {
                        
                        self.backgroundColor = UIColor.red
                    },
                    completion: { _ in
                        
                        self.backgroundColor = UIColor(colorLiteralRed: 0x44 / 255, green: 0x56 / 255, blue: 0x8C / 255, alpha: 1.0)
                    }
                )
            }
        }
    }
    
    
    
    // MARK: - Public Method
    
    func setup() {
        
        var num: Int = -1
        
        if GameButton.unallocatedNumbers.count > 0 {
            let idx = Int(arc4random_uniform(UInt32(GameButton.unallocatedNumbers.count)))
            
            num = GameButton.unallocatedNumbers[idx]
            GameButton.unallocatedNumbers.remove(at: idx)
        }
        
        self.countWrongPressed = 0
        
        self.titleLabel?.textAlignment = .center
        self.setTitle("\(num)", for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        
        self.isHidden = false
    }

}
