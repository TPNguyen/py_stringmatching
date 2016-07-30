# coding=utf-8
from __future__ import division
cimport cython

import numpy as np
cimport numpy as np

import math


def cosine(s1, s2):
    cdef float len_set1 = len(s1)
    cdef float len_set2 = len(s2)
    cdef float sum_lens = len_set1 + len_set2
    if sum_lens == 0:
        return 1.0
    if len_set2 == 0 or len_set1 == 0:
        return 0.0
    cdef float len_intersection = len(s1&s2)
    sqrt_set1 = math.sqrt(len_set1)
    sqrt_set2 = math.sqrt(len_set2)

    return float(len_intersection) / (sqrt_set1*sqrt_set2)



