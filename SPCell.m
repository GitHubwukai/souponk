//
//  SPCell.m
//  souponK
//
//  Created by wukai on 13-6-17.
//  Copyright (c) 2013年 wukai. All rights reserved.
//

#import "SPCell.h"


@implementation SPCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:contentTextView];
		[contentTextView release];
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:nameLabel];
		[nameLabel release];
		
		downNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:downNumLabel];
		[downNumLabel release];
		
		downImage = [[UIImageView alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:downImage];
		[downImage release];
	}
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	float inset = 3.0;
	CGRect bounds = [[self contentView] bounds];
	
	CGRect nameLabelFrame = CGRectMake(72, inset, 230, 14);
	[nameLabel setFrame:nameLabelFrame];
	
	CGRect contentTextFrame = CGRectMake(65, inset + 8, 230, 36);
	[contentTextView setFrame:contentTextFrame];
	
	CGRect downNumLabelFrame = CGRectMake(90, bounds.size.height - 13, 230, 12);
	[downNumLabel setFrame:downNumLabelFrame];
	
	CGRect imageFrame = CGRectMake(75, bounds.size.height-14, 12, 12);
	[downImage setFrame:imageFrame];
}

- (void)setHotData:(SPHotData *)data
{
	nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
	nameLabel.textColor = [UIColor redColor];
	[nameLabel setText:data.s_caption];
	
	contentTextView.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
	[contentTextView setEditable:NO];
	[contentTextView setUserInteractionEnabled:NO];
	contentTextView.textColor = [UIColor darkGrayColor];
	[contentTextView setText:data.s_description];
	
	downNumLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
	downNumLabel.textColor = [UIColor darkGrayColor];
	[downNumLabel setText:data.s_popularity];
	
	[downImage setImage:[UIImage imageNamed:@"listview_times_icon.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
