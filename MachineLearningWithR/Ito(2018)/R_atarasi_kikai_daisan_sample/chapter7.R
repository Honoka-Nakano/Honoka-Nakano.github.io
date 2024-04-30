## Machine-Learning-with-R/chapter7.R
## 2024-03-10
## Nakano Keisuke

## 準備
library(tidyverse)

# -- リスト 7-1-(1)
## import numpy as np
NULL

## # データ生成 ----------
## np.random.seed(seed=1)                # 乱数を固定
set.seed(1)
## N = 200                               # データの数
N <- 200
## K = 3                                 # 分布の数
K <- 3
## T = np.zeros((N, 3), dtype=np.uint8)  # 空のTを準備
t <- array(0, dim = c(N, 3)) # Tは予約語なのでtを使用
## X = np.zeros((N, 2))                  # 空のXを準備
X <- array(0, dim = c(N, 2))
## X0_min, X0_max = -3, 3                # X0の範囲、表示用
X0_min <- -3; X0_max <- 3
## X1_min, X1_max = -3, 3                # X1の範囲、表示用
X1_min <- -3; X1_max <- 3
## prm_mu = np.array([[-0.5, -0.5], [0.5, 1.0], [1, -0.5]])   # 分布の中心
prm_mu <- array(c(-0.5, 0.5, 1, -0.5, 1.0, -0.5), dim = c(3, 2))
## prm_sig = np.array([[0.7, 0.7], [0.8, 0.3], [0.3, 0.8]])   # 分布の分散
prm_sig <- array(c(0.7, 0.8, 0.3, 0.7, 0.3, 0.8), dim = c(3, 2))
## prm_pi = np.array([0.4, 0.8, 1])       # 各分布への割合を決めるパラメータ
prm_pi <- array(c(0.4, 0.8, 1), dim = c(1, 3))
## for n in range(N):
##   r = np.random.rand()
##   # 3クラス用の目標データTを作成
##   for k in range(K):
##     if r < prm_pi[k]:
##       T[n, k] = 1
##       break
##   # Tに対して入力データXを作成
##   for k in range(2):
##     X[n, k] =  \
##       np.random.randn() * prm_sig[T[n, :] == 1, k] \
##       + prm_mu[T[n, :] == 1, k]
for (n in 1:N) {
  r <- runif(1)
  for (k in 1:K) {
    if (r < prm_pi[k]) {
      t[n, k] <- 1
      break
    }
  }
  for (k in c(1, 2)) {
    X[n, k] <- rnorm(1) * prm_sig[t[n,] == 1, k] + prm_mu[t[n,] == 1, k]
  }
}


# リスト 7-1-(2)
## # 訓練データとテストデータに分割 ----------
## TrainingRatio = 0.5
TrainingRatio <- 0.5
## N_training = int(N * TrainingRatio)
N_training <- as.integer(N * TrainingRatio)
## X_train = X[:N_training, :]
X_train <- X[1:N_training,]
## X_test = X[N_training:, :]
X_test <- X[(N_training + 1):nrow(X),]
## T_train = T[:N_training, :]
T_train <- t[1:N_training,]
## T_test = T[N_training:, :]
T_test <- t[(N_training + 1):nrow(t),]

## # データの保存 ----------
## np.savez(
##   "ch7_data.npz",
##   X_train=X_train, T_train=T_train, X_test=X_test, T_test=T_test,
##   X0_min=X0_min, X0_max=X0_max, X1_min=X1_min, X1_max=X1_max,
## )
NULL


# リスト 7-1-(3)
## %matplotlib inline
## import matplotlib.pyplot as plt
NULL

