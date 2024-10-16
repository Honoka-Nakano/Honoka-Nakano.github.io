---
"title": "ベイズ統計学でKaggleのタイタニック問題を解いてみる"
"tags": ["Bayess", "Kaggle", "R"]
"created_at": "2024-07-01"
"updated_at": "2024-07-01"
---

## はじめに

**概要**

Kaggleの[タイタニック問題](https://www.kaggle.com/competitions/titanic)をベイズ推定で解いてみる記事です．

ソースコードは私の[GitHub](https://github.com/Honoka-Nakano/titanic-qiita)で公開しています．

**紹介**

統計学を齧っている経済学部4回生（ベイジアンの卵）です．

**経緯**

以前，[『ベイズ統計でKaggleを解いてみる』](https://qiita.com/Honoka-Nakano/items/b99ea3c7df57a7652bb8)という記事を投稿しました．

初投稿ということもあり，説明不足や改善点がいくつかみられたので，その修正版として本記事を投稿します．

**対象者**

- 統計学・ベイズ推定に興味がある
- ベイズ推定を学んでいる
- 実践的なベイズ推定をやってみたい

以上のような方が対象です．また，以前私が投稿した[CmdStanの解説記事](https://qiita.com/Honoka-Nakano/items/b26222aec402b9ecabf9)に目を通していることを前提とします．

**実行環境**

以下を参照してください．

- MacOS Sonoma 14.5
- R version 4.4.0 (2024-04-24)
- RStudio 2024.04.2+764 (2024.04.2+764)
- `{cmdstanr}` 0.7.1
- `{tidyverse}` 2.0.0
- `{posterior}` 1.5.0

```r:R console
> sessionInfo()
R version 4.4.0 (2024-04-24)
Running under: macOS Sonoma 14.5
 [1] posterior_1.5.0 cmdstanr_0.7.1 lubridate_1.9.3
 [4] forcats_1.0.0   stringr_1.5.1  dplyr_1.1.4
 [7] purrr_1.0.2     readr_2.1.5    tidyr_1.3.1
[10] tibble_3.2.1    ggplot2_3.5.1  tidyverse_2.0.0
```

## 分析概要

**タイタニック問題とは**

1912年4月14日に沈没してしまったタイタニック号の乗客データを用いて，各乗客が生存したか死亡したかを予測し，その精度を競う機械学習コンペティションです[^titanic]．

[^titanic]: 本来は機械学習を用いることを想定していますが，ベイズ統計でも予測は可能なので，腕試し的にやってみることにしました．

**手順**

分析の手順は以下のとおりです．

1. データ可視化・理解
1. データ前処理・加工
1. データ生成過程の確認・モデルの作成
1. データリストの作成
1. Stanファイルの記述
1. MCMCの実行
1. 結果の確認

**準備**

必要なパッケージを読み込みます．

```r:titanic.R
> pacman::p_load(tidyverse,
+                cmdstanr,
+                posterior)
> options(mc.cores = parallel::detectCores())
```

**データのダウンロード・読み込み**

Kaggleの[タイタニック問題](https://www.kaggle.com/competitions/titanic)のページから必要なデータをダウンロードします[^data]．

[^data]: `train.csv`, `test.csv`を使います．ディレクトリ管理は各自にお任せします（私は作業ディレクトリにそのまま保存しました）．

![data.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3765399/db2c4c04-947f-b5f4-c160-9b3765127763.png)

次に，分析に用いる`train.csv`, `test.csv`を読み込みます．

```r:titanic.R
> myd_train <- read_csv('train.csv')
> myd_test <- read_csv('test.csv')
```

可視化や前処理をしやすくするために，2つのデータを1つにまとめます．そのために，テストデータに不足している`Survived`変数を追加し，欠損値を表す`NA`を代入しておきます．

```r:titanic.R
> myd_test$Survived <- NA
> myd <- rbind(myd_train, myd_test)
```

`rbind()`関数は行方向にデータフレームを結合してくれる関数です．

```r:titanic.R
> myd[c(890:895),]
# A tibble: 6 × 12
  PassengerId Survived Pclass Name             Sex     Age SibSp Parch Ticket  Fare Cabin Embarked
        <dbl>    <dbl>  <dbl> <chr>            <chr> <dbl> <dbl> <dbl> <chr>  <dbl> <chr> <chr>   
1         890        1      1 Behr, Mr. Karl … male   26       0     0 111369 30    C148  C       
2         891        0      3 Dooley, Mr. Pat… male   32       0     0 370376  7.75 NA    Q       
3         892       NA      3 Kelly, Mr. James male   34.5     0     0 330911  7.83 NA    Q       
4         893       NA      3 Wilkes, Mrs. Ja… fema…  47       1     0 363272  7    NA    S       
5         894       NA      2 Myles, Mr. Thom… male   62       0     0 240276  9.69 NA    Q       
6         895       NA      3 Wirz, Mr. Albert male   27       0     0 315154  8.66 NA    S   
```

`Survived`変数を見ると，トレーニングデータの下にテストデータが追加されていることがわかります（`nrow(myd_train) = 891`）．

「3. データ生成過程の確認・モデルの作成」でも言及しますが，今回の分析には`Name`, `Ticket`, `Cabin`, `Embarked`は使わないので，それら以外の変数のみ抽出しておきます．

```r:titanic.R
> myd <- myd |>
+   select(-c(Name, Ticket, Cabin, Embarked))
```

以上で分析の準備は完了です．

**データの説明**

```r:titanic.R
> glimpse(myd)
Rows: 1,309
Columns: 8
$ PassengerId <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1...
$ Survived    <dbl> 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1...
$ Pclass      <dbl> 3, 1, 3, 1, 3, 3, 1, 3, 3, 2, 3, 1, 3, 3, 3, 2, 3, 2...
$ Sex         <chr> "male", "female", "female", "female", "male", "male"...
$ Age         <dbl> 22, 38, 26, 35, 35, NA, 54, 2, 27, 14, 4, 58, 20, 39...
$ SibSp       <dbl> 1, 1, 0, 1, 0, 0, 0, 3, 0, 1, 1, 0, 0, 1, 0, 0, 4, 0...
$ Parch       <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 1, 0, 0, 5, 0, 0, 1, 0...
$ Fare        <dbl> 7.2500, 71.2833, 7.9250, 53.1000, 8.0500, 8.4583, 51...
```

- `PassengerId`: 乗客ID
- `Survived`: 生死（0が死亡，1が生存）
- `Pclass`: チケットのクラス（1が最も良いチケット）
- `Sex`: 性別
- `Age`: 年齢
- `SibSp`: 乗っている兄弟・姉妹の人数
- `Parch`: 乗っている親または子の人数
- `Fare`: 料金

### 1. データ可視化・理解

データがどのような特徴を持っているかを理解するために可視化します．これにより，分析にどの変数を用いたら良いか，また変数間に関係はあるのか，欠損処理はどのように行えば良いかなどを決める基準ができます[^viz]．

[^viz]: 今回は簡単なデータ処理しかしません．

**生死（`Survived`）の割合**

```r:titanic.R
> myd |>
+   ggplot() +
+   geom_bar(aes(x = as.factor(Survived),
+                fill = Sex)) +
+   labs(x = NULL, y = '人数') +
+   scale_fill_discrete(name = '性別',
+                       labels = c('女性', '男性')) +
+   theme_minimal()
```

![deadOrAlive.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3765399/14ec3aaa-2bf8-e9d5-fe71-97985c918455.png)

0が死亡，1が生存です．トレーニングデータの半数以上が死亡しています．性別ごとに死亡の割合を見ると，女性よりも男性の方が高いとわかります．

**年齢（`Age`）の分布**

```r:titanic.R
> myd |>
+   ggplot() +
+   geom_histogram(aes(x = Age,
+                      y = after_stat(density)),
+                  color = 'black') +
+   labs(x = '年齢', y = '密度') +
+   theme_minimal()
```

![ageDist.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3765399/5a6ac4bc-bea2-efb2-f1ec-aad76c8ddb1e.png)

0歳から80歳まで，様々な年代の方が乗っていたとわかります（欠損値は除いています）．中でも20代前半が最も多いです．また，10歳未満の子どもたちがいることから，家族連れも多く乗っていたことが予想できます．

**料金（`Fare`）の分布**

```r:titanic.R
> myd |>
+   ggplot() +
+   geom_histogram(aes(x = Fare,
+                      y = after_stat(density),
+                      fill = as.factor(Pclass))) +
+   labs(x = '料金', y = '密度') +
+   scale_fill_discrete(name = 'クラス') +
+   theme_minimal()
```

![fareDist.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3765399/d1f6c5f0-0e3f-f1e6-2233-018551cef253.png)

ほとんどの部屋が100ドル以下であることがわかります．また（当然と言えば当然ですが）クラスによって料金が変動しています．

### 2. データ前処理・加工

`summary()`を使うと，各変数の記述統計量と欠損値の数（`NA's`）を確認できます。

```r:titanic.R
> summary(myd)
  PassengerId      Survived          Pclass          Sex                 Age            SibSp            Parch            Fare        
 Min.   :   1   Min.   :0.0000   Min.   :1.000   Length:1309        Min.   : 0.17   Min.   :0.0000   Min.   :0.000   Min.   :  0.000  
 1st Qu.: 328   1st Qu.:0.0000   1st Qu.:2.000   Class :character   1st Qu.:21.00   1st Qu.:0.0000   1st Qu.:0.000   1st Qu.:  7.896  
 Median : 655   Median :0.0000   Median :3.000   Mode  :character   Median :28.00   Median :0.0000   Median :0.000   Median : 14.454  
 Mean   : 655   Mean   :0.3838   Mean   :2.295                      Mean   :29.88   Mean   :0.4989   Mean   :0.385   Mean   : 33.295  
 3rd Qu.: 982   3rd Qu.:1.0000   3rd Qu.:3.000                      3rd Qu.:39.00   3rd Qu.:1.0000   3rd Qu.:0.000   3rd Qu.: 31.275  
 Max.   :1309   Max.   :1.0000   Max.   :3.000                      Max.   :80.00   Max.   :8.0000   Max.   :9.000   Max.   :512.329  
                NAs    :418                                         NAs    :263                                      NAs    :1        
```

`Age`, `Fare`に欠損値があるので処理します[^nas]．

[^nas]: `Survived`の欠損はテストデータです．

`Fare`は，前節の可視化から`Pclass`に依存していることがわかります．そして，今回`Fare`が欠損しているデータを見ると，`Pclass = 3`であることがわかります．

```r:titanic.R
> myd |> filter(!is.na(Fare) == FALSE)
# A tibble: 1 × 8
  PassengerId Survived Pclass Sex     Age SibSp Parch  Fare
        <dbl>    <dbl>  <dbl> <chr> <dbl> <dbl> <dbl> <dbl>
1        1044       NA      3 male   60.5     0     0    NA
```

よって，この欠損は`Pclass = 3`の`Fare`の平均を代入することで処理したいと思います．

続いて`Age`の欠損処理については，数が多いので簡単のために`Age`が欠損していない乗客の平均年齢を，全ての欠損値に代入することで処理します[^age]．

[^age]: 賢い方法ではありませんが．

まず平均値の計算のために，`myd`から`NA`を含むデータを除去した`myd_NAomit`を作成します．その際，使う変数のみ抽出しておきます．

```r:titanic.R
> myd_NAomit <- na.omit(myd) |>
+   select(Pclass, Age, Fare)
```

続いて，平均値を計算します．平均値を保管しておく空のベクトルを作り，そのベクトルに計算した平均値を代入します．

```r:titanic.R
> empty_vec <- rep(NA, times = 2)      # 空のベクトルを作成
> empty_vec[1] <- mean(myd_NAomit$Age) # Ageの平均
> empty_vec[2] <- myd_NAomit |>        # Fareの平均
+   filter(Pclass == 3) |>             ## Pclass = 3でフィルタリング
+   select(Fare) |>                    ## Fareのみを抽出
+   unlist() |>                        ## リストを解除
+   mean()                             ## 平均値の計算
```

これらの平均値を元のデータセット`myd`に代入します．

```r:titanic.R
> myd <- myd |>
+   mutate(Age  = ifelse(!is.na(Age),  Age,  empty_vec[1]),
+          Fare = ifelse(!is.na(Fare), Fare, empty_vec[2]))
```

以上で欠損処理は完了です．最後に`myd`をトレーニングデータとテストデータに分けておきましょう（`Survived`が欠損しているか否かで分けます）．

```r:titanic.R
> myd_train <- myd |>
+   filter(!is.na(Survived) == TRUE)
> myd_test <- myd |>
+   filter(!is.na(Survived) == FALSE)
```

### 3. データ生成過程の確認・モデルの作成

データ生成過程を確認します．

まず，結果変数の`Survived`は「生存」か「死亡」のどちらかなので，ベルヌーイ分布に従って得られると仮定します．

```math
\begin{align}
    y_i & \sim \mathrm{Bernoulli} (\theta_i) & (尤度関数)
\end{align}
```

続いて，ベルヌーイ分布のパラメタである$\theta$は，リンク関数を用いて以下のように表します．今回は`Pclass`, `Sex`, `Age`, `SibSp`, `Parch`, `Fare`の6つの変数を用いています[^link]．

[^link]: `Name`, `Ticket`, `Cabin`, `Embarked`の4変数は結果に影響しないと判断したためです．

```math
\begin{align}
    \mbox{logit} (\theta_i) & = \beta_1 + \beta_2 x_{pcl, i}
        + \beta_3 x_{sex, i} + \beta_4 x_{age, i} \\
        & + \beta_5 x_{sib, i} + \beta_6 x_{par, i} + \beta_7 x_{far, i}
        & (リンク関数)
\end{align}
```

尤度関数にベルヌーイ分布を仮定しているため，そのパラメタである$\theta$は確率（つまり$0 \le \theta \le 1$）である必要があります．しかし，リンク関数の右辺は実数全体をとり得ます．そのため，それらを$[0, 1]$内の値に変換しなければなりません．そのためにロジット関数を用いて値を変換しています．

事前分布には，どの変数にも「こうだ」という信念がないことを表すためにコーシー分布を用いています．

```math
\begin{align}
    \beta_k & \sim \mbox{Cauchy} (0, 50) \quad (k = 1, 2, ..., 7) & (事前分布)
\end{align}
```

以上が今回用いる統計モデルです．

### 4. データリストの作成

Stanに引き渡すためのデータリストを作成します．今回は変数が多いのでデザイン行列を用いることにします．デザイン行列とは，簡単にいうとデータをまとめて引き渡すための行列のことです．

```math
\begin{align}
    & \beta_1 + \beta_2 x_{pcl, i}
        + \beta_3 x_{sex, i} + \beta_4 x_{age, i} + \beta_5 x_{sib, i}
        + \beta_6 x_{par, i} + \beta_7 x_{far, i} = \mathbb{X} \cdot \mathbb{\beta}　
\end{align}
```

以上のように，長かった線形予測子（リンク関数）が$\mathbb{X} \cdot \mathbb{\beta}$で記述できています．$\mathbb{X} \cdot \mathbb{\beta}$の中身は以下の通りです．

```math
\mathbb{X} \cdot \mathbb{\beta} =
\begin{bmatrix}
    1 & x_{pcl, 1} & x_{sex, 1}
        & x_{age, 1} & x_{sib, 1} & x_{par, 1} & x_{far, 1} \\
    1 & x_{pcl, 2} & x_{sex, 2}
        & x_{age, 2} & x_{sib, 2} & x_{par, 2} & x_{far, 2} \\
    1 & x_{pcl, 3} & x_{sex, 3}
        & x_{age, 3} & x_{sib, 3} & x_{par, 3} & x_{far, 3} \\
    \vdots & \vdots & \vdots & \vdots & \vdots & \vdots & \vdots
\end{bmatrix} \cdot
\begin{bmatrix}
    \beta_1 \\ \beta_2 \\ \beta_3 \\ \beta_4 \\
        \beta_5 \\ \beta_6 \\ \beta_7 \\
\end{bmatrix}
```

ここで，デザイン行列は$\mathbb{X}$を指します．データセットに切片となる変数を追加するとデザイン行列となります．

Rでデザイン行列を作成するには以下のコードを使います．

```r:titanic.R
> formula_titanic <- formula(Survived ~ Pclass + Sex + Age
+                             + SibSp + Parch + Fare)
> design_train <- model.matrix(formula_titanic, data = myd_train)
> head(design_train)
  (Intercept) Pclass Sexmale      Age SibSp Parch    Fare
1           1      3       1 22.00000     1     0  7.2500
2           1      1       0 38.00000     1     0 71.2833
3           1      3       0 26.00000     0     0  7.9250
4           1      1       0 35.00000     1     0 53.1000
5           1      3       1 35.00000     0     0  8.0500
6           1      3       1 29.69912     0     0  8.4583
```

一番左に`(Intercept)`が追加され，デザイン行列を作成することができました．これはパラメタ（$\beta_k$）を推定するためのトレーニングデータを引き渡すデザイン行列です．

今回は推定だけでなく，予測まで行います．そのため，別途予測のためのデザイン行列も作成しなければなりません[^pred]．

[^pred]: トレーニングデータでベイズ推定をし，その後推定されたパラメタ$\beta_k (k = 1, 2, ...7)$とテストデータを用いて結果（生存か死亡）を予測します．そのため，テストデータもStanに引き渡す必要があります．

テストデータは`Survived`変数が欠損しているため，上記の方法ではデザイン行列を作ることはできません．そのため手間はありますがマニュアルで作ります．

```r:titanic.R
> design_test <- myd_test[, c(-1, -2)] |>              # PassengerId, Survivedを除去
+   mutate(Intercept = rep(1, times = n()),            # 切片を追加
+          Sex       = ifelse(Sex == 'male', 1, 0))    # Sexをダミー変数に変換
> design_test <- design_test[, c(7, 1, 2, 3, 4, 5, 6)] # 変数を並び替え．
> head(design_test)
# A tibble: 6 × 7
  Intercept Pclass   Sex   Age SibSp Parch  Fare
      <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
1         1      3     1  34.5     0     0  7.83
2         1      3     0  47       1     0  7   
3         1      2     1  62       0     0  9.69
4         1      3     1  27       0     0  8.66
5         1      3     0  22       1     1 12.3 
6         1      3     1  14       0     0  9.22
```

予測のためのデザイン行列を作成することができました．デザイン行列は`data.frame`型で引き渡すことも可能です．

以上の操作を経て，ようやくデータをリストにまとめることができます．今回は，各データはもちろん，サンプルサイズとデザイン行列の列数（$K$; 切片を含む説明変数の数）もリストにまとめる必要があります．また，予測に用いるデザイン行列とそのサンプルサイズも別で引き渡します．

```r:titanic.R
> myd_list <- list(
+   N = nrow(myd_train),     # トレーニングデータのサンプルサイズ
+   K = 7,                   # デザイン行列の列数
+   Y = myd_train$Survived,  # 結果変数
+   X = design_train,        # デザイン行列（推定）
+   N_pred = nrow(myd_test), # テストデータのサンプルサイズ
+   X_pred = design_test     # デザイン行列（予測）
+ )
```

### 5. Stanファイルの記述

Stanファイルを記述します．今回は`data{}`ブロック，`parameters{}`ブロック，　`transformed parameters{}`ブロック，`model{}`ブロックに加え，`generated quantities{}`ブロックを記述します．

`generated quantities{}`ブロックは，推定したパラメタを用いて値を生成したい時に使います．

**`data{}`ブロック**

```stan:titanic.stan
data {
  int<lower=0> N;           // トレーニングデータのサンプルサイズ
  int<lower=0> K;           // デザイン行列の列数
  array[N] int Y;           // 結果変数
  matrix[N, K] X;           // デザイン行列（推定）
  int<lower=0> N_pred;      // テストデータのサンプルサイズ
  matrix[N_pred, K] X_pred; // デザイン行列（予測）
}
```

先ほどRスクリプトファイルでリストにまとめたデータをStanでも定義します．

行列は`matrix`で定義できます．`[N, K]`で，`N`行`K`列の行列であると指定しています．

**`parameters{}`ブロック**

```stan:titanic.stan
parameters {
  vector[K] beta;
}
```

今回推定したいパラメタは$\beta_k (k = 1, 2, ..., 7)$です．デザイン行列を用いているため，要素が`K`個のベクトル`beta`として定義しています．デザイン行列の列数`K = 7`が，そのまま推定したい$\beta$の数に一致します．

**`transformed parameters{}`ブロック**

```stan:titanic.stan
transformed parameters {
  vector[N] theta = inv_logit(X * beta);
}
```

このブロックはパラメタを変換するために記述します．今回はリンク関数にもある通り，$\mathbb{X} \cdot \mathbb{\beta}$をロジット関数で変換した値を$\theta$として採用します．そのための関数として`inv_logit()`関数を用いて値を変換します[^theta]．

[^theta]: この変換は次のように行なっています．
$$
\mbox{logit} (\theta) = \mathbb{X} \cdot \mathbb{\beta} 
\quad \Leftrightarrow \quad
\theta = \mbox{logit}^{-} (\mathbb{X} \cdot \mathbb{\beta})
$$
ここで，$\mbox{logit} (\theta) = \mathbb{X} \cdot \mathbb{\beta}$が『3. データ生成過程の確認・モデルの作成』で設定したリンク関数そのもので，$\theta = \mbox{logit}^{-} (\mathbb{X} \cdot \mathbb{\beta})$がリンク関数を$\theta$について解いたものです．Stanでは後者を用いて`theta`を定義しています．そのため`logit()`関数ではなく`inv_logit()`関数なのです．

**`model{}`ブロック**

```stan:titanic.stan
model {
  Y ~ bernoulli(theta);
  beta ~ cauchy(0, 50);
}
```

統計モデルの，尤度関数と事前分布にあたる部分を記述します．結果変数$Y$は，パラメタが$\theta$（`theta`）のベルヌーイ分布に，パラメタ$\beta_k (k = 1, 2, ..., 7)$はコーシー分布に従うと仮定しています．

**`generated quantities{}`ブロック**

```stan:titanic.stan
generated quantities {
  vector[N_pred] theta_pred;
  vector[N_pred] Y_pred;
  for (n in 1:N_pred) {
    theta_pred[n] = inv_logit(X_pred[n,] * beta);
    Y_pred[n] = bernoulli_rng(theta_pred[n]);
  }
}
```

推定したパラメタを用いて予測をしたい場合はこのブロックを記述します．

まず変数を定義します（`vector[N_pred] theta_pred;`, `vector[N_pred] Y_pred;`）[^gene]．

[^gene]: Rで結果を格納するための空のベクトルを作るイメージです．

`theta_pred`に，予測のためのデザイン行列`X_pred`と，推定されたパラメタ`beta`を用いて算出した値（もちろん`inv_logit()`で変換する）を代入し，その`theta_pred`をパラメタに持つベルヌーイ分布から結果変数`Y_pred`の値を生成しています[^rng]．

[^rng]: `bernoulli_rng()`はベルヌーイ分布から乱数を生成するという関数です．他にも正規分布から乱数生成をする`normal_rng()`や，ポアソン分布から乱数生成する`poisson_rng()`があります．

### 6. MCMCの実行

まず，先ほど作成したStanファイルをコンパイルします．

```r:titanic.R
> stan_titanic <- cmdstan_model('titanic.stan')
```

`$sample()`関数を用いてMCMCを実行します．

```r:titanic.R
> fit_titanic <- stan_titanic$sample(
+   data = myd_list,     # 引き渡すデータ
+   seed = 1912-04-14,   # 乱数の種
+   chains = 4,          # チェイン数
+   refresh = 1000,      # コンソールに表示する結果の間隔
+   iter_warmup = 1000,  # バーンイン期間
+   iter_sampling = 3000 # サンプリング数
+ )
Running MCMC with 4 chains, at most 8 in parallel...

All 4 chains finished successfully.
Mean chain execution time: 4.2 seconds.
Total execution time: 4.4 seconds.
```

### 7. 結果の確認

`$summary()`で結果を確認できます．今回は数が多いので`$summary('beta')`として，`beta`のみを表示しています[^res]．

[^res]: 今回興味があるのは結果変数の予測値なので，正直$\beta_k (k = 1, 2, ..., 7)$は確認しなくても良いです．

```r:titanic.R
> fit_titanic$summary('beta')
# A tibble: 7 × 10
  variable     mean   median      sd     mad        q5      q95  rhat ess_bulk ess_tail
  <chr>       <dbl>    <dbl>   <dbl>   <dbl>     <dbl>    <dbl> <dbl>    <dbl>    <dbl>
1 beta[1]   5.00     5.00    0.539   0.543    4.10      5.88     1.00    4854.    6572.
2 beta[2]  -1.09    -1.09    0.140   0.138   -1.32     -0.860    1.00    5741.    6632.
3 beta[3]  -2.79    -2.79    0.203   0.205   -3.13     -2.46     1.00    7669.    7885.
4 beta[4]  -0.0404  -0.0403  0.00789 0.00786 -0.0535   -0.0275   1.00    6987.    7948.
5 beta[5]  -0.365   -0.360   0.111   0.111   -0.552    -0.189    1.00    8671.    7697.
6 beta[6]  -0.120   -0.118   0.120   0.120   -0.321     0.0738   1.00    8597.    7793.
7 beta[7]   0.00320  0.00311 0.00244 0.00239 -0.000635  0.00733  1.00   10158.    9221.
```

**収束の確認**

推定値が収束しているかを以下の2点で確認します．

1. $\hat{R}$がすべて1.1以下か
1. 全てのチェインのトレースプロットが重なっているか

まず$\hat{R}$を確認します．以下のコードで確認できます（少し時間がかかります）．

```r:titanic.R
> all(fit_titanic$summary()[, 'rhat'] < 1.1)
[1] TRUE
```

`TRUE`が返ってきたので$\hat{R}$は全て1.1以下であることがわかりました．

続いてトレースプロットです．可能ならすべてのトレースプロットを確認したいのですが，それは不可能なので代表して`beta[1]`（つまり切片）のみ確認します．

まず推定結果をデータフレームとして得ます．

```r:titanic.R
> post_titanic <- fit_titanic$draws() |>
+   as_draws_df() |>
+   mutate(chains = as.factor(.chain))
```

このデータフレームを用いてトレースプロットを描きます．

```r:titanic.R
> post_titanic |>
+   ggplot() +
+   geom_line(aes(x = .iteration,
+                 y = `beta[1]`,
+                 color = chains)) +
+   labs(x = 'iteration', y = expression(beta[1])) +
+   theme_minimal()
```

![traceplot.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3765399/1eba6f9e-a663-d2ba-9143-9b2b4810160e.png)

4つのチェイン全てにおいて，推定値が約5.0周辺に集まっています．

よって，結果は収束しているということがわかりました．

## 結果の提出

以上の結果から，乗客の生死を予測し，そのデータをKaggleに提出しましょう．

**結果から生死の予測**

今回のベイズ推定では，テストデータの乗客の生死について，各チェイン3,000個の値（0か1）をベルヌーイ分布から生成しています．つまり，1人の乗客につき合計で12,000個の0か1の値を持っています[^sub]．

[^sub]: チェインは4つあるので．

各乗客が持つ0か1の値のうち，1（生存）が50%以上なら生存，50%未満なら死亡と判断します[^DorA]．この操作をRで行います．

[^DorA]: 12,000回の乱数生成で何度１（つまり生存）が生成されたか．6,000回以上なら生存とします．

テストデータの乗客の生死については結果の`Y_pred`にあります．

```r:titanic.R
> fit_titanic$summary('Y_pred')
# A tibble: 418 × 10
   variable     mean median    sd   mad    q5   q95  rhat ess_bulk ess_tail
   <chr>       <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>    <dbl>    <dbl>
 1 Y_pred[1]  0.0843      0 0.278     0     0     1  1.00   11530.       NA
 2 Y_pred[2]  0.387       0 0.487     0     0     1  1.00   11882.       NA
 3 Y_pred[3]  0.0833      0 0.276     0     0     1  1.00   11842.       NA
 4 Y_pred[4]  0.104       0 0.305     0     0     1  1.00   11749.       NA
 5 Y_pred[5]  0.597       1 0.490     0     0     1  1.00   11745.       NA
 6 Y_pred[6]  0.174       0 0.379     0     0     1  1.00   12011.       NA
 7 Y_pred[7]  0.629       1 0.483     0     0     1  1.00   12053.       NA
 8 Y_pred[8]  0.192       0 0.394     0     0     1  1.00   11548.       NA
 9 Y_pred[9]  0.732       1 0.443     0     0     1  1.00   12085.       NA
10 Y_pred[10] 0.0728      0 0.260     0     0     1  1.00   11856.       NA
# ℹ 408 more rows
# ℹ Use `print(n = ...)` to see more rows
```

推定値は0か1なので，12,000個の推定値の平均を取った`mean`列がそのまま各乗客の生存確率となります．この値をベクトルとして取り出します．

```r:titanic.R
> res <- fit_titanic$summary('Y_pred')[, 'mean'] |> unlist()
```

そのまま取り出すとリスト型のままとなり，扱いづらいので`unlist()`を用いてリストを解除しています．

`res`に格納されている生存確率は，テストデータの乗客に対応しているので，`for`文を用いて元のデータに0か1の値を代入します．

```r:titanic.R
> for (n in 1:nrow(myd_test)) {
+   myd_test$Survived[n] <- ifelse(res[n] < 0.5, 0, 1)
+ }
> myd_test$Survived |> head(10)
 [1] 0 0 0 0 1 0 1 0 1 0
```

各乗客の生死予測値が代入されました．

ちなみに，各乗客の生死を可視化したものがこちらです．

![pred.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3765399/75c3b696-3ab4-a556-97b3-7a18df7d14b2.png)

性別によって生死にかなり違いが見られます．女性の方がより生き残ると予測されています．$\beta_3 = -2.79$と推定されており，男性（データが1）であることが生存確率を減少させるという結果になっています．

**予測データの提出**

予測はcsvファイルで提出します．`PassengerId`, `Survived`の2つが必要です．この2つの変数を抜き出して`mySubmit.csv`（ファイル名はなんでも良い）としてcsvファイルを作成します．

```r:titanic.R
> write_csv(myd_test |> select(PassengerId, Survived),
+           'mySubmit.csv')
```

`mySubmit.csv`をKaggleのページから提出します．右上の`Submit Prediction`から提出できます．

![submission.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3765399/1847e007-a4a5-29f8-5ec1-7f9c80c8bab3.png)

今回のスコアは0.75でした．つまり約75%の正答率ということです．テストデータには418人のデータがあったので，だいたい300人強の生死を予測することができました．

## 最後に

本記事ではベイズ推定を用いて，Kaggleのタイタニック問題を解いてみました．

正答率は75%とまずまずな結果です．改善できる箇所があるとすれば，欠損値の処理方法や分析に含める変数，また推定値から生死を判断する確率（今回は50%とした）を変更するなどでしょうか．

私の指導教員曰く，予測の精度は機械学習に勝てないとのことなので，より精度を上げたい方は機械学習を勉強するべきなのかもしれません．

ただ，本記事や過去の記事（[CmdStanの解説記事](https://qiita.com/Honoka-Nakano/items/b26222aec402b9ecabf9)）を読んで，ベイズ推定の良さや楽しさを感じて頂けたら幸いです．
