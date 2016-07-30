# coding=utf-8
import cython
cimport cython
import numpy as np
cimport numpy as np


def smith_waterman(unicode string1, unicode string2, float gap_cost, \
                                                             sim_func):

    cdef int i = 0
    cdef int j = 0
    cdef double match = 0.0
    cdef double delete = 0.0
    cdef double insert = 0.0
    cdef double simscore = 0.0

    # Converting char string into bytes
    # cdef bytes string1 = bytes(string1, "utf-8")
    # cdef bytes string2 = bytes(string2, "utf-8")

    cdef int len_s1 = len(string1)
    cdef int len_s2 = len(string2)

    # dist_mat = np.zeros((len(string1) + 1, len(string2) + 1), dtype=np.float)
    cdef double[:,:] dist_mat = np.zeros((len(string1) + 1, len(string2) + 1), dtype=np.float)

    # max_value = 0
    cdef double max_value = 0.0

    # This is an extra flag to see if the SimIdent function is being used
    # If it is, we can use the Cython version to improve performance
    cdef int setSimIdentFlag = 0
    if (sim_func.__name__ == "sim_ident"):
        setSimIdentFlag = 1

    if (setSimIdentFlag):
        # We will use the cython version of SimIdent function

        # Smith Waterman DP calculations
        # for i in xrange(1, len(string1) + 1):
        for i from 1 <= i < (len_s1 + 1):
            # for j in xrange(1, len(string2) + 1):
            for j from 1 <= j < (len_s2 + 1):

                # match = dist_mat[i - 1, j - 1] + self.sim_func(string1[i - 1], string2[j - 1])
                simfuncscore = 1.0 if (string1[i-1]==string2[j-1]) else 0.0
                match = dist_mat[i - 1, j - 1] + simfuncscore

                delete = dist_mat[i - 1, j] - gap_cost
                insert = dist_mat[i, j - 1] - gap_cost
                dist_mat[i, j] = max(0, match, delete, insert)
                max_value = max(max_value, dist_mat[i, j])
    else:
        # We cannot use the cython version of SimIdent function
        # We need to use the user defined function

        # Smith Waterman DP calculations
        # for i in xrange(1, len(string1) + 1):
        for i from 1 <= i < (len_s1 + 1):
            # for j in xrange(1, len(string2) + 1):
            for j from 1 <= j < (len_s2 + 1):

                # match = dist_mat[i - 1, j - 1] + self.sim_func(string1[i - 1], string2[j - 1])
                simfuncscore = sim_func(string1[i - 1], string2[j - 1])
                match = dist_mat[i - 1, j - 1] + simfuncscore

                delete = dist_mat[i - 1, j] - gap_cost
                insert = dist_mat[i, j - 1] - gap_cost
                dist_mat[i, j] = max(0, match, delete, insert)
                max_value = max(max_value, dist_mat[i, j])

    return max_value