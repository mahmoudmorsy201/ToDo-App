//
//  DoneViewController.h
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import <UIKit/UIKit.h>
#import "UpdateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UpdateProtocol,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *doneTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *doneSearchBar;

@property NSMutableArray <NSMutableDictionary*> *doneArray;
@property NSMutableDictionary *doneDict;
@end

NS_ASSUME_NONNULL_END
