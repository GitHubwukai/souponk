//
//  SPCell.h
//  souponK
//
//  Created by wukai on 13-6-17.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPHotData.h"

@interface SPCell : UITableViewCell
{
	UILabel *nameLabel;
	UITextView *contentTextView;
	UILabel *downNumLabel;
	UIImageView *downImage;
}

- (void)setHotData:(SPHotData *)data;

@end
