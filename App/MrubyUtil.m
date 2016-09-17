//
//  mruby Utility Implementation
//

#import "MrubyUtil.h"

#import "mruby/hash.h"
#import "mruby/string.h"

#if __has_feature(objc_arc)
#error This code needs compiler option -fno-objc-arc
#endif

@implementation MrubyUtil {
}

+ (NSString*) str2nstr:(mrb_state*)mrb value:(mrb_value)value {
    const char *cstr = mrb_string_value_ptr(mrb, value);
    return [[NSString alloc] initWithUTF8String:cstr];
}

+ (mrb_value) hashGet:(mrb_state*)mrb hash:(mrb_value)hash key:(const char*)key {
    mrb_value sym = mrb_symbol_value(mrb_intern_cstr(mrb, "link")); 
    return mrb_hash_get(mrb, hash, sym);
}

@end