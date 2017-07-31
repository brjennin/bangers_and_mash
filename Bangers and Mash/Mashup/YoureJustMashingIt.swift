import Foundation
import AVFoundation
import CoreMedia
import CoreGraphics
import UIKit

protocol YoureJustMashingItProtocol {
    func combine(song: Song, videoUrl: URL, completion: @escaping (URL) -> ())
    func randomMash(song: Song, videoUrls: [URL], completion: @escaping (URL) -> ())
}

class YoureJustMashingIt: YoureJustMashingItProtocol {
    var videoArchiver: VideoArchiverProtocol = VideoArchiver()
    var trackStar: TrackStarProtocol = TrackStar()
    var timeSplitter: TimeSplitterProtocol = TimeSplitter()
    var randomPicker: RandomPickerProtocol = RandomPicker()

    func combine(song: Song, videoUrl: URL, completion: @escaping (URL) -> ()) {
        buildComposition(song: song, videoUrls: [videoUrl], chunks: 1, completion: completion)
    }

    func randomMash(song: Song, videoUrls: [URL], completion: @escaping (URL) -> ()) {
        buildComposition(song: song, videoUrls: videoUrls, chunks: 10, completion: completion)
    }

    private func buildComposition(song: Song, videoUrls: [URL], chunks: Int, completion: @escaping (URL) -> ()) {
        let composition = AVMutableComposition()
        let compositionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)

        let videoComposition = AVMutableVideoComposition()

        let videoDuration = CMTime(seconds: song.recordDuration, preferredTimescale: 1)
        let timeRange = CMTimeRange(start: kCMTimeZero, duration: videoDuration)

        let songAsset = AVAsset(url: song.url)
        let songTrack = trackStar.audioTrack(from: songAsset)
        let songRecordStart = CMTime(seconds: song.recordingStartTime, preferredTimescale: 1)
        let songRange = CMTimeRange(start: songRecordStart, duration: videoDuration)
        trackStar.add(track: songTrack, to: compositionAudioTrack, for: songRange, at: timeRange.start)

        let videoAssets = videoUrls.map { videoUrl in return AVAsset(url: videoUrl) }
        let videoTracks = videoAssets.map { asset in return self.trackStar.videoTrack(from: asset) }
        let chunks = timeSplitter.timeChunks(duration: videoDuration, chunks: chunks)

        let videoSize: CGSize!
        let firstVideoSize = videoTracks.first!.naturalSize
        if firstVideoSize.width > firstVideoSize.height {
            videoSize = CGSize(width: firstVideoSize.height, height: firstVideoSize.width)
        } else {
            videoSize = firstVideoSize
        }
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = videoTracks.first!.minFrameDuration

        var videoInstructions = [AVMutableVideoCompositionInstruction]()
        for chunk in chunks {
            let randomVideo = randomPicker.pick(from: videoTracks)
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.backgroundColor = UIColor.red.cgColor
            instruction.timeRange = chunk
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: randomVideo)
            layerInstruction.setTransform(randomVideo.preferredTransform, at: kCMTimeZero)
//            let crop = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
//            layerInstruction.setCropRectangle(crop, at: kCMTimeZero)

            instruction.layerInstructions = [layerInstruction]
            videoInstructions.append(instruction)

            trackStar.add(track: randomVideo, to: compositionVideoTrack, for: chunk, at: chunk.start)
        }

        videoComposition.instructions = videoInstructions

        sleep(3)
        videoArchiver.exportTemp(asset: composition, videoComposition: videoComposition, completion: completion)
    }



    // Create one layer instruction.  We have one video track, and there should be one layer instruction per video track.
//    AVMutableVideoCompositionLayerInstruction *videoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];

//    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

//    NSURL *assetUrl = (NSURL *)obj;
//    AVAsset *asset = [AVAsset assetWithURL:assetUrl];

//    CMTime cliptime = CMTimeConvertScale(asset.duration, commontimescale, kCMTimeRoundingMethod_QuickTime);

//    NSLog(@"%s: Number of tracks: %lu", __PRETTY_FUNCTION__, (unsigned long)[[asset tracks] count]);
//    AVAssetTrack *assetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
//    CGSize naturalSize = assetTrack.naturalSize;

//    NSError *error;
    //insert the video from the assetTrack into the composition track
//    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, cliptime)
//    ofTrack:assetTrack
//    atTime:time
//    error:&error];
//    if (error) {
//    NSLog(@"%s: Error - %@", __PRETTY_FUNCTION__, error.debugDescription);
//    }


//    CGAffineTransform transform = assetTrack.preferredTransform;

    //set the layer to have this videos transform at the time that this video starts
//    if (<* the video is an intermediate video  - has the wrong orientation*>) {
    //these videos have the identity transform, yet they are upside down.
    //we need to rotate them by M_PI radians (180 degrees) and shift the video back into place

