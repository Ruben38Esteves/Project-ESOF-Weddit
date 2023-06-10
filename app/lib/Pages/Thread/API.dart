import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetchRandom() async
{
  final response = await http.get(
    Uri.parse('https://en.wikipedia.org/w/api.php?format=json&action=query&generator=random&grnnamespace=0&grnlimit=1&prop=info|extracts&inprop=url'),
  );


  if(response.statusCode == 200)
  {
    String url = 'https://en.m.wikipedia.org/w/index.php?title=Special%3ASearch&search=';
    dynamic json = jsonDecode(response.body);
    json = json['query']['pages'];
    json.keys.forEach((key) {
      url = json[key.toString()]['fullurl'];
    });
    url = url.substring(0, 10) + '.m' + url.substring(10);
    if ((url.substring(0,32) != 'https://en.m.wikipedia.org/wiki/' || url.substring(27).contains(':') || url.substring(27).contains('?') || url.substring(27).contains('%')) && !url.contains('Search&search=') && !url.contains('Special%3ASearch')) {
      return await fetchRandom();
    }
    return url;
  }
  else
  {
    return 'https://en.m.wikipedia.org/w/index.php?title=Special%3ASearch&search=';
  }
}