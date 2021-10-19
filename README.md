# LIBMF

[LIBMF](https://github.com/cjlin1/libmf) - large-scale sparse matrix factorization - for Ruby

Check out [Disco](https://github.com/ankane/disco) for higher-level collaborative filtering

[![Build Status](https://github.com/ankane/libmf/workflows/build/badge.svg?branch=master)](https://github.com/ankane/libmf/actions)

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'libmf'
```

## Getting Started

Prep your data in the format `[row_index, column_index, value]`

```ruby
data = [
  [0, 0, 5.0],
  [0, 2, 3.5],
  [1, 1, 4.0]
]
```

Create a model

```ruby
model = Libmf::Model.new
model.fit(data)
```

Make predictions

```ruby
model.predict(row_index, column_index)
```

Get the latent factors (these approximate the training matrix)

```ruby
model.p_factors
model.q_factors
```

Get the bias (average of all elements in the training matrix)

```ruby
model.bias
```

Save the model to a file

```ruby
model.save_model("model.txt")
```

Load the model from a file

```ruby
model.load_model("model.txt")
```

Pass a validation set

```ruby
model.fit(data, eval_set: eval_set)
```

## Cross-Validation

Perform cross-validation

```ruby
model.cv(data)
```

Specify the number of folds

```ruby
model.cv(data, folds: 5)
```

## Parameters

Pass parameters - default values below

```ruby
Libmf::Model.new(
  loss: :real_l2,         # loss function
  factors: 8,             # number of latent factors
  threads: 12,            # number of threads used
  bins: 25,               # number of bins
  iterations: 20,         # number of iterations
  lambda_p1: 0,           # coefficient of L1-norm regularization on P
  lambda_p2: 0.1,         # coefficient of L2-norm regularization on P
  lambda_q1: 0,           # coefficient of L1-norm regularization on Q
  lambda_q2: 0.1,         # coefficient of L2-norm regularization on Q
  learning_rate: 0.1,     # learning rate
  alpha: 0.1,             # importance of negative entries
  c: 0.0001,              # desired value of negative entries
  nmf: false,             # perform non-negative MF (NMF)
  quiet: false            # no outputs to stdout
)
```

### Loss Functions

For real-valued matrix factorization

- `:real_l2` - squared error (L2-norm)
- `:real_l1` - absolute error (L1-norm)
- `:real_kl` - generalized KL-divergence

For binary matrix factorization

- `:binary_log` - logarithmic error
- `:binary_l2` - squared hinge loss
- `:binary_l1` - hinge loss

For one-class matrix factorization

- `:one_class_row` - row-oriented pair-wise logarithmic loss
- `:one_class_col` - column-oriented pair-wise logarithmic loss
- `:one_class_l2` - squared error (L2-norm)

## Performance

For performance, read data directly from files

```ruby
model.fit("train.txt", eval_set: "validate.txt")
model.cv("train.txt")
```

Data should be in the format `row_index column_index value`:

```txt
0 0 5.0
0 2 3.5
1 1 4.0
```

## Numo

Get latent factors as Numo arrays

```ruby
model.p_factors(format: :numo)
model.q_factors(format: :numo)
```

## Resources

- [LIBMF: A Library for Parallel Matrix Factorization in Shared-memory Systems](https://www.csie.ntu.edu.tw/~cjlin/papers/libmf/libmf_open_source.pdf)

## History

View the [changelog](https://github.com/ankane/libmf/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/libmf/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/libmf/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone --recursive https://github.com/ankane/libmf.git
cd libmf
bundle install
bundle exec rake vendor:all
bundle exec rake test
```
