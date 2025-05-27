#import <Carbon/Carbon.h>
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

static NSArray<NSString *> *const kCandidateInputSources = @[
  // candidate boxes input methods here
  @"com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"
];

NSString *getCurrentInputSourceID(void) {
  TISInputSourceRef currentSource = TISCopyCurrentKeyboardInputSource();
  if (!currentSource) {
    return nil;
  }

  CFStringRef currentID = TISGetInputSourceProperty(currentSource, kTISPropertyInputSourceID);
  NSString *result = (NSString *)CFStringCreateCopy(NULL, currentID);
  CFRelease(currentSource);
  return result;
}

BOOL selectInputSourceWithID(NSString *inputSourceID) {
  CFStringRef targetID = (__bridge CFStringRef)inputSourceID;
  const void *keys[] = {kTISPropertyInputSourceID};
  const void *values[] = {targetID};
  CFDictionaryRef properties = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, &kCFTypeDictionaryKeyCallBacks,
                                                  &kCFTypeDictionaryValueCallBacks);

  CFArrayRef sources = TISCreateInputSourceList(properties, false);
  if (CFArrayGetCount(sources) == 0) {
    CFRelease(properties);
    CFRelease(sources);
    return NO;
  }

  TISInputSourceRef newSource = (TISInputSourceRef)CFArrayGetValueAtIndex(sources, 0);
  OSStatus status = TISSelectInputSource(newSource);
  CFRelease(properties);
  CFRelease(sources);

  if (status != noErr) {
    return NO;
  }

  return YES;
}

void refreshWindowFocus(void) {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSZeroRect
                                                   styleMask:NSWindowStyleMaskBorderless
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp terminate:nil];
  });

  [NSApplication sharedApplication];
  [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
  [NSApp run];
}

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    if (argc != 2) {
      return 1;
    }

    NSString *currentInputSourceID = getCurrentInputSourceID();
    if (!currentInputSourceID) {
      return 1;
    }

    NSString *targetInputSourceID = [NSString stringWithUTF8String:argv[1]];
    if ([currentInputSourceID isEqualToString:targetInputSourceID]) {
      return 0;
    }

    if (!selectInputSourceWithID(targetInputSourceID)) {
      return 1;
    }

    BOOL shouldRefreshFocus = [kCandidateInputSources containsObject:currentInputSourceID];
    if (shouldRefreshFocus) {
      refreshWindowFocus();
    }
  }

  return 0;
}
