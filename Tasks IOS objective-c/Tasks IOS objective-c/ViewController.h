//
//  ViewController.h
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface ViewController : UIViewController
< UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>

@property NSMutableArray<Task *> *showAllTasks;
@property  NSMutableArray<Task *> *highPriorityTasks ;
@property NSMutableArray<Task *> *mediumPriorityTasks ;
@property NSMutableArray<Task *> *lowPriorityTasks;
@property NSMutableArray<Task *> *showAllToDoTasks;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray<Task *> *searchResults;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableArray<Task *> *filteredTasks;



@end

