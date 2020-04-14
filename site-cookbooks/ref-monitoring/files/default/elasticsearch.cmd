statusdat [ ElasticSearch_Health ] = /ip-*/:elasticsearch
state [ WARNING] = COUNT(WARNING) > 0
state [ CRITICAL ] = COUNT(CRITICAL) > 0 || COUNT(WARNING) > 1 || COUNT(UNKNOWN) > 1

