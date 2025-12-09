# tch_mbt

A MoonBit wrapper for libtorch, enabling tensor operations and neural network inference via FFI.

> [!NOTE]
> Only Linux is supported.

## Installation

### Prerequisites

- Install libtorch (<https://pytorch.org/cppdocs/installing.html>).
- Install CMake (and possibly "build-essential").

### Option 1: Use as a library via Mooncakes

```bash
moon add liuly0322/tch_mbt
CMAKE_PREFIX_PATH=/your/path/to/libtorch bash .mooncakes/liuly0322/tch_mbt/build.sh
```

Edit your `moon.pkg.json`:

```json
{
  // ... other fields
  "import": [
    {
      "path": "liuly0322/tch_mbt/torch",
      "alias": "torch"
    }
  ],
  "link": {
    "native": {
      "cc-link-flags": "-ltchproxy"
    }
  }
}
```

Then write some code:

```moonbit
fn main {
  let tensor = @torch.tensor_from_array([1.0, 2.0, 3.0]).reshape([3, 1])
  println(tensor.matmul(tensor.transpose()))
}
```

Run: `moon run src/main --target native`

### Option 2: Develop from this repo

```bash
git clone https://github.com/moonbit-community/tch-mbt.git
cd tch-mbt
CMAKE_PREFIX_PATH=/your/path/to/libtorch bash build.sh
```

Now edit code in `main/main.mbt` if you want and run `bash run.sh`. Enjoy!

> [!WARNING]
> The `moon build` command will fail for [moon#674](https://github.com/moonbitlang/moon/issues/674), but it will successfully generate the executable, see `run.sh` for details.

```moonbit
// Load a model and do inference on MNIST dataset.
// You can check the images in python_examples/mnist/samples.
fn main {
  let model = @torch.load_model_from_file("python_examples/mnist/mnist_cnn.pt")
  let input_shape = [1, 1, 28, 28]
  let cases = ["1", "2", "3", "4", "5"]
  let expected_answers = [7, 2, 1, 0, 4]
  for i in 0..<5 {
    let filename = "python_examples/mnist/samples/mnist_" + cases[i] + ".pt"
    let input: @torch.Tensor[Float] = @torch.tensor_from_file(filename).reshape(input_shape)
    let output: @torch.Tensor[Float] = model.forward(input)
    let output = output.argmax().get_raw_data()[0]
    println("Expected: " + expected_answers[i].to_string() + ", Output: " + output.to_string())
  }
}
```

## API

Check the full list in [torch.mbti](torch/torch.mbti).

## Roadmap & TODOs

- [x] Basic tensor operations.
- [x] Basic neural network forward pass.
- [x] Build a real inference model demo.
- [ ] Add more tensor operations.
- [ ] Add more neural network operations.
- [ ] Support static build (see [tch-rs](https://github.com/LaurentMazare/tch-rs) for building `libtorch.a`).

## License

Apache 2.0
