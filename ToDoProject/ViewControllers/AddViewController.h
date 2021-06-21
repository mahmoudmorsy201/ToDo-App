//
//  AddViewController.h
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import <UIKit/UIKit.h>
#import "AddToDoProtocol.h"
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *prioPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property id <AddToDoProtocol> P;
@property NSString *prioTxt;



@end

NS_ASSUME_NONNULL_END
