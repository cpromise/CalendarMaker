# CalendarMaker
Helps to create CalendarView(```UIStackView``` honestly) using UIKit

### Prerequisites

- iOS12
- XCode11.3
- Swift5.2

### Installing

```
pod 'CalendarMaker'
```

### How to use

```
import UIKit
import CalendarMaker

class ViewController: UIViewController {
    let maker = CalendarMaker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let calendarView = maker.createCalendarView(year: 2020, month: 4) {
            view.addSubview(calendarView)
            calendarView.translatesAutoresizingMaskIntoConstraints = false
            calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
}


```

## Result
![Simulator Screen Shot - iPhone 11 Pro Max - 2020-04-18 at 20 36 39](https://user-images.githubusercontent.com/5927910/79636696-8a250600-81b4-11ea-8eaa-1c290134a1a9.png)



## Authors

* **Rubberhammer** - [Github](https://github.com/cpromise), [E-mail](rubberhammer225@gmail.com)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/cpromise/CalendarMaker/blob/master/LICENSE) file for details

