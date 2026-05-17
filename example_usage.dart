// Example usage of the HTML parser for Kundelik.kz URLs
// Run this file with: dart run example_usage.dart

import 'lib/utils/html_parser.dart';

void main() {
  // Example URLs from your request
  final urls = [
    'https://schools.kundelik.kz/v2/reports/default?year=2025&school=1000001220513&datefrom=07.02.2026&dateto=07.02.2026&report=ksp-classteacher&teacher=1000002593966',
    'https://schools.kundelik.kz/v2/journals/?school=1000001220513',
    'https://kundelik.kz/journals/criteriaMarks/group/2384130192876720205/subject/1716611619887448404/period/2388013040880783646',
    'https://schools.kundelik.kz/v2/lesson?school=1000001220513&lesson=2441504754018508579'
  ];
  
  print('=== Kundelik URL Analysis ===\n');
  
  for (final url in urls) {
    print('URL: $url');
    final parsed = HtmlParser.parseUrlParameters(url);
    
    print('Host: ${parsed['host']}');
    print('Path: ${parsed['path']}');
    print('Scheme: ${parsed['scheme']}');
    
    final queryParams = parsed['queryParameters'] as Map<String, String>;
    if (queryParams.isNotEmpty) {
      print('Query Parameters:');
      queryParams.forEach((key, value) {
        print('  $key: $value');
      });
    }
    
    print('---\n');
  }
  
  // Example HTML parsing (you would typically get this from HTTP response)
  final sampleHtml = '''
  <html>
    <body>
      <a href="https://schools.kundelik.kz/v2/lesson?school=1000001220513&lesson=2441504754018508579" class="plan-link" data-plan-id="123">Lesson Link</a>
      <a href="https://kundelik.kz/journals/criteriaMarks/group/2384130192876720205" class="another-link">Journal Link</a>
      <div class="plan-link-container" data-plan-type="lesson">
        <span>Plan Content</span>
      </div>
    </body>
  </html>
  ''';
  
  print('=== HTML Parsing Example ===\n');
  
  // Extract plan links
  final planLinks = HtmlParser.extractPlanLinks(sampleHtml);
  print('Plan Links Found:');
  for (final link in planLinks) {
    print('  $link');
  }
  
  // Extract all hrefs
  final allHrefs = HtmlParser.extractAllHrefs(sampleHtml);
  print('\nAll Hrefs Found:');
  for (final href in allHrefs) {
    print('  $href');
  }
  
  // Extract kundelik links
  final kundelikLinks = HtmlParser.extractKundelikLinks(sampleHtml);
  print('\nKundelik Links Found:');
  for (final link in kundelikLinks) {
    print('  $link');
  }
}
