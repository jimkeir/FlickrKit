//
//  FKFileUploadNetworkOperation.m
//  FlickrKit
//
//  Created by Jean-François Hamel on 16-11-26.
//  Copyright © 2016 DevedUp Ltd. All rights reserved.
//

#import "FKFileUploadNetworkOperation.h"
#import "FlickrKit.h"
#import "FKURLBuilder.h"
#import "FKUtilities.h"
#import "FKUploadRespone.h"
#import "FKDUStreamUtil.h"

@interface FKFileUploadNetworkOperation ()

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, retain) NSString *tempFile;
@property (nonatomic, copy) FKAPIImageUploadCompletion completion;
@property (nonatomic, retain) NSDictionary *args;
@property (nonatomic, assign) NSUInteger fileSize;

@end


@implementation FKFileUploadNetworkOperation

- (instancetype) initWithURL:(NSURL *)URL mimeType:(NSString *)mimeType arguments:(NSDictionary *)args completion:(FKAPIImageUploadCompletion)completion {

    self = [super initWithImage:nil arguments:nil completion:completion];
    if (self) {
        self.URL = URL;
        self.mimeType = mimeType;
        self.args = args;
        self.completion = completion;
    }
    return self;
}

- (NSMutableURLRequest *) createRequest:(NSError **)error {
    // Setup args
    NSMutableDictionary *newArgs = self.args ? [NSMutableDictionary dictionaryWithDictionary:self.args] : [NSMutableDictionary dictionary];
    newArgs[@"format"] = @"json";
    
    // Build a URL to the upload service
    FKURLBuilder *urlBuilder = [[FKURLBuilder alloc] init];
    NSDictionary *args = [urlBuilder signedArgsFromParameters:newArgs method:FKHttpMethodPOST url:[NSURL URLWithString:@"https://api.flickr.com/services/upload/"]];
    
    // Form multipart needs a boundary
    NSString *multipartBoundary = FKGenerateUUID();
    
    // File name
    NSString *inFilename = [self.args valueForKey:@"title"];
    if (!inFilename) {
        inFilename = @" "; // Leave space so that the below still uploads a file
    } else {
        inFilename = [inFilename stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    // The multipart opening string
    NSMutableString *multipartOpeningString = [NSMutableString string];
    for (NSString *key in args.allKeys) {
        [multipartOpeningString appendFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", multipartBoundary, key, [args valueForKey:key]];
    }
    [multipartOpeningString appendFormat:@"--%@\r\nContent-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n", multipartBoundary, inFilename];
    [multipartOpeningString appendFormat:@"Content-Type: %@\r\n\r\n", self.mimeType];
    
    // The multipart closing string
    NSMutableString *multipartClosingString = [NSMutableString string];
    [multipartClosingString appendFormat:@"\r\n--%@--", multipartBoundary];
    
    // The temp file to write this multipart to
    NSString *tempFileName = [NSTemporaryDirectory() stringByAppendingFormat:@"%@.%@", @"FKFlickrTempFile", FKGenerateUUID()];
    self.tempFile = tempFileName;
    
    // Output stream is the file...
    NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:tempFileName append:NO];
    [outputStream open];
    
    if (self.URL) {
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:self.URL.path];
        NSInputStream *inImageStream = [[NSInputStream alloc] initWithData:fileData];
        [FKDUStreamUtil writeMultipartStartString:multipartOpeningString imageStream:inImageStream toOutputStream:outputStream closingString:multipartClosingString];
    }
    else {
        return nil;
    }
    
    // Get the file size
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:tempFileName error:error];
    NSNumber *fileSize = nil;
    if (fileInfo) {
        fileSize = fileInfo[NSFileSize];
        self.fileSize = fileSize.integerValue;
    } else {
        //we have the error populated
        return nil;
    }
    
    // Now the input stream for the request is the file just created
    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:tempFileName];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.flickr.com/services/upload/"]];
    request.HTTPMethod = @"POST";
    request.HTTPBodyStream = inputStream;
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", multipartBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:fileSize.stringValue forHTTPHeaderField:@"Content-Length"];
    
    return request;
}


@end
