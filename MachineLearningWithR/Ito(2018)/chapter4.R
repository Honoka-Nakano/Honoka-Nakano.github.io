## Machine-Learning-with-R/chapter4.R
## 2024-03-05
## Nakano Keisuke


## 準備
library(tidyverse)


# リスト 4-1-(1)
## import numpy as np
NULL

# リスト 4-1-(2)
## a = np.array([2, 1])
a <- array(c(2, 1), dim = c(1, 2))
## print(a)
print(a)


# リスト 4-1-(3)
## type(a)
class(a)


# リスト 4-1-(4)
## c = np.array([[1, 2], [3, 4]])
c <- matrix(c(1, 2, 3, 4), nrow = 2, ncol = 2, byrow = TRUE) |>
  as.array()
## print(c)
print(c)


# リスト 4-1-(5)
## d = np.array([[1], [2]])
d <- array(c(1, 2), dim = c(2, 1))
## print(d)
print(d)


# リスト 4-1-(6)
## print(d.T)
print(t(d))
## print(d.T.T)
print(t(t(d)))


# リスト 4-1-(7)
## a = np.array([2, 1])
a <- array(c(2, 1), dim = c(1, 2))
## b = np.array([1, 3])
b <- array(c(1, 3), dim = c(1, 2))
## print(a + b)
print(a + b)


# リスト 4-1-(8)
## a = np.array([2, 1])
a <- array(c(2, 1), dim = c(1, 2))
## b = np.array([1, 3])
b <- array(c(1, 3), dim = c(1, 2))
## print(a + b)
print(a - b)


# リスト 4-1-(9)
## print(2 * a)
print(2 * a)


# リスト 4-1-(10)
## b = np.array([1, 3])
b <- array(c(1, 3), dim = c(1, 2)) # 行列計算の都合上1x2行列．
## c = np.array([4, 2])
c <- array(c(4, 2), dim = c(2, 1)) # 行列計算の都合上2x1行列．
## print(b @ c)
print(b %*% c)

# リスト 4-1-(11)
## a = np.array([1, 3])
a <- array(c(1, 3), dim = c(1, 2))
## print(np.linalg.norm(a))
print(norm(a, '2'))


## %reset
rm(list = ls(all.names = TRUE))


# リスト 4-2-(1)
## import numpy as np

## a = np.ones(1000)       # [1 1 1 ...     1]
a <- array(rep(1, times = 1000), dim = c(1, 1000)) # 行列計算の都合上1x1000行列．
## b = np.arange(1, 1001)  # [1 2 3 ...  1000]
b <- array(seq(1:1000), dim = c(1000, 1))          # 行列計算の都合上1000x1行列．
## print(a @ b)
print(a %*% b)


## %reset
rm(list = ls(all.names = TRUE))


# リスト 4-3-(1)
## # 関数を定義 ----------
## def f(w0, w1):                       # (A) fの定義
##   return w0 ** 2 + 2 * w0 * w1 + 3   # 式4-41
f <- function(w0, w1) {
  return(w0 ^ 2 + 2 * w0 * w1 + 3)
}
## def df_dw0(w0, w1):                  # (B) fのw0に関する偏微分
##   return 2 * w0 + 2 * w1             # 式4-44
df_dw0 <- function(w0, w1) {
  return(2 * w0 + 2 * w1)
}
## def df_dw1(w0, w1):                  # (C) fのw1に関する偏微分
##   return 2 * w0                      # 式4-46
df_dw1 <- function(w0, w1) {
  return(2 * w0)
}

## # 表示データの計算 ----------
## w0_min, w0_max = -2, 2
w0_min <- -2; w0_max <- 2
## w1_min, w1_max = -2, 2
w1_min <- -2; w1_max <- 2
## w0_n, w1_n = 17, 17
w0_n <- 17; w1_n <- 17
## w0 = np.linspace(w0_min, w0_max, w0_n)
w0 <- seq(from = w0_min, to = w0_max, length.out = w0_n)
## w1 = np.linspace(w1_min, w1_max, w1_n)
w1 <- seq(from = w1_min, to = w1_max, length.out = w1_n)
## ww0, ww1 = np.meshgrid(w0, w1)          # (D) グリッド座標の作成
ww0 <- matrix(w0, nrow = w0_n, ncol = w1_n, byrow = TRUE) |>
  as.array()