//    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(M_PI);
//    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(naturalSize.width, naturalSize.height);
//    [videoLayerInstruction setTransform:CGAffineTransformConcat(rotateTransform, translateTransform) atTime:time];

//    } else {
//    [videoLayerInstruction setTransform:transform atTime:time];
//    }

    // time increment variables
//    time = CMTimeAdd(time, cliptime);

//    }];

    // the main instruction set - this is wrapping the time
//    AVMutableVideoCompositionInstruction *videoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    videoCompositionInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,mutableComposition.duration); //make the instruction last for the entire composition
//    videoCompositionInstruction.layerInstructions = @[videoLayerInstruction];
//    [instructions addObject:videoCompositionInstruction];
//    mutableVideoComposition.instructions = instructions;

    // set the frame rate to 9fps
//    mutableVideoComposition.frameDuration = CMTimeMake(1, 12);

    //set the rendersize for the video we're about to write
//    mutableVideoComposition.renderSize = CGSizeMake(1280,720);

//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths firstObject];
//    int number = arc4random_uniform(10000);
//    self.outputFile = [documentsDirectory stringByAppendingFormat:@"/export_%i.mov",number];

    //let the rendersize of the video composition dictate size.  use quality preset here
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mutableComposition
//    presetName:AVAssetExportPresetHighestQuality];
//
//    exporter.outputURL = [NSURL fileURLWithPath:self.outputFile];
//    //Set the output file type
//    exporter.outputFileType = AVFileTypeQuickTimeMovie;
//    exporter.shouldOptimizeForNetworkUse = YES;
//    exporter.videoComposition = mutableVideoComposition;
//
//    dispatch_group_t group = dispatch_group_create();
//
//    dispatch_group_enter(group);
//
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//    dispatch_group_leave(group);
//
//    }];

//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//
//    // get the size of the file
//    unsigned  long long size= ([[[NSFileManager defaultManager] attributesOfItemAtPath:self.outputFile error:nil] fileSize]);
//    NSString *filesize = [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
//    NSString *thereturn = [NSString stringWithFormat:@"%@: %@", self.outputFile, filesize];
//
//    NSLog(@"Export File (Final) - %@", self.outputFile);
//    completion(thereturn);
//
//    });
//    }



























//    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition]; videoComposition.frameDuration = CMTimeMake(1,30); videoComposition.renderScale = 1.0;

//    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];

//    for (int i = 0; i<self.videoPathArray.count; i++) {
//
//    AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[videoPathArray objectAtIndex:i]] options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey]];
//    AVAssetTrack *sourceVideoTrack = [[sourceAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//
//    CGSize temp = CGSizeApplyAffineTransform(sourceVideoTrack.naturalSize, sourceVideoTrack.preferredTransform);
//    CGSize size = CGSizeMake(fabsf(temp.width), fabsf(temp.height));
//    CGAffineTransform transform = sourceVideoTrack.preferredTransform;
//
//    videoComposition.renderSize = sourceVideoTrack.naturalSize;
//    if (size.width > size.height) {
//    [layerInstruction setTransform:transform atTime:CMTimeMakeWithSeconds(time, 30)];
//    } else {
//
//    float s = size.width/size.height;
//
//    CGAffineTransform new = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(s,s));
//
//    float x = (size.height - size.width*s)/2;
//
//    CGAffineTransform newer = CGAffineTransformConcat(new, CGAffineTransformMakeTranslation(x, 0));
//
//    [layerInstruction setTransform:newer atTime:CMTimeMakeWithSeconds(time, 30)];
//    }

//    ok = [compositionVideoTrack insertTimeRange:sourceVideoTrack.timeRange ofTrack:sourceVideoTrack atTime:[composition duration] error:&error];
//
//    if (!ok) {
//    // Deal with the error.
//    NSLog(@"something went wrong");
//    }
//
//    NSLog(@"\n source asset duration is %f \n source vid track timerange is %f %f \n composition duration is %f \n composition vid track time range is %f %f",CMTimeGetSeconds([sourceAsset duration]), CMTimeGetSeconds(sourceVideoTrack.timeRange.start),CMTimeGetSeconds(sourceVideoTrack.timeRange.duration),CMTimeGetSeconds([composition duration]), CMTimeGetSeconds(compositionVideoTrack.timeRange.start),CMTimeGetSeconds(compositionVideoTrack.timeRange.duration));
//
//    time += CMTimeGetSeconds(sourceVideoTrack.timeRange.duration);
//    }

//    instruction.layerInstructions = [NSArray arrayWithObject:layerInstruction]; instruction.timeRange = compositionVideoTrack.timeRange;
//    
//    videoComposition.instructions = [NSArray arrayWithObject:instruction];
}
