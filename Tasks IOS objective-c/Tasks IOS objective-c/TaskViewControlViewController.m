//
//  TaskViewControlViewController.m
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import "TaskViewControlViewController.h"
#import "Task.h"

@interface TaskViewControlViewController ()
@end

@implementation TaskViewControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _task = [Task new];

     self.data.datePickerMode = UIDatePickerModeDateAndTime;
     self.data.minimumDate = [NSDate date];
     self.data.maximumDate = [NSDate distantFuture];
     
    
    if(_comeToEdit){
        self.taskTitle.text=self.selectedTask.taskTitle;
        self.taskDescription.text=self.selectedTask.taskDesc;
        _incomingpriority=_selectedTask.status;
        NSLog(@"IN _incomingpriority %d  ",_selectedTask.status);

        NSLog(@"IN _incomingpriority %d  ",_incomingpriority);

        self.prioritySegmentedControl.selectedSegmentIndex=self.selectedTask.priority;
        self.statusSegmentedControl.selectedSegmentIndex=self.selectedTask.status;
        self.data.date=self.selectedTask.dateAndTime;

        [self.addOrEditButtonOutlet setTitle:@"Edit" forState:UIControlStateNormal];
        switch (self.selectedTask.priority) {
                   case 0:
                       self.stausimage.image = [UIImage imageNamed:@"high.jpg"];
                       break;
                   case 1:
                       self.stausimage.image = [UIImage imageNamed:@"m.jpg"];
                       break;
                   case 2:
                       self.stausimage.image = [UIImage imageNamed:@"low.jpg"];
                       break;
                   default:
                       self.stausimage.image = nil;
                       break;
               }
        switch (self.selectedTask.status) {
                 case 1:
                
                [self.statusSegmentedControl setEnabled:NO forSegmentAtIndex:0];

                break;
                   case 2:
                self.taskTitle.enabled=NO;
                self.taskDescription.userInteractionEnabled=NO;
                self.statusSegmentedControl.userInteractionEnabled =NO;
                self.prioritySegmentedControl.userInteractionEnabled =NO;
                [self.addOrEditButtonOutlet setTitle:@"" forState:UIControlStateNormal];


                break;
                   default:

                break;
               }
        
    }
}

- (IBAction)chooseDataAndTime:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSLog(@"Selected Date and Time: %@", selectedDate);
    _task.dateAndTime = sender.date;
}

- (IBAction)status:(UISegmentedControl *)sender {
    NSArray<NSNumber *> *priorityValues = @[@0, @1, @2];
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    if (selectedIndex >= 0 && selectedIndex < priorityValues.count) {
        _task.status = [priorityValues[selectedIndex] intValue];
    }
}

- (IBAction)priioty:(UISegmentedControl *)sender {
    NSArray<NSNumber *> *priorityValues = @[@0, @1, @2];
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    if (selectedIndex >= 0 && selectedIndex < priorityValues.count) {
        _task.priority = [priorityValues[selectedIndex] intValue];

        switch (_task.priority) {
                   case 0:
                       self.stausimage.image = [UIImage imageNamed:@"high.jpg"];
                       break;
                   case 1:
                       self.stausimage.image = [UIImage imageNamed:@"m.jpg"];
                       break;
                   case 2:
                       self.stausimage.image = [UIImage imageNamed:@"low.jpg"];
                       break;
                   default:
                       self.stausimage.image = nil;
                       break;
               }    }
}


- (IBAction)AddOrEdit:(UIButton *)sender {
    _task.taskTitle = _taskTitle.text;
    _task.taskDesc = _taskDescription.text;
    if (_task.taskTitle.length == 0 || _task.dateAndTime == nil) {
        // Show error alert if task title is empty or date is nil
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Please Enter Correctly Data"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
       
    NSString *buttonTitle = [self.addOrEditButtonOutlet titleForState:UIControlStateNormal];
    if ([buttonTitle isEqualToString:@"Edit"]) {
        _task.taskTitle = _taskTitle.text;
        _task.taskDesc = _taskDescription.text;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confoirmation"
                                                                                 message:@"Sure save the changes?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [Task editTaskAtIndex:_indexOfOjectAtOrignalArray withTask:_task];
            
            [self.navigationController popViewControllerAnimated:YES];
           }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    
    } else if([buttonTitle isEqualToString:@""]){
              
    } else {
        [Task addTask:_task];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add"
                                                                                 message:@"New Task, New Step to success"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [self.navigationController popViewControllerAnimated:YES];
           }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
