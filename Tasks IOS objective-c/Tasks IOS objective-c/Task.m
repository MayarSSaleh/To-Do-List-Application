//
//  Task.m
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import "Task.h"

@implementation Task

static NSMutableArray<Task *> *_tasks;

- (instancetype)initWithTitle:(NSString *)title
                         desc:(NSString *)desc
                     priority:(int)priority
                       status:(int)status
                  dateAndTime:(NSDate *)dateAndTime {
    self = [super init];
    if (self) {
        _taskTitle = title;
        _taskDesc = desc;
        _priority = priority;
        _status = status;
        _dateAndTime = dateAndTime;
    }
    return self;
}

+ (NSArray<Task *> *)allTasks {
    return [_tasks copy];
}

+ (void)addTask:(Task *)task {
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    [_tasks addObject:task];
    [self saveTasksToUserDefaults];
}

+ (void)update:(Task *)task {
    NSUInteger index = [_tasks indexOfObject:task];
    NSLog(@"The update'");
    
    if (index != NSNotFound) {
        NSLog(@"The update' in if ");
        
        // Update the task's properties
        _tasks[index].taskTitle = task.taskTitle;
        _tasks[index].taskDesc = task.taskDesc;
        _tasks[index].priority = task.priority;
        _tasks[index].status = task.status;
        _tasks[index].dateAndTime = task.dateAndTime;
        
        [self saveTasksToUserDefaults];
    }
    
}

+ (void)removeTask:(Task *)taskToRemove {
    if ([_tasks containsObject:taskToRemove]) {
        [_tasks removeObject:taskToRemove];
        [self saveTasksToUserDefaults];
    }
}


+ (void)saveTasksToUserDefaults {
    NSMutableArray *taskDicts = [NSMutableArray array];
    for (Task *task in _tasks) {
        [taskDicts addObject:@{
            @"taskTitle": task.taskTitle,
            @"taskDesc": task.taskDesc,
            @"priority": @(task.priority),
            @"status": @(task.status),
            @"dateAndTime": task.dateAndTime
        }];
    }// all tasks have been saved, the taskDicts array contains dictionaries representing each task.
    
    [[NSUserDefaults standardUserDefaults] setObject:taskDicts forKey:@"tasks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)retrieveTasksFromUserDefaults {
    NSArray *taskDicts = [[NSUserDefaults standardUserDefaults] objectForKey:@"tasks"];
    _tasks = [NSMutableArray array];
    for (NSDictionary *dict in taskDicts) {
        Task *task = [[Task alloc] initWithTitle:dict[@"taskTitle"]
                                             desc:dict[@"taskDesc"]
                                        priority:[dict[@"priority"] intValue]
                                          status:[dict[@"status"] intValue]
                                      dateAndTime:dict[@"dateAndTime"]];
        [self addTask:task];
    }
}

// edit all
// if done all is uneditable

+ (void)editTaskAtIndex:(NSUInteger)index withTask:(Task *)newTask {
    NSLog(@"Editing task at index %lu", (unsigned long)index);

    if (index < _tasks.count) {
        NSLog(@"Task found at index %lu", (unsigned long)index);
        _tasks[index].taskTitle = newTask.taskTitle;
        _tasks[index].taskDesc = newTask.taskDesc;
        _tasks[index].priority = newTask.priority;
        _tasks[index].status = newTask.status;
        _tasks[index].dateAndTime = newTask.dateAndTime;
        [self saveTasksToUserDefaults];
    } else {
        NSLog(@"Index out of range or task not found at index %lu", (unsigned long)index);
    }
}




@end
