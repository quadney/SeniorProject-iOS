//
//  RegionTableViewCell.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/4/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UIView *regionColorView;

@end
