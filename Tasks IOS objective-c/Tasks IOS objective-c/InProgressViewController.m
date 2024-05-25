//
//  InProgressViewController.m
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import "InProgressViewController.h"
#import "TaskViewControlViewController.h"


@interface InProgressViewController ()

@property (nonatomic, assign) BOOL isFiltering;

@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _showAllTasks =[NSMutableArray new];
    _showAllInProgressTasks=[NSMutableArray new] ;
    
    _isFiltering = NO;
    UIImage *emptyStateImage = [UIImage imageNamed:@"o.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:emptyStateImage];
    imageView.contentMode = UIViewContentModeCenter;
    self.tableView.backgroundView = imageView;
    
    NSLog(@"Background view hidden status: %d", self.tableView.backgroundView.hidden);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    _highPriorityTasks = [NSMutableArray array];
    _mediumPriorityTasks = [NSMutableArray array];
    _lowPriorityTasks = [NSMutableArray array];
    
    [_showAllTasks removeAllObjects];
    [_showAllInProgressTasks removeAllObjects];

    [Task retrieveTasksFromUserDefaults];
    _showAllTasks = [[Task allTasks] mutableCopy];
    
    for (Task *task in _showAllTasks) {
        if (task.status == 1) {
            [_showAllInProgressTasks addObject:task];
            
            if (task.priority == 0) {
                [_highPriorityTasks addObject:task];
            } else if (task.priority == 1) {
                [_mediumPriorityTasks addObject:task];
            } else if (task.priority == 2) {
                [_lowPriorityTasks addObject:task];
            }
        }
    }
    NSLog(@"show count of _showAllInProgressTasks: %lu", (unsigned long)_showAllInProgressTasks.count);
    NSLog(@"SHOW: %lu",(unsigned long )_showAllInProgressTasks.count);
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Task *taskToRemove;
        if (self.isFiltering) {
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
            taskToRemove = _showAllInProgressTasks[indexPath.row];
            [_showAllInProgressTasks removeObjectAtIndex:indexPath.row];
        }
        
        [Task removeTask:taskToRemove];
        
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
        selectedTask = _showAllInProgressTasks[indexPath.row];
    }
    
    NSUInteger index = [_showAllTasks indexOfObject:selectedTask];

    TaskViewControlViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetailsVC"];
    detailVC.selectedTask = selectedTask;
    detailVC.indexOfOjectAtOrignalArray = index;

    detailVC.comeToEdit=YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Task *task;
    // orignial array get teh object and sent itis
    if (self.isFiltering) {
        if (indexPath.section == 0) {
            task = self.highPriorityTasks[indexPath.row];
        } else if (indexPath.section == 1) {
            task = self.mediumPriorityTasks[indexPath.row];
        } else if (indexPath.section == 2) {
            task = self.lowPriorityTasks[indexPath.row];
        }
    } else {
        task = _showAllInProgressTasks[indexPath.row];
    }
  
    
    cell.textLabel.text = task.taskTitle;
    return cell;
}


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
    BOOL highPriorityTasksCount = NO;
        BOOL mediumPriorityTasksCount = NO;
        BOOL lowPriorityTasksCount = NO;
        BOOL allInProgressCount = NO;
    if (self.isFiltering) {
        if (section == 0) {
            numberOfRows = [self.highPriorityTasks count];
            highPriorityTasksCount =([self.highPriorityTasks count] >  0);
        } else if (section == 1) {
            numberOfRows = [self.mediumPriorityTasks count];
            mediumPriorityTasksCount =([self.mediumPriorityTasks count]>0);
        } else {
            numberOfRows = [self.lowPriorityTasks count];
            lowPriorityTasksCount = ([self.lowPriorityTasks count]>0);
        }
    } else {
        numberOfRows = [_showAllInProgressTasks count];
        allInProgressCount =([_showAllInProgressTasks count] > 0);
    }
       NSLog(@"highPriorityTasksCount: %@", highPriorityTasksCount ? @"YES" : @"NO");
       NSLog(@"mediumPriorityTasksCount: %@", mediumPriorityTasksCount ? @"YES" : @"NO");
       NSLog(@"lowPriorityTasksCount: %@", lowPriorityTasksCount ? @"YES" : @"NO");
       NSLog(@"allInProgressCount: %@", allInProgressCount ? @"YES" : @"NO");


    if (!(highPriorityTasksCount || mediumPriorityTasksCount || lowPriorityTasksCount || allInProgressCount)) {
         tableView.backgroundView.hidden = NO;
     } else {
         tableView.backgroundView.hidden = YES;
     }

    return numberOfRows;
}


- (void)filtet:(UIButton *)sender{
    
    self.isFiltering = !self.isFiltering;
    [self.tableView reloadData];

}

@end
