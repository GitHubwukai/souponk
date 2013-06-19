//
//  kkSecondViewController.h
//  souponK
//
//  Created by wukai on 13-6-15.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "FPPopoverController.h"
#import "HJManagedImageV.h"
#import "HJObjManager.h"

@interface kkSecondViewController : UIViewController
<ASIHTTPRequestDelegate, FPPopoverControllerDelegate,
UITableViewDelegate, UITableViewDataSource>
{
	NSArray *brandArray;
	NSArray *categoryArray;
	NSArray *districtArray;
	//保存搜索的shuju
	NSArray *searchArray;
	FPPopoverController *popover;
	//导航栏右侧按钮
	UIBarButtonItem *rightItem;
	
	HJObjManager *objManager;
}

@property (retain, nonatomic) IBOutlet UIButton *classesButton;
@property (retain, nonatomic) IBOutlet UIButton *brandButton;
@property (retain, nonatomic) IBOutlet UIButton *businessButton;
@property (nonatomic, strong) UITableView *searchTableView;

- (IBAction)click:(id)sender;
@end