## # データ表示 ----------
## def show_data(x, t):
##   K = t.shape[1]  # tの列数からクラス数を取得
##   col = ["gray", "white", "black"]
##   for k in range(K):
##     plt.plot(
##       x[t[:, k] == 1, 0], x[t[:, k] == 1, 1], col[k],
##       marker="o", linestyle="None",
##       markeredgecolor="black", alpha=0.8,
##     )
##   plt.xlim(X0_min, X0_max)
##   plt.ylim(X1_min, X1_max)
show_data <- function(x, t) {
  K <- ncol(t)
  col <- c('gray', 'white', 'black')
  df <- array(NA, dim = c(nrow(t), 3)) |>
                data.frame() |>
    rename(x0 = 'X1', x1 = 'X2', class = 'X3')
  for (i in 1:nrow(df)) {
    df[i, 1] <- x[i, 1]
    df[i, 2] <- x[i, 2]
    for (k in 1:K) {
      if (t[i, k] == 1) {
        df[i, 3] <- k
        break
      }
    }
  }
  p <- df |>
    ggplot() +
    geom_point(aes(x = x0, y = x1,
               color = as.factor(class),
               shape = as.factor(class))) +
    labs(x = element_blank(), y = element_blank())
  return(p)
}

## # メイン ----------
## plt.figure(figsize=(8, 3.7))
## # 訓練データ表示
## plt.subplot(1, 2, 1)
## show_data(X_train, T_train)
## plt.title("Training Data")
## plt.grid()
show_data(X_train, T_train) +
  xlim(X0_min, X0_max) + ylim(X1_min, X1_max) +
  coord_fixed(ratio = (X0_max - X0_min) / (X1_max - X1_min)) +
  scale_color_discrete(name = 'Class') +
  scale_shape_discrete(name = 'Class')
  
## # テストデータ表示
## plt.subplot(1, 2, 2)
## show_data(X_test, T_test)
## plt.title("Test Data")
## plt.grid()
## plt.show()
show_data(X_test, T_test) +
  xlim(X0_min, X0_max) + ylim(X1_min, X1_max) +
  coord_fixed(ratio = (X0_max - X0_min) / (X1_max - X1_min)) +
  scale_color_discrete(name = 'Class') +
  scale_shape_discrete(name = 'Class')


# リスト 7-1-(4)
## # シグモイド関数 ----------
## def sigmoid(a):
##   y = 1 / (1 + np.exp(-a))  # 式7-6
##   return y
sigmoid <- function(a) {
  y <- 1 / (1 + exp(-a))
  return(y)
}

## # ネットワーク  ----------
## def FNN(wv, M, K, x):
##   N, D = x.shape  # 入力次元
##   w = wv[: M * (D + 1)]     # 中間層ニューロンへの重み
##   w = w.reshape(M, (D + 1))
##   v = wv[M * (D + 1) :]     # 出力層ニューロンへの重み
##   v = v.reshape((K, M + 1))
##   b = np.zeros((N, M + 1))  # 中間層ニューロンの入力総和
##   z = np.zeros((N, M + 1))  # 中間層ニューロンの出力
##   a = np.zeros((N, K))      # 出力層ニューロンの入力総和
##   y = np.zeros((N, K))      # 出力層ニューロンの出力
##   for n in range(N):
##     # 式7-14、式7-15で中間層の出力zを計算
##     for m in range(M):
##       # (A) x[n, :]の末尾に1を加える
##       x_add1 = np.r_[x[n, :], 1]
##       b[n, m] = w[m, :] @ x_add1
##       z[n, m] = sigmoid(b[n, m])
##     # 式7-16、式7-17で出力層の出力yを計算
##     z[n, M] = 1  # ダミーニューロン
##   u = 0
##   for k in range(K):
##     a[n, k] = v[k, :] @ z[n, :]
##     u = u + np.exp(a[n, k])
##   for k in range(K):
##     y[n, k] = np.exp(a[n, k]) / u
## return y, a, z, b
FNN <- function(wv, M, K, x) {
  N <- nrow(x); D <- ncol(x)
  w <- wv[1:(M * (D + 1))]
  w <- array(w, dim = c(M, D + 1))
  v <- wv[(M * (D + 1) + 1):length(wv)]
  v <- array(v, dim = c(K, M + 1))
  b <- array(0, dim = c(N, M + 1))
  z <- array(0, dim = c(N, M + 1))
  a <- array(0, dim = c(N, K))
  y <- array(0, dim = c(N, K))
  for (n in 1:N) {
    for (m in 1:M) {
      x_add1 <- c(x[n,], 1)
      b[n, m] <- w[m,] %*% x_add1
      z[n, m] <- sigmoid(b[n, m])
    }
    z[n, M + 1] <- 1
    u <- 0
    for (k in 1:K) {
      a[n, k] <- v[k,] %*% z[n,]
      u <- u + exp(a[n, k])
    }
    for (k in 1:K) {
      y[n, k] <- exp(a[n, k]) / u
    }
  }
  return(list(y = y, a = a, z = z, b = b))
}

