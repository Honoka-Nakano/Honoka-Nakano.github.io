## Machine-Learning-with-R/chapter6.R
## 2024-03-08
## Nakano Keisuke

# 準備
library(tidyverse)


# リスト 6-1-(1)
## %matplotlib inline
## import numpy as np
## import matplotlib.pyplot as plt
NULL

## # データ生成 ----------
## np.random.seed(seed=0)             # 乱数を固定
set.seed(0)
## X_min, X_max = 0, 2.5              # x の上限と下限（表示用）
X_min <- 0; X_max <- 2.5
## N = 30                             # データ数
N <- 30
## col = ["cornflowerblue", "gray"]   # クラス0と1の表示色
col <- c('cornflowerblue', 'gray')
## X = np.zeros(N)                    # 空のXを準備
X <- rep(NA, times = N)
## T = np.zeros(N, dtype=np.uint8)    # 空のTを準備
t <- rep(NA, times = N)
## prm_s = [0.4, 0.8]                 # クラス0と1の分布の開始地点
prm_s <- c(0.4, 0.8)
## prm_w = [0.8, 1.6]                 # クラス0と1の分布の幅
prm_w = c(0.8, 1.6)
## prm_pi = 0.5                       # クラス0の全体に対する比率
prm_pi <- 0.5
## for n in range(N):
##   r = np.random.rand()
##   T[n] = 0 * (r < prm_pi) + 1 * (r >= prm_pi)          # (A)
##   X[n] = prm_s[T[n]] + np.random.rand() * prm_w[T[n]]  # (B)
for (n in 1:N) {
  r <- runif(1)
  t[n] <- 0 * (r < prm_pi) + 1 * (r >= prm_pi)
  X[n] <- prm_s[t[n] + 1] + runif(1) * prm_w[t[n] + 1]
}
# データ表示
## print("X =", np.round(X, 2))
cat('X =', round(X, 2))
## print("T =", T)
cat('T =', t)


# リスト 6-1-(2)
## # データ分布表示 ----------
## def show_data1d(x, t):
##   for k in range(2):  # (A) k=0、1 のループ
##     plt.plot(       # (B) 分布を表示
##       x[t == k], t[t == k], col[k],
##       alpha=0.5, linestyle="none", marker="o",
##     )
##   plt.xticks(np.arange(0, 3, 0.5))
##   plt.yticks([0, 1])
##   plt.xlim(X_min, X_max)
##   plt.ylim(-0.5, 1.5)
show_data1d <- function(x, t) {
  df <- tibble(x = x, t = t)
  p <- df |>
    ggplot() +
    geom_point(aes(x = x, y = t,
                   color = as.factor(t)))
  return(p)
}

## # メイン ----------
## fig = plt.figure(ﬁgsize=(3, 3))
## show_data1d(X, T)
## plt.grid()
## plt.show()
show_data1d(X, t) +
  labs(x = element_blank(), y = element_blank()) +
  xlim(X_min, X_max) + ylim(0, 1) +
  coord_fixed(ratio = abs(X_min - X_max) / 1) +
  scale_y_continuous(breaks = c(0, 1),
                     labels = c(0, 1)) +
  theme(legend.position = 'none')


# リスト 6-1-(3)
## # ロジスティック回帰モデル ----------
## def logistic(x, w):
##   y = 1 / (1 + np.exp(-(w[0] * x + w[1])))  # 式6-10
##   return y
logistic <- function(x, w) {
  y <- 1 / (1 + exp(-(w[1] * x + w[2])))
  return(y)
}


