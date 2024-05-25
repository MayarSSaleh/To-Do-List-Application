//
//  CustomCellTwoPhotoTableViewCell.m
//  Tasks IOS objective-c
//
//  Created by Mayar on 22/04/2024.
//
// CustomCellTwoPhotoTableViewCell.m

#import "CustomCellTwoPhotoTableViewCell.h"

@implementation CustomCellTwoPhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialize and configure image views
        _firestImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _firestImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_firestImage];
        
        _secondImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _secondImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_secondImage];
        
        // Initialize and configure label
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat cellWidth = self.contentView.bounds.size.width;
    CGFloat cellHeight = self.contentView.bounds.size.height;
                                    // x  y  width  heigth
    _firestImage.frame = CGRectMake(10, -5, 80, cellHeight+ 10);
    _secondImage.frame = CGRectMake(cellWidth - 100, -12, 80, cellHeight +20);
    _title.frame = CGRectMake(100, 5, cellWidth - 100, cellHeight - 5);
    _title.font = [UIFont systemFontOfSize:27];

}

@end
