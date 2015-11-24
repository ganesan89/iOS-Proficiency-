//
//  FeedListCell.m
//  TelstraProficiency
//
//  Created by  on 23/11/15.
//  Copyright (c) 2015 GANESAN. All rights reserved.
//

#import "FeedListCell.h"
#import "TelstraProficiencyConstants.h"

@implementation FeedListCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //Displays Title String from the service
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = titleTextColor;
        [self.contentView addSubview:self.titleLabel];
        
        //Displays Description String from the service
        self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.backgroundColor = [UIColor clearColor];
        self.descriptionLabel.font=[UIFont systemFontOfSize:12];
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.descriptionLabel];
        
        //Displays Image from the service
        self.cellImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:self.cellImageView];
    }
    return self;
}

// For Resizing the subviews in the UItableViewCell
- (void)layoutSubviews {
    [super layoutSubviews];
   
    [self.titleLabel setFrame:CGRectMake(10, 5, screenWidth-(imageSize+10),titleLabelHeight)];
    [self.descriptionLabel setFrame:CGRectMake(10, titleLabelHeight+5, screenWidth-(imageSize+15),self.descriptionLabel.frame.size.height)];
    
    [self.cellImageView setFrame:CGRectMake(screenWidth-(imageSize+10), 10, imageSize, imageSize)];
}
@end
