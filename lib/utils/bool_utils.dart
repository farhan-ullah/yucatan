bool parseBool(String str) {
  if(str == null) return false;
  else return str.toLowerCase() == 'true';
}

bool shuffelActivitysList = false;
int shuffleCounter = 0;