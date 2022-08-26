import numpy as np

#!/usr/bin/python
#
# Based on the file created by Albert Au Yeung (2010) in Python2
# Useful blog post: http://www.quuxlabs.com/blog/2010/09/matrix-factorization-a-simple-tutorial-and-implementation-in-python/#source-code
# An implementation of matrix factorization
#

"""
@INPUT:
    R     : a matrix to be factorized, dimension N x M
    U     : an initial matrix of dimension N x K (latent user)
    V     : an initial matrix of dimension M x K (latent item)
    K     : the number of latent features
    steps : the maximum number of steps to perform the optimisation
    alpha : the learning rate
    beta  : the regularization parameter
@OUTPUT:
    the final matrices U and V
"""

def main():
    R = [
         [5,3,0,1],
         [4,0,0,1],
         [1,1,0,5],
         [1,0,0,4],
         [0,1,5,4],
        ]

    R = np.array(R)

    N = len(R)
    M = len(R[0])
    K = 2

    U = np.random.rand(N,K)
    V = np.random.rand(M,K)

    nU, nV = matrix_factorization(R, U, V, K)
    nR = np.dot(nU, nV.T)
    print(nR)
    return

def matrix_factorization(R, U, V, K, steps=5000, alpha=0.0002, lambda1=0.02, lambda2=0.02):
    V = V.T
    for step in range(steps):
        for i in range(len(R)):
            for j in range(len(R[i])):
                if R[i][j] > 0:
                    eij = R[i][j] - np.dot(U[i,:],V[:,j])
                    for q in range(K):
                        U[i][q] = U[i][q] + alpha * (eij * V[q][j] - lambda1 * U[i][q])
                        V[q][j] = V[q][j] + alpha * (eij * U[i][q] - lambda2 * V[q][j])
        # eR = np.dot(U,V)
        e = 0
        for i in range(len(R)):
            for j in range(len(R[i])):
                if R[i][j] > 0:
                    e = e + pow(R[i][j] - np.dot(U[i,:],V[:,j]), 2)
                    for k in range(K):
                        e = e + ((lambda1/2) * pow(U[i][k],2)) + ((lambda2/2) * pow(V[k][j],2))
        if e < 0.001:
            break
    return U, V.T

if __name__ == "__main__":
    main()
