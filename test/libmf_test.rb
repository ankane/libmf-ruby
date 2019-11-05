require_relative "test_helper"

class LibmfTest < Minitest::Test
  def test_works
    data = read_file("real_matrix.tr.txt")

    model = Libmf::Model.new(quiet: true)
    model.fit(data)

    assert_equal 2309, model.rows
    assert_equal 1368, model.columns
    assert_equal 8, model.factors
    assert model.bias
    assert_equal model.rows, model.p_factors.size
    assert_equal model.factors, model.p_factors.first.size
    assert_equal model.columns, model.q_factors.size
    assert_equal model.factors, model.q_factors.first.size

    pred = model.predict(1, 1)
    tempfile = Tempfile.new("libmf")
    model.save_model(tempfile.path)
    model.load_model(tempfile.path)
    assert_equal pred, model.predict(1, 1)

    assert_equal 2309, model.rows
    assert_equal 1368, model.columns
    assert_equal 8, model.factors
    assert model.bias
    assert_equal model.rows, model.p_factors.size
    assert_equal model.factors, model.p_factors.first.size
    assert_equal model.columns, model.q_factors.size
    assert_equal model.factors, model.q_factors.first.size
  end

  def test_eval_set
    train_set = read_file("real_matrix.tr.txt")
    eval_set = read_file("real_matrix.te.txt")

    model = Libmf::Model.new(quiet: true)
    model.fit(train_set, eval_set: eval_set)
  end

  def test_cv
    data = read_file("real_matrix.tr.txt")
    model = Libmf::Model.new(quiet: true)
    assert model.cv(data)
  end

  def test_not_fit
    model = Libmf::Model.new
    error = assert_raises Libmf::Error do
      model.bias
    end
    assert_equal "Not fit", error.message
  end

  def test_no_data
    model = Libmf::Model.new
    error = assert_raises Libmf::Error do
      model.fit([])
    end
    assert_equal "No data", error.message
  end

  private

  def read_file(filename)
    data = []
    File.foreach("vendor/libmf/demo/#{filename}") do |line|
      row = line.chomp.split(" ")
      data << [row[0].to_i, row[1].to_i, row[2].to_f]
    end
    data
  end
end
