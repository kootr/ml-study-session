import numpy as np

#!/usr/bin/python
#
# Based on the file created by Albert Au Yeung (2010) in Python2
# Useful blog post: http://www.quuxlabs.com/blog/2010/09/matrix-factorization-a-simple-tutorial-and-implementation-in-python/#source-code
# An implementation of matrix factorization
#

"""
@INPUT:
    R           : a matrix to be factorized, dimension N x M
    U           : an initial matrix of dimension N x K (latent user)
    V           : an initial matrix of dimension M x K (latent item)
    K           : the number of latent features
    steps       : the maximum number of steps to perform the optimisation
    alpha       : the learning rate
    lambda1,2   : the regularization parameter
@OUTPUT:
    the final matrices U and V
"""
np.random.seed(314)

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

    U_init = np.random.rand(N,K) # ランダムな値で初期化
    V_init = np.random.rand(M,K) 

    U, V = matrix_factorization(R, U_init, V_init, K)
    R_hat = np.dot(U, V.T)
    print(R_hat)
    return

def matrix_factorization(R, U, V, K, steps=5000, alpha=0.0002, lambda1=0.02, lambda2=0.02):
    V = V.T
    for step in range(steps):
        U, V = _update_parameter(R, U, V, K, alpha, lambda1, lambda2)
        e = _calc_objective_funcion(R, U, V, K, lambda1, lambda2)
        if e < 0.001: # 収束
            break
    return U, V.T


def _update_parameter(R, U, V, K, alpha, lambda1, lambda2):
    """勾配降下法によるパラメータ更新"""
    for i in range(len(R)):
        for j in range(len(R[i])):
            if R[i][j] > 0: # 未評価のアイテムは計算しない
                eij = R[i][j] - np.dot(U[i,:],V[:,j])
                for q in range(K):
                    U[i][q] = U[i][q] + alpha * (eij * V[q][j] - lambda1 * U[i][q])
                    V[q][j] = V[q][j] + alpha * (eij * U[i][q] - lambda2 * V[q][j])
    return U, V

def _calc_objective_funcion(R, U, V, K, lambda1, lambda2):
    """目的関数の計算"""
    e = 0
    for i in range(len(R)): # Number of users
        for j in range(len(R[i])): # Number of items
            if R[i][j] > 0: # 未評価のアイテムは計算しない
                eij = R[i][j] - np.dot(U[i,:],V[:,j])
                e = e + pow(eij, 2) # 二乗誤差
                for k in range(K): # 正則化項
                    e = e + ((lambda1/2) * pow(U[i][k],2)) + ((lambda2/2) * pow(V[k][j],2))
    return e

if __name__ == "__main__":
    main()