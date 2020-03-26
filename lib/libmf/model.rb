module Libmf
  class Model
    def initialize(**options)
      @options = options
    end

    def fit(data, eval_set: nil)
      train_set = create_problem(data)

      @model =
        if eval_set
          eval_set = create_problem(eval_set)
          FFI.mf_train_with_validation(train_set, eval_set, param)
        else
          FFI.mf_train(train_set, param)
        end

      nil
    end

    def predict(row, column)
      FFI.mf_predict(model, row, column)
    end

    def cv(data, folds: 5)
      problem = create_problem(data)
      FFI.mf_cross_validation(problem, folds, param)
    end

    def save_model(path)
      FFI.mf_save_model(model, path)
    end

    def load_model(path)
      @model = FFI.mf_load_model(path)
    end

    def rows
      model[:m]
    end

    def columns
      model[:n]
    end

    def factors
      model[:k]
    end

    def bias
      model[:b]
    end

    def p_factors(format: nil)
      _factors(model[:p], rows, format)
    end

    def q_factors(format: nil)
      _factors(model[:q], columns, format)
    end

    private

    def _factors(ptr, n, format)
      case format
      when :numo
        Numo::SFloat.from_string(ptr.read_bytes(n * factors * 4)).reshape(n, factors)
      when nil
        ptr.read_array_of_float(n * factors).each_slice(factors).to_a
      else
        raise ArgumentError, "Invalid format"
      end
    end

    def model
      raise Error, "Not fit" unless @model
      @model
    end

    def param
      param = FFI.mf_get_default_param
      options = @options.dup
      # silence insufficient blocks warning with default params
      options[:bins] ||= 25 unless options[:nr_bins]
      options[:copy_data] = false unless options.key?(:copy_data)
      options_map = {
        :loss => :fun,
        :factors => :k,
        :threads => :nr_threads,
        :bins => :nr_bins,
        :iterations => :nr_iters,
        :learning_rate => :eta,
        :nmf => :do_nmf
      }
      options.each do |k, v|
        k = options_map[k] if options_map[k]
        param[k] = v
      end
      # do_nmf must be true for generalized KL-divergence
      param[:do_nmf] = true if param[:fun] == 2
      param
    end

    def create_problem(data)
      if data.is_a?(String)
        # need to expand path so it's absolute
        return FFI.mf_read_problem(File.expand_path(data))
      end

      raise Error, "No data" if data.empty?

      # TODO do in C for better performance
      # can use FIX2INT() and RFLOAT_VALUE() instead of pack
      buffer = String.new
      data.each do |row|
        row[0, 2].pack("i*".freeze, buffer: buffer)
        row[2, 1].pack("f".freeze, buffer: buffer)
      end

      r = ::FFI::MemoryPointer.new(FFI::Node, data.size)
      r.write_bytes(buffer)

      # double check size is what we expect
      # FFI will throw an error above if too long
      raise Error, "Bad buffer size" if r.size != buffer.bytesize

      m = data.max_by { |r| r[0] }[0] + 1
      n = data.max_by { |r| r[1] }[1] + 1

      prob = FFI::Problem.new
      prob[:m] = m
      prob[:n] = n
      prob[:nnz] = data.size
      prob[:r] = r
      prob
    end
  end
end
