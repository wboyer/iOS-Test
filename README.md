iOS-Test
========

This is an iOS app for miscellaneous prototyping.  Currently it demonstrates the following things:

- A simple [Core Data](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdBasics.html) store, using [SQLite](http://www.sqlite.org/) for persistence.
- Storing binary image data directly in Core Data, which seems appropriate when the images are very small, as in this example.
- Using an [NSFetchedResultsController](https://developer.apple.com/library/ios/documentation/CoreData/Reference/NSFetchedResultsController_Class/) to mirror the contents of the store to a [UITableView](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITableView_Class/).
- Using UITableView's editing mode to enable row deletion.
- Using [NSURLConnection](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html) to fetch asynchronously via HTTP.
