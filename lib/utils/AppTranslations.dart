// 定义多语言翻译类
import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': {
          'lyrics_search': '검색',
          'lyrics_search_hint': '검색 키워드를 입력하십시오.',
          'search_result_hint': '죄송해요, 가사를 아직 못 찾았어요',
          'lyrics_title': '노래 이름',
          'cancel': '취소',
          'chinese': '중국어',
          'korean': '한국어',
          'switch_language': '언어 전환',
          'lyric_details': '가사 상세',
          'load_lyric_error': '가사 로딩에 실패했어요. 잠시후 다시 시도해보세요.',
          'init_data': '데이터를 초기화하고 있으니 잠시만 기다려 주세요...',
          'lyrics_number': '노래 번호'
        },
        'zh_CN': {
          'lyrics_search': '搜索',
          'lyrics_search_hint': '请输入搜索关键字',
          'search_result_hint': '抱歉，暂时没有找到相关歌词',
          'lyrics_title': '歌曲名称',
          'cancel': '取消',
          'chinese': '中文',
          'korean': '韩文',
          'switch_language': '切换语言',
          'lyric_details': '歌词详情',
          'load_lyric_error': '加载歌词失败,请稍候再试',
          'init_data': '正在初始化数据,请稍候...',
          'lyrics_number': '歌曲编号'
        },
      };
}
