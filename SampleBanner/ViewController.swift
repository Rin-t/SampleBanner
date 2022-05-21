//
//  ViewController.swift
//  SampleBanner
//
//  Created by Rin on 2022/05/21.
//

import UIKit

struct Banner {
    let title: String
    let backgroundColor: UIColor
}

final class ViewController: UIViewController {

    typealias Cell = BannerCollectionViewCell

    // Outlets
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(Cell.nib(), forCellWithReuseIdentifier: Cell.identifier)
            collectionView.delegate = self
            collectionView.dataSource = self

            // ↓ページング機能をonにできます。cellを切り替える毎に止まってくれます。
            collectionView.isPagingEnabled = true
            // ↓スクロールするときに現在地を示してくれるバーの表示非表示ができます。
            collectionView.showsHorizontalScrollIndicator = false

            let layout = UICollectionViewFlowLayout()
            // 横スクロールしかできないようにします
            layout.scrollDirection = .horizontal
            // cell間の間を詰めます。これがないとスクロールしたときに余白ができてしまいます。
            layout.minimumLineSpacing = 0
            collectionView.collectionViewLayout = layout

        }
    }

    // Properties
    private let banners = [
        Banner(title: "ヨッシーの本名", backgroundColor: .blue),
        Banner(title: "実は", backgroundColor: .red),
        Banner(title: "T.ヨシザウルスムンチャクッパス", backgroundColor: .systemGreen)
    ]
    private var timer: Timer!
    private var currentIndex = 0

    // LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimer()
        pageControl.numberOfPages = banners.count
    }

    // Methods
    private func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    // タイマーの処理
    @objc private func timerAction(){
        let scrollPosition = (currentIndex < banners.count - 1) ? currentIndex + 1 : 0
        collectionView.scrollToItem(at: IndexPath(item: scrollPosition, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = scrollPosition
        currentIndex = scrollPosition
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
        let banner = banners[indexPath.row]
        cell.configure(title: banner.title, backgroundColor: banner.backgroundColor)
        return cell
    }

    // スクロールが完全に止まったら呼ばれる: 手動でスクロールされたときのみ呼ばれる
    // 手動でバナーをスクロールした際にPageControlのPageを更新する
    // 手動でスクロールした場合は既存のタイマーの処理を止めて、
    // 現在のIndexでもう一度タイマーをセットし直す。
    // この処理を入れないと、自動スクロールをしている最中に手動でスクロールした場合、
    // PageControlやスクロールのタイミングがずれてしまいます。
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        timer.invalidate()
        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = currentIndex
        setTimer()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.window?.bounds.width ?? 0
        return CGSize(width: width, height: width * 0.3)
    }
}

