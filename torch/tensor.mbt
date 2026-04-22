///|
pub enum ElementKind {
  // Uint8
  // Int8
  Int16
  Int
  Int64
  // Half
  Float
  Double
  // ComplexHalf
  // ComplexFloat
  // ComplexDouble
  // Bool
  // QInt8
  // QUInt8
  // QInt32
  // BFloat16
  // Float8e5m2
  // Float8e4m3fn
  // Float8e5m2fnuz
  // Float8e4m3fnuz
}

///|
pub(open) trait Element {
  kind(Self) -> ElementKind
  elt_size_in_bytes(Self) -> UInt = _
  c_int(Self) -> Int = _
  bytes(Array[Self]) -> Bytes
  to_vec(Bytes) -> Array[Self]
}

///|
impl Element with elt_size_in_bytes(self) {
  match self.kind() {
    // ElementKind::Uint8 => 1
    // ElementKind::Int8 => 1
    ElementKind::Int16 => 2
    ElementKind::Int => 4
    ElementKind::Int64 => 8
    // ElementKind::Half => 2
    ElementKind::Float => 4
    ElementKind::Double => 8
    // ElementKind::ComplexHalf => 4
    // ElementKind::ComplexFloat => 8
    // ElementKind::ComplexDouble => 16
    // ElementKind::Bool => 1
    // ElementKind::QInt8 => 1
    // ElementKind::QUInt8 => 1
    // ElementKind::QInt32 => 4
    // ElementKind::BFloat16 => 2
    // ElementKind::Float8e5m2 => 1
    // ElementKind::Float8e4m3fn => 1
    // ElementKind::Float8e5m2fnuz => 1
    // ElementKind::Float8e4m3fnuz => 1
  }
}

// These values should be in sync with include/c10/core/ScalarType.h
///|
impl Element with c_int(self) {
  match self.kind() {
    // ElementKind::Uint8 => 0
    // ElementKind::Int8 => 1
    ElementKind::Int16 => 2
    ElementKind::Int => 3
    ElementKind::Int64 => 4
    // ElementKind::Half => 5
    ElementKind::Float => 6
    ElementKind::Double => 7
    // ElementKind::ComplexHalf => 8
    // ElementKind::ComplexFloat => 9
    // ElementKind::ComplexDouble => 10
    // ElementKind::Bool => 11
    // ElementKind::QInt8 => 12
    // ElementKind::QUInt8 => 13
    // ElementKind::QInt32 => 14
    // ElementKind::BFloat16 => 15
    // ElementKind::Float8e5m2 => 23
    // ElementKind::Float8e4m3fn => 24
    // ElementKind::Float8e5m2fnuz => 25
    // ElementKind::Float8e4m3fnuz => 26
  }
}

///|
pub impl Element for Int16 with kind(_) {
  ElementKind::Int16
}

///|
pub impl Element for Int16 with bytes(arr) {
  int_16_array_to_bytes(arr)
}

///|
pub impl Element for Int16 with to_vec(bytes) {
  bytes_to_int_16_array(bytes)
}

///|
pub impl Element for Int with kind(_) {
  ElementKind::Int
}

///|
pub impl Element for Int with bytes(arr) {
  int_array_to_bytes(arr)
}

///|
pub impl Element for Int with to_vec(bytes) {
  bytes_to_int_array(bytes)
}

///|
pub impl Element for Int64 with kind(_) {
  ElementKind::Int64
}

///|
pub impl Element for Int64 with bytes(arr) {
  int_64_array_to_bytes(arr)
}

///|
pub impl Element for Int64 with to_vec(bytes) {
  bytes_to_int_64_array(bytes)
}

///|
pub impl Element for Float with kind(_) {
  ElementKind::Float
}

///|
pub impl Element for Float with bytes(arr) {
  float_array_to_bytes(arr)
}

///|
pub impl Element for Float with to_vec(bytes) {
  bytes_to_float_array(bytes)
}

///|
pub impl Element for Double with kind(_) {
  ElementKind::Double
}

///|
pub impl Element for Double with bytes(arr) {
  double_array_to_bytes(arr)
}

///|
pub impl Element for Double with to_vec(bytes) {
  bytes_to_double_array(bytes)
}

///|
pub struct Tensor[T] {
  object : TensorObject
}

///|
pub fn[T : Element] Tensor::get_raw_data(self : Tensor[T]) -> Array[T] {
  T::to_vec(get_tensor_raw_ffi(self.object))
}

///|
pub fn[T] Tensor::reshape(self : Tensor[T], dims : Array[Int]) -> Tensor[T] {
  let ndims = dims.length().reinterpret_as_uint()
  let dims = dims.map(fn(x) { x.to_int64() }) |> int_64_array_to_bytes
  let object = reshape_ffi(self.object, dims, ndims)
  { object, }
}

