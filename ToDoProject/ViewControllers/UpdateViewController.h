//
//  UpdateViewController.h
//  ToDoProject
//
//  Created by Mahmoud Morsy on 02/03/2021.
//

#import <UIKit/UIKit.h>
#import "UpdateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpdateViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *prioPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property NSString *prioTxt;
@property NSMutableDictionary *editDict;
@property id <UpdateProtocol> P;
@property NSIndexPath* index;
@property NSInteger indexSearch;

@end

NS_ASSUME_NONNULL_END