ww1 <- array(w1, dim = c(w0_n, w1_n))
## f_num = f(ww0, ww1)                     # (E) fの値の計算
f_num <- f(ww0, ww1)
## df_dw0_num = df_dw0(ww0, ww1)           #     fの偏微分の計算
df_dw0_num <- df_dw0(ww0, ww1)
## df_dw1_num = df_dw1(ww0, ww1)           #     fの偏微分の計算
df_dw1_num = df_dw1(ww0, ww1)

## # グラフ描画 ----------
## plt.figure(figsize=(9, 4))
## plt.subplots_adjust(wspace=0.3)
## # 等高線表示
## plt.subplot(1, 2, 1)
## cont = plt.contour(                     # (F) fの等高線表示
##   ww0, ww1, f_num, levels=10, colors="black")
## cont.clabel(fmt="%d", fontsize=8)
## plt.xticks(range(w0_min, w0_max + 1, 1))
## plt.yticks(range(w1_min, w1_max + 1, 1))
## plt.xlim(w0_min - 0.5, w0_max + 0.5)
## plt.ylim(w1_min - 0.5, w1_max + 0.5)
## plt.xlabel("$w_0$", fontsize=14)
## plt.ylabel("$w_1$", fontsize=14)
df <- array(NA, dim = c(w0_n * w1_n, 5)) |> # 空のデータフレームを用意．
  data.frame() |>
  rename(ww0   = 'X1',                      # 変数名を変更．
         ww1   = 'X2',
         f_num = 'X3',
         dw0   = 'X4',
         dw1   = 'X5')
n <- 1                                      #  便宜上のインデックス．
for (i in 1:w0_n) {
  for (j in 1:w1_n) {
    df[n, 1] <- ww0[i, j]                   # ww0を順番に代入．
    df[n, 2] <- ww1[i, j]                   # ww1を順番に代入．
    df[n, 3] <- f_num[i, j]                 # ww0, ww1に対応するfを代入．
    df[n, 4] <- df_dw0_num[i, j]            # ww0, ww1に対応するdw0を代入．
    df[n, 5] <- df_dw1_num[i, j]            # ww0, ww1に対応するdw1を代入．
    n <- n + 1
  }
}
df |>
  ggplot(aes(ww0, ww1, z = f_num)) +
  geom_contour() +
  coord_fixed(ratio = 1) +
  labs(x = expression(w[0]), y = expression(w[1]))
## # ベクトル表示
## plt.subplot(1, 2, 2)
## plt.quiver(                      # (G) fの勾配のベクトル表示
##   ww0, ww1, df_dw0_num, df_dw1_num)
## plt.xlabel("$w_0$", fontsize=14)
## plt.ylabel("$w_1$", fontsize=14)
## plt.xticks(range(w0_min, w0_max + 1, 1))
## plt.yticks(range(w1_min, w1_max + 1, 1))
## plt.xlim(w0_min - 0.5, w0_max + 0.5)
## plt.ylim(w1_min - 0.5, w1_max + 0.5)
## plt.show()
df |>
  ggplot() +
  geom_segment(aes(x = ww0, xend = ww0 + dw0 / 30,
                   y = ww1, yend = ww1 + dw1 / 30),
               linewidth = 0.3,
               arrow = arrow(length = unit(0.1, 'cm'))) +
  coord_fixed(ratio = 1) +
  labs(x = expression(w[0]), y = expression(w[1]))


## %reset
rm(list = ls(all.names = TRUE))


# リスト 4-4-(1)
## import numpy as np
NULL


# リスト 4-4-(2)
## A = np.array([[1, 2, 3], [4, 5, 6]])
A <- matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE) |>
  as.array()
## print(A)
print(A)


