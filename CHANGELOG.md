## 0.4.0 (2024-10-22)

- Dropped support for Ruby < 3.1

## 0.3.0 (2022-08-07)

- Added metrics
- Prefer `save` over `save_model`
- Prefer `load` over `load_model`
- Dropped support for Ruby < 2.7

## 0.2.6 (2021-12-02)

- Improved ARM detection

## 0.2.5 (2021-10-18)

- Added named loss functions
- Added `Matrix` class
- Improved error checking for `fit`, `cv`, `save_model`, and `load_model`

## 0.2.4 (2021-08-05)

- Fixed memory leak

## 0.2.3 (2021-03-14)

- Added ARM shared library for Linux

## 0.2.2 (2021-02-04)

- Reduced allocations
- Improved ARM detection

## 0.2.1 (2020-12-28)

- Added ARM shared library for Mac

## 0.2.0 (2020-03-26)

- Changed to BSD 3-Clause license to match LIBMF
- Added support for reading data directly from files
- Added `format: :numo` option to `p_factors` and `q_factors`
- Improved performance of loading data by 5x

## 0.1.3 (2019-11-07)

- Made parameter names more Ruby-like
- No need to set `do_nmf` with generalized KL-divergence

## 0.1.2 (2019-11-06)

- Fixed bug in `p_factors` and `q_factors` methods

## 0.1.1 (2019-11-05)

- Fixed errors on Linux and Windows

## 0.1.0 (2019-11-04)

- First release
