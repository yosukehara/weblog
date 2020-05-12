# KNIME 実践編 / 解約予測

* 初版作成日: 2020-04-30
* 最終更新日: 2020-05-12


## ワークフロー全体

*Fig. 全体ワークフロー*

![ワークフロー](images/knime-4/workflow.png)


## 分析用データ読み込み, 前処理

*Fig. 分析用データ読み込み, 前処理 ワークフロー*

![分析用データ読み込み, 前処理 ワークフロー](images/knime-4/wf-part-1/wf-part-1.png)

### 分析用データ読み込み

*Fig. 分析用データ読み込み/設定*

![](images/knime-4/wf-part-1/wf1-node-1-1.png)


### データ確認

*Fig. データ確認 (1)*

![](images/knime-4/wf-part-1/wf1-node-2-1.png)

*Fig. データ確認 (2)*

![](images/knime-4/wf-part-1/wf1-node-2-2.png)

*Fig. データ確認 (3)*

![](images/knime-4/wf-part-1/wf1-node-2-3.png)

### 色識別設定

*Fig. 継続/解約 色設定*

![](images/knime-4/wf-part-1/wf1-node-3-1.png)

### 欠損値含む行削除

*Fig. 欠損値 設定*

![](images/knime-4/wf-part-1/wf1-node-4-1.png)

### 文字列カラムの数値変換

*Fig. 文字列カラム 数値変換 / 設定*

![](images/knime-4/wf-part-1/wf1-node-5-1.png)

### テーブル分割

*Fig. テーブル分割 / 設定*

![](images/knime-4/wf-part-1/wf1-node-6-1.png)

入力テーブルは2つのパーティション *(トレーニング用とテスト用)* に分割されます。 それぞれのパーティションには、出力ポートが存在するので、このノードの後ろに繋がるノードは、分割されたテーブルを利用することになります。

今回の演習では、**トレーニング用レコード と テスト用レコードの割合を 「80% : 20%」に設定**しています。


## モデル作成, モデル評価 (4モデル)

*Fig. モデル作成, モデル評価 ワークフロー*

![モデル作成, モデル評価 ワークフロー](images/knime-4/wf-part-2/wf-part-2.png)

### 1. Multi Layer Perceptron


### 2. Random Forrest


### 3. Logistic Regression


### 4. Decision Tree

Decision Tree *(決定木)* は、回帰分析、クラス分類に利用されます。回帰モデル、クラス分類モデルが Tree(木)構造のため、モデルを直感的に理解することができます。その反面、このモデルの精度は他の高度なモデルよりも精度が落ちる事が多いと言われています。

#### **学習**

Decision Tree Learningノードの設定画面で、以下の6つの項目を設定します。データの特徴、分析内容に従って これらの設定を行う必要があります。

| 項目 | 説明 | 設定|
| ---- | ---- | ---- |
| 1. Class column | 分類対象クラスのカラム名 | Churn *(解約/継続カラム)* |
| 2. Quality measure | データ分割手法:<br/>- `Gini Index`<br/>- `Gain Ratio`| Gini Index [^1] |
| 3. Pruning method | 剪定有無:<br/>- `MDL (最小記述長)` - 過学習抑止<br/>- `No pruning (無剪定)` | MDL [^2] |
| 4. Reduced Error Pruning | 単純な剪定方法を使用、剪定エラーの削減には単純さと速度の利点がある | ON |
| 5. Min number records per node | 各ノードで最低限必要なレコードの最小数を指定する<br/> レコード数がこの指定値以下の場合、ツリーはそれ以上大きくならない | 2 |
| 6. Average split point | - `ON`: 数値属性の分割値は、2つのパーティションを分離する2つの属性値の平均値に従って決定される <br/>- `OFF`: 分割値は下位パーティションの最大値に設定される |  ON |

*Fig. Decision Tree / 学習.設定*

![](images/knime-4/wf-part-2/wf2-dt-node-1-1.png)


Decision Tree Learnerノードの実行結果を確認することで、生成された Decision Tree(決定木) を確認できます。Decision Treeは、二分木構造であり、根から葉に向かって順番に条件分岐を辿ることで最終的な結果を返すことがわかります。図を見ると、*ROOT 〜 Contract 〜 InternetService 〜 tenure ...*  - Decision Tree *(決定木)* が構築されていることがわかります。

