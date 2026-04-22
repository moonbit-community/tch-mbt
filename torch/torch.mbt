///|
test "demo" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_from_array([6.0, 5.0, 4.0, 3.0, 2.0, 1.0])
  inspect(tensor_a * tensor_b, content="Tensor([6, 10, 12, 12, 10, 6])")
  inspect(tensor_a.matmul(tensor_b.reshape([6, 1])), content="Tensor([56])")
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  inspect(-tensor_a, content="Tensor([-1, -2, -3, -4, -5, -6])")
}

///|
test "inference" {
  let model = load_model_from_file("python_examples/mnist/mnist_cnn.pt")
  let input_shape = [1, 1, 28, 28]
  let cases = ["1", "2", "3", "4", "5"]
  let expected_answers = [7, 2, 1, 0, 4]
  for i in 0..<5 {
    let filename = "python_examples/mnist/samples/mnist_" + cases[i] + ".pt"
    let input : Tensor[Float] = tensor_from_file(filename).reshape(input_shape)
    let output : Tensor[Float] = model.forward(input)
    let output = output.argmax().get_raw_data()[0]
    assert_eq(output, expected_answers[i].to_int64())
  }
}
