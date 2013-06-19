//
//  kkThirdViewController.m
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "kkThirdViewController.h"

@interface kkThirdViewController ()

@end

@implementation kkThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.title = NSLocalizedString(@"周边优惠", @"周边优惠");
		self.tabBarItem.image = [UIImage imageNamed:@"3.png"];
		self.tabBarController.navigationController.title = @"周边优惠";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.tabBarItem.title = @"周边优惠";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
