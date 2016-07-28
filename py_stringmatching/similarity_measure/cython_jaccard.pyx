from __future__ import division
cimport cython


cdef inline int int_min(int a, int b): return a if a <= b else b

def jaccard(s1, s2):
    cdef int len_set1 = len(s1)
    cdef int len_set2 = len(s2)
    cdef int sum_lens = len_set1 + len_set2

    if sum_lens == 0:
        return 1.0

    if int_min(len_set1, len_set2) == 0:
        return 0.0

    cdef int len_intersection = len(s1.intersection(s2))
    return float(len_intersection) / (sum_lens - len_intersection)