## # テスト ----------
## wv = np.ones(15)
wv <- rep(1, times = 15)
## M, K = 2, 3
M <- 2; K <- 3
## y, a, z, b = FNN(wv, M, K, X_train[:2, :])
res <- FNN(wv, M, K, X_train[1:2,])
## print("y =\n", np.round(y, 6))
print('y =')
print(round(res$y, 6))
## print("a =\n", np.round(a, 6))
print('a =')
print(round(res$a, 6))
## print("z =\n", np.round(z, 6))
print('z =')
print(round(res$z, 6))
## print("b =\n", np.round(b, 6))
print('b =')
print(round(res$b, 6))


# リスト 7-1-(5)
## # 平均交差エントロピー誤差 ----------
## def cee_FNN(wv, M, K, x, t):
##   N, D = x.shape
##   y, a, z, b = FNN(wv, M, K, x)
##   # (A) 式7-18の計算
##   cee = -(t.reshape(-1) @ np.log(y.reshape(-1))) / N
##   return cee
cee_FNN <- function(wv, M, K, x, t) {
  N <- nrow(x); D <- ncol(x)
  res <- FNN(wv, M, K, x)
  t_for_calc <- t(t) |>
    as.vector() |>
    as.array(dim = c(1, 6))
  y_for_calc <- t(res$y) |>
    as.vector() |>
    as.array(dim = x(6, 1))
  cee <- -(t_for_calc %*% log(y_for_calc)) / N
  return(cee)
}

# テスト ----------
## wv = np.ones(15)
wv <- rep(1, times = 15)
## M, K = 2, 3
M <- 2; K <- 3
## cee = cee_FNN(wv, M, K, X_train[:2, :], T_train[:2, :])
cee <- cee_FNN(wv, M, K, X_train[1:2,], T_train[1:2,])
## print(f"cee = {cee:.6}")
cat('cee =', cee)


# リスト 7-1-(6)
## # 平均交差エントロピー誤差の数値微分 ----------
## def dcee_FNN_num(wv, M, K, x, t):
##   epsilon = 0.001
##   dwv = np.zeros_like(wv)
##   # 式7-20の計算
##   for iwv in range(len(wv)):
##     wv_shifted = wv.copy()
##     wv_shifted[iwv] = wv[iwv] + epsilon
##     mse1 = cee_FNN(wv_shifted, M, K, x, t)
##     wv_shifted[iwv] = wv[iwv] - epsilon
##     mse2 = cee_FNN(wv_shifted, M, K, x, t)
##     dwv[iwv] = (mse1 - mse2) / (2 * epsilon)
##   return dwv
dcee_FNN_num <- function(wv, M, K, x, t) {
  epsilon <- 0.001
  dwv <- array(0, dim = c(1, ncol(wv)))
  for (iwv in 1:length(wv)) {
    wv_shifted <- wv
    wv_shifted[iwv] <- wv[iwv] + epsilon
    mse1 <- cee_FNN(wv_shifted, M, K, x, t)
    wv_shifted[iwv] <- wv[iwv] - epsilon
    mse2 <- cee_FNN(wv_shifted, M, K, x, t)
    dwv[iwv] <- (mse1 - mse2) / (2 * epsilon)
  }
  return(dwv)
}

