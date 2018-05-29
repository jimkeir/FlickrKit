//
//  FKReplaceFileNetworkOperation.h
//  FlickrKit
//
//  Created by Jean-François Hamel on 16-11-27.
//  Copyright © 2016 DevedUp Ltd. All rights reserved.
//

#import "FKImageUploadNetworkOperation.h"

@interface FKReplaceFileNetworkOperation : FKImageUploadNetworkOperation

- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithImage:(DUImage *)image arguments:(NSDictionary *)args completion:(FKAPIImageUploadCompletion)completion NS_UNAVAILABLE;

- (instancetype)initWithAssetURL:(NSURL *)assetURL arguments:(NSDictionary *)args completion:(FKAPIImageUploadCompletion)completion NS_UNAVAILABLE;

- (instancetype) initWithURL:(NSURL *)URL mimeType:(NSString *)mimeType flickrPhotoId:(NSString *)flickrPhotoId completion:(FKAPIImageUploadCompletion)completion NS_DESIGNATED_INITIALIZER;

@end
