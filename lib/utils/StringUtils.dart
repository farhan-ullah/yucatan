String? trimLeading(String pattern, String from) {
  if(from == null) return null;
  else if(pattern == null) return from;
  else {
    int i = 0;
    while (from.startsWith(pattern, i)) i += pattern.length;
    return from.substring(i);
  }
}

bool isNotNullOrEmpty(String str){
  return str != null && str.isNotEmpty;
}

///check for null or empty or string
bool checkIfNullOrEmpty(String str){
  return  (str != null && str.trim().isNotEmpty);
}

