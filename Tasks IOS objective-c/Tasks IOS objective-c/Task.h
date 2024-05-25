//
//  Task.h
//  Tasks IOS objective-c
//
//  Created by Mayar on 21/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject

@property NSString* taskTitle;
@property NSString* taskDesc;
@property int  priority;
@property int status;
@property NSDate* dateAndTime;

- (instancetype)initWithTitle:(NSString *)title
                         desc:(NSString *)desc
                     priority:(int)priority
                       status:(int )status
                  dateAndTime:(NSDate *)dateAndTime;

+ (NSArray<Task *> *)allTasks;
+ (void)addTask:(Task *)task;
+ (void)removeTask:(Task *)taskToRemove;
+ (void)saveTasksToUserDefaults;
+ (void)retrieveTasksFromUserDefaults;
+ (void)editTaskAtIndex:(NSUInteger)index withTask:(Task *)newTask;

@end

NS_ASSUME_NONNULL_END

