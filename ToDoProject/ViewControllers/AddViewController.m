//
//  AddViewController.m
//  ToDoProject
//
//  Created by Mahmoud Morsy on 25/02/2021.
//

#import "AddViewController.h"
#import "Model.h"
#import "AllToDoViewController.h"


@interface AddViewController ()

@end

@implementation AddViewController {
    
    NSArray *prio;
    NSMutableDictionary *dict;
    NSDate *now;
    NSDate *nowCreated;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dict = [NSMutableDictionary new];
   
    now = [NSDate new];
    nowCreated = [NSDate new];

    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnTapped)];
    
    [self.navigationItem setRightBarButtonItem:saveBtn];

    prio = @[@"High",@"Medium",@"Low"];
    self.prioPickerView.dataSource = self;
    self.prioPickerView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:TRUE];
    self.view.backgroundColor = [UIColor systemGray4Color];
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

- (void)saveBtnTapped {
    
    Model *model =[Model new];
    model.name = _nameTextField.text;
    model.detail = _detailTextField.text;
    if (_prioTxt == nil) {
        model.priority = prio[0];
    }else {
        model.priority = _prioTxt;
    }
    
    
    
    model.date = _datePicker.date;
    model.dateCreated = nowCreated;
    model.isReminded = @"NO";

    [dict setObject:model.name forKey:@"title"];
    [dict setObject:model.detail forKey:@"detail"];
    [dict setObject:model.priority forKey:@"prio"];
    [dict setObject:model.date forKey:@"date"];
    [dict setObject:model.dateCreated forKey:@"dateCreated"];
    [dict setObject:model.isReminded forKey:@"isReminded"];

    
    [_P saveMehodDic:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
