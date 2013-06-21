//
//  kkFourthViewController.m
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "kkFourthViewController.h"

@interface kkFourthViewController ()

@end

@implementation kkFourthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.title = NSLocalizedString(@"我的优惠", @"我的优惠");
		self.tabBarItem.image = [UIImage imageNamed:@"4.png"];
		    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	self.tabBarController.title = @"我的优惠";
	self.tabBarController.navigationController.title = @"我的优惠";

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
