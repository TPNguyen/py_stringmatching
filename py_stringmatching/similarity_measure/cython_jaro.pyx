# coding=utf-8
from __future__ import division
import cython
cimport cython

import numpy as np
cimport numpy as np

def jaro(unicode string1, unicode string2):
    cdef int i = 0
    cdef int low = 0
    cdef int high = 0
    cdef int j = 0
    cdef unsigned char ch_s1 = 0
    cdef int f_s1 = 0

    cdef int len_s1 = len(string1)
    cdef int len_s2 = len(string2)

    cdef int max_len = max(len_s1, len_s2)

    cdef int search_range = (max_len // 2) - 1

    if search_range < 0:
        search_range = 0


    cdef int[:] flags_s1 = np.zeros(len_s1, dtype=np.int32)
    cdef int[:] flags_s2 = np.zeros(len_s2, dtype=np.int32)

    cdef int common_chars=0

    for i from 0 <= i < len_s1:

        ch_s1 = string1[i]

        # low = i - search_range if i > search_range else 0
        low = i - search_range if i > search_range else 0

        # high = i + search_range if i + search_range < len_s2 else len_s2 - 1
        high = i + search_range if i + search_range < len_s2 else len_s2 - 1

        # for j in xrange(low, high + 1):
        for j from low <= j < (high + 1):

            # if not flags_s2[j] and string2[j] == ch_s1:
            if (flags_s2[j] == 0) and (string2[j] == ch_s1):
                # flags_s1[i] = flags_s2[j] = True 
                flags_s1[i] = flags_s2[j] = 1

                common_chars += 1
                break

    if common_chars == 0:
        return 0.0

    cdef int k = 0
    cdef int trans_count = 0

    # for i, f_s1 in enumerate(flags_s1):
    for i from 0 <= i < len_s1:
        # if f_s1:
        if (flags_s1[i] == 1):
            # for j in xrange(k, len_s2):
            for j from k <= j < len_s2:
                # if flags_s2[j]:
                if (flags_s2[j] == 1):
                    k = j + 1
                    break
            # if string1[i] != string2[j]: 
            if string1[i] != string2[j]:
                trans_count += 1

    trans_count /= 2

    # common_chars = float(common_chars)
    cdef float common_chars2 = float(common_chars)

    # weight = ((common_chars / len_s1 + common_chars / len_s2 + 
    #                           (common_chars - trans_count) / common_chars)) / 3 return weight

    cdef float weight = ((common_chars2 / len_s1 + common_chars2 / len_s2 +
               (common_chars2 - trans_count) / common_chars2)) / 3

    return weight

