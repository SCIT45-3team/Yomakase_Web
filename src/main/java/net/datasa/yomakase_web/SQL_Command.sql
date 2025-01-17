CREATE TABLE `member` (
                          `member_num` int auto_increment primary key,
                          `id` varchar(50) NOT NULL UNIQUE,
                          `pw` varchar(100) NOT NULL,
                          `name` varchar(100) NOT NULL UNIQUE,
                          `gen` char(1) NOT NULL,
                          `birth_date` date NOT NULL,
                          `user_role` varchar(30) DEFAULT 'ROLE_USER' CHECK (`user_role` IN ('ROLE_USER', 'ROLE_SUBSCRIBER', 'ROLE_ADMIN')),
                          `enabled` tinyint(1) DEFAULT 1 CHECK (`enabled` IN (1, 0))
);

select * from `member`;
UPDATE `member` SET user_role ='ROLE_ADMIN' WHERE name ='Admin';

CREATE TABLE `stock` (
                         `ingredient_name` varchar(700) NOT NULL,
                         `member_num` int NOT NULL,
                         `is_having` tinyint(1) DEFAULT 1 CHECK (`is_having` IN (0, 1)), -- 1 : 재고 있음, 0 : 재고 없음
                         `use_by_date` DATE NOT NULL,
                         `update_date` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         PRIMARY KEY (`ingredient_name`, `member_num`),
                         FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `stock`;

CREATE TABLE `allergy` (
                           `member_num` int NOT NULL,
                           `eggs` tinyint(1) DEFAULT 0 CHECK (`eggs` IN (0, 1)), -- 1 : 알레르기 있음, 0 : 알레르기 없음
                           `milk` tinyint(1) DEFAULT 0 CHECK (`milk` IN (0, 1)),
                           `buckwheat` tinyint(1) DEFAULT 0 CHECK (`buckwheat` IN (0, 1)),
                           `peanut` tinyint(1) DEFAULT 0 CHECK (`peanut` IN (0, 1)),
                           `soybean` tinyint(1) DEFAULT 0 CHECK (`soybean` IN (0, 1)),
                           `wheat` tinyint(1) DEFAULT 0 CHECK (`wheat` IN (0, 1)),
                           `mackerel` tinyint(1) DEFAULT 0 CHECK (`mackerel` IN (0, 1)),
                           `crab` tinyint(1) DEFAULT 0 CHECK (`crab` IN (0, 1)),
                           `shrimp` tinyint(1) DEFAULT 0 CHECK (`shrimp` IN (0, 1)),
                           `pork` tinyint(1) DEFAULT 0 CHECK (`pork` IN (0, 1)),
                           `peach` tinyint(1) DEFAULT 0 CHECK (`peach` IN (0, 1)),
                           `tomato` tinyint(1) DEFAULT 0 CHECK (`tomato` IN (0, 1)),
                           `walnuts` tinyint(1) DEFAULT 0 CHECK (`walnuts` IN (0, 1)),
                           `chicken` tinyint(1) DEFAULT 0 CHECK (`chicken` IN (0, 1)),
                           `beef` tinyint(1) DEFAULT 0 CHECK (`beef` IN (0, 1)),
                           `squid` tinyint(1) DEFAULT 0 CHECK (`squid` IN (0, 1)),
                           `shellfish` tinyint(1) DEFAULT 0 CHECK (`shellfish` IN (0, 1)),
                           `pine_nut` tinyint(1) DEFAULT 0 CHECK (`pine_nut` IN (0, 1)),
                           PRIMARY KEY (`member_num`),
                           FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `allergy`;

CREATE TABLE `user_body_info` (
                                  `member_num` int NOT NULL,
                                  `weight` int NULL,
                                  `height` int NULL,
                                  PRIMARY KEY (`member_num`),
                                  FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `user_body_info`;

CREATE TABLE `board` (
                         `board_num` int NOT NULL AUTO_INCREMENT,
                         `member_num` int NOT NULL,
                         `title` varchar(200) NOT NULL,
                         `category` varchar(10) NOT NULL,
                         `contents` mediumtext NOT NULL,
                         `create_date` timestamp DEFAULT current_timestamp,
                         `update_date` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         `file_name` varchar(100) NULL,
                         `recommended` int DEFAULT 0 NOT NULL,
                         PRIMARY KEY (`board_num`),
                         FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `board`;

CREATE TABLE `reply` (
                         `reply_num` int NOT NULL AUTO_INCREMENT,
                         `board_num` int NOT NULL,
                         `member_num` int NOT NULL,
                         `reply_contents` varchar(1000) NULL,
                         `create_date`	timestamp default current_timestamp,
                         PRIMARY KEY (`reply_num`),
                         FOREIGN KEY (`board_num`) REFERENCES `board`(`board_num`) ON DELETE CASCADE,
                         FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `reply`;

CREATE TABLE `saved_recipe` (
                                `index_num` int NOT NULL AUTO_INCREMENT,
                                `member_num` int NOT NULL,
                                `food_name` varchar(100) NOT NULL,
                                `recipe_url` varchar(700) NOT NULL,
                                `saved_recipe` mediumtext NOT NULL,
                                PRIMARY KEY (`index_num`),
                                FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `saved_recipe`;

CREATE TABLE `cal` (
                       `input_date` date NOT NULL,
                       `member_num` int NOT NULL,
                       `b_name` varchar(100) NULL,
                       `b_kcal` int DEFAULT 0,
                       `l_name` varchar(100) NULL,
                       `l_kcal` int DEFAULT 0,
                       `d_name` varchar(100) NULL,
                       `d_kcal` int DEFAULT 0,
                       `too_much` mediumtext NULL, -- 과하게 먹은 것.
                       `lack` mediumtext NULL, -- 적게 먹은 것.
                       `recom` mediumtext NULL, -- 권장 식재료 이름만
                       `total_kcal` int DEFAULT 0,
                       `score` int DEFAULT 0, -- 점수 → 마우스 오버시, 혹은 날짜 밑에 표시
                       PRIMARY KEY (`input_date`, `member_num`),
                       FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);
select * from `cal`;

CREATE TABLE `history` (
                           `history_id` int NOT NULL AUTO_INCREMENT, -- 자동 증가하는 기본 키
                           `ingredient_name` varchar(700) NOT NULL,
                           `member_num` int NOT NULL,
                           `date` date NOT NULL, -- 날짜
                           `type` varchar(10) NOT NULL CHECK (`type` IN ('c', 'b')), -- c : 소비, b : 버림
                           PRIMARY KEY (`history_id`),
                           FOREIGN KEY (`ingredient_name`, `member_num`) REFERENCES `stock`(`ingredient_name`, `member_num`) ON DELETE CASCADE -- 외래 키 제약 조건
);


select * from `history`;

CREATE TABLE `subscription` (
                                `subscription_id` int auto_increment primary key,
                                `member_num` int NOT NULL,
                                `start_date` date NOT NULL,
                                `end_date` date NOT NULL,
                                FOREIGN KEY (`member_num`) REFERENCES `member`(`member_num`) ON DELETE CASCADE
);

drop table  allergy ;
drop table  history  ;
drop table  user_body_info  ;
drop table  board  ;
drop table  reply  ;
drop table  saved_recipe  ;
drop table  cal ;
drop table member;
drop table  `stock`;

-- history 테이블에 더미 데이터 추가
INSERT INTO stock (ingredient_name, member_num, is_having, use_by_date, update_date) VALUES
                                                                                         ('토마토', 3, 0, '2024-09-12', '2024-09-12 00:00:00'),
                                                                                         ('당근', 3, 0, '2024-09-13', '2024-09-13 00:00:00'),
                                                                                         ('감자', 3, 0, '2024-09-14', '2024-09-14 00:00:00'),
                                                                                         ('상추', 3, 0, '2024-09-15', '2024-09-15 00:00:00'),
                                                                                         ('양파', 3, 0, '2024-09-16', '2024-09-16 00:00:00'),
                                                                                         ('마늘', 3, 0, '2024-09-17', '2024-09-17 00:00:00'),
                                                                                         ('오이', 3, 0, '2024-09-18', '2024-09-18 00:00:00'),
                                                                                         ('피망', 3, 0, '2024-09-19', '2024-09-19 00:00:00'),
                                                                                         ('시금치', 3, 0, '2024-09-20', '2024-09-20 00:00:00'),
                                                                                         ('브로콜리', 3, 0, '2024-09-21', '2024-09-21 00:00:00'),
                                                                                         ('콜리플라워', 3, 0, '2024-09-22', '2024-09-22 00:00:00'),
                                                                                         ('애호박', 3, 0, '2024-09-23', '2024-09-23 00:00:00'),
                                                                                         ('가지', 3, 0, '2024-09-24', '2024-09-24 00:00:00'),
                                                                                         ('호박', 3, 0, '2024-09-25', '2024-09-25 00:00:00'),
                                                                                         ('고구마', 3, 0, '2024-09-26', '2024-09-26 00:00:00');
INSERT INTO `history` (`ingredient_name`, `member_num`, `date`, `type`) VALUES
                                                                            ('토마토', 3, '2024-09-12', 'c'),  -- 소비
                                                                            ('당근', 3, '2024-09-13', 'b'),    -- 버림
                                                                            ('감자', 3, '2024-09-14', 'c'),    -- 소비
                                                                            ('상추', 3, '2024-09-15', 'b'),    -- 버림
                                                                            ('양파', 3, '2024-09-16', 'c'),    -- 소비
                                                                            ('마늘', 3, '2024-09-17', 'b'),    -- 버림
                                                                            ('오이', 3, '2024-09-18', 'c'),     -- 소비
                                                                            ('피망', 3, '2024-09-19', 'b'),    -- 버림
                                                                            ('시금치', 3, '2024-09-20', 'c'),  -- 소비
                                                                            ('브로콜리', 3, '2024-09-21', 'c'), -- 소비
                                                                            ('콜리플라워', 3, '2024-09-22', 'b'), -- 버림
                                                                            ('애호박', 3, '2024-09-23', 'c'),  -- 소비
                                                                            ('가지', 3, '2024-09-24', 'b'),    -- 버림
                                                                            ('호박', 3, '2024-09-25', 'c'),    -- 소비
                                                                            ('고구마', 3, '2024-09-26', 'b');  -- 버림

-- stock 테이블에 더미 데이터 추가

-- 게시판 공지사항 데이터
INSERT INTO `board` (`member_num`,`title`, `category`, `contents`) values	(1, '[공지사항] 서비스 이용 관련 안내', '공지사항', '서비스 이용 시 아래 내용을 참고하시기 바랍니다.'),	-- member_num은 관리자 계정 번호로 수정해주세요
                                                                             (1, '[공지사항] 9/25 변경사항 알림', '공지사항', '서비스의 내용이 일부 변경되었으니 첨부파일을 참고바랍니다.'),
                                                                             (1, '[공지사항] 10/8 서버점검 예정', '공지사항', '23:00~23:59에 서버점검으로 인해 서비스 이용이 불가하니 참고바랍니다.');

-- 게시판 나만의레시피 데이터
    INSERT INTO `board` (`member_num`,`title`, `category`, `contents`) values	(2, '나만의 김치볶음밥 맛있게 만드는 방법', '나만의레시피', '팬에 간장과 설탕을 태우듯 볶고 밥, 김치, 마요네즈 넣어 볶으면 됌'),
                                                                                (2, '비빔국수 깔끔하게 만들려면', '나만의레시피', '고추장 넣지 말고 고춧가루로 만들면 안 텁텁하고 깔끔해요!'),
                                                                                (3, '이렇게 만들면 엽떡이랑 맛 똑같음', '나만의레시피', '카레가루랑 후추를 넣어보세요'),
                                                                                (3, '엄마한테 전수받은 김치찌개 레시피', '나만의레시피', '고기, 김치 먼저 볶고 끓일 때 국물에 액젓을 넣음');

INSERT INTO `saved_recipe` (`member_num`, `food_name`, `recipe_url`, `saved_recipe`) VALUES
                                                                                         (3, '김치찌개', 'https://www.youtube.com/watch?v=qWbHSOplcvY', '재료: 김치, 돼지고기, 두부, 대파\n1. 김치를 잘게 썰어 냄비에 넣고 볶아주세요.\n2. 돼지고기를 넣고 함께 볶다가 물을 넣고 끓여줍니다.\n3. 두부와 대파를 넣고 한소끔 더 끓여 마무리합니다.'),
                                                                                         (3, '된장찌개', 'https://www.youtube.com/watch?v=ffuakdFmuh4', '재료: 된장, 감자, 두부, 애호박, 표고버섯\n1. 냄비에 된장을 풀고 물을 넣어 끓입니다.\n2. 감자, 두부, 애호박, 표고버섯을 넣고 익을 때까지 끓입니다.\n3. 필요하면 소금으로 간을 맞추고 마무리합니다.'),
                                                                                         (3, '비빔밥', 'https://www.youtube.com/watch?v=Jq2SwKMw8vI', '재료: 밥, 고사리, 시금치, 당근, 계란, 고추장\n1. 밥 위에 다양한 나물과 볶은 야채를 올립니다.\n2. 계란 후라이를 올리고 고추장을 넣어 비벼 드세요.');

INSERT INTO stock (ingredient_name, member_num, is_having, use_by_date, update_date) VALUES
                                                                                         ('삼겹살', 3, 1, '2024-12-30', '2024-10-04 20:10:12'),
                                                                                         ('닭가슴살', 3, 1, '2024-11-25', '2024-10-04 20:10:12'),
                                                                                         ('소고기 등심', 3, 1, '2024-12-15', '2024-10-04 20:10:12'),
                                                                                         ('대패 삼겹살', 3, 1, '2025-01-10', '2024-10-04 20:10:12'),
                                                                                         ('돼지 안심', 3, 1, '2025-01-05', '2024-10-04 20:10:12'),
                                                                                         ('배추', 3, 1, '2024-11-05', '2024-10-04 20:10:12'),
                                                                                         ('양파', 3, 1, '2024-11-20', '2024-10-04 20:10:12'),
                                                                                         ('감자', 3, 1, '2024-11-30', '2024-10-04 20:10:12'),
                                                                                         ('당근', 3, 1, '2024-11-10', '2024-10-04 20:10:12'),
                                                                                         ('파프리카', 3, 1, '2024-11-25', '2024-10-04 20:10:12'),
                                                                                         ('호박', 3, 1, '2024-11-15', '2024-10-04 20:10:12'),
                                                                                         ('오이', 3, 1, '2024-11-12', '2024-10-04 20:10:12'),
                                                                                         ('상추', 3, 1, '2024-11-08', '2024-10-04 20:10:12'),
                                                                                         ('고등어', 3, 1, '2024-12-20', '2024-10-04 20:10:12'),
                                                                                         ('연어', 3, 1, '2024-12-05', '2024-10-04 20:10:12'),
                                                                                         ('오징어', 3, 1, '2025-01-02', '2024-10-04 20:10:12'),
                                                                                         ('참치', 3, 1, '2025-01-20', '2024-10-04 20:10:12'),
                                                                                         ('바지락', 3, 1, '2024-12-30', '2024-10-04 20:10:12'),
                                                                                         ('새우', 3, 1, '2025-02-05', '2024-10-04 20:10:12'),
                                                                                         ('문어', 3, 1, '2025-01-15', '2024-10-04 20:10:12'),
                                                                                         ('미역', 3, 1, '2025-03-01', '2024-10-04 20:10:12'),
                                                                                         ('다시마', 3, 1, '2025-04-10', '2024-10-04 20:10:12'),
                                                                                         ('멸치', 3, 1, '2025-05-15', '2024-10-04 20:10:12'),
                                                                                         ('갈치', 3, 1, '2024-12-20', '2024-10-04 20:10:12'),
                                                                                         ('명태', 3, 1, '2025-01-25', '2024-10-04 20:10:12'),
                                                                                         ('장어', 3, 1, '2024-12-31', '2024-10-04 20:10:12'),
                                                                                         ('조개', 3, 1, '2025-01-10', '2024-10-04 20:10:12'),
                                                                                         ('김치', 3, 1, '2024-12-05', '2024-10-04 20:10:12'),
                                                                                         ('두부', 3, 1, '2024-11-10', '2024-10-04 20:10:12'),
                                                                                         ('버섯', 3, 1, '2024-11-15', '2024-10-04 20:10:12'),
                                                                                         ('고구마', 3, 1, '2024-12-10', '2024-10-04 20:10:12'),
                                                                                         ('브로콜리', 3, 1, '2024-11-20', '2024-10-04 20:10:12'),
                                                                                         ('아스파라거스', 3, 1, '2024-11-18', '2024-10-04 20:10:12'),
                                                                                         ('양배추', 3, 1, '2024-11-12', '2024-10-04 20:10:12'),
                                                                                         ('사과', 3, 1, '2024-11-30', '2024-10-04 20:10:12'),
                                                                                         ('배', 3, 1, '2024-12-05', '2024-10-04 20:10:12'),
                                                                                         ('포도', 3, 1, '2024-11-08', '2024-10-04 20:10:12'),
                                                                                         ('바나나', 3, 1, '2024-11-05', '2024-10-04 20:10:12'),
                                                                                         ('복숭아', 3, 1, '2024-12-12', '2024-10-04 20:10:12'),
                                                                                         ('감', 3, 1, '2024-11-20', '2024-10-04 20:10:12'),
                                                                                         ('귤', 3, 1, '2024-11-25', '2024-10-04 20:10:12'),
                                                                                         ('토마토', 3, 1, '2024-11-15', '2024-10-04 20:10:12'),
                                                                                         ('딸기', 3, 1, '2024-11-28', '2024-10-04 20:10:12'),
                                                                                         ('블루베리', 3, 1, '2024-12-02', '2024-10-04 20:10:12'),
                                                                                         ('시금치', 3, 1, '2024-12-25', '2024-10-04 20:10:12'),
                                                                                         ('콩나물', 3, 1, '2024-11-20', '2024-10-04 20:10:12'),
                                                                                         ('무', 3, 1, '2024-11-10', '2024-10-04 20:10:12'),
                                                                                         ('배추김치', 3, 1, '2024-12-15', '2024-10-04 20:10:12'),
                                                                                         ('깻잎', 3, 1, '2024-11-08', '2024-10-04 20:10:12'),
                                                                                         ('우엉', 3, 1, '2024-12-10', '2024-10-04 20:10:12'),
                                                                                         ('방울토마토', 3, 1, '2024-11-05', '2024-10-04 20:10:12'),
                                                                                         ('애플망고', 3, 1, '2024-12-12', '2024-10-04 20:10:12'),
                                                                                         ('블랙베리', 3, 1, '2024-12-25', '2024-10-04 20:10:12'),
                                                                                         ('파인애플', 3, 1, '2024-12-01', '2024-10-04 20:10:12'),
                                                                                         ('키위', 3, 1, '2024-11-30', '2024-10-04 20:10:12'),
                                                                                         ('양송이', 3, 1, '2024-11-15', '2024-10-04 20:10:12'),
                                                                                         ('표고버섯', 3, 1, '2024-11-22', '2024-10-04 20:10:12'),
                                                                                         ('팽이버섯', 3, 1, '2024-11-07', '2024-10-04 20:10:12'),
                                                                                         ('가지', 3, 1, '2024-11-25', '2024-10-04 20:10:12'),
                                                                                         ('파슬리', 3, 1, '2024-11-05', '2024-10-04 20:10:12'),
                                                                                         ('로즈마리', 3, 1, '2024-12-01', '2024-10-04 20:10:12'),
                                                                                         ('바질', 3, 1, '2024-12-05', '2024-10-04 20:10:12'),
                                                                                         ('오레가노', 3, 1, '2024-12-10', '2024-10-04 20:10:12'),
                                                                                         ('레몬', 3, 1, '2024-11-20', '2024-10-04 20:10:12'),
                                                                                         ('라임', 3, 1, '2024-11-22', '2024-10-04 20:10:12'),
                                                                                         ('고추', 3, 1, '2024-12-15', '2024-10-04 20:10:12'),
                                                                                         ('대파', 3, 1, '2024-12-02', '2024-10-04 20:10:12'),
                                                                                         ('고구마순', 3, 1, '2024-11-25', '2024-10-04 20:10:12'),
                                                                                         ('부추', 3, 1, '2024-11-12', '2024-10-04 20:10:12'),
                                                                                         ('콜라비', 3, 1, '2024-11-30', '2024-10-04 20:10:12'),
                                                                                         ('청경채', 3, 1, '2024-11-28', '2024-10-04 20:10:12'),
                                                                                         ('케일', 3, 1, '2024-11-20', '2024-10-04 20:10:12'),
                                                                                         ('아보카도', 3, 1, '2024-12-01', '2024-10-04 20:10:12'),
                                                                                         ('토르티야', 3, 1, '2025-01-15', '2024-10-04 20:10:12'),
                                                                                         ('체리', 3, 1, '2024-12-05', '2024-10-04 20:10:12');


INSERT INTO `cal` (`input_date`, `member_num`, `b_name`, `b_kcal`, `l_name`, `l_kcal`, `d_name`, `d_kcal`, `too_much`, `lack`, `recom`, `total_kcal`, `score`) VALUES
                                                                                                                                                                   ('2024-09-01', 3, '토스트', 350, '비빔밥', 700, '삼겹살', 900, '탄수화물,나트륨', '단백질,식이섬유,비타민 A', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'호박씨\', \'연어\', \'두부\']을 섭취하는 것을 권장합니다.', 1950, 78),
                                                                                                                                                                   ('2024-09-02', 3, '시리얼', 300, '비빔밥', 700, '돼지갈비', 900, '나트륨,지방', '식이섬유,비타민 A,칼슘', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'아몬드\', \'브로콜리\', \'검정콩\']을 섭취하는 것을 권장합니다.', 1900, 80),
                                                                                                                                                                   ('2024-09-03', 3, '계란후라이', 200, '짜장면', 650, '닭갈비', 850, '탄수화물,나트륨', '비타민 C,철,마그네슘', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'호박씨\', \'연어\', \'두부\']을 섭취하는 것을 권장합니다.', 1700, 78),
                                                                                                                                                                   ('2024-09-04', 3, '우유', 150, '돈까스', 800, '해물탕', 700, '나트륨,지방', '단백질,식이섬유,비타민 A', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'검정콩\', \'시금치\', \'연어\']을 섭취하는 것을 권장합니다.', 1650, 72),
                                                                                                                                                                   ('2024-09-05', 3, '샌드위치', 450, '불고기', 700, '순두부찌개', 600, '탄수화물,나트륨', '비타민 C,칼슘,오메가-3 지방산', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'연어\', \'시금치\', \'호박씨\']을 섭취하는 것을 권장합니다.', 1750, 77),
                                                                                                                                                                   ('2024-09-06', 3, '프렌치토스트', 400, '냉면', 600, '갈비찜', 950, '탄수화물,나트륨', '단백질,식이섬유,칼슘', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'닭가슴살\', \'두부\', \'아몬드\']을 섭취하는 것을 권장합니다.', 1950, 85),
                                                                                                                                                                   ('2024-09-07', 3, '오믈렛', 350, '김밥', 500, '돼지불고기', 800, '나트륨,지방', '칼슘,철,비타민 A', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'브로콜리\', \'시금치\', \'연어\']을 섭취하는 것을 권장합니다.', 1650, 74),
                                                                                                                                                                   ('2024-09-08', 3, '팬케이크', 400, '라면', 600, '불고기', 700, '탄수화물,지방', '비타민 C,식이섬유,칼슘', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'닭가슴살\', \'연어\', \'시금치\']을 섭취하는 것을 권장합니다.', 1700, 76),
                                                                                                                                                                   ('2024-09-09', 3, '계란밥', 300, '짜장면', 650, '삼겹살', 900, '탄수화물,나트륨', '단백질,식이섬유,비타민 A', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'호박씨\', \'연어\', \'두부\']을 섭취하는 것을 권장합니다.', 1850, 80),
                                                                                                                                                                   ('2024-09-10', 3, '토스트', 350, '제육볶음', 700, '갈비탕', 850, '나트륨,지방', '비타민 C,칼슘,식이섬유', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'검정콩\', \'연어\', \'시금치\']을 섭취하는 것을 권장합니다.', 1900, 83),
                                                                                                                                                                   ('2024-09-11', 3, '샌드위치', 450, '비빔냉면', 550, '곰탕', 700, '탄수화물,지방', '단백질,비타민 A,철', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'브로콜리\', \'두부\', \'시금치\']을 섭취하는 것을 권장합니다.', 1700, 72),
                                                                                                                                                                   ('2024-09-12', 3, '우동', 550, '짜장면', 650, '짬뽕', 750, '탄수화물,나트륨', '단백질,지방,식이섬유,비타민 A,비타민 C,칼슘,철,마그네슘,칼륨,아연,오메가-3 지방산', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'연어\', \'닭가슴살\', \'콩\', \'검정콩\', \'아몬드\', \'호박씨\']을 섭취하는 것을 권장합니다.', 1950, 70),
                                                                                                                                                                   ('2024-09-13', 3, '계란후라이', 250, '초밥', 650, '돼지갈비', 850, '나트륨,지방', '비타민 C,식이섬유,칼슘', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'브로콜리\', \'연어\', \'호박씨\']을 섭취하는 것을 권장합니다.', 1750, 75),
                                                                                                                                                                   ('2024-09-14', 3, '시리얼', 200, '떡볶이', 600, '김치찜', 700, '탄수화물,나트륨', '단백질,비타민 A,철', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'검정콩\', \'두부\', \'시금치\']을 섭취하는 것을 권장합니다.', 1500, 68),
                                                                                                                                                                   ('2024-09-15', 3, '오믈렛', 350, '제육볶음', 700, '비빔밥', 600, '탄수화물,나트륨', '단백질,비타민 C,식이섬유', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'닭가슴살\', \'연어\', \'검정콩\']을 섭취하는 것을 권장합니다.', 1650, 73),
                                                                                                                                                                   ('2024-09-16', 3, '팬케이크', 400, '김밥', 500, '갈비탕', 800, '나트륨,지방', '식이섬유,칼슘,비타민 A', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'연어\', \'아몬드\', \'시금치\']을 섭취하는 것을 권장합니다.', 1700, 75),
                                                                                                                                                                   ('2024-09-17', 3, '샌드위치', 450, '비빔냉면', 550, '곰탕', 700, '탄수화물,지방', '단백질,비타민 A,철', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'브로콜리\', \'두부\', \'시금치\']을 섭취하는 것을 권장합니다.', 1700, 72),
                                                                                                                                                                   ('2024-09-18', 3, '토스트', 350, '제육볶음', 700, '갈비탕', 850, '나트륨,지방', '비타민 C,칼슘,식이섬유', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'검정콩\', \'연어\', \'시금치\']을 섭취하는 것을 권장합니다.', 1900, 83),
                                                                                                                                                                   ('2024-09-19', 3, '우동', 550, '짜장면', 650, '짬뽕', 750, '탄수화물,나트륨', '단백질,지방,식이섬유,비타민 A,비타민 C,칼슘,철,마그네슘,칼륨,아연,오메가-3 지방산', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'연어\', \'닭가슴살\', \'콩\', \'검정콩\', \'아몬드\', \'호박씨\']을 섭취하는 것을 권장합니다.', 1950, 70),
                                                                                                                                                                   ('2024-09-20', 3, '계란후라이', 250, '초밥', 650, '돼지갈비', 850, '나트륨,지방', '비타민 C,식이섬유,칼슘', '당신의 일일 권장 섭취량인 2849.69 kcal를 고려했을 때, 과잉 섭취된 영양소는 줄이고 부족한 영양소를 보충하기 위해 [\'브로콜리\', \'연어\', \'호박씨\']을 섭취하는 것을 권장합니다.', 1750, 75);

DROP TABLE IF EXISTS `board`;
DROP TABLE IF EXISTS `saved_recipe`;
DROP TABLE IF EXISTS `history`;
DROP TABLE IF EXISTS `cal`;
DROP TABLE IF EXISTS `subscription`;
DROP TABLE IF EXISTS `stock`;
DROP TABLE IF EXISTS `allergy`;
DROP TABLE IF EXISTS `user_body_info`;
DROP TABLE IF EXISTS `food_items`;
DROP TABLE IF EXISTS `complaint`;


DROP TABLE IF EXISTS `member`;

SHOW TABLES;