# リスト 4-4-(3)
## B = np.array([[7, 8, 9], [10, 11, 12]])
B <- matrix(7:12, nrow = 2, ncol = 3, byrow = TRUE) |>
  as.array()
## print(B)
print(B)


# リスト 4-4-(4)
## print(A + B)
print(A + B)
## print(A - B)
print(A - B)


# リスト 4-4-(5)
## A = np.array([[1, 2, 3], [4, 5, 6]])
A <- matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE) |>
  as.array()
## print(2 * A)
print(2 * A)


# リスト 4-4-(6)
## A = np.array([1, 2, 3])
A <- array(1:3, dim = c(1, 3)) # 行列計算の都合上1x3行列．
## B = np.array([4, 5, 6])
B <- array(4:6, dim = c(3, 1)) # 行列計算の都合上3x1行列．
## print(A @ B)
print(A %*% B)                 # 内積は`%*%`で計算可能．


# リスト 4-4-(7)
## A = np.array([1, 2, 3])
A <- array(1:3, dim = c(1, 3))
## B = np.array([4, 5, 6])
B <- array(4:6, dim = c(1, 3))
## print(A * B)
print(A * B)                   # 対応する要素同士の積は`*`で計算可能．


# リスト 4-4-(8)
## A = np.array([1, 2, 3])
A <- array(1:3, dim = c(1, 3))
## B = np.array([4, 5, 6])
B <- array(4:6, dim = c(1, 3))
## print(A / B)
print(A / B)


# リスト 4-4-(9)
## A = np.array([[1, 2, 3], [-1, -2, -3]])
A <- matrix(c(1:3, -1:-3), nrow = 2, ncol = 3, byrow = TRUE) |>
  as.array()
## B = np.array([[4, -4], [5, -5], [6, -6]])
B <- array(c(4:6, -4:-6), dim = c(3, 2))
## print(A @ B)
print(A %*% B)


# リスト 4-4-(10)
## print(np.identity(3))
print(diag(1, nrow = 3, ncol = 3))


# リスト 4-4-(11)
## A = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
A <- matrix(1:9, nrow = 3, ncol = 3, byrow = TRUE) |>
  as.array()
## I = np.identity(3)
I <- diag(1, nrow = 3, ncol = 3)
## print(A @ I)
print(A %*% I)


# リスト 4-4-(12)
## A = np.array([[1, 2], [3, 4]])
A <- matrix(1:4, nrow = 2, ncol = 2, byrow = TRUE) |>
  as.array()
## invA = np.linalg.inv(A)
invA <- solve(A)
## print(invA)
print(invA)


# リスト 4-4-(13)
## A = np.array([[1, 2, 3], [4, 5, 6]])
A <- matrix(1:6, nrow = 2, ncol = 3, byrow = TRUE) |>
  as.array()
## print(A)
print(A)
## print(A.T)
print(t(A))


## %reset
rm(list = ls(all.names = TRUE))


# リスト 4-5-(1)
## %matplotlib inline
## import numpy as np
## import matplotlib.pyplot as plt
NULL

## # 表示データの計算 ----------
## x = np.linspace(-4, 4, 100)
x <- seq(from = -4, to = 4, length.out = 100)
## y = 2 ** x
y <- 2 ^ x
## y2 = 3 ** x
y2 <- 3 ^ x
## y3 = 0.5 ** x
y3 <- 0.5 ^ x

## # グラフ描画 ----------
## plt.figure(figsize=(5, 5))
## plt.plot(x, y, "black", linewidth=3, label="$y=2^x$")
## plt.plot(x, y2, "cornflowerblue", linewidth=3, label="$y=3^x$")
## plt.plot(x, y3, "gray", linewidth=3, label="$y=0.5^x$")
## plt.legend(loc="lower right")
## plt.xlim(-4, 4)
## plt.ylim(-2, 6)
## plt.grid()
## plt.show()
tibble(x_plt = c(x, x, x),
       y_plt = c(y, y2, y3),
       col   = rep(c('1', '2', '3'), each = length(x))) |>
  ggplot(aes(x = x_plt, y = y_plt, color = col)) +
  geom_line() +
  xlim(-4, 4) + ylim(-2, 6) +
  coord_fixed(ratio = 8 / 8) +
  scale_color_manual(values = c('black', 'cornflowerblue', 'gray'),
                     name   = element_blank(),
                     labels = c(expression(y == 2 ^ x),
                                expression(y == 3 ^ x),
                                expression(y == 0.5 ^ x))) +
  labs(x = element_blank(), y = element_blank())