## # -- dwvの棒グラフによる表示 ----------
## def show_dwv(dwv, D, M):
##   v_start = M * (D + 1)     # v の始めのインデックス
##   v_end = dwv.shape[0] - 1  # v の最後のインデックス
##   plt.bar(  # dwの表示
##     range(0, v_start), dwv[:v_start],
##     color="black", align="center",
##   )
##   plt.bar(  # dvの表示
##     range(v_start, v_end + 1), dwv[v_start:],
##     color="cornflowerblue", align="center",
##   )
##   plt.xticks(range(0, v_end + 1))
##   plt.xlim(-1, v_end + 1)
show_dwv(dwv, D, M) {
  
}

## # テスト ----------
## D, M, K, N = 2, 2, 3, 2
D <- 2; M <- 2; K <- 3; N <- 2
## wv_n = M * (D + 1) + K * (M + 1)
wv_n <- M * (D + 1) + K * (M + 1)
## np.random.seed(seed=1)
set.seed(1)
## wv = np.random.normal(
##   0.0, 1.0, wv_n)  # 平均0.0分散1.0のwv_n個の乱数
wv <- rnorm(wv_n)
## dwv = dcee_FNN_num(
##   wv, M, K, X_train[:N, :], T_train[:N, :])
dwv <- dcee_FNN_num(wv, M, K, X_train[1:N,], T_train[1:N,])
## print("numerical dwv")
print('numerical dwv')
## print("dwv =\n", np.round(dwv, 6))
cat('dwv =', round(dwv, 6))

## # グラフ描画 ----------
## plt.figure(figsize=(5, 3))
## show_dwv(dwv, D, M)
## plt.show()
df <- tibble(dwv = dwv) |>
  mutate(id = 1:n(),
         color = c(rep(0, times = 1:(M * (D + 1)) |> length()),
                   rep(1, times = ((M * (D + 1) + 1):length(dwv)) |>
                         length())))
df |>
  ggplot() +
  geom_bar(aes(x = as.factor(id), y = dwv, fill = as.factor(color)),
           stat = 'identity') +
  labs(x = element_blank(), y = element_blank()) +
  ylim(-0.4, 0.4) +
  coord_fixed(ratio = 15 / 0.8) +
  theme(legend.position = 'none')


# リスト 7-1-(7)
## import time
NULL

## # 数値微分を使った勾配法 -------
## def fit_FNN_num(
##   wv_init, M, K,
##   x_train, t_train, x_test, t_test,
##   tau_max, alpha,
## ):
##   # 訓練データの誤差の履歴保存用
##   cee_train = np.zeros(tau_max)
##   # テストデータの誤差の履歴保存用
##   cee_test = np.zeros(tau_max)
##   # wv の履歴保存用
##   wv = np.zeros((tau_max, len(wv_init)))
##   # wv の初期値をセットし、そのときの誤差を計算
##   wv[0, :] = wv_init
##   cee_train[0] = cee_FNN(wv_init, M, K, x_train, t_train)
##   cee_test[0] = cee_FNN(wv_init, M, K, x_test, t_test)
##   # 勾配法
##   for tau in range(tau_max - 1):  # (A)
##     dcee = dcee_FNN_num(wv[tau, :], M, K, x_train, t_train)
##     wv[tau + 1, :] = wv[tau, :] - alpha * dcee
##     cee_train[tau + 1] = \
##       cee_FNN(wv[tau + 1, :], M, K, x_train, t_train)
##     cee_test[tau + 1] = \
##       cee_FNN(wv[tau + 1, :], M, K, x_test, t_test)
##   wv_final = wv[-1, :]
##   return wv_final, wv, cee_train, cee_test
fit_FNN_num <- function(wv_init, M, K, x_train, t_train,
                        x_test, t_test, tau_max, alpha) {
  cee_train <- array(0, dim = c(1, tau_max))
  cee_test <- array(0, dim = c(1, tau_max))
  wv <- array(0, dim = c(tau_max, length(wv_init)))
  wv[1,] <- wv_init
  cee_train[1] <- cee_FNN(wv_init, M, K, x_train, t_train)
  cee_test[1] <- cee_FNN(wv_init, M, K, x_test, t_test)
  for (tau in 1:(tau_max - 1)) {
    dcee <- dcee_FNN_num(wv[tau,], M, K, x_train, t_train)
    wv[tau + 1,] <- wv[tau,] - alpha * dcee
    cee_train[tau + 1] <- cee_FNN(wv[tau + 1,], M, K, x_train, t_train)
    cee_test[tau + 1] <- cee_FNN(wv[tau + 1,], M, K, x_test, t_test)
  }
  wv_final <- wv[-1,]
  return(list(wv_final = wv_final, wv = wv, cee_train = cee_train, cee_test = cee_test))
}

