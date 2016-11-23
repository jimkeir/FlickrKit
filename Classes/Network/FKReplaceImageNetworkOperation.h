//
//  FKReplaceImageNetworkOperation.h
//  FlickrKit
//
//  Created by Jean-François Hamel on 16-11-20.
//  Copyright © 2016 DevedUp Ltd. All rights reserved.
//

#import "FKImageUploadNetworkOperation.h"

@interface FKReplaceImageNetworkOperation : FKImageUploadNetworkOperation

- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithImage:(DUImage *)image arguments:(NSDictionary *)args completion:(FKAPIImageUploadCompletion)completion NS_UNAVAILABLE;

- (instancetype) initWithImage:(DUImage *)image flickrPhotoId:(NSString *)flickrPhotoId completion:(FKAPIImageUploadCompletion)completion NS_DESIGNATED_INITIALIZER;

#if TARGET_OS_IOS
//*** NOT TESTED
- (instancetype) initWithAssetURL:(NSURL *)assetURL arguments:(NSDictionary *)args completion:(FKAPIImageUploadCompletion)completion NS_UNAVAILABLE;

- (instancetype) initWithAssetURL:(NSURL *)assetURL flickrPhotoId:(NSString *)flickrPhotoId completion:(FKAPIImageUploadCompletion)completion NS_DESIGNATED_INITIALIZER;
#endif

@end
