//
//  TaskViewControlViewController.h
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "Task.h"


NS_ASSUME_NONNULL_BEGIN

@interface TaskViewControlViewController : UIViewController


- (IBAction)AddOrEdit:(UIButton *)sender;
@property Task * selectedTask;
@property (nonatomic, assign) BOOL comeToEdit;
@property int incomingpriority;


@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *data;
@property (weak, nonatomic) IBOutlet UIButton *addOrEditButtonOutlet;

@property  Task * task;
@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;

@property (nonatomic, assign) NSUInteger indexOfOjectAtOrignalArray;

@property (weak, nonatomic) IBOutlet UIImageView *stausimage;

- (IBAction)priioty:(UISegmentedControl *)sender;
- (IBAction)status:(UISegmentedControl *)sender;


- (IBAction)chooseDataAndTime:(UIDatePicker *)sender;


@end

NS_ASSUME_NONNULL_END