## # メイン ----------
## start_time = time.time()
NULL
## D, M, K = 2, 2, 3
D <- 2; M <- 2; K <- 3
## wv_n = M * (D + 1) + K * (M + 1)
wv_n <- M * (D + 1) + K * (M + 1)
## np.random.seed(seed=1)
set.seed(1)
## wv_init = np.random.normal(0, 0.01, wv_n)  # wvの初期値
wv_init <- rnorm(wv_n)
## tau_max = 1000  # (B) 学習ステップ
tau_max <- 1000
## alpha = 0.5
alpha <- 0.5
## # 勾配法でwvを計算
## wv, wv_hist, cee_train, cee_test = \
## fit_FNN_num(
##   wv_init, M, K,
##   X_train, T_train, X_test, T_test,
##   tau_max, alpha,
## )
res <- fit_FNN_num(wv_init, M, K, X_train, T_train, X_test, T_test,
                   tau_max, alpha)
## # 計算時間の表示
## calculation_time = time.time() - start_time
NULL
## print(f"Calculation time:{calculation_time:.2f} sec")
NULL


# リスト 7-1-(8)
## # 学習誤差の表示 ----------
## plt.figure(figsize=(3, 3))
## plt.plot(cee_train, "black", label="training")
## plt.plot(cee_test, "cornflowerblue", label="test")
## plt.legend()
## plt.show()
tibble(tau = rep(1:tau_max, times = 2),
       cee = c(res$cee_train, res$cee_test),
       type = rep(c('train', 'test'), each = tau_max)) |>
  ggplot() +
  geom_line(aes(x = tau, y = cee, color = type)) +
  labs(x = element_blank(), y = element_blank()) +
  xlim(0, 1000) + ylim(0, 2) +
  coord_fixed(ratio = 1000 / 2) +
  theme(legend.position = 'none')


# リスト 7-1-(9)
## # 重みの時間発展の表示 ----------
## plt.figure(figsize=(3, 3))
## v_start = M * (D + 1)  # v の始めのインデックス
## plt.plot(wv_hist[:, :v_start], "black")
## plt.plot(wv_hist[:, v_start:], "cornflowerblue")
## plt.show()
as.data.frame(res$wv) |>
  pivot_longer(cols = c(1:ncol(res$wv)),
               names_to = 'col',
               values_to = 'wv',
               names_prefix = 'V') |>
  mutate(tau = rep(1:tau_max, each = ncol(res$wv))) |>
  ggplot() +
  geom_line(aes(x = tau, y = wv, color = col)) +
  scale_color_manual(values = c(rep('black', times = c(1:(M * (D + 1))) |>
                                      length()),
                                rep('cornflowerblue', times = c((M * (D + 1) + 1):ncol(res$wv)) |>
                                      length()))) +
  labs(x = element_blank(), y = element_blank()) +
  xlim(0, 1000) + ylim(-6, 8) +
  coord_fixed(ratio = 1000 / 14) +
  theme(legend.position = 'none')