# リスト 6-1-(4)
## # ロジスティック回帰モデルの表示 ----------
## def show_logistic(w):
##   x = np.linspace(X_min, X_max, 100)
##   y = logistic(x, w)
##   plt.plot(x, y, "gray", linewidth=4)
##   # 決定境界
##   i = np.min(np.where(y > 0.5))     # (A)
##   boundary = (x[i - 1] + x[i]) / 2  # (B)
##   plt.plot([boundary, boundary], [-0.5, 1.5], "black", linestyle="--")
##   return boundary
show_logistic <- function(w) {
  x <- seq(X_min, X_max, length.out = 100)
  y <- logistic(x, w)
  df <- tibble(x = x, y = y) |>
    mutate(id = 1:n())
  p <- df |>
    ggplot() +
    geom_line(aes(x = x, y = y),
              color = 'gray')
  i <- df |>
    filter(y > 0.5) |>
    filter(y == min(y))
  boundary <- (x[i$id - 1] + x[i$id]) / 2
  p <- p +
    geom_vline(xintercept = boundary, linetype = 'dashed')
  return(list(p = p, boundry = boundary))
}

## # テスト ----------
## w = np.array([8, -10])
w <- c(8, -10)
## b = show_logistic(w)
b <- show_logistic(w)
## ## print(f'decision boundary = {b}')
cat('dicision boundary =', b$boundry)
## ## plt.grid()
## ## plt.show()
plot(b$p)


# リスト 6-1-(5)
## # 平均交差エントロピー誤差 ----------
## def cee_logistic(w, x, t):
##   y = logistic(x, w)
##   # 式6-16の計算
##   cee = 0
##   for n in range(len(y)):
##     cee = cee - (t[n] * np.log(y[n]) + (1 - t[n]) * np.log(1 - y[n]))
##   cee = cee / N
##   return cee
cee_logistic <- function(w, x, t) {
  y <- logistic(x, w)
  cee <- 0
  for (n in 1:length(y)) {
    cee <- cee - (t[n] * log(y[n]) + (1 - t[n]) * log(1 - y[n]))
  }
  cee <- cee / N
  return(cee)
}

## # テスト ----------
## w = np.array([1, 1])
w <- c(1, 1)
## cee = cee_logistic(w, X, T)
cee <- cee_logistic(w, X, t)
## print(f"CEE = {cee:.6f}")
cat('CEE =', round(cee, 6))


# リスト 6-1-(6)
## # 平均交差エントロピー誤差の計算 ----------
## w0_n, w1_n = 80, 80  # 等高線表示の解像度
w0_n <- 80; w1_n <- 80
## w0_min, w0_max = 0, 15
w0_min <- 0; w0_max <- 15
## w1_min, w1_max = -15, 0
w1_min <- -15; w1_max <- 0
## w0 = np.linspace(w0_min, w0_max, w0_n)
w0 <- seq(w0_min, w0_max, length.out = w0_n)
## w1 = np.linspace(w1_min, w1_max, w1_n)
w1 <- seq(w1_min, w1_max, length.out = w1_n)
## C = np.zeros((w1_n, w0_n))
C <- array(0, dim = c(w1_n, w0_n))
## for i0 in range(w0_n):
##   for i1 in range(w1_n):
##     w = np.array([w0[i0], w1[i1]])
##     C[i1, i0] = cee_logistic(w, X, T)  # CEEを計算
for (i0 in 1:w0_n) {
  for (i1 in 1:w1_n) {
    w <- c(w0[i0], w1[i1])
    C[i1, i0] <- cee_logistic(w, X, t)
  }
}
## ww0, ww1 = np.meshgrid(w0, w1)  # 描画用座標の作成
NULL

