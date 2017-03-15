#include <mruby.h>

static mrb_value
mrb_uri_s_encode_www_component(mrb_state *mrb, mrb_value uri)
{
  mrb_value *argv;
  mrb_int argc;
  mrb_warn(mrb, "[Deprecated] Please use `URI.encode_www_form_component' instead of `URI.encode_www_component' \n");
  mrb_get_args(mrb, "*", &argv, &argc);
  return mrb_funcall_argv(mrb, uri, mrb_intern_lit(mrb, "encode_www_form_component"), argc, argv);
}

static mrb_value
mrb_uri_s_decode_www_component(mrb_state *mrb, mrb_value uri)
{
  mrb_value *argv;
  mrb_int argc;
  mrb_warn(mrb, "[Deprecated] Please use `URI.decode_www_form_component' instead of `URI.decode_www_component' \n");
  mrb_get_args(mrb, "*", &argv, &argc);
  return mrb_funcall_argv(mrb, uri, mrb_intern_lit(mrb, "decode_www_form_component"), argc, argv);
}

void
mrb_mruby_uri_gem_init(mrb_state *mrb)
{
  struct RClass *uri = mrb_define_module(mrb, "URI");
  mrb_define_class_method(mrb, uri, "encode_www_component", mrb_uri_s_encode_www_component, MRB_ARGS_ANY());
  mrb_define_class_method(mrb, uri, "decode_www_component", mrb_uri_s_decode_www_component, MRB_ARGS_ANY());
}

void
mrb_mruby_uri_gem_final(mrb_state *mrb)
{
}
