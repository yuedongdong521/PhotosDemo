//
//  AddImageTools.m
//  PhotosDemo
//
//  Created by ydd on 2019/7/17.
//  Copyright © 2019 ydd. All rights reserved.
//

#import "AddImageTools.h"
#import "TZImagePickerController.h"
#import "TOCropViewController.h"


static AddImageTools *_addImageTools;

@interface AddImageTools ()<TZImagePickerControllerDelegate, TOCropViewControllerDelegate>

@property (nonatomic, copy) void(^completeHandle)(UIImage *image);

@end


@implementation AddImageTools

+ (instancetype)shareTools
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _addImageTools = [[AddImageTools alloc] init];
    });
    return _addImageTools;
}

+(void)addImagePickerWithTargetViewController:(UIViewController *)targeVC completeHandle:(void(^)(UIImage *image))completeHandle
{
    
    [AddImageTools shareTools].completeHandle = completeHandle;
    [[AddImageTools shareTools] openImagePickerWithTargetViewController:targeVC];
}


- (void)openImagePickerWithTargetViewController:(UIViewController *)targeVC
{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVC.allowPickingGif = NO;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.preferredLanguage = @"zh-Hans";
    [targeVC presentViewController:imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    
    if (self.completeHandle) {
        self.completeHandle(photos.firstObject);
    }
}


- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    
}






@end
