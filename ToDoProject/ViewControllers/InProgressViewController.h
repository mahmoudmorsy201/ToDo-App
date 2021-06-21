//
//  ViewController.h
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import <UIKit/UIKit.h>
#import "UpdateProtocol.h"

@interface InProgressViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UpdateProtocol,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *inProgressTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *inProgressSearch;

@property NSMutableArray <NSMutableDictionary*> *inProgressArray;
@property NSMutableDictionary *inProgressDict;

@end