# リスト 4-5-(2)
## # 表示データの計算 ----------
## x = np.linspace(-8, 8, 100)
x <- seq(from = -8, to = 8, length.out = 100)
## y = 2 ** x
y <- 2 ^ x
## # np.log(0) はエラーになるので 0 は含めない
## x2 = np.linspace(0.001, 8, 100)
x2 <- seq(from = 0.001, to = 8, length.out = 100)
## # 底を 2 とした log を公式 (7) で計算
## y2 = np.log(x2) / np.log(2)
y2 <- log(x2) / log(2)

## # グラフ描画 ----------
## plt.figure(figsize=(5, 5))
## plt.plot(x, y, "black", linewidth=3)
## plt.plot(x2, y2, "cornflowerblue", linewidth=3)
## plt.plot(x, x, "black", linestyle="--", linewidth=1)
## plt.xlim(-8, 8)
## plt.ylim(-8, 8)
## plt.grid()
## plt.show()
ggplot() +
  geom_line(data    = tibble(x_plt = x, y_plt = y),   # 指数関数
            mapping = aes(x = x_plt, y = y_plt),
            color   = 'black') +
  geom_line(data    = tibble(x_plt = x2, y_plt = y2), # 対数関数
            mapping = aes(x = x_plt, y = y_plt),
            color   = 'cornflowerblue') +
  geom_line(data     = tibble(x_plt = x, y_plt = x),  # y = x
            mapping  = aes(x = x_plt, y = y_plt),
            linetype = 'dashed') +
  xlim(-8, 8) + ylim(-8, 8) +
  coord_fixed(ratio = 1) +
  labs(x = element_blank(), y = element_blank())
  

# リスト 4-5-(3)
## # 表示データの計算 ----------
## x = np.linspace(-4, 4, 100)
x <- seq(from = -4, to = 4, length.out = 100)
## y = (x - 1) ** 2 + 2
y <- (x - 1) ^ 2 + 2
## logy = np.log(y)
logy <- log(y)

## # グラフ描画 ----------
## plt.figure(figsize=(4, 4))
## plt.plot(x, y, "black", linewidth=3)
## plt.plot(x, logy, "cornflowerblue", linewidth=3)
## plt.xticks(range(-4, 5, 1))
## plt.yticks(range(-4, 9, 1))
## plt.xlim(-4, 4)
## plt.ylim(-4, 8)
## plt.grid()
## plt.show()
ggplot() +
  geom_line(data    = tibble(x_plt = x, y_plt = y),    # 指数関数
            mapping = aes(x = x_plt, y = y_plt),
            color   = 'black') +
  geom_line(data    = tibble(x_plt = x, y_plt = logy), # 対数化
            mapping = aes(x = x_plt, y = y_plt),
            color   = 'cornflowerblue') +
  xlim(-4, 4) + ylim(-4, 8) +
  coord_fixed(ratio = 8 / 12) +
  labs(x = element_blank(), y = element_blank())


# リスト 4-5-(4)
## # 表示データの計算 ----------
## x = np.linspace(-4, 4, 100)
x <- seq(from = -4, to = 4, length.out = 100)
## a = 2
a <- 2
## y = a ** x
y <- a ^ x
## dy = np.log(a) * y
dy <- log(a) * y