///|
pub fn[T] Tensor::abs(self : Tensor[T]) -> Tensor[T] {
  let object = abs_tensor_ffi(self.object)
  { object, }
}

///|
pub fn[T, U] Tensor::exp(self : Tensor[T]) -> Tensor[U] {
  let object = exp_tensor_ffi(self.object)
  { object, }
}

///|
pub fn[T, U] Tensor::log(self : Tensor[T]) -> Tensor[U] {
  let object = log_tensor_ffi(self.object)
  { object, }
}

///|
pub fn[T] Tensor::op_add(self : Tensor[T], other : Tensor[T]) -> Tensor[T] {
  let object = add_tensors_ffi(self.object, other.object)
  { object, }
}

///|
pub fn[T] Tensor::op_sub(self : Tensor[T], other : Tensor[T]) -> Tensor[T] {
  let object = sub_tensors_ffi(self.object, other.object)
  { object, }
}

///|
pub fn[T] Tensor::op_neg(self : Tensor[T]) -> Tensor[T] {
  let object = neg_tensor_ffi(self.object)
  { object, }
}

///|
pub impl[T] Eq for Tensor[T] with equal(self : Tensor[T], other : Tensor[T]) {
  equal_tensors_ffi(self.object, other.object) == 1
}

///|
pub impl[T] Add for Tensor[T] with add(self : Tensor[T], other : Tensor[T]) {
  self.op_add(other)
}

///|
pub impl[T] Sub for Tensor[T] with sub(self : Tensor[T], other : Tensor[T]) {
  self.op_sub(other)
}

///|
pub impl[T] Mul for Tensor[T] with mul(self : Tensor[T], other : Tensor[T]) {
  self.op_mul(other)
}

///|
pub impl[T] Neg for Tensor[T] with neg(self : Tensor[T]) {
  self.op_neg()
}

///|
pub fn[T] Tensor::op_mul(self : Tensor[T], other : Tensor[T]) -> Tensor[T] {
  let object = mul_tensors_ffi(self.object, other.object)
  { object, }
}

///|
pub fn[T] Tensor::matmul(self : Tensor[T], other : Tensor[T]) -> Tensor[T] {
  let object = matmul_tensors_ffi(self.object, other.object)
  { object, }
}

///|
pub fn[T] Tensor::transpose(self : Tensor[T]) -> Tensor[T] {
  let object = transpose_tensor_ffi(self.object)
  { object, }
}

///|
pub fn[T] Tensor::length(self : Tensor[T]) -> Int {
  get_tensor_length_ffi(self.object)
}

///|
pub fn[T] Tensor::shape(self : Tensor[T]) -> Array[Int] {
  get_tensor_shape_ffi(self.object) |> bytes_to_int_array
}

///|
pub fn[T] Tensor::argmin(self : Tensor[T]) -> Tensor[Int64] {
  let object = argmin_tensor_ffi(self.object)
  { object, }
}

///|
pub fn[T] Tensor::argmax(self : Tensor[T]) -> Tensor[Int64] {
  let object = argmax_tensor_ffi(self.object)
  { object, }
}

///|
pub impl[T : Element + Show] Show for Tensor[T] with output(self, logger) {
  let shape = self.shape().rev()
  let vec = self.get_raw_data()
  logger.write_string("Tensor(")
  let n = vec.length()
  let shape_len = shape.length()
  for i in 0..<n {
    let mut left_cnt = 0
    let mut right_cnt = 0
    let mut index = i
    for j in 0..<shape_len {
      let dim = shape[j]
      let index_in_dim = index % dim
      if index_in_dim == 0 {
        left_cnt += 1
      } else {
        break
      }
      index = index / dim
    }
    index = i
    for j in 0..<shape_len {
      let dim = shape[j]
      let index_in_dim = index % dim
      if index_in_dim == dim - 1 {
        right_cnt += 1
      } else {
        break
      }
      index = index / dim
    }
    logger.write_string("[".repeat(left_cnt))
    logger.write_string(vec[i].to_string())
    logger.write_string("]".repeat(right_cnt))
    if i < n - 1 {
      logger.write_string(", ")
    }
  }
  logger.write_string(")")
}

///|
fn[T] at_tensor_of_data(
  data_ptr : Bytes,
  dims : Array[Int],
  ndims : UInt,
  element_size_in_bytes : UInt,
  _type : Int
) -> Tensor[T] {
  let dims = dims.map(fn(x) { x.to_int64() }) |> int_64_array_to_bytes
  let object = at_tensor_of_data_ffi(
    data_ptr, dims, ndims, element_size_in_bytes, _type,
  )
  { object, }
}

