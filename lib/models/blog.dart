class Blog {
  String title;
  String imageUrl;
  DateTime time;
  String tags;
  String content;

  Blog({
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.tags,
    required this.content,
  });

  Blog.fromMap(Map<dynamic, dynamic> snapshot, String id)
      : title = snapshot['title'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '',
        time = snapshot['time'].toDate() ?? '',
        tags = snapshot['tags'] ?? '',
        content = snapshot['content'] ?? '';

  toJson() {
    return {
      "title": title,
      "imageUrl": imageUrl,
      "time": time,
      "tags": tags,
      "content": content,
    };
  }
}
