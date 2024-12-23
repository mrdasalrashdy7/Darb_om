String anonymizeName(String name) {
  return name.length > 6
      ? "${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}"
      : "${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}";
}
