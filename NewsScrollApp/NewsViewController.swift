//
//  NewsViewController.swift
//  NewsScrollApp
//
//  Created by 原田悠嗣 on 2019/08/11.
//  Copyright © 2019 原田悠嗣. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import WebKit

class NewsViewController: UIViewController, IndicatorInfoProvider, UITableViewDataSource, UITableViewDelegate, WKNavigationDelegate, XMLParserDelegate{

    // テーブルビューのインスタンスを取得
    var tableView: UITableView = UITableView()

    // XMLParserのインスタンスを取得
    var parser = XMLParser()

    // 記事情報の配列の入れ物
//    var articles = NSMutableArray()
    var articles: [Any] = []

    // webview
    @IBOutlet weak var webView: WKWebView!

    // toolbar(4つのボタンがはいってる)
    @IBOutlet weak var toolBar: UIToolbar!
    
    // urlを受け取る
    var url: String = ""
    // itemInfoを受け取る
    var itemInfo: IndicatorInfo = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲートとの接続
        tableView.delegate = self
        tableView.dataSource = self

        // parserとの接続
        parser.delegate = self

        // navigationDelegateとの接続
        webView.navigationDelegate = self

        // tableviewのサイズを確定
        tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 50)

        // tableviewをviewに追加
        self.view.addSubview(tableView)

        // 最初は隠す（tableviewが表示されるのを邪魔しないように）
        webView.isHidden = true
        toolBar.isHidden = true
    }

    // urlを解析する
    func parseUrl() {
        // url型いに変換
        let urlToSend: URL = URL(string: url)!
        // parser に解析対象のurlを格納
        parser = XMLParser(contentsOf: urlToSend)!
        // 記事情報を初期化
        articles = []
        // 解析の実行
        parser.parse()
        // TableViewのリロード
        tableView.reloadData()
    }

    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 記事の数だけセルを返す
        return articles.count
    }

    // セルの設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        // セルの色
        cell.backgroundColor = #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)

        // 記事テキストサイズとフォント
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.black

        // 記事urlのサイズとフォント
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        cell.detailTextLabel?.textColor = UIColor.gray

        return cell
    }

    // セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 後で書く
    }

    // ページの読み込み完了時に呼ばれる
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //tableviewを隠す
        tableView.isHidden = true
        // toolbarを表示する
        toolBar.isHidden = false
        // webviewを表示する
        webView.isHidden = false
    }

    // キャンセル
    @IBAction func cancel(_ sender: Any) {
        tableView.isHidden = false
        toolBar.isHidden = true
        webView.isHidden = true
    }

    // 戻る
    @IBAction func backPage(_ sender: Any) {
        webView.goBack()
    }
    // 次へ
    @IBAction func nextPage(_ sender: Any) {
        webView.goForward()
    }
    // リロード
    @IBAction func refreshPage(_ sender: Any) {
        webView.reload()
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {

        return itemInfo
    }

}
