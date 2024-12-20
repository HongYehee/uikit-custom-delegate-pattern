//  ViewController.swift
//  MemberList

import UIKit

final class ViewController: UIViewController {
    
    // 테이블 뷰 만들기 (뷰를 따로 분리해서 만들 필요 없음)
    private let tableView = UITableView()
    
    // 비즈니스 로직을 관리할 수 있는 멤버 리스트 매니저 모델 생성
    var memberListManager = MemberListManagger()
    
    // 내비게이션 바에 넣기 위한 버튼
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupDatas()
        setupTableView()
        setupNavBar()
        setupTableViewConstraints()
    }
    
    // 업데이트가 된 경우 테이블 뷰 다시 그리기
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        tableView.reloadData()
//    }
    
    // 내비게이션 바 설정
    func setupNavBar() {
        title = "회원 목록"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 내비게이션 바 오른쪽 상단 버튼 설정
        self.navigationItem.rightBarButtonItem = self.plusButton
    }
    
    // 테이블 뷰 설정
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 60
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MemberCell")
    }
    
    // 배열에 데이터가 생기도록 멤버를 만드는 함수
    func setupDatas() {
        memberListManager.makeMembersListDatas() // 일반적으로는 서버에 요청
    }
    
    // 테이블 뷰의 오토 레이아웃 설정
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    // 멤버를 추가하기 위한 다음 화면으로 이동
    @objc func plusButtonTapped() {
        // 다음 화면으로 이동 (멤버는 전달하지 않음)
        let detailVC = DetailViewController()
        
        // 다음 화면의 대리자 설정 (현재의 뷰 컨트롤러)
        //detailVC.delegate = self
        
        // 화면 이동
        navigationController?.pushViewController(detailVC, animated: true)
        //show(detailVC, sender: nil)
    }
}

// TableView 사용 시 UITableViewDataSource 프로토콜 채택
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberListManager.getMembersList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MyTableViewCell
        
        cell.member = memberListManager[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 다음 화면으로 넘어가는 코드
        let detailVC = DetailViewController()
        detailVC.delegate = self
        
        let array = memberListManager.getMembersList()
        detailVC.member = array[indexPath.row]
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: MemberDelegate {
    func addNewMember(_ member: Member) {
        memberListManager.makeNewMember(member)
        tableView.reloadData()
    }
    
    func update(index: Int, _ member: Member) {
        memberListManager.updateMemberInfo(index: index, member)
        tableView.reloadData()
    }
}
