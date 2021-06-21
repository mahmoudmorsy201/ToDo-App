//
//  DetailsViewController.h
//  ToDoProject
//
//  Created by Mahmoud Morsy on 01/03/2021.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "UpdateProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController <UpdateProtocol>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *prioLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateCreatedLabel;
@property id <UpdateProtocol> P;


@property NSMutableDictionary *detailModelDict;

@property NSMutableDictionary *selectedModelDict;
@property NSIndexPath* index;
@property NSInteger indexSearch;


@end

NS_ASSUME_NONNULL_END