*Fig. Decision Tree / 学習.結果*

![](images/knime-4/wf-part-2/wf2-dt-node-1-2.png)

#### **予測**

Decision Tree Predictorノードの設定は、**Append columns with normalized class distribution** *(正規化されたクラス分布で列を追加する)* を "ON" にすることで、各予測の正規化されたクラス分布を表示します。 

*Fig. Decision Tree / 予測.設定*

![](images/knime-4/wf-part-2/wf2-dt-node-2-1.png)

既存のテーブルに 以下の3カラムが追加されていることを確認します。次のステップでは、継続/退会 の判別精度を評価します。

* P (Churn = No) : `Churn = No` の割合
* P (Churn = Yes) : `Churn = Yes` の割合
* Prediction (Churn) : 予測結果

*Fig. Decision Tree / 予測.結果*

![](images/knime-4/wf-part-2/wf2-dt-node-2-2.png)

#### **評価 (1)**

継続/退会 の判別精度を評価するため、次の通り Sorerノード を設定します。

* First Column *(データの実クラス)* : `Churn`
* Second Column *(データの予測クラス)* : `Prediction (Churn)`

*Fig. Decision Tree / 評価(1).設定*

![](images/knime-4/wf-part-2/wf2-dt-node-3-1.png)

Scorerノードを実行すると **Confusion Matix** *(混同行列)* をテーブル形式で表示します。また、**Accuracy Statistics (下図参照)** *(精度統計)* を表示することで、詳細な精度を確認することができます。

* Accuracy *(精度)* : 0.802
* Kohen's Kappa *(カッパ係数)*  [^3] : 0.446

*Fig. Decision Tree / 評価(1).結果*

![](images/knime-4/wf-part-2/wf2-dt-node-3-2.png)

Accuracy *(精度)*, Kohen's Kappa *(カッパ係数)* 共に 1.0に近づくほど精度が高いとされています。カッパ係数の基準 *(Landis and Koch 基準)* は以下の通りです。

**Landis and Koch 基準:**

| カッパ係数 範囲 | 解釈 |
|:----:|----|
| 0.00  - 0.20 | わずかに一致 *(slight agreement)* |
| 0.21 - 0.40 | まずまずの一致 *(fair agreement)* |
| 0.41 - 0.60 | 中等度の一致 *(moderate agreement)* |
| 0.61 - 0.80 | かなりの一致 *(substantial agreement)* |
| 0.81 - 1.00 | ほぼ完全、完全一致 *(almost perfect or perfect agreement)* |


#### **評価 (2)**

ROC *(Receiver Operating Characteristic)* Curve *(ROC曲線)* は、二値分類の評価で使われます。Y軸にTPR *(True Positive Rate - 真陽性率)*、X軸に FPR *(False Positive Rate - 偽陽性立)* の割合をプロットします。AUC *(Area Under the Curve)* は、その曲線の下部の面のことであり、AUC の面積が大きいほどモデルの性能が良いとされています。

以下の通り ROC Curveノード を設定します

* Class column : Churn
* Positive class value : No
* Columns containing the positive class probablities : P (Chuen = No)

*Fig. Decision Tree / 評価(2).設定*

![](images/knime-4/wf-part-2/wf2-dt-node-4-1.png)

ROC Curveノード の実行結果は、次の通り **「AUC: 0.823」** であることがわかります

*Fig. Decision Tree / 評価(2).結果 - ROC曲線*

![](images/knime-4/wf-part-2/wf2-dt-node-4-2.png)

*Fig. Decision Tree / 評価(2).結果 - AUC*

![](images/knime-4/wf-part-2/wf2-dt-node-4-3.png)


[^1]: <a href="https://ja.wikipedia.org/wiki/ジニ係数" target="_blank">Gini Index *(ジニ係数)*</a>
[^2]: <a href="https://ja.wikipedia.org/wiki/最小記述長" target="_blank"> MDL *(最小記述長)*</a>
[^3]: <a href="https://en.wikipedia.org/wiki/Cohen%27s_kappa" target="_blank"> Kohen's Kappa *(カッパ係数)*</a>