///|
pub fn[T : Element] tensor_from_array(arr : Array[T]) -> Tensor[T] {
  let raw = T::bytes(arr)
  at_tensor_of_data(
    raw,
    [arr.length()],
    1,
    arr[0].elt_size_in_bytes(),
    arr[0].c_int(),
  )
}

///|
pub fn[T] tensor_from_file(path : String) -> Tensor[T] {
  let path = mbt_string_to_utf8_bytes(path, true)
  let object = load_tensor_from_file_ffi(path)
  { object, }
}

///|
test "tensor" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  inspect(tensor_a, content="Tensor([1, 2, 3, 4, 5, 6])")
  let tensor_b = tensor_from_array([1, 2, 3])
  inspect(tensor_b, content="Tensor([1, 2, 3])")
}

///|
test "tensor_abs" {
  let tensor_a = tensor_from_array([-1.0, -2.0, -3.0, -4.0, -5.0, -6.0])
  let tensor_b = tensor_a.abs()
  inspect(tensor_b, content="Tensor([1, 2, 3, 4, 5, 6])")
}

///|
test "tensor_exp" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b : Tensor[Double] = tensor_a.exp()
  inspect(
    tensor_b,
    content="Tensor([2.718281828459045, 7.38905609893065, 20.085536923187668, 54.598150033144236, 148.4131591025766, 403.4287934927351])",
  )
}

///|
test "tensor_log" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b : Tensor[Double] = tensor_a.log()
  inspect(
    tensor_b,
    content="Tensor([0, 0.6931471805599453, 1.0986122886681098, 1.3862943611198906, 1.6094379124341003, 1.791759469228055])",
  )
}

///|
test "tensor_add" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_from_array([6.0, 5.0, 4.0, 3.0, 2.0, 1.0])
  let tensor_c = tensor_a + tensor_b
  inspect(tensor_c, content="Tensor([7, 7, 7, 7, 7, 7])")
}

///|
test "tensor_neg" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = -tensor_a
  inspect(tensor_b, content="Tensor([-1, -2, -3, -4, -5, -6])")
}

///|
test "tensor_sub" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_from_array([6.0, 5.0, 4.0, 3.0, 2.0, 1.0])
  let tensor_c = tensor_a - tensor_b
  inspect(tensor_c, content="Tensor([-5, -3, -1, 1, 3, 5])")
}

///|
test "tensor_mul" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_from_array([6.0, 5.0, 4.0, 3.0, 2.0, 1.0])
  let tensor_c = tensor_a * tensor_b
  inspect(tensor_c, content="Tensor([6, 10, 12, 12, 10, 6])")
}

///|
test "tensor_matmul" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_from_array([6.0, 5.0, 4.0, 3.0, 2.0, 1.0])
  let reshape_b = tensor_b.reshape([6, 1])
  let tensor_c = tensor_a.matmul(reshape_b)
  inspect(tensor_c, content="Tensor([56])")
}

///|
test "tensor_transpose" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let reshape_a = tensor_a.reshape([2, 3])
  let tensor_b = reshape_a.transpose()
  inspect(tensor_b, content="Tensor([[1, 4], [2, 5], [3, 6]])")
}

///|
test "tensor_length" {
  let tensor_a = tensor_from_array([1.0])
  let length = tensor_a.length()
  inspect(length, content="1")
  inspect(tensor_a, content="Tensor([1])")
  let tensor_b = tensor_a.reshape([])
  let length = tensor_b.length()
  inspect(length, content="1")
  inspect(tensor_b, content="Tensor(1)")
}

///|
test "tensor_shape" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let shape = tensor_a.shape()
  inspect(shape, content="[6]")
}

///|
test "tensor_argmin" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_a.argmin()
  inspect(tensor_b, content="Tensor(0)")
}

///|
test "tensor_argmax" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_a.argmax()
  inspect(tensor_b, content="Tensor(5)")
}

///|
test "tensor_allclose" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_c = tensor_from_array([6.0, 5.0, 4.0, 3.0, 2.0, 1.0])
  assert_true(tensor_a == tensor_b)
  assert_false(tensor_a == tensor_c)
}

///|
test "reshape" {
  let tensor_a = tensor_from_array([1.0, 2.0, 3.0, 4.0, 5.0, 6.0])
  let tensor_b = tensor_a.reshape([2, 3])
  inspect(tensor_a, content="Tensor([1, 2, 3, 4, 5, 6])")
  inspect(tensor_b, content="Tensor([[1, 2, 3], [4, 5, 6]])")
}
