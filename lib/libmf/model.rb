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

    def p_factors
      reshape(model[:p].read_array_of_float(factors * rows), factors)
    end

    def q_factors
      reshape(model[:q].read_array_of_float(factors * columns), factors)
    end

    private

    def model
      raise Error, "Not fit" unless @model
      @model
    end

    def param
      param = FFI.mf_get_default_param
      # silence insufficient blocks warning with default params
      options = {nr_bins: 25}.merge(@options)
      options.each do |k, v|
        param[k] = v
      end
      param
    end

    def create_problem(data)
      raise Error, "No data" if data.empty?

      nodes = []
      r = ::FFI::MemoryPointer.new(FFI::Node, data.size)
      data.each_with_index do |row, i|
        n = FFI::Node.new(r[i])
        n[:u] = row[0]
        n[:v] = row[1]
        n[:r] = row[2]
        nodes << n
      end

      m = nodes.map { |n| n[:u] }.max + 1
      n = nodes.map { |n| n[:v] }.max + 1

      prob = FFI::Problem.new
      prob[:m] = m
      prob[:n] = n
      prob[:nnz] = nodes.size
      prob[:r] = r
      prob
    end

    def reshape(arr, factors)
      arr.each_slice(factors).to_a
    end
  end
end
