# データ分析プラットフォーム / KNIME
## KNIME 概要

* <a href="https://www.knime.com/" target="_blank">KNIME (ナイム)</a>は、データ連携・統合・分析を自動化することができるエンドツーエンドのデータ分析プラットフォームです
	* ワークフロー型データ分析プラットフォーム - ノードと呼ばれる機能のかたまり(モジュール)を繋げていくことで、さまざまな処理を実現します
	* 2000を超えるノード、数多くのワークフローサンプル、包括的な統合ツール、様々なアルゴリズムが利用でき、データに隠されている可能性を発見したり、新たな知見を得たり、未来を予測するのに役立ちます
	* ビルトイン機械学習モジュールを利用し、高度な分析や分析の自動化を実現することができます


## KNIME 入門編 / 前処理 (1)

ビッグデータでは、大量のテキストデータ、数値データを扱います。数値データには、欠損値、異常値などを含む為、そのままデータ分析を進めても期待した結果・効果を得ることができません。データ分析では、データの誤り、漏れ、不足、矛盾を事前にチェックし、データを整える「前処理」という工程が必要とされています


### 事例概要

1. [データ処理] 顧客マスター
	- フォーマット修正
		- 氏名
		- 登録日
    - 処理後データ出力 *(CSV形式ファイル)*
2. [データ処理] 売上データ
	- フォーマット修正
		- 購買日 
		- 商品名
	- 列追加: 購買年月 *(購買日から作成)*
	- 欠損値処理
		- レコード分割: 欠損値含むレコード, 欠損値含まないレコード
		- 欠損値 置換値の算出: 欠損値含まないレコードを元に 商品別平均値算出
		- 欠損値 置換
		- レコード連結: 欠損値含むレコード, 欠損値含まないレコード
3. [データ処理後] 売上データと顧客マスター
	- 売上データと顧客マスターの連結
	- 連結後レコード出力 *(CSV形式ファイル)*

### 実装後スクリーンショット
#### 全体
![](images/knime_practice_1_1.png)

#### 顧客マスタ 前処理

META_顧客マスタ

![](images/knime_practice_1_2.png)

#### 売上データ 前処理

META_売上データ

![](images/knime_practice_1_3.png)


### 利用するノード (モジュール)

|  カテゴリー |モジュール  |  機能  |
| :----: | :----: | :--- |
|  IO | ![](images/node_io_excel_reader.png) | Excel スプレッドシートをの1つのシートからデータのみを読み取ります。数値、日付、ブール値、文字列のデータのみを読み取ることができます。図、写真、その他のアイテムは読み取ることができません  |
|  IO | ![](images/node_io_csv_reader.png) |  CSVファイルを読み取ります。ノードが実行されると、入力ファイルをスキャンして列の数とタイプを決定し、自動推測された構造を持つテーブルを出力します  |
|  IO | ![](images/node_io_csv_writer.png) |  入力データテーブルをファイルまたはURLで示されるリモートの場所にCSVフォーマットで書き込みます  |
| Manipulation / Column / Convert, Replace | ![](images/node_string_manipulation.png) |  検索と置換、大文字と小文字の区別、先頭と末尾の空白などの文字列を操作します  |
| Manipulation / Column / Convert, Replace | ![](images/node_string_to_number.png) |  列 *(または列のセット)* 内の文字列を数値に変換します  |
| Manipulation / Column / Convert, Replace | ![](images/node_column_rename.png) |  列名を変更するか、そのタイプを変更します  |
|  TIme Series / Transform | ![](images/node_unix_timestamp_to_datetime.png) | エポック *(1970年1月1日)* 以降の秒単位、ミリ秒単位、マイクロ秒単位、またはナノ秒単位のUNIXタイムスタンプでなければなりません。出力は、ローカルとゾーンの日付と時刻の形式を選択し、必要に応じてタイムゾーンを追加できます  |
|  TIme Series / Transform | ![](images/node_datetime_to_string.png) |  DateTimeFormatterで定義されているユーザー指定のフォーマットパターンを使用して、Date＆Time列の時刻値を文字列に変換します  |
|  TIme Series / Transform | ![](images/node_string_to_datetime.png) |  文字列を解析し、指定されたフォーマットパターンを使用して日付と時刻のセルに変換します。日付には、月や曜日の名前などのローカライズされた用語が含まれる場合があるのでロケールを選択できます |
| Row / Filter | ![](images/node_row_splitter_1.png) |  `Row Filter` とまったく同じ機能を備えています。パフォーマンスとディスク容量の理由から、行フィルターノードの使用を検討する必要があります  |
| Row / Other | ![](images/node_row_id.png) |  入力データの `RowID` を別の列の値 *(値を文字列に変換すること)* にすることができます *(列を新規に作成することも可能)*  |
| Row / Transform | ![](images/node_row_concatenate.png) |  2つのテーブルを連結します  |
| Row / Transform | ![](images/node_group_by.png) |  選択したグループ列の一意の値でテーブルの行をグループ化します。選択したグループ列の値の一意のセットごとに行が作成されます。残りの列は、指定した集計設定に基づいて集計されます  |
| Column / Filter | ![](images/node_column_filter.png) | 入力テーブルの不要な列を出力テーブルから除外します |
| Column / Split and Combine | ![](images/node_joiner.png) |  データベースのような方法で2つのテーブルを結合します (`inner join`, `left outer join` , `right outer join`, `full outer join` のいずれかを指定する)  |
| Scripting / Java  | ![](images/node_java_snipet.png) |  任意のJavaコードを実行して、新しい列を作成したり、既存の列を置き換えたりできます  |
