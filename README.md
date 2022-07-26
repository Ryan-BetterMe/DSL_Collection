# DSL_Collection
看了swift的result builder的提案中的一些DSL的案例，萌生了自己制作DSL的念头，希望后续这个合集可以多些一些相关的DSL来应对实际的项目需求。

## AttributedBuilder

### Features
将NSAttributedString的初始化变成了SwiftUI风格的，大体上和0289提案中的功能类似

| Emoji | description |
| --- | --- |
| 🐦	| Open source library written in Swift 5.4 |
| 🍬	| SwiftUI-like syntax |
| 💪	| Support most attributes in NSAttributedString.Key |
| 📦	| Distribution with Swift Package Manager |
| 🧪	| Fully tested code |

但是在这个基础上，我额外实现了几个重要的功能:
- [x] 描述时支持if语句
- [x] 描述时支持if-else语句
- [x] 描述时支持switch语句
- [x] 描述时支持for-in循环
- [x] 描述时支持if #avaliable

### How to use?
类似SwiftUI的语法，直接简单的初始化即可。
```
return NSAttributedString {
    AText("世界那么大")
        .foregroundColor(Color.black)
        .font(Font.systemFont(ofSize: 12))
        .alignment(.center)
        .baselineOffset(1.5)

    if true {
        AText("我想去看看")
            .foregroundColor(Color.red)
            .font(Font.systemFont(ofSize: 18))
            .alignment(.center)
    }

    for _ in 0...2 {
        AText("!")
            .foregroundColor(Color.red)
            .font(Font.systemFont(ofSize: 18))
            .alignment(.center)
    }

    ImageText(UIImage(systemName: "star")!)
        .bounds(CGRect.init(x: 0, y: -1.5, width: 18, height: 18))
}
```

### Requirements
Xcode 12.5. This project uses Swift 5.4 feature Result Builder.
