///|
fn bytes_to_float_array(bytes : Bytes) -> Array[Float] {
  let n = bytes.length() / 4
  let floats : Array[Float] = Array::new(capacity=n)
  for i in 0..<n {
    let i = i * 4
    let float_int = bytes[i].to_uint() +
      (bytes[i + 1].to_uint() << 8) +
      (bytes[i + 2].to_uint() << 16) +
      (bytes[i + 3].to_uint() << 24)
    floats.push(Float::reinterpret_from_uint(float_int))
  }
  floats
}

///|
fn float_array_to_bytes(floats : Array[Float]) -> Bytes {
  let n = floats.length()
  let bytes_arr : Array[Byte] = []
  for i in 0..<n {
    let float_int = floats[i].reinterpret_as_int()
    bytes_arr.push((float_int & 0xff).to_byte())
    bytes_arr.push(((float_int >> 8) & 0xff).to_byte())
    bytes_arr.push(((float_int >> 16) & 0xff).to_byte())
    bytes_arr.push(((float_int >> 24) & 0xff).to_byte())
  }
  Bytes::from_array(bytes_arr)
}

///|
fn bytes_to_double_array(bytes : Bytes) -> Array[Double] {
  let n = bytes.length() / 8
  let doubles : Array[Double] = Array::new(capacity=n)
  for i in 0..<n {
    let i = i * 8
    let double_int = bytes[i].to_uint64() +
      (bytes[i + 1].to_uint64() << 8) +
      (bytes[i + 2].to_uint64() << 16) +
      (bytes[i + 3].to_uint64() << 24) +
      (bytes[i + 4].to_uint64() << 32) +
      (bytes[i + 5].to_uint64() << 40) +
      (bytes[i + 6].to_uint64() << 48) +
      (bytes[i + 7].to_uint64() << 56)
    doubles.push(double_int.reinterpret_as_double())
  }
  doubles
}

///|
fn double_array_to_bytes(doubles : Array[Double]) -> Bytes {
  let n = doubles.length()
  let bytes_arr : Array[Byte] = []
  for i in 0..<n {
    let double_int_bytes = doubles[i].reinterpret_as_uint64().to_le_bytes()
    for j in 0..<8 {
      bytes_arr.push(double_int_bytes[j])
    }
  }
  Bytes::from_array(bytes_arr)
}

///|
fn bytes_to_int_array(bytes : Bytes) -> Array[Int] {
  let n = bytes.length() / 4
  let ints : Array[Int] = Array::new(capacity=n)
  for i in 0..<n {
    let i = i * 4
    let int = bytes[i].to_uint() +
      (bytes[i + 1].to_uint() << 8) +
      (bytes[i + 2].to_uint() << 16) +
      (bytes[i + 3].to_uint() << 24)
    ints.push(int.reinterpret_as_int())
  }
  ints
}

///|
fn int_array_to_bytes(ints : Array[Int]) -> Bytes {
  let n = ints.length()
  let bytes_arr : Array[Byte] = []
  for i in 0..<n {
    let int_val = ints[i]
    bytes_arr.push((int_val & 0xff).to_byte())
    bytes_arr.push(((int_val >> 8) & 0xff).to_byte())
    bytes_arr.push(((int_val >> 16) & 0xff).to_byte())
    bytes_arr.push(((int_val >> 24) & 0xff).to_byte())
  }
  Bytes::from_array(bytes_arr)
}

///|
fn bytes_to_int_16_array(bytes : Bytes) -> Array[Int16] {
  let n = bytes.length() / 2
  let ints : Array[Int16] = Array::new(capacity=n)
  for i in 0..<n {
    // let i = i * 2
    // let int = bytes[i].to_uint() + (bytes[i + 1].to_uint() << 8)
    // TODO: FIXME
    // ints.push(int.reinterpret_as_int16())
  }
  ints
}

///|
fn int_16_array_to_bytes(ints : Array[Int16]) -> Bytes {
  let n = ints.length()
  let bytes_arr : Array[Byte] = []
  for i in 0..<n {
    bytes_arr.push((ints[i].to_int() & 0xff).to_byte())
    bytes_arr.push(((ints[i].to_int() >> 8) & 0xff).to_byte())
  }
  Bytes::from_array(bytes_arr)
}

///|
fn bytes_to_int_64_array(bytes : Bytes) -> Array[Int64] {
  let n = bytes.length() / 8
  let ints : Array[Int64] = Array::new(capacity=n)
  for i in 0..<n {
    let i = i * 8
    let int = bytes[i].to_uint64() +
      (bytes[i + 1].to_uint64() << 8) +
      (bytes[i + 2].to_uint64() << 16) +
      (bytes[i + 3].to_uint64() << 24) +
      (bytes[i + 4].to_uint64() << 32) +
      (bytes[i + 5].to_uint64() << 40) +
      (bytes[i + 6].to_uint64() << 48) +
      (bytes[i + 7].to_uint64() << 56)
    ints.push(int.reinterpret_as_int64())
  }
  ints
}

///|
fn int_64_array_to_bytes(ints : Array[Int64]) -> Bytes {
  let n = ints.length()
  let bytes_arr : Array[Byte] = []
  for i in 0..<n {
    let int_val = ints[i]
    bytes_arr.push((int_val & 0xffL).to_byte())
    bytes_arr.push(((int_val >> 8) & 0xffL).to_byte())
    bytes_arr.push(((int_val >> 16) & 0xffL).to_byte())
    bytes_arr.push(((int_val >> 24) & 0xffL).to_byte())
    bytes_arr.push(((int_val >> 32) & 0xffL).to_byte())
    bytes_arr.push(((int_val >> 40) & 0xffL).to_byte())
    bytes_arr.push(((int_val >> 48) & 0xffL).to_byte())
    bytes_arr.push(((int_val >> 56) & 0xffL).to_byte())
  }
  Bytes::from_array(bytes_arr)
}
