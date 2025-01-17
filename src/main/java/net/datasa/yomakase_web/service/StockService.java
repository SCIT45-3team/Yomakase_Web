package net.datasa.yomakase_web.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.datasa.yomakase_web.domain.dto.StockDTO;
import net.datasa.yomakase_web.domain.entity.MemberEntity;
import net.datasa.yomakase_web.domain.entity.StockEntity;
import net.datasa.yomakase_web.repository.MemberRepository;
import net.datasa.yomakase_web.repository.StockRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class StockService {

    private final StockRepository stockRepository;
    private final MemberRepository memberRepository;
    private final Random random = new Random();

    @Transactional
    public void saveStock(Map<String, String> ingredients, Object identifier) {
        Integer memberNum = null;

        if (identifier instanceof Integer) {
            // 앱에서 온 요청: memberNum이 Integer로 전달됨
            memberNum = (Integer) identifier;
        } else if (identifier instanceof String) {
            // 이메일(아이디)를 사용해 memberNum을 조회
            MemberEntity member = memberRepository.findById((String) identifier)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            memberNum = member.getMemberNum();
        }

        // ingredients는 Map<String, String> 형식
        for (Map.Entry<String, String> entry : ingredients.entrySet()) {
            String ingredientName = entry.getKey();  // key는 재료명
            String expirationDate = entry.getValue();  // value는 소비기한일수

            log.info("Saving ingredient: {}, Expiration Date: {}", ingredientName, expirationDate);

            // 소비기한일수를 LocalDate로 변환
            LocalDate currentDate = LocalDate.now();
            LocalDate useByDate = currentDate.plusDays(Integer.parseInt(expirationDate));

            // StockEntity 생성 후 데이터 저장
            StockEntity stockEntity = StockEntity.builder()
                    .ingredientName(ingredientName)
                    .isHaving(true)
                    .memberNum(memberNum)
                    .useByDate(useByDate)
                    .build();

            stockRepository.save(stockEntity);
        }
    }
    @Transactional
    public void updateStockIsHaving(String ingredientName, Integer memberNum) {
        // 재료명과 회원 번호를 이용하여 Stock 테이블의 isHaving 필드를 0으로 업데이트
        stockRepository.updateIsHavingByIngredientAndMember(ingredientName, memberNum, 0);
        log.info("Stock의 isHaving 필드가 0으로 업데이트되었습니다. 재료: {}, 회원 번호: {}", ingredientName, memberNum);
    }

    public List<Map<String, Object>> getStockForMember(Object identifier) {
        Integer memberNum = null;

        if (identifier instanceof Integer) {
            // 앱에서 온 요청: memberNum이 Integer로 전달됨
            memberNum = (Integer) identifier;
        } else if (identifier instanceof String) {
            // 이메일(아이디)를 사용해 memberNum을 조회
            MemberEntity member = memberRepository.findById((String) identifier)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            memberNum = member.getMemberNum();
        }

        // memberNum을 사용하여 스톡 데이터 조회
        List<StockEntity> stockEntities = stockRepository.findByMemberNumAndIsHavingTrueOrderByUseByDateAsc(memberNum);

        // StockEntity를 Map 형식으로 변환
        List<Map<String, Object>> stockList = new ArrayList<>();

        for (StockEntity stockEntity : stockEntities) {
            Map<String, Object> stockMap = new HashMap<>();
            stockMap.put("ingredientName", stockEntity.getIngredientName());

            // UseByDate(소비 기한일)를 그대로 저장
            stockMap.put("useByDate", stockEntity.getUseByDate()); // LocalDate 그대로 전달

            stockList.add(stockMap);
        }

        return stockList;
    }

    public List<String> getAllIngredientNamesForMember(Object identifier) {
        Integer memberNum = null;

        if (identifier instanceof Integer) {
            // 앱에서 온 요청: memberNum이 Integer로 전달됨
            memberNum = (Integer) identifier;
        } else if (identifier instanceof String) {
            // 이메일(아이디)를 사용해 memberNum을 조회
            MemberEntity member = memberRepository.findById((String) identifier)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            memberNum = member.getMemberNum();
        }

        // memberNum과 isHaving이 true인 ingredient_name 가져오기
        return stockRepository.findAllIngredientNamesByMemberNumAndIsHavingTrue(memberNum);
    }


    // 이미지 파일명 리스트
    private final List<String> imageFileNames = List.of(
            "food-containerB.png",
            "food-containerG.png",
            "food-containerR.png",
            "food-containerY.png"
    );

    /**
     * 소비 기한이 임박한 순서로 상위 9개 재고 아이템을 가져오고 랜덤으로 이미지 경로를 설정
     *
     * @param memberNum 로그인한 회원의 memberNum
     * @return 재고 아이템의 리스트를 포함한 맵 리스트
     */
    public List<Map<String, String>> getTop9StockItems(int memberNum) {
        Pageable pageable = PageRequest.of(0, 9); // 첫 페이지, 9개 항목

        // memberNum에 맞는 재고 아이템을 조회
        // isHaving이 true(1)인 경우만 필터링
        List<StockEntity> stocks = stockRepository.findTop9ByMemberNumAndIsHavingTrueOrderByUseByDateAsc(memberNum, pageable);

        // 이미지의 기본 경로
        String imagePathBase = "img/";  // 실제로 저장된 이미지 경로를 설정

        // List<StockEntity>를 List<Map>으로 변환하며 랜덤 이미지 경로를 설정
        return stocks.stream()
                .filter(stock -> stock.isHaving())  // isHaving이 true(1)인 경우만 필터링
                .map(stock -> {
                    // 랜덤으로 이미지 파일명 선택
                    String imageFileName = getRandomImageFileName();
                    return Map.of(
                            "name", stock.getIngredientName(),
                            "image", imageFileName // 이미지 파일명 반환
                    );
                })
                .collect(Collectors.toList());
    }

    /**
     * 이미지 파일명 리스트에서 랜덤으로 하나를 선택
     *
     * @return 랜덤 이미지 파일명
     */
    private String getRandomImageFileName() {
        int index = random.nextInt(imageFileNames.size());
        return imageFileNames.get(index); // 랜덤 이미지 파일명 반환
    }

    /**
     * 해당되는 재고를 선택하고 날짜 업데이트
     * @param ingredientName 식재료 이름
     * @param memberNum 회원 일련번호
     * @param useByDate 업데이트 날짜
     */
    public void updateStockDate(String ingredientName, int memberNum, LocalDate useByDate) {
        // 재고 항목을 찾습니다.
        StockEntity stockEntity = stockRepository.findByIngredientNameAndMemberNum(ingredientName, memberNum)
                .orElseThrow(() -> new RuntimeException("재고 항목을 찾을 수 없습니다. ingredientName: " + ingredientName + ", memberNum: " + memberNum));

        // found stockEntity의 useByDate 업데이트
        stockEntity.setUseByDate(useByDate);

        // 업데이트된 엔티티 저장
        stockRepository.save(stockEntity);
    }

}
