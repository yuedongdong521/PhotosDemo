//
//  PhotoPreCollectionViewCell.m
//  PhotosDemo
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "PhotoPreCollectionViewCell.h"
#import "PhotoModel.h"

@implementation PhotoPreCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setModel:(PhotoModel *)model
{
    if (![_model.imageURL.absoluteString isEqualToString:model.imageURL.absoluteString]) {
        _model = model;
        [_imageView yy_setImageWithURL:model.imageURL placeholder:[UIImage imageNamed:@"defaultIcon"]];
    }
}




@end
