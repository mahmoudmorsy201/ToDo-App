//
//  UpdateViewController.m
//  ToDoProject
//
//  Created by Mahmoud Morsy on 02/03/2021.
//

#import "UpdateViewController.h"
#import "Model.h"

@interface UpdateViewController ()

@end

@implementation UpdateViewController {
    NSArray *prio;
    NSMutableDictionary *dict;
    NSDate *now;
    NSDate *nowCreated;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict = [NSMutableDictionary new];
   
    now = [NSDate new];
    nowCreated = [NSDate new];

    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveUpdateBtnTapped)];
    
    [self.navigationItem setRightBarButtonItem:saveBtn];

    prio = @[@"High",@"Medium",@"Low"];
    self.prioPickerView.dataSource = self;
    self.prioPickerView.delegate = self;
    
    _titleTextField.text = [_editDict objectForKey:@"title"];
    _detailTextField.text = [_editDict objectForKey:@"detail"];
    
    int index = 0;
    int priorityy = 0;
    for (NSString* priority in prio) {
        if ([priority  isEqual: [_editDict objectForKey:@"prio"]]) {
            priorityy = index;
        }
        index ++;
    }
    [_prioPickerView selectRow:priorityy inComponent:0 animated:TRUE];

    [_datePickerView setDate: [_editDict objectForKey:@"date"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    self.view.backgroundColor = [UIColor systemGray4Color];
    
    prio = @[@"High",@"Medium",@"Low"];
    self.prioPickerView.dataSource = self;
    self.prioPickerView.delegate = self;
    
    _titleTextField.text = [_editDict objectForKey:@"title"];
    _detailTextField.text = [_editDict objectForKey:@"detail"];
    
    int index = 0;
    int priorityy = 0;
    for (NSString* priority in prio) {
        if ([priority  isEqual: [_editDict objectForKey:@"prio"]]) {
            priorityy = index;
        }
        index ++;
    }
    [_prioPickerView selectRow:priorityy inComponent:0 animated:TRUE];

    [_datePickerView setDate: [_editDict objectForKey:@"date"]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return prio.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return prio[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _prioTxt = prio[row];
}

-(void) saveUpdateBtnTapped {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Updated!" message:@"Do you want to save the updated ToDo" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion: nil];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        Model *model =[Model new];
        model.name = self->_titleTextField.text;
        model.detail = self->_detailTextField.text;
        
        if (self->_prioTxt == nil) {
            model.priority = [self->_editDict objectForKey:@"prio"];
        }else {
            model.priority = self->_prioTxt;
        }
        
        model.date = self->_datePickerView.date;
        model.dateCreated = self->nowCreated;
        
        [self->dict setObject:model.name forKey:@"title"];
        [self->dict setObject:model.detail forKey:@"detail"];
        [self->dict setObject:model.priority forKey:@"prio"];
        [self->dict setObject:model.date forKey:@"date"];
        [self->dict setObject:model.dateCreated forKey:@"dateCreated"];
        
        [self->_P updateMehodDic:self->dict :self->_index.row :self->_indexSearch];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:cancel];
    [alert addAction: ok];
}

@end
