node default {
  notice("This node is configured in $environment")
}

Package {
  allow_virtual => true
}

stage { 'first':
  before => Stage['main']
}
stage { 'last': }
Stage['main'] -> Stage['last']
