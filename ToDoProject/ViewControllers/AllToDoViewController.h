//
//  AllToDoTableViewController.h
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "AddToDoProtocol.h"
#import "UpdateProtocol.h"
#import <UserNotifications/UserNotifications.h>


NS_ASSUME_NONNULL_BEGIN

@interface AllToDoViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,AddToDoProtocol,UpdateProtocol,UISearchBarDelegate,UNUserNotificationCenterDelegate>

@property (weak, nonatomic) IBOutlet UITableView *allTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *allToDoSearchBar;

@property NSMutableArray<NSMutableDictionary*> *dictArray;




@end

NS_ASSUME_NONNULL_END
