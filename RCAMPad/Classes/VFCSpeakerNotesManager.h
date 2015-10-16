//
//  VFCSpeakerNotesManager.h
//  RCAMPad
//

@import Foundation;

#pragma mark - VFCSpeakerNotesManager

#pragma mark - Public Interface

@interface VFCSpeakerNotesManager : NSObject
@property (nonatomic, copy, readwrite) NSString *speakerNotesKey;
+ (VFCSpeakerNotesManager *)speakerNotesManager;
- (NSString *)speakerNotes;
@end