## # グラフ描画 ----------
## plt.figure(figsize=(4, 4))
## plt.plot(x, y, "gray", linestyle="--", linewidth=3)
## plt.plot(x, dy, "black", linewidth=3)
## plt.xlim(-4, 4)
## plt.ylim(-1, 8)
## plt.grid()
## plt.show()
ggplot() +
  geom_line(data     = tibble(x_plt = x, y_plt = y), # y
            mapping  = aes(x = x_plt, y = y_plt),
            color    = 'gray',
            linetype = 'dashed') +
  geom_line(data    = tibble(x_plt = x, y_plt = dy), # y'
            mapping = aes(x = x_plt, y = y_plt)) +
  xlim(-4, 4) + ylim(-1, 8) +
  coord_fixed(ratio = 8 / 9) +
  labs(x = element_blank(), y = element_blank())


# リスト 4-5-(5)
## # 表示データの計算 ----------
## x = np.linspace(0.0001, 4, 100)  # 0 以下では定義できない
x <- seq(from = 0.0001, to = 4, length.out = 100)
## y = np.log(x)
y <- log(x)
## dy = 1 / x
dy <- 1 / x

## # グラフ描画 ----------
## plt.figure(figsize=(4, 4))
## plt.plot(x, y, "gray", linestyle="--", linewidth=3)
## plt.plot(x, dy, "black", linewidth=3)
## plt.xlim(-1, 4)
## plt.ylim(-8, 8)
## plt.grid()
## plt.show()
ggplot() +
  geom_line(data     = tibble(x_plt = x, y_plt = y), # y
            mapping  = aes(x = x_plt, y = y_plt),
            color    = 'gray',
            linetype = 'dashed') +
  geom_line(data    = tibble(x_plt = x, y_plt = dy), # y'
            mapping = aes(x = x_plt, y = y_plt)) +
  xlim(-1, 4) + ylim(-8, 8) +
  coord_fixed(ratio = 5 / 16) +
  labs(x = element_blank(), y = element_blank())


# リスト 4-5-(6)
## # 表示データの計算 ----------
## x = np.linspace(-10, 10, 100)
x <- seq(from = -10, to = 10, length.out = 100)
## y = 1 / (1 + np.exp(-x))  # 式4-114
y <- 1 / (1 + exp(-x))

## # グラフ描画 ----------
## plt.figure(figsize=(4, 4))
## plt.plot(x, y, "black", linewidth=3)
## plt.xlim(-10, 10)
## plt.ylim(-1, 2)
## plt.grid()
## plt.show()
ggplot() +
  geom_line(data    = tibble(x_plt = x, y_plt = y),
            mapping = aes(x = x_plt, y = y_plt)) +
  xlim(-10, 10) + ylim(-1, 2) +
  coord_fixed(ratio = 20 / 3) +
  labs(x = element_blank(), y = element_blank())


# リスト 4-5-(7)
## # ソフトマックス関数 ----------
## def softmax(x0, x1, x2):
##   u = np.exp(x0) + np.exp(x1) + np.exp(x2)  # 式4-119
##   y0 = np.exp(x0) / u                       # 式4-120
##   y1 = np.exp(x1) / u
##   y2 = np.exp(x2) / u
##   return y0, y1, y2
softmax <- function(x0, x1, x2) {
  u <- exp(x0) + exp(x1) + exp(x2)
  y0 <- exp(x0) / u
  y1 <- exp(x1) / u
  y2 <- exp(x2) / u
  return(c(y0, y1, y2))
}

## # テスト ----------
## y = softmax(2, 1, -1)
y <- softmax(2, 1, -1)
## print(np.round(y, 4))  # 小数点以下4桁の概数を表示
print(round(y, 4))
## print(np.sum(y))       # 和を表示
print(sum(y))


# リスト 4-5-(8)
## # 表示データの計算 ----------
## x0_n, x1_n = 20, 20             # サーフェス表示の解像度
x0_n <- 20; x1_n <- 20
## x0 = np.linspace(-4, 4, x0_n)
x0 <- seq(from = -4, to = 4, length.out = x0_n)
## x1 = np.linspace(-4, 4, x1_n)
x1 <- seq(from = -4, to = 4, length.out = x1_n)
## xx0, xx1 = np.meshgrid(x0, x1)  # グリッド座標の作成
xx0 <- matrix(x0, nrow = x0_n, ncol = x1_n, byrow = TRUE) |>
  as.array()
