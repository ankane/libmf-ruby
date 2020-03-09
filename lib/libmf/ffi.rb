module Libmf
  module FFI
    extend ::FFI::Library

    ffi_lib Libmf.ffi_lib

    class Node < ::FFI::Struct
      layout :u, :int,
        :v, :int,
        :r, :float
    end

    class Problem < ::FFI::Struct
      layout :m, :int,
        :n, :int,
        :nnz, :long_long,
        :r, :pointer
    end

    class Parameter < ::FFI::Struct
      layout :fun, :int,
        :k, :int,
        :nr_threads, :int,
        :nr_bins, :int,
        :nr_iters, :int,
        :lambda_p1, :float,
        :lambda_p2, :float,
        :lambda_q1, :float,
        :lambda_q2, :float,
        :eta, :float,
        :alpha, :float,
        :c, :float,
        :do_nmf, :bool,
        :quiet, :bool,
        :copy_data, :bool
    end

    class Model < ::FFI::Struct
      layout :fun, :int,
        :m, :int,
        :n, :int,
        :k, :int,
        :b, :float,
        :p, :pointer,
        :q, :pointer
    end

    attach_function :mf_get_default_param, [], Parameter.by_value
    attach_function :read_problem, [:string], Problem.by_value
    attach_function :mf_save_model, [Model.by_ref, :string], :int
    attach_function :mf_load_model, [:string], Model.by_ref
    attach_function :mf_destroy_model, [Model.by_ref], :void
    attach_function :mf_train, [Problem.by_ref, Parameter.by_value], Model.by_ref
    attach_function :mf_train_with_validation, [Problem.by_ref, Problem.by_ref, Parameter.by_value], Model.by_ref
    attach_function :mf_predict, [Model.by_ref, :int, :int], :float
    attach_function :mf_cross_validation, [Problem.by_ref, :int, Parameter.by_value], :double
  end
end
