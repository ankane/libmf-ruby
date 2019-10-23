# LIBMF

[LIBMF](https://github.com/cjlin1/libmf) - large-scale sparse matrix factorization - for Ruby

:fire: Uses the C API for blazing performance

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

Get the bias and latent factors

```ruby
model.bias
model.p_factors
model.q_factors
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

## Parameters

Pass parameters

```ruby
model = Libmf::Model.new(k: 20, nr_iters: 50)
```

Supports the same parameters as LIBMF

```text
variable      meaning                                    default
================================================================
fun           loss function                                    0
k             number of latent factors                         8
nr_threads    number of threads used                          12
nr_bins       number of bins                                  25
nr_iters      number of iterations                            20
lambda_p1     coefficient of L1-norm regularization on P       0
lambda_p2     coefficient of L2-norm regularization on P     0.1
lambda_q1     coefficient of L1-norm regularization on Q       0
lambda_q2     coefficient of L2-norm regularization on Q     0.1
eta           learning rate                                  0.1
alpha         importance of negative entries                 0.1
c             desired value of negative entries           0.0001
do_nmf        perform non-negative MF (NMF)                false
quiet         no outputs to stdout                         false
copy_data     copy data in training procedure               true
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
