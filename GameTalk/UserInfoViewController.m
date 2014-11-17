//
//  UserInfoViewController.m
//  GameTalk
//
//  Created by WangLi on 14/11/17.
//  Copyright (c) 2014年 Wang Li. All rights reserved.
//

#import "UserInfoViewController.h"
#import <QBImagePickerController/QBImagePickerController.h>
#import "UIImage+Resize.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "HFImageEditorViewController.h"
#import "DemoImageEditor.h"
@interface UserInfoViewController ()<QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@end

@implementation UserInfoViewController
{
    UIImagePickerController *       _imagePickerController;
    QBImagePickerController *       _QBimagePickController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    _imagePickerController.delegate = nil;
    _QBimagePickController.delegate = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)editDone:(id)sender
{
    
}


-(IBAction)uploadHeadImg:(id)sender
{
    UIActionSheet* tActionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [tActionSheet showInView:self.view];
}

-(void) DoImageEdit:(UIImage*)souceImg
            thumImg:(UIImage*)tImg
{
    DemoImageEditor* tImageEditController =[[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil];
    tImageEditController.checkBounds =YES;
    tImageEditController.rotateEnabled =NO;
    tImageEditController.sourceImage =souceImg;
    [tImageEditController reset:NO];
    tImageEditController.doneCallback = ^(UIImage *image, BOOL canceled){
        if (!canceled) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
            NSLog(@"image size %lu", (unsigned long)[imageData length]);
            AVFile *imageFile = [AVFile fileWithName:@"headimage.png" data:imageData];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                }
            }];
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:tImageEditController animated:YES];
}


#pragma mark-
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
            if([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"打开相机失败"
                                                               message:@"请打开 设置-隐私-相机 来进行设置"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                return;
            }else{
                if (_imagePickerController == nil) {
                    _imagePickerController = [[UIImagePickerController alloc] init];
                    _imagePickerController.delegate = self;
                    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                }
                [self presentViewController:_imagePickerController animated:NO completion:^{
                    
                }];
            }
        }
            break;
        case 1:
        {
            if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"读取相册失败"
                                                               message:@"请打开 设置-隐私-照片 来进行设置"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
            
            if (![QBImagePickerController isAccessible]) {
                NSLog(@"Error: Source is not accessible.");
                return;
            }
            if (_QBimagePickController == nil) {
                _QBimagePickController = [[QBImagePickerController alloc] init];
                _QBimagePickController.delegate = self;
            }

            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_QBimagePickController];
            [self presentViewController:navigationController animated:YES completion:NULL];
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark-
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (image) {
            UIImage *scaledImage = [image resizedImageToFitInSize:CGSizeMake(1080, 1920) scaleIfSmaller:NO];
            [self DoImageEdit:scaledImage thumImg:nil];
        }
    }];
}

#pragma mark-
#pragma mark QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    UIImage* tThumImg = [UIImage imageWithCGImage:[asset thumbnail]];
    UIImage *tFullImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
    [self dismissViewControllerAnimated:YES completion:^{
        [self DoImageEdit:tFullImg thumImg:tThumImg];
    }];
}
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
