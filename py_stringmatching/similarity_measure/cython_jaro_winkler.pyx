# coding=utf-8
from __future__ import division
import cython
cimport cython

import numpy as np
cimport numpy as np

from py_stringmatching.similarity_measure.cython_jaro import jaro

def jaro_winkler(unicode string1, unicode string2, float prefix_weight):
    cdef float jw_score = jaro(string1, string2)
    cdef int min_len = min(len(string1), len(string2))

    cdef int j = min(min_len, 4)
    cdef int i = 0
    while i < j and string1[i] == string2[i] and string1[i]:
        i += 1

    if i != 0:
        jw_score += i * prefix_weight * (1 - jw_score)

    return jw_score
