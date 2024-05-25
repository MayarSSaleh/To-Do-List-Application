//
//  DoViewController.m
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import "DoViewController.h"
#import "TaskViewControlViewController.h"
#import "CustomCellTwoPhotoTableViewCell.h"

  


@interface DoViewController ()
@property (nonatomic, assign) BOOL isFiltering;

@end

@implementation DoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _showAllTasks =[NSMutableArray new];
    _showAllDoneTasks=[NSMutableArray new] ;
    
    _isFiltering = NO;
    
    [self.tableView registerClass:[CustomCellTwoPhotoTableViewCell class] forCellReuseIdentifier:@"CustomCellTwoPhotoTableViewCell"];
    
    UIImage *emptyStateImage = [UIImage imageNamed:@"o.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:emptyStateImage];
    imageView.contentMode = UIViewContentModeCenter;
    self.tableView.backgroundView = imageView;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    _highPriorityTasks = [NSMutableArray array];
    _mediumPriorityTasks = [NSMutableArray array];
    _lowPriorityTasks = [NSMutableArray array];
    
    [_showAllTasks removeAllObjects];
    [_showAllDoneTasks removeAllObjects];

    [Task retrieveTasksFromUserDefaults];
    _showAllTasks = [[Task allTasks] mutableCopy];
    

    for (Task *task in _showAllTasks) {
    
        if (task.status == 2) {
            [_showAllDoneTasks addObject:task];
            
            if (task.priority == 0) {
                [_highPriorityTasks addObject:task];
            } else if (task.priority == 1) {
                [_mediumPriorityTasks addObject:task];
            } else if (task.priority == 2) {
                [_lowPriorityTasks addObject:task];
            }
        } else {
            NSLog(@"Task is not in done status");
        }
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Task *taskToRemove;
        if (self.isFiltering) {
            // If filtering is enabled, remove task from priority-specific arrays
            if (indexPath.section == 0) {
                taskToRemove = self.highPriorityTasks[indexPath.row];
                [self.highPriorityTasks removeObjectAtIndex:indexPath.row];
            } else if (indexPath.section == 1) {
                taskToRemove = self.mediumPriorityTasks[indexPath.row];
                [self.mediumPriorityTasks removeObjectAtIndex:indexPath.row];
            } else if (indexPath.section == 2) {
                taskToRemove = self.lowPriorityTasks[indexPath.row];
                [self.lowPriorityTasks removeObjectAtIndex:indexPath.row];
            }
        } else {
            // If filtering is disabled, remove task from _showAllTasks array
            taskToRemove = _showAllDoneTasks[indexPath.row];
            [_showAllDoneTasks removeObjectAtIndex:indexPath.row];
        }
        
        // Remove the task from wherever it's stored
        [Task removeTask:taskToRemove];
        
        // Delete the row from the table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Task *selectedTask;
    if (self.isFiltering) {
        if (indexPath.section == 0) {
            selectedTask = self.highPriorityTasks[indexPath.row];
        } else if (indexPath.section == 1) {
            selectedTask = self.mediumPriorityTasks[indexPath.row];
        } else if (indexPath.section == 2) {
            selectedTask = self.lowPriorityTasks[indexPath.row];
        }
    } else {
        selectedTask = _showAllDoneTasks[indexPath.row];
    }
    
   
    NSUInteger index = [_showAllTasks indexOfObject:selectedTask];
    NSLog(@"the indexxxxxxxxxxx  is in do view control  %lu", (unsigned long)index);

    TaskViewControlViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetailsVC"];
    detailVC.selectedTask = selectedTask;
    detailVC.indexOfOjectAtOrignalArray = index;

    detailVC.comeToEdit=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellTwoPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellTwoPhotoTableViewCell" forIndexPath:indexPath];
    
    Task *task;
    if (self.isFiltering) {
        if (indexPath.section == 0) {
            task = self.highPriorityTasks[indexPath.row];
        } else if (indexPath.section == 1) {
            task = self.mediumPriorityTasks[indexPath.row];
        } else if (indexPath.section == 2) {
            task = self.lowPriorityTasks[indexPath.row];
        }
    } else {
        task = _showAllDoneTasks[indexPath.row];
    }
    
    // Configure your custom cell with task data
    // For example:
    cell.firestImage.image = [UIImage imageNamed:@"completed.jpg"];
    
    switch (task.priority) {
               case 0:
            cell.secondImage.image = [UIImage imageNamed:@"high.jpg"];
                   break;
               case 1:
            cell.secondImage.image = [UIImage imageNamed:@"m.jpg"];
                   break;
               case 2:
            cell.secondImage.image = [UIImage imageNamed:@"low.jpg"];
                   break;
               default:
            cell.secondImage.image = nil;
                   break;
           }
     cell.title.text = task.taskTitle;

    return cell;
}

/*
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Task *task;
    
    if (self.isFiltering) {
        if (indexPath.section == 0) {
            task = self.highPriorityTasks[indexPath.row];
        } else if (indexPath.section == 1) {
            task = self.mediumPriorityTasks[indexPath.row];
        } else if (indexPath.section == 2) {
            task = self.lowPriorityTasks[indexPath.row];
        }
    } else {
        task = _showAllDoneTasks[indexPath.row];
    }
    
    cell.textLabel.text = task.taskTitle;
    return cell;
}

*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isFiltering) {
        return 3;
    }
    else return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    headerView.backgroundColor = [UIColor yellowColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 20, 30)];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    switch (section) {
        case 0:
            if(_isFiltering){
                headerLabel.text = @"High Priority";
            }
            else{
                headerLabel.text = @"All Tasks";
                headerView.backgroundColor = [UIColor whiteColor];
            }

            break;
        case 1:
            headerLabel.text = @"Medium Priority";
            break;
        case 2:
            headerLabel.text = @"Low Priority";
            break;
        default:
            headerLabel.text = @"";
            break;
    }
    
    [headerView addSubview:headerLabel];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if (self.isFiltering) {
        if (section == 0) {
            numberOfRows = [self.highPriorityTasks count];
        } else if (section == 1) {
            numberOfRows = [self.mediumPriorityTasks count];
        } else {
            numberOfRows = [self.lowPriorityTasks count];
        }
    } else {
        numberOfRows = [_showAllDoneTasks count];
    }

    if (numberOfRows == 0) {
        tableView.backgroundView.hidden = NO; // Show the background image
    } else {
        tableView.backgroundView.hidden = YES; // Hide the background image
    }

    return numberOfRows;
}


- (IBAction)filterAtDone:(UIButton *)sender {
    self.isFiltering = !self.isFiltering;
    [self.tableView reloadData];
}
@end
