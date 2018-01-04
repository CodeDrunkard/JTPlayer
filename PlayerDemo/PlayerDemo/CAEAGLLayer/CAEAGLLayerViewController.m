//
//  CAEAGLLayerViewController.m
//  PlayerDemo
//
//  Created by JT Ma on 15/12/2017.
//  Copyright © 2017 JT (ma.jiangtao.86@gmail.com). All rights reserved.
//

#import "CAEAGLLayerViewController.h"
#import "APLEAGLView.h"
#import <JTPlayer/JTPlayer.h>

@interface CAEAGLLayerViewController () <PlayerDelegate>

@property (weak, nonatomic) IBOutlet APLEAGLView *playerPreview;
@property (nonatomic, strong) Player *player;

@end

@implementation CAEAGLLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.player = [[Player alloc] init];
    self.player.delegate = self;
    self.player.outputFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
    self.player.loop = YES;
    
    NSString *videoAddress = @"https://images.apple.com/media/cn/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-cn-20170912_1280x720h.mp4";
    NSURL *url = [NSURL URLWithString:videoAddress];
    [self.player play:url];
}

#pragma mark <PlayerItemOutputPixelBufferDelegate>

- (void)playerReadyToPlay:(AVPlayer *)player {
    self.playerPreview.chromaThreshold = 1;
    self.playerPreview.lumaThreshold = 1;
    self.playerPreview.preferredRotation = -1 * atan2(self.player.preferredTransform.b, self.player.preferredTransform.a);
    self.playerPreview.presentationRect = player.currentItem.presentationSize;
    [self.playerPreview setupGL];
}

- (void)player:(AVPlayer *)player didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    [self.playerPreview displayPixelBuffer:pixelBuffer];
}

@end