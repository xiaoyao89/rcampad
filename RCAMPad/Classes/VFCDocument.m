//
//  VFCDocument.m
//  RCAMPad
//
//  Created by Xiao Yao
//  Copyright (c) 2014 Xcelerate Media Inc. All rights reserved.
//

#import "VFCDocument.h"

#pragma mark - NSUserDefaults

#pragma mark - Private Interface

static NSString *const PreviousDocumentPath = @"com.venturafoods.rcampad.previousDocumentPath";

@interface NSUserDefaults (VFCDocumentAdditions)
- (NSString *)previousDocumentPath;
- (void)setPreviousDocumentPath:(NSString *)path;
@end

#pragma mark - Private Implementation

@implementation NSUserDefaults (VFCDocumentAdditions)

- (NSString *)previousDocumentPath {
    return [self objectForKey:PreviousDocumentPath];
}

- (void)setPreviousDocumentPath:(NSString *)path {
    [self setObject:path forKey:PreviousDocumentPath];
    [self synchronize];
}

@end

#pragma mark - VFCDocument

#pragma mark - Private Interface

// Versions
static NSString *VFCDocumentCurrentVersion = @"1.0";

// Metadata
static NSString *VFCDocumentKeyMetadata = @"metadata";
static NSString *VFCDocumentMetadataKeyIdentifier = @"identifier";
static NSString *VFCDocumentMetadataKeyVersion = @"version";
static NSString *VFCDocumentMetadataKeyTitle = @"title";
static NSString *VFCDocumentMetadataKeyMacroTrend = @"macroTrend";
static NSString *VFCDocumentMetadataKeySegmentChoice = @"segmentChoice";
static NSString *VFCDocumentMetadataKeyState = @"state";
static NSString *VFCDocumentMetadataKeyStep = @"step";

@interface VFCDocument()
@property (nonatomic, strong, readwrite) NSMutableDictionary *metadata;
@property (nonatomic, copy, readwrite) NSString *identifier;
@end

NSString *const VFCNotificationDidCreateDocument = @"VFCNotificationDidCreateDocument";

#pragma mark - Public Implementation

@implementation VFCDocument

#pragma mark Initialization

- (instancetype)initWithFileURL:(NSURL *)url {
    self = [super initWithFileURL:url];
    if (self) {
        [self setMetadata:[NSMutableDictionary dictionary]];
        [[self metadata] setObject:VFCDocumentCurrentVersion forKey:VFCDocumentMetadataKeyVersion];
        [[self metadata] setObject:@"" forKey:VFCDocumentMetadataKeyTitle];
        [self setMacroTrend:@"Millenials"];
        [self setSegmentChoice:@"Fast Casual"];
    }
    return self;
}

#pragma mark Reading / writing
 
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    NSFileWrapper *contentWrapper = (NSFileWrapper *)contents;
    NSDictionary *fileWrappers = [contentWrapper fileWrappers];
    
    // Metadata
    NSFileWrapper *wrapper = [fileWrappers objectForKey:VFCDocumentKeyMetadata];
    NSData *data = [wrapper regularFileContents];
    [[self metadata] addEntriesFromDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    if (![self identifier]) {
        NSString *identifier = [[NSUUID UUID] UUIDString];
        [[self metadata] setObject:identifier forKey:VFCDocumentMetadataKeyIdentifier];
    }
    
    NSLog(@"%@", [self metadata]);
    
    return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    NSFileWrapper *contentWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    
    // Metadata
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self metadata]];
    NSFileWrapper *wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
    [wrapper setPreferredFilename:VFCDocumentKeyMetadata];
    [contentWrapper addFileWrapper:wrapper];
    
    NSLog(@"%@", [self metadata]);
    
    return contentWrapper;
}

#pragma mark Property Overrides

- (NSString *)identifier {
    return [[self metadata] objectForKey:VFCDocumentMetadataKeyIdentifier];
}

- (NSString *)version {
    return [[self metadata] objectForKey:VFCDocumentMetadataKeyVersion];
}

- (NSString *)title {
    return [[self metadata] objectForKey:VFCDocumentMetadataKeyTitle];
}

- (void)setTitle:(NSString *)title {
    [[self metadata] setObject:title forKey:VFCDocumentMetadataKeyTitle];
    [self updateChangeCount:UIDocumentChangeDone];
}

- (NSNumber *)state {
    return [[self metadata] objectForKey:VFCDocumentMetadataKeyState];
}

- (void)setState:(NSNumber *)state {
    [[self metadata] setObject:state forKey:VFCDocumentMetadataKeyState];
    [self updateChangeCount:UIDocumentChangeDone];
}

- (NSNumber *)step {
    return [[self metadata] objectForKey:VFCDocumentMetadataKeyStep];
}

