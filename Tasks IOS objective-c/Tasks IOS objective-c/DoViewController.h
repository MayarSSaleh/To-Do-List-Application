//
//  DoViewController.h
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"


NS_ASSUME_NONNULL_BEGIN

@interface DoViewController : UIViewController
< UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray<Task *> *showAllTasks;
@property NSMutableArray<Task *> *showAllDoneTasks;
@property  NSMutableArray<Task *> *highPriorityTasks ;
@property NSMutableArray<Task *> *mediumPriorityTasks ;
@property NSMutableArray<Task *> *lowPriorityTasks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)filterAtDone:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
