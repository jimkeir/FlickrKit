//
//  FKFileUploadNetworkOperation.h
//  FlickrKit
//
//  Created by Jean-François Hamel on 16-11-26.
//  Copyright © 2016 DevedUp Ltd. All rights reserved.
//

#import "FKImageUploadNetworkOperation.h"

@interface FKFileUploadNetworkOperation : FKImageUploadNetworkOperation

- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithImage:(DUImage *)image arguments:(NSDictionary *)args completion:(FKAPIImageUploadCompletion)completion NS_UNAVAILABLE;

- (instancetype) initWithURL:(NSURL *)URL mimeType:(NSString *)mimeType arguments:(NSDictionary *)args completion:(FKAPIImageUploadCompletion)completion NS_DESIGNATED_INITIALIZER;

@end