######## プロットに苦戦 ########

# リスト 7-1-(10)
## # 境界線表示関数 ----------
## def show_FNN(wv, M, K):
##     x0_n, x1_n = 60, 60  # 等高線表示の解像度
##     x0 = np.linspace(X0_min, X0_max, x0_n)
##     x1 = np.linspace(X1_min, X1_max, x1_n)
##     xx0, xx1 = np.meshgrid(x0, x1)
##     # xx0とxx1を1次元ベクトルに展開し、
##     # それぞれを0列目と1行目に配置した行列xを作る
##     x = np.c_[xx0.reshape(-1), xx1.reshape(-1)]
##     # 行列xに対するyを一度に求める
##     y, a, z, b = FNN(wv, M, K, x)
##     for ic in range(K):
##         f = y[:, ic]
##         f = f.reshape(x1_n, x0_n)
##         cont = plt.contour(  # 等高線表示
##             xx0, xx1, f,
##             levels=[0.5, 0.9], colors=["cornflowerblue", "black"],
##         )
##         cont.clabel(fmt="%.2f", fontsize=9)
##     plt.xlim(X0_min, X0_max)
##     plt.ylim(X1_min, X1_max)
show_FNN <- function(wv, M, K) {
  x0_n <- 60; x1_n <- 60
  x0 <- seq(X0_min, X0_max, length.out = x0_n)
  x1 <- seq(X1_min, X1_max, length.out = x1_n)
  xx0 <- as.array(matrix(x0, nrow = x0_n, ncol = x1_n, byrow = TRUE))
  xx1 <- array(x1, dim = c(x0_n, x1_n))
  x <- array(NA, dim = c(x0_n * x1_n, 2))
  x[, 1] <- rep(x0, times = x0_n)
  x[, 2] <- rep(x1, each = x1_n)
  res <- FNN(wv, M, K, x)
  # for (ic in 1:K) {
  #   f <- res$y[, ic]
  # }
  df <- as.data.frame(x) |>
    rename(x0 = 'V1', x1 = 'V2') |>
    mutate(y1 = res$y[,1],
           y2 = res$y[,2],
           y3 = res$y[,3])
  df |>
    ggplot(aes(x = x0, y = x1)) +
    geom_contour(aes(z = y3), breaks = 0.8372)
}

## # 境界線の表示 ----------
## plt.figure(figsize=(3, 3))
## show_data(X_test, T_test)
## show_FNN(wv, M, K)
## plt.grid()
## plt.show()


