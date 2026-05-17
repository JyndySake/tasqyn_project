import 'package:http/http.dart' as http;
import '../utils/html_parser.dart';

class KundelikService {
  static Future<List<Map<String, String>>> extractPlanLinksFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return HtmlParser.extractPlanLinks(response.body);
      } else {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching URL: $e');
    }
  }
  
  static Future<List<String>> extractAllHrefsFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return HtmlParser.extractAllHrefs(response.body);
      } else {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching URL: $e');
    }
  }
  
  static Future<List<Map<String, String>>> extractKundelikLinksFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return HtmlParser.extractKundelikLinks(response.body);
      } else {
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching URL: $e');
    }
  }
  
  static void analyzeSpecificUrls() {
    // Example URLs from your request
    final urls = [
      'https://schools.kundelik.kz/v2/reports/default?year=2025&school=1000001220513&datefrom=07.02.2026&dateto=07.02.2026&report=ksp-classteacher&teacher=1000002593966',
      'https://schools.kundelik.kz/v2/journals/?school=1000001220513',
      'https://kundelik.kz/journals/criteriaMarks/group/2384130192876720205/subject/1716611619887448404/period/2388013040880783646',
      'https://schools.kundelik.kz/v2/lesson?school=1000001220513&lesson=2441504754018508579'
    ];
    
    for (final url in urls) {
      final parsed = HtmlParser.parseUrlParameters(url);
      print('URL: $url');
      print('Path: ${parsed['path']}');
      print('Host: ${parsed['host']}');
      print('Query Parameters: ${parsed['queryParameters']}');
      print('---');
    }
  }
}
