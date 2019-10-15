//
//  PhotosViewController.m
//  PhotosDemo
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "PhotosViewController.h"
#import "CustomFlowLayout.h"
#import "PhotosCollectionViewCell.h"
#import "AddImageTools.h"
#import "PhotoModel.h"
#import "PhotoGroupView.h"

@interface PhotosViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CustomFlowLayoutDelegate, PhotoGroupViewDelegate>

@property (nonatomic, strong) NSMutableArray <PhotoModel *>*photosArr;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) PhotoModel *addModel;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
    NSLog(@"self view : %@", NSStringFromCGRect(self.view.frame));
    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CustomFlowLayout *flowLayout = [[CustomFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PhotosCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(PhotosCollectionViewCell.class)];
        
    }
    return _collectionView;
}

- (PhotoModel *)addModel
{
    if (!_addModel) {
        _addModel = [[PhotoModel alloc] init];
        [_addModel setupImage:[UIImage imageNamed:@"addphotos"]];
    }
    return _addModel;
}

- (NSMutableArray<PhotoModel *> *)photosArr
{
    if (!_photosArr) {
        _photosArr = [NSMutableArray array];
    }
    return _photosArr;
}

#pragma mark - UICollectionViewDelegate -

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CustomFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath
{
    return width;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CustomFlowLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;
{
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CustomFlowLayout*)collectionViewLayout rowMarginForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(CustomFlowLayout*)collectionViewLayout columnMarginForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(CustomFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(PhotosCollectionViewCell.class) forIndexPath:indexPath];
    
    if (self.photosArr.count > indexPath.item) {
        cell.model = self.photosArr[indexPath.item];
    } else {
        cell.model = self.addModel;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.photosArr.count > indexPath.item) {
        NSMutableArray *mutArr = [NSMutableArray array];
        [self.photosArr enumerateObjectsUsingBlock:^(PhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PhotoGroupItem *item = [[PhotoGroupItem alloc] init];
            item.largeImageURL = obj.imageURL;
            item.index = idx;
            [mutArr addObject:item];
        }];
        PhotoGroupView *view = [[PhotoGroupView alloc] initWithGroupItems: mutArr];
        view.delegate = self;
        [view hiddenPageControl:YES];
        [view presentFromCurItem:indexPath.item toContainer:[UIApplication sharedApplication].keyWindow animated:YES ompletion:^{
            
        }];
    } else {
        __weak typeof(self) weakself = self;
        [AddImageTools addImagePickerWithTargetViewController:self completeHandle:^(UIImage * _Nonnull image) {
            [weakself addImage:image];
        }];
    }
    
}

- (void)addImage:(UIImage *)image
{
    PhotoModel *model = [[PhotoModel alloc] init];
    [model setupImage:image];
    [self.photosArr addObject:model];
    [self.collectionView reloadData];
}

- (UIView *)getCurrentThumbViewWithPage:(NSInteger)page
{
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
}

- (UIView *)photoGroupView:(PhotoGroupView *)photoGroupView getThumbViewWithPage:(NSInteger)page
{
    return [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
}

- (UIImage *)photoGroupView:(PhotoGroupView *)photoGroupView getImageWithPage:(NSInteger)page
{
    PhotosCollectionViewCell *cell = (PhotosCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
    return cell.imageView.image;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
