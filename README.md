LDETL
======

概要, Description
----

LDETL は，Linked (Open) Data に対する ETL（Extract, Transform, and Load）処理を行うための，ruby向けプログラミングライブラリです．これにより，Linked Dataとして公開されている，数値・統計データを含むデータに対して，Pentaho Mondrian などの既存のOLAPツールを用いた多次元分析処理が可能になります．

本プロジェクトは下記の研究成果の一部をライブラリ化するものであり，分析対象のデータ内部および外部の（リンクしている）情報を利用し，OLAPに必要な次元候補を導出します．


A programming library to apply ETL(Extract, Transform, and Load) operations on Linked (Open) Data. LDETL is implemented in ruby and uses with ruby as a library (gem). Using this library, we can apply multidimensional analysis to data which contains numerical and/or statistical values, and are published as Linked (Open) Data with existing OLAP system such as Pentaho Mondrian.

This project arranges the following research results as a library. Explores internal and external (linked) information of target data and induce dimensions for OLAP analysis.

For LOD Challenge 2012
----

本ライブラリはLOD Challenge 2012に向けて開発されていましたが，残念ながらまだ完成していません．現在は，ターゲットデータセットの抽出とデータベースへの格納，メジャー（分析対象）の列挙のみ可能です．

This library is developed for deadline of LOD Challenge 2012 (in Japan), but unfortunately,  it's not completed. It provides only extraction and storing target dataset to RDB and enumerates candidates of measure (target of analysis) .

Research Information
----

井上寛之，天笠俊之，北川博之, "OLAPを利用したLinked Dataの分析処理", 情報処理学会 第74回全国大会, 2N-2, 2012年3月6日-8日.
http://www.slideshare.net/inohiro/mm-13219298

License
----
Copyright (c) 2012-2013 Hiroyuki Inoue.
