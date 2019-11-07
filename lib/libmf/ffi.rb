module Libmf
  module FFI
    extend Fiddle::Importer

    libs = Libmf.ffi_lib.dup
    begin
      dlload libs.shift
    rescue Fiddle::DLError => e
      retry if libs.any?
      raise e if ENV["LIBMF_DEBUG"]
      raise LoadError, "Could not find LIBMF"
    end

    typealias "bool", "int"

    typealias "mf_float", "float"
    typealias "mf_double", "double"
    typealias "mf_int", "int"
    typealias "mf_long", "long long"

    Node = struct [
      "mf_int u",
      "mf_int v",
      "mf_float r"
    ]

    Problem = struct [
      "mf_int m",
      "mf_int n",
      "mf_long nnz",
      "struct mf_node *R"
    ]

    Parameter = struct [
      "mf_int fun",
      "mf_int k",
      "mf_int nr_threads",
      "mf_int nr_bins",
      "mf_int nr_iters",
      "mf_float lambda_p1",
      "mf_float lambda_p2",
      "mf_float lambda_q1",
      "mf_float lambda_q2",
      "mf_float eta",
      "mf_float alpha",
      "mf_float c",
      "bool do_nmf",
      "bool quiet",
      "bool copy_data"
    ]

    Model = struct [
      "mf_int fun",
      "mf_int m",
      "mf_int n",
      "mf_int k",
      "mf_float b",
      "mf_float *P",
      "mf_float *Q"
    ]

    extern "struct mf_parameter mf_get_default_param()"
    extern "mf_int mf_save_model(struct mf_model const *model, char const *path)"
    extern "struct mf_model* mf_load_model(char const *path)"
    extern "void mf_destroy_model(struct mf_model **model)"
    extern "struct mf_model* mf_train(struct mf_problem const *prob, struct mf_parameter param)"
    extern "struct mf_model* mf_train_with_validation(struct mf_problem const *tr, struct mf_problem const *va, struct mf_parameter param)"
    extern "mf_double mf_cross_validation(struct mf_problem const *prob, mf_int nr_folds, struct mf_parameter param)"
    extern "mf_float mf_predict(struct mf_model const *model, mf_int u, mf_int v)"
  end
end
