# 들어봄 (Heard It Before)
### [소개](https://retrievemusic.wordpress.com)
* 오디오 인식을 통해 음원 메타데이터를 찾아 주고, 해당 결과를 기반으로 국내 음원 사이트에 검색해주는 앱입니다.
* 주로 외국 음악을 즐겨 듣는 청자들로부터, 국내 음원 사이트마다 가지고 있는 음원의 풀이 다르다는 불편함을 접했고, 이를 해결하기 위해 만들었습니다.
* 국내 서비스중인 6개 음원 사이트에 한 번에 검색해주어, 상위 3개의 검색 결과를 표시해 줍니다.
* 이를 통해 각기 다른 사이트에 여러 번 검색하는 수고를 덜 수 있습니다.
* [App Store 링크](https://apps.apple.com/kr/app/retrievemusic/id1594913051)
---
### 사용 기술 및 라이브러리
* iOS SDK 중 ShazamKit을 사용해 오디오 인식을 통한 검색 기능을 구현했습니다.
* REST API와 Web Crawling을 통해 국내 음원 사이트 검색 결과를 수집했습니다.
* 패키지 관리 툴로 Swift Package Manager를 사용했습니다.
* 오픈 소스 라이브러리는 [Alamofire](https://github.com/Alamofire/Alamofire), [Kingfisher](https://github.com/onevcat/Kingfisher), [SwiftSoup](https://github.com/scinfu/SwiftSoup)를 사용했습니다.
* UI 디자인은 UIKit과 Auto Layout 기능을 사용했으며, Storyboard를 사용하지 않고 개별 xib 뷰를 직접 제작하고 연결했습니다.
* 내부 디자인 패턴은 MVC로 처음 제작되었으며, 이후 유지 보수의 용이함을 위해 MVVM 패턴(1.2.0) 및 [RxSwift](https://github.com/ReactiveX/RxSwift)(1.3.0)를 활용하여 리팩토링하였습니다.
* 버전 관리 과정에서 git-flow 방법론을 사용하고자 했습니다.
---
### 업데이트 예정사항
* Spotify, Vibe 사이트 지원
* 검색 기록을 저장하고 표시
* 텍스트 기반 검색
* 검색 편의성 증대 : 검색 버튼 확대
---
* [제작 과정 To-do 및 자체 피드백](https://windy-crayfish-861.notion.site/WhereIsMyMusic-90b32a3ea3874eafa0b2c2df37837b52)
* 이 Repository는 `main` 브랜치에 갱신되고 있습니다.