xx1 <- array(x1, dim = c(x0_n, x1_n))
## y = softmax(xx0, xx1, 1)        # ソフトマックス関数の値を計算
y <- softmax(xx0, xx1, 1)              # 長さ1200のベクトル(y0[1], y0[2], ..., y0[400], y1[1], y1[2], ...)
y <- array(y, dim = c(x0_n * x1_n, 3)) # 400x3の行列とする．1列目に400個のy0，2列目に400個のy1...

## # グラフ描画 ----------
## plt.figure(figsize=(8, 3))
## for i in range(2):
##   ax = plt.subplot(1, 2, i + 1, projection="3d")
##   ax.plot_surface(
##     xx0, xx1, y[i],
##     rstride=1, cstride=1, alpha=0.3,
##     color="blue", edgecolor="black",
##   )
##   ax.set_xlabel("$x_0$", fontsize=14)
##   ax.set_ylabel("$x_1$", fontsize=14)
##   ax.view_init(40, -125)
##
## plt.show()
persp(x = x0, y = x1,
      z = y[,1] |>                                      # x引数, y引数に対応した
        matrix(nrow = x0_n, ncol = x1_n, byrow = TRUE), # 行列でないとプロットできない．
      zlab = '',
      theta = -40, phi = 30)
persp(x = x0, y = x1,
      z = y[,2] |>                                      # x引数，y引数に対応した
        matrix(nrow = x0_n, ncol = x1_n, byrow = TRUE), # 行列でないとプロットできない．
      zlab = '',
      theta = -40, phi = 30)


# リスト 4-5-(9)
## # ガウス関数 ----------
## def gauss(mu, sigma, a):
##   # 式4-135
##   y = a * np.exp(-((x - mu) ** 2) / (2 * sigma ** 2))
##   return y
gauss <- function(mu, sigma, a, x) {          # 便宜上x引数を追加．
  y <- a * exp(-((x - mu) ^ 2) / (2 * sigma ^ 2))
}

## # グラフ描画 ----------
## x = np.linspace(-4, 4, 100)
x <- seq(from = -4, to = 4, length.out = 100)
## plt.figure(figsize=(4, 4))
## plt.plot(x, gauss(0, 1, 1), "black", linewidth=3)
## plt.plot(x, gauss(2, 2, 0.5), "gray", linewidth=3)
## plt.xlim(-4, 4)
## plt.ylim(-0.5, 1.5)
## plt.grid()
## plt.show()
ggplot() +
  geom_line(data    = tibble(a = x, b = gauss(0, 1, 1, x)),   # 平均0，標準偏差1，高さ1
            mapping = aes(x = a, y = b),
            color   = 'black') +
  geom_line(data    = tibble(c = x, d = gauss(2, 2, 0.5, x)), # 平均2，標準偏差2，高さ0.5
            mapping = aes(x = c, y = d),
            color   = 'gray') +
  xlim(-4, 4) + ylim(-0.5, 1.5) +
  coord_fixed(ratio = 8 / 2) +
  labs(x = element_blank(), y = element_blank())


## %reset
rm(list = ls(all.names = TRUE)) 


# リスト 4-6-(1)
## %matplotlib inline
## import numpy as np
## import matplotlib.pyplot as plt
NULL

## # ガウス関数  ----------
## def gauss(x0, x1, mu, sigma):
##   x = np.array([x0, x1])
##   # 式4-142
##   a = 1 / (2 * np.pi) * 1 / (np.linalg.det(sigma) ** (1 / 2))
##   # 式4-138
##   inv_sigma = np.linalg.inv(sigma)
##   y = a * np.exp(
##     (-1 / 2) * (x - mu).T @ inv_sigma @ (x - mu))
##   return y
gauss <- function(x0, x1, mu, sigma) {
  x <- array(c(x0, x1), dim = c(2, 1))
  a <- 1 / (2 * pi) * 1 / (det(sigma) ^ (1 / 2))
  inv_sigma <- solve(sigma)
  y <- a * exp((-1 / 2) * t(x - mu) %*% inv_sigma %*% (x - mu))
  return(y)
}


