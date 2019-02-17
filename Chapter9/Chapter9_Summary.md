## Chapter9 - Smashtag

1. UITableView
  - style
    + plain: dynamic(list) & plain(ungrouped)
    + grouped: static & grouped
  - table header, table footer, section(section header, section footer), table cell
  - sections or not
    + depends on you
  - cell type
    + subtitle: UITableViewCellStyle.subtitle
    + basic: .default
    + right detail: .value1
    + left detail: .value2
  - UITableViewController
    + useful when the UITableView is going to fill all of self.view
    + Controller: UITableViewController, Controller's property: UITableView
    + subclass: dataSource, delegate
    + shift-right-click(ctrl-shift-left-click): Controller, table view, cell in a table view, view inside a cell in the table view
    + plain vs grouped, static vs dynamic(normally use plain, dynamic together and grouped, static together)
      * dynamic make outlet on UITableViewCell, not UITableViewController
      * static make outlet directly on UITableViewController
  - UITableView Protocols
    + connections to code are made using the UITableView's dataSource and delegate
      * delegate: used to control how the table is displayed
      * dataSource: provides the data that is displayed inside the cells
    + data in the table is dynamic(i.e. not static cells), need to implement the dataSource
  - customizing each row
    + has to be a UITableViewCell or subclass thereof
      * only the visible ones will have a UITableViewCell
      * UITableViewCells are **reused** as rows appear and disappear(**multithreaded situations so be careful**)
      * dequeueReusableCell(withIdentifier: "MyCell", for: )
  - UITableViewDataSource
    + set the table view's dataSource to your Controller(automatic with UITableViewController)
    + implement numberOfSections and numberOfRowsInSection
    + implement cellForRowAt to return loaded-up UITableViewCells
    + section titles are also considered part of the table's data
  - table view segues
    ```swift
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let identifier = segue.identifier {
        switch identifier {
        case "XyzSegue": // handle XyzSegue here
        case "AbcSegue":
          if let cell = sender as? MyTableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let seguedToMVC = segue.destination as? MyVC {
              seguedToMVC.publicAPI = data[indexPath.section][indexPath.row]
            }
        default: break
        }
      }
    }
    ```
  - UITableViewDelegate
    + controls how the UITableView is displayed
    + lets you observe what the table view is doing
  - UITableView Target/Action
    + UITableViewDelegate method sent when row is selected
      * Delegate method sent also when Detail Disclosure button is touched
  - if Model changes?
    + func reloadData()
    + func reloadRows(at indexPath: [indexPath], with animation: UITableViewRowAnimation)
