//
//  ViewController.m
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import "ViewController.h"
#import "TaskViewControlViewController.h"

@interface ViewController () <UISearchBarDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _showAllToDoTasks = [NSMutableArray new];
    self.searchBar.delegate = self;
    
    UIImage *emptyStateImage = [UIImage imageNamed:@"o.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:emptyStateImage];
    imageView.contentMode = UIViewContentModeCenter;
    self.tableView.backgroundView = imageView;

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");

    [_showAllToDoTasks removeAllObjects];

    [Task retrieveTasksFromUserDefaults];
    _showAllTasks = [[Task allTasks] mutableCopy];
    
    for (Task *task in _showAllTasks) {
        if (task.status == 0) { // Task is in status "to do"
            [_showAllToDoTasks addObject:task];
        } else {
            NSLog(@"Task is not in 'to do' status");
        }
    }
    [self.tableView reloadData];
}

// Implement other table view delegate and data source methods here...

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText];
}

#pragma mark - Helper Methods

- (void)filterContentForSearchText:(NSString *)searchText {
    if (searchText.length == 0) {
        self.searchResults = nil;
        [self.tableView reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskTitle CONTAINS[c] %@", searchText];
    NSArray *filteredResults = [_showAllToDoTasks filteredArrayUsingPredicate:predicate];
    if (filteredResults.count > 0) {
        self.searchResults = [filteredResults mutableCopy];
    } else {
        self.searchResults = [NSMutableArray array];
    }
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        Task *taskToRemove;
      
            taskToRemove = self.showAllToDoTasks[indexPath.row];
            [self.showAllToDoTasks removeObjectAtIndex:indexPath.row];
                
        [_showAllTasks removeObject:taskToRemove];
        
        [Task removeTask:taskToRemove];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (Task *)taskForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    if (self.searchResults.count > 0) {
        return self.searchResults[indexPath.row];
    } else {
        return _showAllToDoTasks[indexPath.row];
    }
    
}- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    if (self.searchResults.count > 0) {
        numberOfRows = self.searchResults.count;
    } else {
        numberOfRows = _showAllToDoTasks.count;
    }

    if (numberOfRows == 0) {
        self.tableView.backgroundView.hidden = NO;
    } else {
        self.tableView.backgroundView.hidden = YES;
    }

    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Task *task = [self taskForTableView:tableView atIndexPath:indexPath];
    cell.textLabel.text = task.taskTitle;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Task * selectedTask = self.showAllToDoTasks[indexPath.row];
        
    
    NSUInteger index = [_showAllTasks indexOfObject:selectedTask];
    NSLog(@"the indexxxxxxxxxxx  is %lu", (unsigned long)index);

    TaskViewControlViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetailsVC"];
    detailVC.selectedTask = selectedTask;
    detailVC.indexOfOjectAtOrignalArray = index;

    detailVC.comeToEdit=YES;
    [self.navigationController pushViewController:detailVC animated:YES];

}
@end
