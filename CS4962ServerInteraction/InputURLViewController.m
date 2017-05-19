//
//  InputURLViewController.m
//  CS4962ServerInteraction
//
//  Created by WENGzhang on 17/05/2017.
//  Copyright © 2017 WENGzhang. All rights reserved.
//

#import "InputURLViewController.h"
#import "ViewController.h"

@interface InputURLViewController ()
@property(strong,nonatomic) UILabel *label;
@property(strong,nonatomic) UITextField *textField;
@property(strong,nonatomic) UIButton *button;
@end

@implementation InputURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [_button addTarget: self action: @selector(handleSearch) forControlEvents: UIControlEventTouchUpInside];
}

- (void)setUpUI {
    //initiate views
    [self.view setBackgroundColor: [UIColor whiteColor]];
    _label = [UILabel new];
    [_label setText: @"Input An https URL for Image Fetch Engin"];
    [_label setFont: [UIFont boldSystemFontOfSize: 16]];
    [_label setTextAlignment: NSTextAlignmentCenter];
    
    _textField = [UITextField new];
    [_textField setPlaceholder: @"Input URL Here"];
    [_textField setTextAlignment: NSTextAlignmentCenter];
    
    _button = [UIButton buttonWithType: UIButtonTypeSystem];
    [_button setTitle: @"Enter" forState: UIControlStateNormal];
    [_button.layer setBorderWidth: 2];
    [_button.layer setCornerRadius:5];
    [_button.layer setMasksToBounds: YES];
    [_button.layer setBorderColor: [UIColor.cyanColor CGColor]];
    
    NSArray *viewArray = [NSArray arrayWithObjects:
                          _label,
                          _textField,
                          _button
                          , nil];
    [self.view addSubview:_label];
    [self.view addSubview:_textField];
    [self.view addSubview:_button];

    //don't use @NO ! Only nil will be interpreted as NO in your method with bool argument
    [viewArray makeObjectsPerformSelector:@selector(setTranslatesAutoresizingMaskIntoConstraints:) withObject: nil];
    
    //set constraints
    NSArray *constraintsArray = [NSArray arrayWithObjects:
                                 //label
                                 [_label.topAnchor constraintEqualToAnchor: [self.topLayoutGuide bottomAnchor] constant: 20],
                                 [_label.centerXAnchor constraintEqualToAnchor: [self.view centerXAnchor] constant: 0],
                                 [_label.heightAnchor constraintEqualToConstant: 50],
                                 [_label.widthAnchor constraintEqualToConstant: 400],
                                 //textfield
                                 [_textField.topAnchor constraintEqualToAnchor: [_label bottomAnchor] constant: 20],
                                 [_textField.centerXAnchor constraintEqualToAnchor: [self.view centerXAnchor] constant: 0],
                                 [_textField.heightAnchor constraintEqualToConstant: 50],
                                 [_textField.widthAnchor constraintEqualToConstant: 200],
                                 //_button
                                 [_button.topAnchor constraintEqualToAnchor: [_textField bottomAnchor] constant: 20],
                                 [_button.centerXAnchor constraintEqualToAnchor: [self.view centerXAnchor] constant: 0],
                                 [_button.heightAnchor constraintEqualToConstant: 30],
                                 [_button.widthAnchor constraintEqualToConstant: 60],
                                 nil];
    
    [NSLayoutConstraint activateConstraints: constraintsArray];
}

- (void)handleSearch {
    ViewController* vc = [ViewController new];
    [vc setUrlString: _textField.text];
    [self.navigationController pushViewController: vc animated: YES];
}
@end
