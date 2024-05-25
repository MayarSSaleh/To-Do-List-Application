//
//  InProgressViewController.h
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface InProgressViewController : UIViewController
< UITableViewDelegate, UITableViewDataSource>

- (IBAction)filtet:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageInProgress;

@property NSMutableArray<Task *> *showAllTasks;
@property NSMutableArray<Task *> *showAllInProgressTasks;
@property  NSMutableArray<Task *> *highPriorityTasks ;
@property NSMutableArray<Task *> *mediumPriorityTasks ;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray<Task *> *lowPriorityTasks;

@end

NS_ASSUME_NONNULL_END
