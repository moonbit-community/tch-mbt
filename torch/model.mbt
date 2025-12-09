///|
pub struct Model {
  object : ModelObject
}

///|
pub fn load_model_from_file(path : String) -> Model {
  let path = mbt_string_to_utf8_bytes(path, true)
  let object = load_model_ffi(path)
  { object, }
}

///|
pub fn[U, V] Model::forward(self : Model, input : Tensor[U]) -> Tensor[V] {
  let object = forward_ffi(self.object, input.object)
  { object, }
}
