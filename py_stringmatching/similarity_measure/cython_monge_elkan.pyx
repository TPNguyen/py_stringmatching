# coding=utf-8
from __future__ import division
import cython
cimport cython

import numpy as np
cimport numpy as np

from py_stringmatching.similarity_measure.cython_jaro_winkler import jaro_winkler

def monge_elkan(bag1, bag2, sim_func, jw_flag=False):
    cdef float sum_of_maxes = 0.0
    cdef float float_neg_inf = -float("inf")
    cdef float max_sim = 0.0
    cdef int len1 = len(bag1)
    cdef int len2 = len(bag2)
    cdef int sim_jw_flag = 0


    if len1 == 0 and len2 == 0:
        return 1.0

    if len1 == 0 or len2 == 0:
        return 0
    if jw_flag == False:
        for el1 in bag1:
            max_sim = float_neg_inf
            for el2 in bag2:
                max_sim = max(max_sim, sim_func(el1, el2))
            sum_of_maxes += max_sim
    else:
        for el1 in bag1:
            max_sim = float_neg_inf
            for el2 in bag2:
                max_sim = max(max_sim, jaro_winkler(el1, el2, 0.1))
            sum_of_maxes += max_sim

    return sum_of_maxes/len1