# リスト 4-6-(2)
## x0, x1 = 2, 1
x0 <- 2; x1 <- 1
## mu = np.array([1, 2])               # 平均ベクトル
mu <- array(c(1, 2), dim = c(2, 1))
## sigma = np.array([[1, 0], [0, 1]])  # 共分散行列
sigma = array(c(1, 0, 0, 1), dim = c(2, 2))
## y = gauss(x0, x1, mu, sigma)
y <- gauss(x0, x1, mu, sigma)
## print("y =", np.round(y, 6))
cat('y =', round(y, 6))


# リスト 4-6-(3)
## # パラメータ ----------
## mu = np.array([1, 0.5])             # (A) 平均ベクトル
mu <- array(c(1, 0.5), dim = c(2, 1))
## sigma = np.array([[2, 1], [1, 1]])  # (B) 共分散行列
sigma <- array(c(2, 1, 1, 1), dim = c(2, 2))
## x0_min, x0_max = -3, 3              # x0の計算範囲
x0_min <- -3; x0_max <- 3
## x1_min, x1_max = -3, 3              # x1の計算範囲
x1_min <- -3; x1_max <- 3

## # データ生成 ----------
## x0_n, x1_n = 40, 40  # グラフ表示の解像度
x0_n <- 40; x1_n <- 40
## x0 = np.linspace(x0_min, x0_max, x0_n)
x0 <- seq(from = x0_min, to = x0_max, length.out = x0_n)
## x1 = np.linspace(x1_min, x1_max, x1_n)
x1 <- seq(from = x1_min, to = x1_max, length.out = x1_n)
## f = np.zeros((x1_n, x0_n))
f <- array(0, dim = c(x1_n, x0_n))
## for i0 in range(x0_n):
##   for i1 in range(x1_n):
##     f[i1, i0] = gauss(x0[i0], x1[i1], mu, sigma)
for (i0 in 1:x0_n) {
  for (i1 in 1:x1_n) {
    f[i0, i1] <- gauss(x0[i0], x1[i1], mu, sigma)
  }
}
## xx0, xx1 = np.meshgrid(x0, x1)  # グリッド座標の作成
NULL

## # グラフ描画 ----------
## plt.figure(figsize=(7, 3))
NULL
## # 等高線表示
## plt.subplot(1, 2, 1)
## cont = plt.contour(xx0, xx1, f, levels=15, colors="black")
## plt.xlabel("$x_0$", fontsize=14)
## plt.ylabel("$x_1$", fontsize=14)
## plt.xlim(x0_min, x0_max)
## plt.ylim(x1_min, x1_max)
## plt.grid()
df <- array(NA, dim = c(x0_n * x1_n, 3)) |> # 空のデータフレームを作成．
  data.frame() |>
  rename(x0 = 'X1',                         # 変数名を変更．
         x1 = 'X2',
         f  = 'X3')
n <- 1                                      # 便宜上インデックスを作成．
for (i in 1:x0_n) {
  for (j in 1:x1_n) {
    df[n, 1] <- x0[i]                       # 1列目にx0
    df[n, 2] <- x1[j]                       # 2列目にx1
    df[n, 3] <- f[i, j]                     # 3列目に，x0, x1に対応するf．
    n <- n + 1
  }
}
df |>
  ggplot(aes(x0, x1, z = f)) +
  geom_contour() +
  xlim(-2, 3) + ylim(-2, 3) +
  coord_fixed(ratio = 5 / 5) +
  labs(x = expression(x[0]), y = expression(x[1]))
# サーフェス表示
## ax = plt.subplot(1, 2, 2, projection="3d")
## ax.plot_surface(
##   xx0, xx1, f,
##   rstride=2, cstride=2, alpha=0.3, color="blue", edgecolor="black",
## )
## ax.set_zticks([0.05, 0.10])
## ax.set_xlabel("$x_0$", fontsize=14)
## ax.set_ylabel("$x_1$", fontsize=14)
## ax.view_init(40, -100)
## plt.show()
persp(x = x0, y = x1, z = f, zlab = '',
      theta = -25, phi = 35)
