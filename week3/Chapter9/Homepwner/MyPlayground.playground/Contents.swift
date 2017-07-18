////TERMINATE
//import Foundation
//
//let last = 10
//let numberOfThreads = 10
//
//var producerLock = NSLock()
//var consumerLocks: [NSLock] = []
//
//var total = 0
//var totalLock = NSLock()
//
//var ended = 0
//var endedLock = NSLock()
//
//for i in 0 ..< numberOfThreads {
//    consumerLocks.append(NSLock())
//}
//
//var items:[Int] = []
//
//class Producer: NSObject {
//    func runLoop() {
//        for i in 0...last {
//            producerLock.lock()
//            items.append(i)
//            producerLock.unlock()
//        }
//    }
//    
//    override init() {
//        super.init()
//        let thread = Thread(target: self, selector: #selector(runLoop), object: nil)
//        thread.start()
//    }
//}
//
//class Consumer: Operation {
//    var items:[Int]
//    var num:Int
//    
//    init(_ num: Int){
//        self.num = num
//        self.items = []
//        
//        super.init()
//    }
//    
//    override func main() {
//        if self.isCancelled {
//            return
//        }
//        
//        while(true){
//            consumerLocks[num].lock()
//            
//            var tmp = 0
//            while !self.items.isEmpty {
//                tmp += self.items.popLast()!
//            }
//            consumerLocks[num].unlock()
//            totalLock.lock()
//            total += tmp
//            print("\(num) - \(total)")
//            totalLock.unlock()
//            
//            if total == last * (last + 1) / 2 {
//                break
//            }
//        }
//        
//        endedLock.lock()
//        ended += 1
//        endedLock.unlock()
//    }
//}
//
//var operationQueue:OperationQueue = {
//    var queue = OperationQueue()
//    queue.name = "testQueue"
//    queue.maxConcurrentOperationCount = numberOfThreads
//    return queue
//}()
//
//var producer = Producer()
//var consumers:[Consumer] = []
//for i in 0 ..< numberOfThreads {
//    consumers.append(Consumer(i))
//    operationQueue.addOperation(consumers[i])
//}
//
//
//var num: Int, i = 0;
//while(ended < numberOfThreads){
//    producerLock.lock()
//    num = i % numberOfThreads
//    consumerLocks[num].lock()
//    while !items.isEmpty {
//        consumers[num].items.append(items.popLast()!)
//    }
//    consumerLocks[num].unlock()
//    producerLock.unlock()
//    i += 1
//}


import UIKit

var view = UIView()
if let control = view as? UIControl {
    print(99)
} else {
    print(99)
}