# リスト 7-1-(11)
## # -- 解析的微分 ----------
## def dcee_FNN(wv, M, K, x, t):
##     N, D = x.shape
##     # wv を w と v に戻す
##     v_start = M * (D + 1)
##     w = wv[:v_start]
##     w = w.reshape(M, D + 1)
##     v = wv[v_start:]
##     v = v.reshape(K, M + 1)
##     # ① 入力xを入れて出力yを得る
##     y, a, z, b = FNN(wv, M, K, x)
##     # 出力変数の準備
##     dwv = np.zeros_like(wv)
##     dw = np.zeros((M, D + 1))
##     dv = np.zeros((K, M + 1))
##     delta1 = np.zeros(M)  # 1 層目誤差
##     delta2 = np.zeros(K)  # 2 層目誤差 (k=0 の部分は使わず)
##     for n in range(N):  # (A)
##         # ② 2層（出力層）の誤差を得る
##         for k in range(K):
##             delta2[k] = y[n, k] - t[n, k]
##         # ③ 1層（中間層）の誤差を得る
##         for j in range(M):
##             delta1[j] = z[n, j] * (1 - z[n, j]) * v[:, j] @ delta2
##         # ④ vの更新分（dv）を得る
##         for k in range(K):
##             dv[k, :] = dv[k, :] + delta2[k] * z[n, :] / N
##         # ④ wの更新分（dw）を得る
##         for j in range(M):
##             x_add1 = np.r_[x[n, :], 1]
##             dw[j, :] = dw[j, :] + delta1[j] * x_add1 / N
##     # dw と dv を合体させて dwv とする
##     dwv = np.c_[
##         dw.reshape((1, M * (D + 1))),
##         dv.reshape((1, K * (M + 1))),
##     ]
##     dwv = dwv.reshape(-1)
##     return dwv
dcee_FNN <- function(wv, M, K, x, t) {
  N <- nrow(x); D <- ncol(x)
  v_start <- M * (D + 1)
  w <- wv[1:v_start]
  w <- array(w, dim = c(M, D + 1))
  # w <- as.array(matrix(w, nrow = M, ncol = D + 1, byrow = TRUE))
  v <- wv[v_start:length(wv)]
  v <- array(v, dim = c(K, M + 1))
  # v <- as.array(matrix(v, nrow = K, ncol = M + 1, byrow = TRUE))
  res <- FNN(wv, M, K, x)
  # dwv <- array(0, dim = c(1, length(wv)))
  dw <- array(0, dim = c(M, D + 1))
  dv <- array(0, dim = c(K, M + 1))
  delta1 <- array(0, dim = c(1, M))
  delta2 <- array(0, dim = c(1, K))
  for (n in 1:N) {
    for (k in 1:K) {
      delta2[k] <- res$y[n, k] - t[n, k]
    }
    for (j in 1:M) {
      delta1[j] <- res$z[n, j] * (1 - res$z[n, j]) * t(v[, j]) %*% t(delta2)
    }
    for (k in 1:K) {
      dv[k,] <- dv[k,] + delta2[k] * res$z[n,] / N
    }
    for (j in 1:M) {
      x_add1 <- array(c(x[n,], 1), dim = c(1, ncol(x) + 1))
      dw[j,] <- dw[j,] + delta1[j] * x_add1 / N
    }
    return(c(dw, dv))
  }
}

## # テスト ----------
## D, M, K, N = 2, 2, 3, 2
D <- 2; M <- 2; K <- 3; N <- 2
## wv_n = M * (D + 1) + K * (M + 1)
wv_n <- M * (D + 1) + K + (M + 1)
## np.random.seed(seed=1)
set.seed(1)
## wv = np.random.normal(0.0, 1.0, wv_n)
wv <- rnorm(wv_n)
## dwv_ana = dcee_FNN(wv, M, K, X_train[:N, :], T_train[:N, :])
dwv_ana <- dcee_FNN(wv, M, K, X_train[1:N,], T_train[1:N,])
## dwv_num = dcee_FNN_num(wv, M, K, X_train[:N, :], T_train[:N, :])
dwv_num <- dcee_FNN_num(wv, M, K, X_train[1:N,], T_train[1:N,])
## # 結果表示
## print("analytical dwv")
cat('analytical dwv')
## print("dwv =\n", np.round(dwv_ana, 6))
cat('dwv =', round(dwv_ana, 6))
## print("numerical dwv")
cat('numerical dwv')
## print("dwv =\n", np.round(dwv_num, 6))
cat('dwv =', round(dwv_num, 6))

## # グラフ描画 ----------
## plt.figure(figsize=(8, 3))
## plt.subplots_adjust(wspace=0.5)
## # 解析的微分
## plt.subplot(1, 2, 1)
## show_dwv(dwv_ana, D, M)
## plt.title("analitical")
## # 数値微分
## plt.subplot(1, 2, 2)
## show_dwv(dwv_num, D, M)
## plt.title("numerical")
## plt.show()
tibble(ana = dwv_ana, num = dwv_num) |>
  mutate(id = 1:n(),
         col = rep('w', times = v_start)) |>
  ggplot() +
  geom_bar(aes(x = id, y = ana),)


# dcee_FNN関数内w, vの要素の並び．
# for delta1 <- のとこ，転置してよかったか
