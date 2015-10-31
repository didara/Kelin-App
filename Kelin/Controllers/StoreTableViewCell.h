//
//  StoreTableViewCell.h
//  Kelin
//
//  Created by Zhanserik on 10/14/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreTableViewCell;

@protocol StoreTableViewCellDelegate <NSObject>

- (void) storeButtonDidPressForCell: (nonnull StoreTableViewCell *) cell;

@end

@interface StoreTableViewCell : UITableViewCell

@property (nonatomic, weak) id<StoreTableViewCellDelegate> delegate;
@property (nonatomic, nonnull) NSString *buttonTitle;
@property (nonatomic, nullable) UIButton *storeButton;

@end
