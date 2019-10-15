//
//  PhotosCollectionViewCell.h
//  PhotosDemo
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoModel;
NS_ASSUME_NONNULL_BEGIN

@interface PhotosCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PhotoModel *model;

@end

NS_ASSUME_NONNULL_END
