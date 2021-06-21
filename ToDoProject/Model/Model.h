//
//  Model.h
//  ToDoProject
//
//  Created by Mahmoud Morsy on 27/02/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject
@property NSString* name;
@property NSString* detail;
@property NSString* priority;
@property NSDate* date;
@property NSDate *dateCreated;
@property NSString* isReminded;

@end

NS_ASSUME_NONNULL_END
