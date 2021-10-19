module Libmf
  class Matrix
    attr_reader :data

    def initialize
      @data = []
    end

    def push(row_index, column_index, value)
      @data << [row_index, column_index, value]
    end
  end
end
