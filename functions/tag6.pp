# For compatibility with puppet 4.6 return type is left
# out of the function signature, but `tag6` should return
# an Array

function datadog_agent::tag6(
  Variant[Array, String] $tag_names,
  Variant[String, Boolean] $lookup_fact = false,
) {
  if is_array($tag_names) {
    $tags = $tag_names.reduce([]) |$_tags , $tag| {
        concat($_tags, datadog_agent::tag6($tag, lookup_fact))
    }
  } elsif str2bool($lookup_fact) {
    $value = getvar($tag_names)

    if is_array($value){
      $tags = prefix($value, "${tag_name}:")
    }
  } else {
    $tags = [$tag_name]
  }

  $tags
}
