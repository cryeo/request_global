#include "request_global.h"

VALUE mRequestGlobal;

VALUE
class_variable_storages(VALUE self) {
  return rb_cv_get(self, "@@storages");
}

VALUE
class_variable_current_request(VALUE self) {
  return rb_cv_get(self, "@@current_request");
}

void
check_condition(VALUE self) {
  Check_Type(class_variable_storages(self), T_HASH);
  if (class_variable_current_request(self) == Qnil) rb_raise(rb_eException, "Could not idendify current request");
}

VALUE
request_global_current_storage(VALUE self) {
  VALUE current_storage = rb_hash_aref(class_variable_storages(self), class_variable_current_request(self));
  Check_Type(current_storage, T_HASH);
  return current_storage;
}

/*
 * call-seq:
 *   RequestGlobal.set_current_request(request) -> request
 *
 * Set current request id.
 */
static VALUE
request_global_set_current_request(VALUE self, VALUE request) {
  rb_cv_set(self, "@@current_request", request);
  return class_variable_current_request(self);
}

/*
 * call-seq:
 *   RequestGlobal.get_current_request -> request
 *
 * Get current request id.
 */
static VALUE
request_global_get_current_request(VALUE self) {
  return class_variable_current_request(self);
}

/*
 * call-seq:
 *   RequestGlobal.begin! -> nil
 *
 * Set up storage for current request.
 */
static VALUE
request_global_begin(VALUE self) {
  check_condition(self);
  Check_Type(rb_hash_aref(class_variable_storages(self), class_variable_current_request(self)), T_NIL);
  rb_hash_aset(class_variable_storages(self), class_variable_current_request(self), rb_hash_new());
  return Qnil;
}

/*
 * call-seq:
 *   RequestGlobal.clear! -> nil
 *
 * Removes all key-value pairs from storage for current request.
 */
static VALUE
request_global_clear(VALUE self) {
  check_condition(self);
  rb_hash_clear(request_global_current_storage(self));
  return Qnil;
}

/*
 * call-seq:
 *   RequestGlobal.clear_all! -> nil
 *
 * Removes all storages from container.
 */
static VALUE
request_global_clear_all(VALUE self) {
  rb_hash_clear(class_variable_storages(self));
  request_global_set_current_request(self, Qnil);
  return Qnil;
}

/*
 * call-seq:
 *   RequestGlobal.end! -> nil
 *
 * Destroy information of current request and storage for current request.
 */
static VALUE
request_global_end(VALUE self) {
  check_condition(self);
  rb_hash_delete(class_variable_storages(self), class_variable_current_request(self));
  request_global_set_current_request(self, Qnil);
  return Qnil;
}

/*
 * call-seq:
 *   RequestGlobal.storage -> hash
 *
 * Get storage for current request.
 */
static VALUE
request_global_storage(VALUE self) {
  check_condition(self);
  return request_global_current_storage(self);
}

/*
 * call-seq:
 *   RequestGlobal.delete(key) -> value
 *
 * Delete the key-value pair for the given key and return the value from storage for current request.
 */
static VALUE
request_global_delete(VALUE self, VALUE key) {
  check_condition(self);
  return rb_hash_delete(request_global_current_storage(self), key);
}

/*
 * call-seq:
 *   RequestGlobal.fetch(key) -> value
 *   RequestGlobal[key]       -> value
 *
 * Return the value for the given key from storage for current request.
 */
static VALUE
request_global_fetch(VALUE self, VALUE key) {
  check_condition(self);
  return rb_hash_aref(request_global_current_storage(self), key);
}

/*
 * call-seq:
 *   RequestGlobal.store(key, value) -> value
 *   RequestGlobal[key] = value      -> value
 *
 * Assign the value with the key to storage for current request.
 */
static VALUE
request_global_store(VALUE self, VALUE key, VALUE value) {
  check_condition(self);
  return rb_hash_aset(request_global_current_storage(self), key, value);
}

void
Init_request_global(void) {
  mRequestGlobal = rb_define_module("RequestGlobal");

  rb_cv_set(mRequestGlobal, "@@storages", rb_hash_new());
  rb_cv_set(mRequestGlobal, "@@current_request", Qnil);

  rb_define_module_function(mRequestGlobal, "begin!", request_global_begin, 0);
  rb_define_module_function(mRequestGlobal, "end!", request_global_end, 0);
  rb_define_module_function(mRequestGlobal, "clear!", request_global_clear, 0);
  rb_define_module_function(mRequestGlobal, "clear_all!", request_global_clear_all, 0);

  rb_define_module_function(mRequestGlobal, "get_current_request", request_global_get_current_request, 0);
  rb_define_module_function(mRequestGlobal, "set_current_request", request_global_set_current_request, 1);

  rb_define_module_function(mRequestGlobal, "storage", request_global_storage, 0);

  rb_define_module_function(mRequestGlobal, "delete", request_global_delete, 1);
  rb_define_module_function(mRequestGlobal, "fetch", request_global_fetch, 1);
  rb_define_module_function(mRequestGlobal, "[]", request_global_fetch, 1);
  rb_define_module_function(mRequestGlobal, "store", request_global_store, 2);
  rb_define_module_function(mRequestGlobal, "[]=", request_global_store, 2);
}
