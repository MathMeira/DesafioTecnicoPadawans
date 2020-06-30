import 'package:http/http.dart' as http;

const baseUrl = "https://jsonplaceholder.typicode.com";

class API{
  static Future getPosts()async{
    var url = baseUrl + "/posts";
    return await http.get(url);
  }

  static Future getAlbuns()async{
    var url = baseUrl + "/albums";
    return await http.get(url);
  }

  static Future getTODOs()async{
    var url = baseUrl + "/todos";
    return await http.get(url);
  }

}