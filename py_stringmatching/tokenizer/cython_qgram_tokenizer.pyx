cimport numpy
import numpy
from six.moves import xrange

def qgram_tok(unicode input_string, int qval, padding,  prefix_pad, \
                                         suffix_pad):

    qgram_list = []

    # If the padding flag is set to true, add q-1 "prefix_pad" characters
    # in front of the input string and  add q-1 "suffix_pad" characters at
    # the end of the input string.
    if padding:
        input_string = (prefix_pad * (qval - 1)) + input_string \
                       + (suffix_pad * (qval - 1))

    if len(input_string) < qval:
        return qgram_list

    qgram_list = [input_string[i:i + qval] for i in
                  xrange(len(input_string) - (qval - 1))]
    qgram_list = list(filter(None, qgram_list))
    return qgram_list