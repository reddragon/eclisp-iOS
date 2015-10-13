//
//  MainViewController.m
//  eclisp-app
//
//  Created by Gaurav Menghani on 8/30/15.
//  Copyright (c) 2015 Gaurav Menghani. All rights reserved.
//

#import "MainViewController.h"

#import "lang/Lang.h"

#import "KeyboardHelperView.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UITextView *contentScreen;
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomPaddingConstraint;
@property CGFloat initialPaddingConstant;
@property NSOperationQueue* evalQueue;
@property GoLangLangEnv* env;
@end

@implementation MainViewController

- (id)init {
    self = [super init];
    self.env = GoLangNewEnv();
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification*) notification {
    NSLog(@"KeyboardWillShow");
    [self adjustViewForKeyboard:notification];
}

- (void)keyboardWillHide:(NSNotification*) notification {
    NSLog(@"KeyboardWillHide");
    [self adjustViewForKeyboard:notification];
}

- (void)adjustViewForKeyboard:(NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomPaddingConstraint.constant = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(rect) + self.initialPaddingConstant;

    // double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.contentScreen.layer.cornerRadius = 5;
    self.contentScreen.layer.masksToBounds = YES;
    self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.initialPaddingConstant = self.bottomPaddingConstraint.constant;
    
    self.inputField.inputAccessoryView = [[KeyboardHelperView alloc] init];
    self.inputField.delegate = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
    [self.inputField becomeFirstResponder];
    
    self.contentScreen.text = @"> ";
    self.contentScreen.userInteractionEnabled = YES;
    self.contentScreen.scrollEnabled = YES;
    self.contentScreen.editable = NO;
    self.contentScreen.layoutManager.allowsNonContiguousLayout = NO;
    
    self.evalQueue = [[NSOperationQueue alloc] init];
}

- (NSString*)evaluate:(NSString*)expr {
    NSString* result;
    
    GoLangEvalResult *evalResult = GoLangEval(expr, self.env);
    if (evalResult.ErrStr.length > 0) {
        result = evalResult.ErrStr;
    } else {
        result = evalResult.ValStr;
    }
    return result;
}


-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"Began editing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"Ended editing");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"Should edit: %@, range loc: %lu, len: %lu.", string, (unsigned long)range.location, (unsigned long)range.length);
    NSLog(@"Keyboard type: %ld", (long)textField.keyboardType);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField resignFirstResponder];
    [textField becomeFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Input: %@", self.inputField.text);
    
    NSString *result = [self evaluate:self.inputField.text];
    self.contentScreen.text = [self.contentScreen.text stringByAppendingString:[NSString stringWithFormat:@"%@\n%@\n\n> ", self.inputField.text, result]];
    self.inputField.text = @"";
    [self scrollTextViewToBottom:self.contentScreen];

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
