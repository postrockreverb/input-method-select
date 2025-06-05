#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>
#include <CoreFoundation/CFArray.h>
#import <Foundation/Foundation.h>

#define kTempInputSource @"com.apple.keylayout.ABC"

#define kABCInputSources                                                                                               \
  @[ /* abc input methods here */                                                                                      \
     @"com.apple.keylayout.ABC"                                                                                        \
  ]

NSString *getCurrentInputSourceID(void) {
  TISInputSourceRef currentSource = TISCopyCurrentKeyboardInputSource();
  if (!currentSource) {
    return nil;
  }

  NSString *result = (__bridge NSString *)TISGetInputSourceProperty(currentSource, kTISPropertyInputSourceID);

  CFRelease(currentSource);
  return result;
}

BOOL selectInputSource(NSString *inputSourceID) {
  NSDictionary *filter = @{
    (__bridge NSString *)kTISPropertyInputSourceID : inputSourceID,
    (__bridge NSString *)kTISPropertyInputSourceIsEnabled : @YES
  };

  CFArrayRef sourceList = TISCreateInputSourceList((__bridge CFDictionaryRef)filter, false);
  if (!sourceList || CFArrayGetCount(sourceList) == 0) {
    return NO;
  }

  TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex(sourceList, 0);
  OSStatus err = TISSelectInputSource(source);
  if (err != noErr) {
    return NO;
  }

  CFRelease(sourceList);
  return YES;
}

BOOL selectInputSourceSafe(NSString *inputSourceID, NSString *inputSourceTempID) {
  if (!selectInputSource(inputSourceID)) {
    return NO;
  }

  if (!selectInputSource(inputSourceTempID)) {
    return NO;
  }

  if (!selectInputSource(inputSourceID)) {
    return NO;
  }

  return YES;
}

CFArrayRef getEnabledInputSources(void) {
  NSDictionary *filter = @{
    (__bridge NSString *)kTISPropertyInputSourceIsEnabled : @YES,
    (__bridge NSString *)kTISPropertyInputSourceCategory : (__bridge NSString *)kTISCategoryKeyboardInputSource
  };
  return TISCreateInputSourceList((__bridge CFDictionaryRef)filter, false);
}

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    if (argc != 2) {
      printf("Usage: %s <input-source-id>\n", argv[0]);
      printf("If no argument is given, prints the list of enabled input sources.\n");
      printf("Enabled input sources:\n");

      CFArrayRef sourceList = getEnabledInputSources();
      for (CFIndex i = 0; i < CFArrayGetCount(sourceList); ++i) {
        TISInputSourceRef source = (TISInputSourceRef)CFArrayGetValueAtIndex(sourceList, i);
        CFStringRef sid = TISGetInputSourceProperty(source, kTISPropertyInputSourceID);
        printf("- %s\n", CFStringGetCStringPtr(sid, kCFStringEncodingUTF8));
      }

      CFRelease(sourceList);
      return 0;
    }

    NSString *currentInputSourceID = getCurrentInputSourceID();
    if (!currentInputSourceID) {
      return 1;
    }

    NSString *targetInputSourceID = [NSString stringWithUTF8String:argv[1]];
    if ([currentInputSourceID isEqualToString:targetInputSourceID]) {
      return 0;
    }

    BOOL res = [kABCInputSources containsObject:currentInputSourceID]
                   ? selectInputSource(targetInputSourceID)
                   : selectInputSourceSafe(targetInputSourceID, kTempInputSource);
    if (!res) {
      return 1;
    }
  }

  return 0;
}
