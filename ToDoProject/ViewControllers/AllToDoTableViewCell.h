//
//  MyTableViewCell.h
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllToDoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *prioImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isRemindedImage;

@end

NS_ASSUME_NONNULL_END