- (void)setStep:(NSNumber *)step {
    [[self metadata] setObject:step forKey:VFCDocumentMetadataKeyStep];
    [self updateChangeCount:UIDocumentChangeDone];
}

- (NSString *)macroTrend {
    return [[self metadata] objectForKey:VFCDocumentMetadataKeyMacroTrend];
}

- (void)setMacroTrend:(NSString *)macroTrend {
    [[self metadata] setObject:macroTrend forKey:VFCDocumentMetadataKeyMacroTrend];
    [self updateChangeCount:UIDocumentChangeDone];
}

- (NSString *)segmentChoice {
    return [[self metadata] objectForKey:VFCDocumentMetadataKeySegmentChoice];
}

- (void)setSegmentChoice:(NSString *)segmentChoice {
    [[self metadata] setObject:segmentChoice forKey:VFCDocumentMetadataKeySegmentChoice];
    [self updateChangeCount:UIDocumentChangeDone];
}

#pragma mark Public

+ (NSString *)extension {
    return @"rcam";
}

+ (VFCDocument *)previousDocument {
    NSString *path = [[NSUserDefaults standardUserDefaults] previousDocumentPath];
    if (path) {
        NSString *docPath = [VFCDocument documentsDirectoryPath];
        docPath = [docPath stringByAppendingPathComponent:path];
        NSURL *URL = [NSURL fileURLWithPath:docPath];
        VFCDocument *doc = [[VFCDocument alloc] initWithFileURL:URL];
        return doc;
    }
    return nil;
}

+ (VFCDocument *)document {
    NSString *docPath = [VFCDocument documentsDirectoryPath];
    docPath = [docPath stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
    docPath = [docPath stringByAppendingPathExtension:[VFCDocument extension]];
    NSURL *URL = [NSURL fileURLWithPath:docPath];
    VFCDocument *doc = [[VFCDocument alloc] initWithFileURL:URL];
    [doc saveToURL:URL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VFCNotificationDidCreateDocument object:doc];
    }];
    return doc;
}

+ (NSArray *)documents {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = [fileManager contentsOfDirectoryAtPath:[VFCDocument documentsDirectoryPath] error:nil];
    NSMutableArray *docs = [NSMutableArray array];
    for (NSString *path in paths) {
        NSString *docPath = [VFCDocument documentsDirectoryPath];
        docPath = [docPath stringByAppendingPathComponent:path];
        NSURL *URL = [NSURL fileURLWithPath:docPath];
        VFCDocument *doc = [[VFCDocument alloc] initWithFileURL:URL];
        [docs addObject:doc];
    }
    return [NSArray arrayWithArray:docs];
}

+ (void)saveAsPreviousDocument:(VFCDocument *)document {
    if (document) {
        NSString *path = [[document fileURL] lastPathComponent];
        [[NSUserDefaults standardUserDefaults] setPreviousDocumentPath:path];
    } else {
        [[NSUserDefaults standardUserDefaults] setPreviousDocumentPath:nil];
    }
}

- (NSArray *)crumbTrails {
    NSMutableArray *crumbTrails = [NSMutableArray array];
    
    NSInteger step = [[self step] integerValue];
    
    if (step >= VFCDocumentStepMacroTrend) {
        if (step == VFCDocumentStepMacroTrend) {
            [crumbTrails addObject:([[self macroTrend] length] > 0) ? [self macroTrend] : @"Select a macro trend"];
        } else {
            [crumbTrails addObject:([[self macroTrend] length] > 0) ? [self macroTrend] : @"Macro Trend"];
        }
    }
    if (step >= VFCDocumentStepSegmentChoice) {
        if (step == VFCDocumentStepSegmentChoice) {
            [crumbTrails addObject:([[self segmentChoice] length] > 0) ? [self segmentChoice] : @"Select a segment choice"];
        } else {
            [crumbTrails addObject:([[self segmentChoice] length] > 0) ? [self segmentChoice] : @"Segment Choice"];
        }
    }
    if (step >= VFCDocumentStepGapAnaysis) {
        [crumbTrails addObject:@"Gap Analysis"];
    }
    if (step >= VFCDocumentStepSolution) {
        [crumbTrails addObject:@"Suggested Solution"];
    }
    
    return [NSArray arrayWithArray:crumbTrails];
}

- (NSArray *)uppercaseCrumbTrails {
    NSArray *crumbTrails = [self crumbTrails];
    NSMutableArray *uppercaseCrumbTrails = [NSMutableArray array];
    for (NSString *crumbTrail in crumbTrails) {
        [uppercaseCrumbTrails addObject:[crumbTrail uppercaseString]];
    }
    return [NSArray arrayWithArray:uppercaseCrumbTrails];
}

#pragma mark Private

+ (NSString *)documentsDirectoryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    return path;
}

@end