## # グラフ描画 ----------
## plt.ﬁgure(ﬁgsize=(12, 5))
## plt.subplots_adjust(wspace=0.5)
## # サーフェス表示
## ax = plt.subplot(1, 2, 1, projection="3d")
## ax.plot_surface(
##   ww0, ww1, C,
##   color="blue", edgecolor="black", rstride=10, cstride=10, alpha=0.3,
## )
## ax.set_xlabel("$w_0$", fontsize=14)
## ax.set_ylabel("$w_1$", fontsize=14)
## ax.set_xlim(0, 15)
## ax.set_ylim(-15, 0)
## ax.set_zlim(0, 8)
## ax.view_init(30, -95)
persp(w0, w1, C, theta = -195, phi = 30, lwd = 0.3)
## # 等高線表示
## plt.subplot(1, 2, 2)
## cont = plt.contour(
##   ww0, ww1, C,
##   colors="black", levels=[0.26, 0.4, 0.8, 1.6, 3.2, 6.4],
## )
## cont.clabel(fmt="%.2f", fontsize=8)
## plt.xlabel("$w_0$", fontsize=14)
## plt.ylabel("$w_1$", fontsize=14)
## plt.grid()
## plt.show()
df <- data.frame(array(NA, dim = c(w0_n, w1_n)))
n <- 1
for (i in 1:w0_n) {
  for (j in 1:w1_n) {
    df[n, 1] <- w0[i]
    df[n, 2] <- w1[j]
    df[n, 3] <- C[i, j]
    n <- n + 1
  }
}
df |>
  ggplot() +
  geom_contour(aes(X1, X2, z = X3)) +
  labs(x = element_blank(), y = element_blank()) +
  xlim(w0_min, w0_max) + ylim(w1_min, w1_max) +
  coord_fixed(ratio = (w0_max - w0_min) / (w1_max - w1_min))


# リスト 6-1-(7)
## # 平均交差エントロピー誤差の微分 ----------
## def dcee_logistic(w, x, t):
##     y = logistic(x, w)
##     # 式6-32、式6-33の計算
##     dcee = np.zeros(2)
##     for n in range(len(y)):
##         dcee[0] = dcee[0] + (y[n] - t[n]) * x[n]
##         dcee[1] = dcee[1] + (y[n] - t[n])
##     dcee = dcee / N
##     return dcee
dcee_logistic <- function(w, x, t) {
  y <- logistic(x, w)
  dcee <- rep(0, times = 2)
  for (n in 1:length(y)) {
    dcee[1] <- dcee[1] + (y[n] - t[n]) * x[n]
    dcee[2] <- dcee[2] + (y[n] - t[n])
  }
  dcee <- dcee / N
  return(dcee)
}

## # テスト ----------
## w = np.array([1, 1])
w <- c(1, 1)
## dcee = dcee_logistic(w, X, T)
dcee <- dcee_logistic(w, X, t)
## print("dCEE =", np.round(dcee, 6))
cat('dCEE =', round(dcee, 6))


# リスト 6-1-(8)
## from scipy.optimize import minimize
NULL

## # ロジスティック回帰モデルのパラメータ最適化
## def fit_logistic(w_init, x, t):
##     res = minimize(  # (A)
##         cee_logistic, w_init, args=(x, t),
##         jac=dcee_logistic, method="CG",
##     )
##    return res.x

######## 共役勾配法の実装に苦戦中 ########

# minimize <- function(w_init, x, t, alpha = 0.001, tau = 10000, eps = 0.1) {
#   w_for_calc <- w_init
#   w_hist <- array(NA, dim = c(tau, 2))
#   w_hist[1,] <- w_init
#   n <- 1
#   for (i in 1:tau) {
#     dcee <- dcee_logistic(w_for_calc, x, t)
#     w_for_calc <- w_for_calc - alpha * dcee
#     w_hist[i+1,] <- w_for_calc
#     if (max(abs(dcee)) < eps) break
#     n <- n + 1
#   }
#   cee <- cee_logistic(w_for_calc, x, t)
#   return(list(w = w_for_calc, w_history = w_hist[1:n,], cee = cee, dcee = dcee))
# }
# fit_logistic <- function(w_init, x, t) {
#   res <- minimize(w_init, x, t)
# }

# メイン ----------
## w_init = np.array([1.0, -1.0])  # wの初期値
w_init <- c(1, -1)
## w = fit_logistic(w_init, X, T)  # wを計算
res <- minimize(w_init, X, t)
## cee = cee_logistic(w, X, T)     # CEEを計算
cee <- res$cee

## # グラフ描画 ----------
## plt.figure(figsize=(3, 3))
## boundary = show_logistic(w)
## show_data1d(X, T)
## plt.grid()
## plt.show()

## # 結果表示 ----------
## print(f"w0 = {w[0]:.2f}, w1 = {w[1]:.2f}")
## print(f"CEE = {cee:.2f}")
## print(f"Boundary = {boundary:.2f} g")

