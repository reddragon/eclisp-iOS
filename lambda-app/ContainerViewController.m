//
//  ContainerViewController.m
//  lambda
//
//  Created by Gaurav Menghani on 10/18/15.
//  Copyright © 2015 Gaurav Menghani. All rights reserved.
//

#import "ContainerViewController.h"
#import "MainViewController.h"
#import "HamburgerViewController.h"

@interface ContainerViewController ()
@property (strong, nonatomic) HamburgerViewController *hamburgerVC;
@property (strong, nonatomic) MainViewController* mainVC;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *sideView;
@property (strong, nonatomic) IBOutlet UIView *rightView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sideViewLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sideViewWidth;

@end

@implementation ContainerViewController

-(id)init {
    self = [super init];
    if (self) {
        self.hamburgerVC = [[HamburgerViewController alloc] init];
        self.mainVC = [[MainViewController alloc] initWithDelegate:self];
    }
    return self;
}

- (void)toggleMenu {
    NSLog(@"Should toggle the menu now., %f", self.sideViewLeading.constant);
    [UIView animateWithDuration:1.0 animations:^{
        if (self.sideViewWidth.constant == 150) {
            self.sideViewWidth.constant = 0;
        } else {
            self.sideViewWidth.constant = 150;
        }
    }];
    /*
    CGRect mainVCFrame = self.mainVC.view.frame;
    CGRect hamburgerVCFrame = self.hamburgerVC.view.frame;
    // NSLog(@"Frame: %f %f", se)
    if (mainVCFrame.origin.x > 0) {
        NSLog(@"It was opened up.");
        mainVCFrame.origin.x = 0;
        hamburgerVCFrame.origin.x = -hamburgerVCFrame.size.width;
    } else {
        NSLog(@"It was closed.");
        hamburgerVCFrame.origin.x = 0;
        mainVCFrame.origin.x = hamburgerVCFrame.size.width;
    }
    [self.mainVC.view endEditing:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.mainVC.view.frame = mainVCFrame;
    }];
    */
}

- (void)viewWillLayoutSubviews {
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.sideView.autoresizesSubviews = YES;
    //self.hamburgerVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.hamburgerVC.view.frame = CGRectMake(0, 0, self.sideView.frame.size.width, self.sideView.frame.size.height);
    
    self.mainVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.sideView addSubview:self.hamburgerVC.view];
    [self.rightView addSubview:self.mainVC.view];
    self.sideView.autoresizesSubviews = YES;
    //NSLog(@"Width %f %f", self.view.bounds.size.width, self.containerView.bounds.size.width);
    
    // [self.sideView addSuself.hamburgerVC.view;
    //self.hamburgerVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        /*
    CGRect frame = self.containerView.bounds;
    
    int widthForHamburgerVC = 150;
    CGRect hamburgerVCFrame = frame;
    hamburgerVCFrame.size.width = widthForHamburgerVC;
    hamburgerVCFrame.origin.x = 0;
    self.hamburgerVC.view.frame = hamburgerVCFrame;
    self.hamburgerVC.view.bounds = hamburgerVCFrame;
    
    
    CGRect mainVCFrame = self.containerView.bounds;
    mainVCFrame.origin.x = widthForHamburgerVC;
    self.mainVC.view.frame = mainVCFrame;
    
    [self.containerView addSubview:self.mainVC.view];
    
    [self.containerView addSubview:self.hamburgerVC.view];
    
    NSLog(@"Width of hvc %f, x: %f", self.hamburgerVC.view.frame.size.width, self.hamburgerVC.view.frame.origin.x);
    */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
