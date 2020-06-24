//
//  MovieCell.h
//  Flix
//
//  Created by Fernando Arturo Perez on 6/24/20.
//  Copyright © 2020 Fernando Arturo Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@end

NS_ASSUME_NONNULL_END
