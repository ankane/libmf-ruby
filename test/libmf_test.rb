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

    lines = File.readlines(tempfile.path)
    p10 = lines.find { |l| l.start_with?("p10 ") }[5..-1].split(" ").map(&:to_f)
    p10.zip(model.p_factors[10]).each do |a, b|
      assert_in_delta a, b
    end
    q10 = lines.find { |l| l.start_with?("q10 ") }[5..-1].split(" ").map(&:to_f)
    q10.zip(model.q_factors[10]).each do |a, b|
      assert_in_delta a, b
    end

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

  def test_path
    skip
    model = Libmf::Model.new(quiet: true)
    model.fit(file_path("real_matrix.tr.txt"))
    assert_equal 2309, model.rows
  end

  def test_path_eval_set
    skip
    model = Libmf::Model.new(quiet: true)
    model.fit(file_path("real_matrix.tr.txt"), eval_set: file_path("real_matrix.te.txt"))
    assert_equal 2309, model.rows
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

  def test_numo
    data = read_file("real_matrix.tr.txt")

    model = Libmf::Model.new(quiet: true)
    model.fit(data)

    assert_equal [model.rows, model.factors], model.p_factors(:numo).shape
    assert_equal [model.columns, model.factors], model.q_factors(:numo).shape

    # unknown format
    assert_raises(ArgumentError) do
      model.p_factors(:bad)
    end
  end

  private

  def file_path(filename)
    "vendor/libmf/demo/#{filename}"
  end

  def read_file(filename)
    data = []
    File.foreach(file_path(filename)) do |line|
      row = line.chomp.split(" ")
      data << [row[0].to_i, row[1].to_i, row[2].to_f]
    end
    data
  end
end
