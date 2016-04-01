#include "request_global.h"

VALUE rb_mRequestGlobal;

void
Init_request_global(void)
{
  rb_mRequestGlobal = rb_define_module("RequestGlobal");
}
