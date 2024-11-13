///歌詞bean
class LyricBean {
  ///歌詞編號
  final String number;

  ///歌詞名
  final String name;

  ///第一句歌词
  final String? firstLine;

  LyricBean({required this.number, required this.name,required this.firstLine});

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
      'firstLine':firstLine
    };
  }

  @override
  String toString() {
    return 'LyricBean{ name: $name, number: $number,firstLine: $firstLine}';
  }
}
